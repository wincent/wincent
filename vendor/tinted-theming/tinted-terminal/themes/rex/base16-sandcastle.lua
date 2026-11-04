-- vim: ft=lua
-- Sandcastle theme for Rex
-- Scheme Author: George Essig (https://github.com/gessig)
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

local name = "base16-sandcastle"
local variant = "dark"

-- This must match themes/ghostty/base16-sandcastle exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sandcastle theme for Ghostty
# Scheme Author: George Essig (https://github.com/gessig)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#282c34
palette = 1=#83a598
palette = 2=#528b8b
palette = 3=#a07e3b
palette = 4=#83a598
palette = 5=#d75f5f
palette = 6=#83a598
palette = 7=#a89984
palette = 8=#665c54
palette = 9=#83a598
palette = 10=#528b8b
palette = 11=#a07e3b
palette = 12=#83a598
palette = 13=#d75f5f
palette = 14=#83a598
palette = 15=#fdf4c1
palette = 16=#a07e3b
palette = 17=#a87322
palette = 18=#2c323b
palette = 19=#3e4451
palette = 20=#928374
palette = 21=#d5c4a1

# Foreground & background colors
background = #282c34
foreground = #a89984
cursor-color = #a89984
selection-background = #a89984
selection-foreground = #3e4451
search-background = #a07e3b
search-foreground = #2c323b
search-selected-background = #a07e3b
search-selected-foreground = #2c323b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fdf4c1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #83a598
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
