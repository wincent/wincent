-- vim: ft=lua
-- Adventure Time theme for Rex
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

local name = "base24-adventure-time"
local variant = "dark"

-- This must match themes/ghostty/base24-adventure-time exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Adventure Time theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e1c44
palette = 1=#bc0013
palette = 2=#49b117
palette = 3=#1896c6
palette = 4=#0f49c6
palette = 5=#665992
palette = 6=#6fa497
palette = 7=#cdc3bf
palette = 8=#7893bf
palette = 9=#fc5e59
palette = 10=#9dff6e
palette = 11=#efc11a
palette = 12=#1896c6
palette = 13=#9a5952
palette = 14=#c8f9f3
palette = 15=#f5f4fb
palette = 16=#e6741d
palette = 17=#5e0009
palette = 18=#050404
palette = 19=#4e7bbf
palette = 20=#a3abbf
palette = 21=#f8dbc0

# Foreground & background colors
background = #1e1c44
foreground = #cdc3bf
cursor-color = #cdc3bf
selection-background = #cdc3bf
selection-foreground = #4e7bbf
search-background = #1896c6
search-foreground = #050404
search-selected-background = #e6741d
search-selected-foreground = #050404

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f5f4fb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1896c6
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
