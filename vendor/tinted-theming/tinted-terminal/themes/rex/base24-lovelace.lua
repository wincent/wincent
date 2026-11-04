-- vim: ft=lua
-- Lovelace theme for Rex
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

local name = "base24-lovelace"
local variant = "dark"

-- This must match themes/ghostty/base24-lovelace exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lovelace theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d1f28
palette = 1=#f37f97
palette = 2=#5adecd
palette = 3=#556fff
palette = 4=#8897f4
palette = 5=#c574dd
palette = 6=#79e6f3
palette = 7=#ceced3
palette = 8=#707281
palette = 9=#ff4971
palette = 10=#18e3c8
palette = 11=#ff8037
palette = 12=#556fff
palette = 13=#b043d1
palette = 14=#3fdcee
palette = 15=#bebec1
palette = 16=#f2a272
palette = 17=#793f4b
palette = 18=#282a36
palette = 19=#414458
palette = 20=#9fa0aa
palette = 21=#fdfdfd

# Foreground & background colors
background = #1d1f28
foreground = #ceced3
cursor-color = #ceced3
selection-background = #ceced3
selection-foreground = #414458
search-background = #556fff
search-foreground = #282a36
search-selected-background = #f2a272
search-selected-foreground = #282a36

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #bebec1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #556fff
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
