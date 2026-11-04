-- vim: ft=lua
-- Blue Berry Pie theme for Rex
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

local name = "base24-blue-berry-pie"
local variant = "dark"

-- This must match themes/ghostty/base24-blue-berry-pie exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Blue Berry Pie theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c0b28
palette = 1=#99236d
palette = 2=#5bb0b2
palette = 3=#38163d
palette = 4=#90a5bc
palette = 5=#9d53a7
palette = 6=#7e82cc
palette = 7=#bbb2ad
palette = 8=#534a5e
palette = 9=#c77171
palette = 10=#0a6b7e
palette = 11=#793188
palette = 12=#38163d
palette = 13=#bc93b6
palette = 14=#5d5f71
palette = 15=#f0e7d5
palette = 16=#e9b8a7
palette = 17=#4c1136
palette = 18=#0a4b61
palette = 19=#1f1637
palette = 20=#877e86
palette = 21=#f0e7d5

# Foreground & background colors
background = #1c0b28
foreground = #bbb2ad
cursor-color = #bbb2ad
selection-background = #bbb2ad
selection-foreground = #1f1637
search-background = #38163d
search-foreground = #0a4b61
search-selected-background = #e9b8a7
search-selected-foreground = #0a4b61

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f0e7d5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #38163d
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
