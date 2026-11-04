-- vim: ft=lua
-- Gruvbox Material Light, Hard theme for Rex
-- Scheme Author: Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)
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

local name = "base16-gruvbox-material-light-hard"
local variant = "light"

-- This must match themes/ghostty/base16-gruvbox-material-light-hard exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gruvbox Material Light, Hard theme for Ghostty
# Scheme Author: Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f9f5d7
palette = 1=#c14a4a
palette = 2=#6c782e
palette = 3=#b47109
palette = 4=#45707a
palette = 5=#945e80
palette = 6=#4c7a5d
palette = 7=#654735
palette = 8=#a89984
palette = 9=#c14a4a
palette = 10=#6c782e
palette = 11=#b47109
palette = 12=#45707a
palette = 13=#945e80
palette = 14=#4c7a5d
palette = 15=#282828
palette = 16=#c35e0a
palette = 17=#e78a4e
palette = 18=#fbf1c7
palette = 19=#e0cfa9
palette = 20=#c9b99a
palette = 21=#3c3836

# Foreground & background colors
background = #f9f5d7
foreground = #654735
cursor-color = #654735
selection-background = #654735
selection-foreground = #e0cfa9
search-background = #b47109
search-foreground = #282828
search-selected-background = #c35e0a
search-selected-foreground = #282828

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #282828
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #45707a
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
