-- vim: ft=lua
-- Github Light High Contrast theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming)
-- Scheme System: tinted8
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

local name = "tinted8-github-light-high-contrast"
local variant = "light"

-- This must match themes/ghostty/tinted8-github-light-high-contrast exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Github Light High Contrast theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming)
# Scheme System: tinted8
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#010409
palette = 1=#a0111f
palette = 2=#024c1a
palette = 3=#3f2200
palette = 4=#0349b4
palette = 5=#622cbc
palette = 6=#1b7c83
palette = 7=#59636e
palette = 8=#393f46
palette = 9=#86061d
palette = 10=#055d20
palette = 11=#4e2c00
palette = 12=#1168e3
palette = 13=#844ae7
palette = 14=#3192aa
palette = 15=#818b98

# Foreground & background colors
background = #ffffff
foreground = #010409
cursor-color = #010409
selection-background = #3d454c
selection-foreground = #010409

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #818b98
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1168e3
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
