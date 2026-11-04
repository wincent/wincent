-- vim: ft=lua
-- Desert theme for Rex
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

local name = "base24-desert"
local variant = "dark"

-- This must match themes/ghostty/base24-desert exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Desert theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#333333
palette = 1=#ff2b2b
palette = 2=#98fb98
palette = 3=#87ceff
palette = 4=#cd853f
palette = 5=#ffdead
palette = 6=#ffa0a0
palette = 7=#cdbb9b
palette = 8=#7d776c
palette = 9=#ff5555
palette = 10=#55ff55
palette = 11=#ffff55
palette = 12=#87ceff
palette = 13=#ff55ff
palette = 14=#ffd700
palette = 15=#ffffff
palette = 16=#f0e68c
palette = 17=#7f1515
palette = 18=#4d4d4d
palette = 19=#555555
palette = 20=#a59984
palette = 21=#f5deb3

# Foreground & background colors
background = #333333
foreground = #cdbb9b
cursor-color = #cdbb9b
selection-background = #cdbb9b
selection-foreground = #555555
search-background = #87ceff
search-foreground = #4d4d4d
search-selected-background = #f0e68c
search-selected-foreground = #4d4d4d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #87ceff
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
