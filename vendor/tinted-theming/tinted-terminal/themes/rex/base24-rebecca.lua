-- vim: ft=lua
-- Rebecca theme for Rex
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

local name = "base24-rebecca"
local variant = "dark"

-- This must match themes/ghostty/base24-rebecca exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Rebecca theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#292a44
palette = 1=#dd7655
palette = 2=#04dbb4
palette = 3=#69bffa
palette = 4=#7aa5ff
palette = 5=#be9bf8
palette = 6=#56d3c1
palette = 7=#c3c3d4
palette = 8=#8585ac
palette = 9=#ff91cd
palette = 10=#00e9c0
palette = 11=#fefca8
palette = 12=#69bffa
palette = 13=#c07ff8
palette = 14=#8bfce1
palette = 15=#f3f2f8
palette = 16=#f2e7b7
palette = 17=#6e3b2a
palette = 18=#12131d
palette = 19=#666699
palette = 20=#a4a4c0
palette = 21=#e3e2e8

# Foreground & background colors
background = #292a44
foreground = #c3c3d4
cursor-color = #c3c3d4
selection-background = #c3c3d4
selection-foreground = #666699
search-background = #69bffa
search-foreground = #12131d
search-selected-background = #f2e7b7
search-selected-foreground = #12131d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f3f2f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #69bffa
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
