-- vim: ft=lua
-- Treehouse theme for Rex
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

local name = "base24-treehouse"
local variant = "dark"

-- This must match themes/ghostty/base24-treehouse exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Treehouse theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#191919
palette = 1=#b1270e
palette = 2=#44a900
palette = 3=#85cfec
palette = 4=#578499
palette = 5=#96363c
palette = 6=#b2591d
palette = 7=#695d47
palette = 8=#4f4330
palette = 9=#ed5c20
palette = 10=#55f237
palette = 11=#f1b731
palette = 12=#85cfec
palette = 13=#e04b5a
palette = 14=#f07d14
palette = 15=#ffc800
palette = 16=#a9810b
palette = 17=#581307
palette = 18=#321200
palette = 19=#423625
palette = 20=#5c503c
palette = 21=#776b53

# Foreground & background colors
background = #191919
foreground = #695d47
cursor-color = #695d47
selection-background = #695d47
selection-foreground = #423625
search-background = #85cfec
search-foreground = #321200
search-selected-background = #a9810b
search-selected-foreground = #321200

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffc800
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #85cfec
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
