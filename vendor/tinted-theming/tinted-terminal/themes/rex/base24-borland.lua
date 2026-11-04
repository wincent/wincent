-- vim: ft=lua
-- Borland theme for Rex
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

local name = "base24-borland"
local variant = "dark"

-- This must match themes/ghostty/base24-borland exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Borland theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0000a4
palette = 1=#ff6b60
palette = 2=#a7ff60
palette = 3=#b5dcfe
palette = 4=#96cafd
palette = 5=#ff73fd
palette = 6=#c6c4fd
palette = 7=#d1d1d1
palette = 8=#989898
palette = 9=#ffb6b0
palette = 10=#ceffab
palette = 11=#ffffcb
palette = 12=#b5dcfe
palette = 13=#ff9cfe
palette = 14=#dfdffe
palette = 15=#ffffff
palette = 16=#ffffb6
palette = 17=#7f3530
palette = 18=#4e4e4e
palette = 19=#7c7c7c
palette = 20=#b5b5b5
palette = 21=#eeeeee

# Foreground & background colors
background = #0000a4
foreground = #d1d1d1
cursor-color = #d1d1d1
selection-background = #d1d1d1
selection-foreground = #7c7c7c
search-background = #b5dcfe
search-foreground = #4e4e4e
search-selected-background = #ffffb6
search-selected-foreground = #4e4e4e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b5dcfe
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
