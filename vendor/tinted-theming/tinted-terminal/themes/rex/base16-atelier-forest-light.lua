-- vim: ft=lua
-- Atelier Forest Light theme for Rex
-- Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
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

local name = "base16-atelier-forest-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-forest-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Forest Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f1efee
palette = 1=#f22c40
palette = 2=#7b9726
palette = 3=#c38418
palette = 4=#407ee7
palette = 5=#6666ea
palette = 6=#3d97b8
palette = 7=#68615e
palette = 8=#9c9491
palette = 9=#f22c40
palette = 10=#7b9726
palette = 11=#c38418
palette = 12=#407ee7
palette = 13=#6666ea
palette = 14=#3d97b8
palette = 15=#1b1918
palette = 16=#df5320
palette = 17=#c33ff3
palette = 18=#e6e2e0
palette = 19=#a8a19f
palette = 20=#766e6b
palette = 21=#2c2421

# Foreground & background colors
background = #f1efee
foreground = #68615e
cursor-color = #68615e
selection-background = #68615e
selection-foreground = #a8a19f
search-background = #c38418
search-foreground = #1b1918
search-selected-background = #df5320
search-selected-foreground = #1b1918

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1b1918
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #407ee7
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
