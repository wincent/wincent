-- vim: ft=lua
-- Tokyo Night Moon theme for Rex
-- Scheme Author: Michaël Ball, based on Tokyo Night by enkia (https://github.com/enkia/tokyo-night-vscode-theme)
-- Scheme System: base24
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

local name = "base24-tokyo-night-moon"
local variant = "dark"

-- This must match themes/ghostty/base24-tokyo-night-moon exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokyo Night Moon theme for Ghostty
# Scheme Author: Michaël Ball, based on Tokyo Night by enkia (https://github.com/enkia/tokyo-night-vscode-theme)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#222436
palette = 1=#c099ff
palette = 2=#c3e88d
palette = 3=#ffc777
palette = 4=#82aaff
palette = 5=#fca7ea
palette = 6=#86e1fc
palette = 7=#c8d3f5
palette = 8=#444a73
palette = 9=#ff757f
palette = 10=#c3e88d
palette = 11=#ffd793
palette = 12=#82aaff
palette = 13=#fca7ea
palette = 14=#86e1fc
palette = 15=#c8d3f5
palette = 16=#ffc777
palette = 17=#c53b53
palette = 18=#1e2030
palette = 19=#2f334d
palette = 20=#828bb8
palette = 21=#b4c2f0

# Foreground & background colors
background = #222436
foreground = #c8d3f5
cursor-color = #c8d3f5
selection-background = #c8d3f5
selection-foreground = #2f334d
search-background = #ffc777
search-foreground = #1e2030
search-selected-background = #ffc777
search-selected-foreground = #1e2030

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #c8d3f5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #82aaff
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
