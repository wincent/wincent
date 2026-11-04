-- vim: ft=lua
-- Corduroy theme for Rex
-- Scheme Author: taysatte (https://github.com/taysatte)
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

local name = "base16-corduroy"
local variant = "dark"

-- This must match themes/ghostty/base16-corduroy exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Corduroy theme for Ghostty
# Scheme Author: taysatte (https://github.com/taysatte)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d1920
palette = 1=#e06278
palette = 2=#4b8686
palette = 3=#edb392
palette = 4=#d27f91
palette = 5=#c285b2
palette = 6=#e99d90
palette = 7=#cdc8d0
palette = 8=#6f6373
palette = 9=#e06278
palette = 10=#4b8686
palette = 11=#edb392
palette = 12=#d27f91
palette = 13=#c285b2
palette = 14=#e99d90
palette = 15=#504757
palette = 16=#e99d90
palette = 17=#887b8c
palette = 18=#261e2a
palette = 19=#2e2533
palette = 20=#887b8c
palette = 21=#cdc8d0

# Foreground & background colors
background = #1d1920
foreground = #cdc8d0
cursor-color = #cdc8d0
selection-background = #cdc8d0
selection-foreground = #2e2533
search-background = #edb392
search-foreground = #261e2a
search-selected-background = #e99d90
search-selected-foreground = #261e2a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #504757
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #d27f91
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
