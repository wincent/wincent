-- vim: ft=lua
-- Papel theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-papel"
local variant = "light"

-- This must match themes/ghostty/base16-papel exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Papel theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5efe2
palette = 1=#c0392b
palette = 2=#5e7a28
palette = 3=#a8761a
palette = 4=#2c6ca0
palette = 5=#9b4d8e
palette = 6=#2a8a7a
palette = 7=#3a2e20
palette = 8=#9a8c76
palette = 9=#c0392b
palette = 10=#5e7a28
palette = 11=#a8761a
palette = 12=#2c6ca0
palette = 13=#9b4d8e
palette = 14=#2a8a7a
palette = 15=#efe8d8
palette = 16=#c25c1f
palette = 17=#6e6353
palette = 18=#8e8576
palette = 19=#e0d0ac
palette = 20=#6a5d4b
palette = 21=#958b7c

# Foreground & background colors
background = #f5efe2
foreground = #3a2e20
cursor-color = #3a2e20
selection-background = #3a2e20
selection-foreground = #e0d0ac
search-background = #a8761a
search-foreground = #efe8d8
search-selected-background = #c25c1f
search-selected-foreground = #efe8d8

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #efe8d8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2c6ca0
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
