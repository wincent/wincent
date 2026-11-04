-- vim: ft=lua
-- Highway theme for Rex
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

local name = "base24-highway"
local variant = "dark"

-- This must match themes/ghostty/base24-highway exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Highway theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#212224
palette = 1=#cf0d17
palette = 2=#128033
palette = 3=#4fc2fd
palette = 4=#006ab3
palette = 5=#6a2674
palette = 6=#384563
palette = 7=#c8c5c4
palette = 8=#807672
palette = 9=#ef7d17
palette = 10=#b1d130
palette = 11=#fff11f
palette = 12=#4fc2fd
palette = 13=#de0070
palette = 14=#5c4f49
palette = 15=#fefffe
palette = 16=#ffca3d
palette = 17=#67060b
palette = 18=#000000
palette = 19=#5c4f49
palette = 20=#a49e9b
palette = 21=#ededed

# Foreground & background colors
background = #212224
foreground = #c8c5c4
cursor-color = #c8c5c4
selection-background = #c8c5c4
selection-foreground = #5c4f49
search-background = #4fc2fd
search-foreground = #000000
search-selected-background = #ffca3d
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fefffe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4fc2fd
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
