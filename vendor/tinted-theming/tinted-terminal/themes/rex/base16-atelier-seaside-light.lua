-- vim: ft=lua
-- Atelier Seaside Light theme for Rex
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

local name = "base16-atelier-seaside-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-seaside-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Seaside Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f4fbf4
palette = 1=#e6193c
palette = 2=#29a329
palette = 3=#98981b
palette = 4=#3d62f5
palette = 5=#ad2bee
palette = 6=#1999b3
palette = 7=#5e6e5e
palette = 8=#809980
palette = 9=#e6193c
palette = 10=#29a329
palette = 11=#98981b
palette = 12=#3d62f5
palette = 13=#ad2bee
palette = 14=#1999b3
palette = 15=#131513
palette = 16=#87711d
palette = 17=#e619c3
palette = 18=#cfe8cf
palette = 19=#8ca68c
palette = 20=#687d68
palette = 21=#242924

# Foreground & background colors
background = #f4fbf4
foreground = #5e6e5e
cursor-color = #5e6e5e
selection-background = #5e6e5e
selection-foreground = #8ca68c
search-background = #98981b
search-foreground = #131513
search-selected-background = #87711d
search-selected-foreground = #131513

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #131513
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3d62f5
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
