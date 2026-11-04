-- vim: ft=lua
-- Still Alive theme for Rex
-- Scheme Author: Derrick McKee (derrick.mckee@gmail.com), Tinted Theming (https://github.com/tinted-theming)
-- Scheme System: base16
-- Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)
--
-- Imports this scheme into every Rex app running on this machine and switches
-- the app to the scheme's appearance. Run it with the Rex CLI, for example as a
-- tinty hook:
--
--     hook = "rex --autostart=false do %f"
--
-- Rex can only import theme files from the app's own machine, so apps connected
-- to the Rex server from another machine are skipped. Run tinty there too.

local name = "base16-still-alive"
local variant = "light"

-- This must match themes/ghostty/base16-still-alive exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Still Alive theme for Ghostty
# Scheme Author: Derrick McKee (derrick.mckee@gmail.com), Tinted Theming (https://github.com/tinted-theming)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f0f0f0
palette = 1=#d80000
palette = 2=#30a860
palette = 3=#fff018
palette = 4=#365eff
palette = 5=#9036ff
palette = 6=#36d3ff
palette = 7=#4c383b
palette = 8=#a3a3a3
palette = 9=#d80000
palette = 10=#30a860
palette = 11=#fff018
palette = 12=#365eff
palette = 13=#9036ff
palette = 14=#36d3ff
palette = 15=#140c0d
palette = 16=#f0d848
palette = 17=#140c0d
palette = 18=#d6d6d6
palette = 19=#bdbdbd
palette = 20=#605758
palette = 21=#331f21

# Foreground & background colors
background = #f0f0f0
foreground = #4c383b
cursor-color = #4c383b
selection-background = #4c383b
selection-foreground = #bdbdbd
search-background = #fff018
search-foreground = #140c0d
search-selected-background = #f0d848
search-selected-foreground = #140c0d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #140c0d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #365eff
]==]

local me = assert(rex.call("server.whoami")).principal
if me.transport ~= "unix" then
    io.stderr:write("rex: not connected to a local Rex server, skipping\n")
    return
end

-- Rex names an imported theme after its file, and re-importing a name
-- replaces that theme's colors.
local home = os.getenv("HOME")
local dir = (os.getenv("XDG_CACHE_HOME") or (home .. "/.cache")) .. "/tinted-theming/rex"
rex.exec({ "mkdir", "-p", dir })
local file = dir .. "/" .. name
local out = assert(io.open(file, "w"))
out:write(theme)
out:close()

local function perform(client, action, args)
    local _, err = rex.call("client.perform", {
        client_id = client.client_id, action = action, args = args,
    })
    return err
end

-- Apps connected over the server's local socket as the same user are the
-- apps on this machine.
local list = assert(rex.call("client.list", { kinds = { "app" } }))
local failures = {}
for _, client in ipairs(list.clients or {}) do
    local peer = client.principal or {}
    local label = (client.info or {}).label or client.client_id
    if peer.transport == "unix" and peer.uid == me.uid then
        -- Rex guesses a theme's appearance from its colors when importing.
        -- Switch to the scheme's own variant in case it guessed wrong.
        local err = perform(client, "client.theme.import", { path = file })
            or perform(client, "client.appearance.switch_mode", { mode = variant })
        if err then
            table.insert(failures, label .. ": " .. tostring(err))
        end
    else
        io.stderr:write("rex: skipped " .. label .. ", which is connected from another machine or user\n")
    end
end

if #failures > 0 then
    error(table.concat(failures, "\n"))
end
