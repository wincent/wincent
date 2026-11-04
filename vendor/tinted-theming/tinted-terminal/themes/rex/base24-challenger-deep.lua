-- vim: ft=lua
-- Challenger Deep theme for Rex
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

local name = "base24-challenger-deep"
local variant = "dark"

-- This must match themes/ghostty/base24-challenger-deep exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Challenger Deep theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e1c31
palette = 1=#ff5458
palette = 2=#62d196
palette = 3=#91ddff
palette = 4=#65b2ff
palette = 5=#906cff
palette = 6=#63f2f1
palette = 7=#929bb6
palette = 8=#6a6c8a
palette = 9=#ff8080
palette = 10=#95ffa4
palette = 11=#ffe9aa
palette = 12=#91ddff
palette = 13=#c991e1
palette = 14=#aaffe4
palette = 15=#cbe3e7
palette = 16=#ffb378
palette = 17=#7f2a2c
palette = 18=#141127
palette = 19=#565575
palette = 20=#7e84a0
palette = 21=#a6b3cc

# Foreground & background colors
background = #1e1c31
foreground = #929bb6
cursor-color = #929bb6
selection-background = #929bb6
selection-foreground = #565575
search-background = #91ddff
search-foreground = #141127
search-selected-background = #ffb378
search-selected-foreground = #141127

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #cbe3e7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #91ddff
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
