-- vim: ft=lua
-- lime theme for Rex
-- Scheme Author: limelier
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

local name = "base16-lime"
local variant = "dark"

-- This must match themes/ghostty/base16-lime exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# lime theme for Ghostty
# Scheme Author: limelier
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a1a2f
palette = 1=#ff662a
palette = 2=#8cd97c
palette = 3=#ffd15e
palette = 4=#2b926f
palette = 5=#1b825f
palette = 6=#4cad83
palette = 7=#818175
palette = 8=#313140
palette = 9=#ff662a
palette = 10=#8cd97c
palette = 11=#ffd15e
palette = 12=#2b926f
palette = 13=#1b825f
palette = 14=#4cad83
palette = 15=#fff8e1
palette = 16=#ff773a
palette = 17=#b4d97c
palette = 18=#202030
palette = 19=#2a2a3f
palette = 20=#515155
palette = 21=#fff2d1

# Foreground & background colors
background = #1a1a2f
foreground = #818175
cursor-color = #818175
selection-background = #818175
selection-foreground = #2a2a3f
search-background = #ffd15e
search-foreground = #202030
search-selected-background = #ff773a
search-selected-foreground = #202030

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff8e1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2b926f
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
