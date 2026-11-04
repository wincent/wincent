-- vim: ft=lua
-- Nord Light theme for Rex
-- Scheme Author: threddast, based on fuxialexander&#39;s doom-nord-light-theme (Doom Emacs)
-- Scheme System: base16
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

local name = "base16-nord-light"
local variant = "light"

-- This must match themes/ghostty/base16-nord-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Nord Light theme for Ghostty
# Scheme Author: threddast, based on fuxialexander&#39;s doom-nord-light-theme (Doom Emacs)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#e5e9f0
palette = 1=#99324b
palette = 2=#4f894c
palette = 3=#9a7500
palette = 4=#3b6ea8
palette = 5=#97365b
palette = 6=#398eac
palette = 7=#2e3440
palette = 8=#aebacf
palette = 9=#99324b
palette = 10=#4f894c
palette = 11=#9a7500
palette = 12=#3b6ea8
palette = 13=#97365b
palette = 14=#398eac
palette = 15=#29838d
palette = 16=#ac4426
palette = 17=#5272af
palette = 18=#c2d0e7
palette = 19=#b8c5db
palette = 20=#60728c
palette = 21=#3b4252

# Foreground & background colors
background = #e5e9f0
foreground = #2e3440
cursor-color = #2e3440
selection-background = #2e3440
selection-foreground = #b8c5db
search-background = #9a7500
search-foreground = #29838d
search-selected-background = #ac4426
search-selected-foreground = #29838d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #29838d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3b6ea8
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
