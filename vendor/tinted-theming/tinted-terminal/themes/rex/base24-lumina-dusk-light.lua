-- vim: ft=lua
-- Lumina Dusk Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
-- Scheme System: base24
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

local name = "base24-lumina-dusk-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-dusk-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Dusk Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f6f3fe
palette = 1=#872423
palette = 2=#357545
palette = 3=#9e611b
palette = 4=#3163ad
palette = 5=#7b46a4
palette = 6=#007185
palette = 7=#2e2945
palette = 8=#d4d0de
palette = 9=#622320
palette = 10=#216033
palette = 11=#854e07
palette = 12=#2b5088
palette = 13=#713a6c
palette = 14=#005b6c
palette = 15=#2e2945
palette = 16=#8c491d
palette = 17=#874d82
palette = 18=#f0ecfa
palette = 19=#e4e0ef
palette = 20=#878491
palette = 21=#494552

# Foreground & background colors
background = #f6f3fe
foreground = #2e2945
cursor-color = #2e2945
selection-background = #2e2945
selection-foreground = #e4e0ef
search-background = #9e611b
search-foreground = #f0ecfa
search-selected-background = #8c491d
search-selected-foreground = #f0ecfa

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2e2945
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2b5088
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
