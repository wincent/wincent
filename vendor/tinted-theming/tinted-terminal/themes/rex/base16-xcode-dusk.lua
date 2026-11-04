-- vim: ft=lua
-- XCode Dusk theme for Rex
-- Scheme Author: Elsa Gonsiorowski (https://github.com/gonsie)
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

local name = "base16-xcode-dusk"
local variant = "dark"

-- This must match themes/ghostty/base16-xcode-dusk exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# XCode Dusk theme for Ghostty
# Scheme Author: Elsa Gonsiorowski (https://github.com/gonsie)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#282b35
palette = 1=#b21889
palette = 2=#df0002
palette = 3=#438288
palette = 4=#790ead
palette = 5=#b21889
palette = 6=#00a0be
palette = 7=#939599
palette = 8=#686a71
palette = 9=#b21889
palette = 10=#df0002
palette = 11=#438288
palette = 12=#790ead
palette = 13=#b21889
palette = 14=#00a0be
palette = 15=#bebfc2
palette = 16=#786dc5
palette = 17=#c77c48
palette = 18=#3d4048
palette = 19=#53555d
palette = 20=#7e8086
palette = 21=#a9aaae

# Foreground & background colors
background = #282b35
foreground = #939599
cursor-color = #939599
selection-background = #939599
selection-foreground = #53555d
search-background = #438288
search-foreground = #3d4048
search-selected-background = #786dc5
search-selected-foreground = #3d4048

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #bebfc2
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #790ead
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
