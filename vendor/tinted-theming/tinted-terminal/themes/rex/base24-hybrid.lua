-- vim: ft=lua
-- Hybrid theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-hybrid"
local variant = "dark"

-- This must match themes/ghostty/base24-hybrid exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Hybrid theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#161718
palette = 1=#b74d50
palette = 2=#b3be5a
palette = 3=#4b6b88
palette = 4=#6d90b0
palette = 5=#a07eab
palette = 6=#7fbeb3
palette = 7=#8f9190
palette = 8=#434446
palette = 9=#8c2d32
palette = 10=#788331
palette = 11=#e5894f
palette = 12=#4b6b88
palette = 13=#6e4f79
palette = 14=#4d7b73
palette = 15=#5a6169
palette = 16=#e3b55e
palette = 17=#5b2628
palette = 18=#2a2e33
palette = 19=#1d1e21
palette = 20=#696b6b
palette = 21=#b5b8b6

# Foreground & background colors
background = #161718
foreground = #8f9190
cursor-color = #8f9190
selection-background = #8f9190
selection-foreground = #1d1e21
search-background = #4b6b88
search-foreground = #2a2e33
search-selected-background = #e3b55e
search-selected-foreground = #2a2e33

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #5a6169
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4b6b88
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
