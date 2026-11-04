-- vim: ft=lua
-- Gruvbox Material Dark, Soft theme for Rex
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

local name = "base16-gruvbox-material-dark-soft"
local variant = "dark"

-- This must match themes/ghostty/base16-gruvbox-material-dark-soft exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gruvbox Material Dark, Soft theme for Ghostty
# Scheme Author: Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#32302f
palette = 1=#ea6962
palette = 2=#a9b665
palette = 3=#d8a657
palette = 4=#7daea3
palette = 5=#d3869b
palette = 6=#89b482
palette = 7=#ddc7a1
palette = 8=#7c6f64
palette = 9=#ea6962
palette = 10=#a9b665
palette = 11=#d8a657
palette = 12=#7daea3
palette = 13=#d3869b
palette = 14=#89b482
palette = 15=#fbf1c7
palette = 16=#e78a4e
palette = 17=#bd6f3e
palette = 18=#3c3836
palette = 19=#5a524c
palette = 20=#bdae93
palette = 21=#ebdbb2

# Foreground & background colors
background = #32302f
foreground = #ddc7a1
cursor-color = #ddc7a1
selection-background = #ddc7a1
selection-foreground = #5a524c
search-background = #d8a657
search-foreground = #3c3836
search-selected-background = #e78a4e
search-selected-foreground = #3c3836

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fbf1c7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7daea3
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
