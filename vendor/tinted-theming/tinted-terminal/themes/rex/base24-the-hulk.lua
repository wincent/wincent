-- vim: ft=lua
-- The Hulk theme for Rex
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

local name = "base24-the-hulk"
local variant = "dark"

-- This must match themes/ghostty/base24-the-hulk exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# The Hulk theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1b1d1e
palette = 1=#259d1a
palette = 2=#13ce2f
palette = 3=#4f6a95
palette = 4=#2424f4
palette = 5=#641e73
palette = 6=#378ca9
palette = 7=#b6b6b1
palette = 8=#727473
palette = 9=#8dff2a
palette = 10=#48ff76
palette = 11=#3afe15
palette = 12=#4f6a95
palette = 13=#72579d
palette = 14=#3f85a5
palette = 15=#e5e5e0
palette = 16=#62e456
palette = 17=#124e0d
palette = 18=#1b1d1e
palette = 19=#505354
palette = 20=#949592
palette = 21=#d8d8d0

# Foreground & background colors
background = #1b1d1e
foreground = #b6b6b1
cursor-color = #b6b6b1
selection-background = #b6b6b1
selection-foreground = #505354
search-background = #4f6a95
search-foreground = #1b1d1e
search-selected-background = #62e456
search-selected-foreground = #1b1d1e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e5e5e0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4f6a95
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
