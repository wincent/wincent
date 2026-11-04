-- vim: ft=lua
-- Tomorrow Night theme for Rex
-- Scheme Author: Cody Buell (https://github.com/codybuell)
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

local name = "base24-tomorrow-night"
local variant = "dark"

-- This must match themes/ghostty/base24-tomorrow-night exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tomorrow Night theme for Ghostty
# Scheme Author: Cody Buell (https://github.com/codybuell)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d1f21
palette = 1=#cc6666
palette = 2=#b5bd68
palette = 3=#f0c674
palette = 4=#81a2be
palette = 5=#b294bb
palette = 6=#8abeb7
palette = 7=#c5c8c6
palette = 8=#969896
palette = 9=#e74c3c
palette = 10=#b8d4b3
palette = 11=#f7dc6f
palette = 12=#85c1e9
palette = 13=#d7a3ca
palette = 14=#95d3ce
palette = 15=#ffffff
palette = 16=#de935f
palette = 17=#a3685a
palette = 18=#282a2e
palette = 19=#373b41
palette = 20=#b4b7b4
palette = 21=#e0e0e0

# Foreground & background colors
background = #1d1f21
foreground = #c5c8c6
cursor-color = #c5c8c6
selection-background = #c5c8c6
selection-foreground = #373b41
search-background = #f0c674
search-foreground = #282a2e
search-selected-background = #de935f
search-selected-foreground = #282a2e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #85c1e9
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
