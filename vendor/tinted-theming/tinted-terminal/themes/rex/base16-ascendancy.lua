-- vim: ft=lua
-- Ascendancy theme for Rex
-- Scheme Author: EmergentMind (https://github.com/emergentmind/ascendancy-scheme)
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

local name = "base16-ascendancy"
local variant = "dark"

-- This must match themes/ghostty/base16-ascendancy exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ascendancy theme for Ghostty
# Scheme Author: EmergentMind (https://github.com/emergentmind/ascendancy-scheme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#282828
palette = 1=#d05000
palette = 2=#b8bb26
palette = 3=#ffcc1b
palette = 4=#458588
palette = 5=#fabd2f
palette = 6=#8f3f71
palette = 7=#d5c7a1
palette = 8=#928374
palette = 9=#d05000
palette = 10=#b8bb26
palette = 11=#ffcc1b
palette = 12=#458588
palette = 13=#fabd2f
palette = 14=#8f3f71
palette = 15=#fbf1c7
palette = 16=#fe8019
palette = 17=#b59b4d
palette = 18=#212f3d
palette = 19=#504945
palette = 20=#bdae93
palette = 21=#ebdbb2

# Foreground & background colors
background = #282828
foreground = #d5c7a1
cursor-color = #d5c7a1
selection-background = #d5c7a1
selection-foreground = #504945
search-background = #ffcc1b
search-foreground = #212f3d
search-selected-background = #fe8019
search-selected-foreground = #212f3d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fbf1c7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #458588
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
