-- vim: ft=lua
-- Brogrammer theme for Rex
-- Scheme Author: Vik Ramanujam (http://github.com/piggyslasher)
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

local name = "base16-brogrammer"
local variant = "dark"

-- This must match themes/ghostty/base16-brogrammer exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Brogrammer theme for Ghostty
# Scheme Author: Vik Ramanujam (http://github.com/piggyslasher)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1f1f1f
palette = 1=#d6dbe5
palette = 2=#f3bd09
palette = 3=#1dd361
palette = 4=#5350b9
palette = 5=#0f7ddb
palette = 6=#1081d6
palette = 7=#4e5ab7
palette = 8=#ecba0f
palette = 9=#d6dbe5
palette = 10=#f3bd09
palette = 11=#1dd361
palette = 12=#5350b9
palette = 13=#0f7ddb
palette = 14=#1081d6
palette = 15=#d6dbe5
palette = 16=#de352e
palette = 17=#ffffff
palette = 18=#f81118
palette = 19=#2dc55e
palette = 20=#2a84d2
palette = 21=#1081d6

# Foreground & background colors
background = #1f1f1f
foreground = #4e5ab7
cursor-color = #4e5ab7
selection-background = #4e5ab7
selection-foreground = #2dc55e
search-background = #1dd361
search-foreground = #f81118
search-selected-background = #de352e
search-selected-foreground = #f81118

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d6dbe5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5350b9
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
