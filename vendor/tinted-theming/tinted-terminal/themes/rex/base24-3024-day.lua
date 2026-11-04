-- vim: ft=lua
-- 3024 Day theme for Rex
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

local name = "base24-3024-day"
local variant = "light"

-- This must match themes/ghostty/base24-3024-day exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# 3024 Day theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f7f7f7
palette = 1=#db2d20
palette = 2=#01a252
palette = 3=#807d7c
palette = 4=#01a0e4
palette = 5=#a16a94
palette = 6=#b5e4f4
palette = 7=#928f8e
palette = 8=#6e6a68
palette = 9=#e8bbd0
palette = 10=#3a3432
palette = 11=#4a4543
palette = 12=#807d7c
palette = 13=#d6d5d4
palette = 14=#cdab53
palette = 15=#090300
palette = 16=#fded02
palette = 17=#6d1610
palette = 18=#090300
palette = 19=#5c5855
palette = 20=#807d7b
palette = 21=#a5a2a2

# Foreground & background colors
background = #f7f7f7
foreground = #928f8e
cursor-color = #928f8e
selection-background = #928f8e
selection-foreground = #5c5855
search-background = #807d7c
search-foreground = #090300
search-selected-background = #fded02
search-selected-foreground = #090300

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #090300
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #807d7c
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
