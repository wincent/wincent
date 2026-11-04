-- vim: ft=lua
-- Atelier Cave theme for Rex
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

local name = "base16-atelier-cave"
local variant = "dark"

-- This must match themes/ghostty/base16-atelier-cave exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Cave theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#19171c
palette = 1=#be4678
palette = 2=#2a9292
palette = 3=#a06e3b
palette = 4=#576ddb
palette = 5=#955ae7
palette = 6=#398bc6
palette = 7=#8b8792
palette = 8=#655f6d
palette = 9=#be4678
palette = 10=#2a9292
palette = 11=#a06e3b
palette = 12=#576ddb
palette = 13=#955ae7
palette = 14=#398bc6
palette = 15=#efecf4
palette = 16=#aa573c
palette = 17=#bf40bf
palette = 18=#26232a
palette = 19=#585260
palette = 20=#7e7887
palette = 21=#e2dfe7

# Foreground & background colors
background = #19171c
foreground = #8b8792
cursor-color = #8b8792
selection-background = #8b8792
selection-foreground = #585260
search-background = #a06e3b
search-foreground = #26232a
search-selected-background = #aa573c
search-selected-foreground = #26232a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #efecf4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #576ddb
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
