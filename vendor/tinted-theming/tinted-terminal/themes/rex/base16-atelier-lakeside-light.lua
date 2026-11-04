-- vim: ft=lua
-- Atelier Lakeside Light theme for Rex
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

local name = "base16-atelier-lakeside-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-lakeside-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Lakeside Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ebf8ff
palette = 1=#d22d72
palette = 2=#568c3b
palette = 3=#8a8a0f
palette = 4=#257fad
palette = 5=#6b6bb8
palette = 6=#2d8f6f
palette = 7=#516d7b
palette = 8=#7195a8
palette = 9=#d22d72
palette = 10=#568c3b
palette = 11=#8a8a0f
palette = 12=#257fad
palette = 13=#6b6bb8
palette = 14=#2d8f6f
palette = 15=#161b1d
palette = 16=#935c25
palette = 17=#b72dd2
palette = 18=#c1e4f6
palette = 19=#7ea2b4
palette = 20=#5a7b8c
palette = 21=#1f292e

# Foreground & background colors
background = #ebf8ff
foreground = #516d7b
cursor-color = #516d7b
selection-background = #516d7b
selection-foreground = #7ea2b4
search-background = #8a8a0f
search-foreground = #161b1d
search-selected-background = #935c25
search-selected-foreground = #161b1d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #161b1d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #257fad
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
