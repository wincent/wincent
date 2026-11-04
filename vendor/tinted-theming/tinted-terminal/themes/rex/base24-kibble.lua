-- vim: ft=lua
-- Kibble theme for Rex
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

local name = "base24-kibble"
local variant = "dark"

-- This must match themes/ghostty/base24-kibble exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Kibble theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0e100a
palette = 1=#c70031
palette = 2=#29cf13
palette = 3=#97a4f7
palette = 4=#3449d1
palette = 5=#8400ff
palette = 6=#0798ab
palette = 7=#c0b3c0
palette = 8=#7c777c
palette = 9=#f01578
palette = 10=#6ce05c
palette = 11=#f3f79e
palette = 12=#97a4f7
palette = 13=#c495f0
palette = 14=#68f2e0
palette = 15=#ffffff
palette = 16=#d8e30e
palette = 17=#630018
palette = 18=#4d4d4d
palette = 19=#5a5a5a
palette = 20=#9e959e
palette = 21=#e2d1e3

# Foreground & background colors
background = #0e100a
foreground = #c0b3c0
cursor-color = #c0b3c0
selection-background = #c0b3c0
selection-foreground = #5a5a5a
search-background = #97a4f7
search-foreground = #4d4d4d
search-selected-background = #d8e30e
search-selected-foreground = #4d4d4d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #97a4f7
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
