-- vim: ft=lua
-- Everforest Dark Medium theme for Rex
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

local name = "base16-everforest-dark-medium"
local variant = "dark"

-- This must match themes/ghostty/base16-everforest-dark-medium exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Everforest Dark Medium theme for Ghostty
# Scheme Author: Sainnhe Park (https://github.com/sainnhe)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2d353b
palette = 1=#e67e80
palette = 2=#a7c080
palette = 3=#dbbc7f
palette = 4=#7fbbb3
palette = 5=#d699b6
palette = 6=#83c092
palette = 7=#859289
palette = 8=#475258
palette = 9=#e67e80
palette = 10=#a7c080
palette = 11=#dbbc7f
palette = 12=#7fbbb3
palette = 13=#d699b6
palette = 14=#83c092
palette = 15=#d3c6aa
palette = 16=#e69875
palette = 17=#514045
palette = 18=#343f44
palette = 19=#3d484d
palette = 20=#7a8478
palette = 21=#9da9a0

# Foreground & background colors
background = #2d353b
foreground = #859289
cursor-color = #859289
selection-background = #859289
selection-foreground = #3d484d
search-background = #dbbc7f
search-foreground = #343f44
search-selected-background = #e69875
search-selected-foreground = #343f44

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d3c6aa
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
