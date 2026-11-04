-- vim: ft=lua
-- Atelier Sulphurpool Light theme for Rex
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

local name = "base16-atelier-sulphurpool-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-sulphurpool-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Sulphurpool Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5f7ff
palette = 1=#c94922
palette = 2=#ac9739
palette = 3=#c08b30
palette = 4=#3d8fd1
palette = 5=#6679cc
palette = 6=#22a2c9
palette = 7=#5e6687
palette = 8=#898ea4
palette = 9=#c94922
palette = 10=#ac9739
palette = 11=#c08b30
palette = 12=#3d8fd1
palette = 13=#6679cc
palette = 14=#22a2c9
palette = 15=#202746
palette = 16=#c76b29
palette = 17=#9c637a
palette = 18=#dfe2f1
palette = 19=#979db4
palette = 20=#6b7394
palette = 21=#293256

# Foreground & background colors
background = #f5f7ff
foreground = #5e6687
cursor-color = #5e6687
selection-background = #5e6687
selection-foreground = #979db4
search-background = #c08b30
search-foreground = #202746
search-selected-background = #c76b29
search-selected-foreground = #202746

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #202746
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3d8fd1
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
