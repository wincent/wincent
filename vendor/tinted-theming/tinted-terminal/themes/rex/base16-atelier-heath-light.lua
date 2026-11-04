-- vim: ft=lua
-- Atelier Heath Light theme for Rex
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

local name = "base16-atelier-heath-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-heath-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Heath Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f7f3f7
palette = 1=#ca402b
palette = 2=#918b3b
palette = 3=#bb8a35
palette = 4=#516aec
palette = 5=#7b59c0
palette = 6=#159393
palette = 7=#695d69
palette = 8=#9e8f9e
palette = 9=#ca402b
palette = 10=#918b3b
palette = 11=#bb8a35
palette = 12=#516aec
palette = 13=#7b59c0
palette = 14=#159393
palette = 15=#1b181b
palette = 16=#a65926
palette = 17=#cc33cc
palette = 18=#d8cad8
palette = 19=#ab9bab
palette = 20=#776977
palette = 21=#292329

# Foreground & background colors
background = #f7f3f7
foreground = #695d69
cursor-color = #695d69
selection-background = #695d69
selection-foreground = #ab9bab
search-background = #bb8a35
search-foreground = #1b181b
search-selected-background = #a65926
search-selected-foreground = #1b181b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1b181b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #516aec
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
