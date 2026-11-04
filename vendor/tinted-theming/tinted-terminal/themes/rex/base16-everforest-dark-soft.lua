-- vim: ft=lua
-- Everforest Dark Soft theme for Rex
-- Scheme Author: Sainnhe Park (https://github.com/sainnhe)
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

local name = "base16-everforest-dark-soft"
local variant = "dark"

-- This must match themes/ghostty/base16-everforest-dark-soft exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Everforest Dark Soft theme for Ghostty
# Scheme Author: Sainnhe Park (https://github.com/sainnhe)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#333c43
palette = 1=#e67e80
palette = 2=#a7c080
palette = 3=#dbbc7f
palette = 4=#7fbbb3
palette = 5=#d699b6
palette = 6=#83c092
palette = 7=#d3c6aa
palette = 8=#859289
palette = 9=#e67e80
palette = 10=#a7c080
palette = 11=#dbbc7f
palette = 12=#7fbbb3
palette = 13=#d699b6
palette = 14=#83c092
palette = 15=#f3ead3
palette = 16=#e69875
palette = 17=#9da9a0
palette = 18=#3a464c
palette = 19=#4d5960
palette = 20=#9da9a0
palette = 21=#ddd8be

# Foreground & background colors
background = #333c43
foreground = #d3c6aa
cursor-color = #d3c6aa
selection-background = #d3c6aa
selection-foreground = #4d5960
search-background = #dbbc7f
search-foreground = #3a464c
search-selected-background = #e69875
search-selected-foreground = #3a464c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f3ead3
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7fbbb3
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
