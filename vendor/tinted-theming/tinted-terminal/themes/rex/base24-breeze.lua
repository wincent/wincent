-- vim: ft=lua
-- Breeze theme for Rex
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

local name = "base24-breeze"
local variant = "dark"

-- This must match themes/ghostty/base24-breeze exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Breeze theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#31363b
palette = 1=#ed1515
palette = 2=#11d116
palette = 3=#3daee9
palette = 4=#1d99f3
palette = 5=#9b59b6
palette = 6=#1abc9c
palette = 7=#d3d7d8
palette = 8=#9ba5a6
palette = 9=#c0392b
palette = 10=#1cdc9a
palette = 11=#fdbc4b
palette = 12=#3daee9
palette = 13=#8e44ad
palette = 14=#16a085
palette = 15=#fcfcfc
palette = 16=#f67400
palette = 17=#760a0a
palette = 18=#31363b
palette = 19=#7f8c8d
palette = 20=#b7bebf
palette = 21=#eff0f1

# Foreground & background colors
background = #31363b
foreground = #d3d7d8
cursor-color = #d3d7d8
selection-background = #d3d7d8
selection-foreground = #7f8c8d
search-background = #3daee9
search-foreground = #31363b
search-selected-background = #f67400
search-selected-foreground = #31363b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcfcfc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3daee9
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
