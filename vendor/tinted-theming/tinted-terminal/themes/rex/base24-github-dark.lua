-- vim: ft=lua
-- Github Dark theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming)
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

local name = "base24-github-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-github-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Github Dark theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0d1117
palette = 1=#ff7b72
palette = 2=#3fb950
palette = 3=#d29922
palette = 4=#58a6ff
palette = 5=#be8fff
palette = 6=#39c5cf
palette = 7=#d1d7e0
palette = 8=#656c76
palette = 9=#ffa198
palette = 10=#56d364
palette = 11=#e3b341
palette = 12=#79c0ff
palette = 13=#d2a8ff
palette = 14=#56d4dd
palette = 15=#ffffff
palette = 16=#ffa657
palette = 17=#ffa198
palette = 18=#151b23
palette = 19=#2f3742
palette = 20=#9198a1
palette = 21=#f0f6fc

# Foreground & background colors
background = #0d1117
foreground = #d1d7e0
cursor-color = #d1d7e0
selection-background = #d1d7e0
selection-foreground = #2f3742
search-background = #d29922
search-foreground = #151b23
search-selected-background = #ffa657
search-selected-foreground = #151b23

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #79c0ff
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
