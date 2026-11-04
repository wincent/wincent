-- vim: ft=lua
-- Lumina Harbor Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-harbor-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-harbor-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Harbor Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fbf5ec
palette = 1=#8c1c1d
palette = 2=#19784d
palette = 3=#a25f06
palette = 4=#0468a4
palette = 5=#6758a8
palette = 6=#046871
palette = 7=#1c2d4f
palette = 8=#dad2c6
palette = 9=#651f1d
palette = 10=#00623c
palette = 11=#874e00
palette = 12=#005486
palette = 13=#713b7d
palette = 14=#00535a
palette = 15=#1c2d4f
palette = 16=#9f501d
palette = 17=#8b499a
palette = 18=#f6eee1
palette = 19=#ebe2d6
palette = 20=#8d857a
palette = 21=#4d473c

# Foreground & background colors
background = #fbf5ec
foreground = #1c2d4f
cursor-color = #1c2d4f
selection-background = #1c2d4f
selection-foreground = #ebe2d6
search-background = #a25f06
search-foreground = #f6eee1
search-selected-background = #9f501d
search-selected-foreground = #f6eee1

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1c2d4f
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #005486
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
