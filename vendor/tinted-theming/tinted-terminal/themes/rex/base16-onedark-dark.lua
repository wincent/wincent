-- vim: ft=lua
-- OneDark Dark theme for Rex
-- Scheme Author: olimorris (https://github.com/olimorris)
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

local name = "base16-onedark-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-onedark-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# OneDark Dark theme for Ghostty
# Scheme Author: olimorris (https://github.com/olimorris)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#ef596f
palette = 2=#89ca78
palette = 3=#e5c07b
palette = 4=#61afef
palette = 5=#d55fde
palette = 6=#2bbac5
palette = 7=#abb2bf
palette = 8=#434852
palette = 9=#ef596f
palette = 10=#89ca78
palette = 11=#e5c07b
palette = 12=#61afef
palette = 13=#d55fde
palette = 14=#2bbac5
palette = 15=#c8ccd4
palette = 16=#d19a66
palette = 17=#be5046
palette = 18=#1c1f24
palette = 19=#2c313a
palette = 20=#565c64
palette = 21=#b6bdca

# Foreground & background colors
background = #000000
foreground = #abb2bf
cursor-color = #abb2bf
selection-background = #abb2bf
selection-foreground = #2c313a
search-background = #e5c07b
search-foreground = #1c1f24
search-selected-background = #d19a66
search-selected-foreground = #1c1f24

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #c8ccd4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #61afef
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
