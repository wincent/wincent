-- vim: ft=lua
-- Windows 10 Light theme for Rex
-- Scheme Author: Fergus Collins (https://github.com/ferguscollins)
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

local name = "base16-windows-10-light"
local variant = "light"

-- This must match themes/ghostty/base16-windows-10-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Windows 10 Light theme for Ghostty
# Scheme Author: Fergus Collins (https://github.com/ferguscollins)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f2f2f2
palette = 1=#c50f1f
palette = 2=#13a10e
palette = 3=#c19c00
palette = 4=#0037da
palette = 5=#881798
palette = 6=#3a96dd
palette = 7=#767676
palette = 8=#cccccc
palette = 9=#c50f1f
palette = 10=#13a10e
palette = 11=#c19c00
palette = 12=#0037da
palette = 13=#881798
palette = 14=#3a96dd
palette = 15=#0c0c0c
palette = 16=#f9f1a5
palette = 17=#16c60c
palette = 18=#e5e5e5
palette = 19=#d9d9d9
palette = 20=#ababab
palette = 21=#414141

# Foreground & background colors
background = #f2f2f2
foreground = #767676
cursor-color = #767676
selection-background = #767676
selection-foreground = #d9d9d9
search-background = #c19c00
search-foreground = #0c0c0c
search-selected-background = #f9f1a5
search-selected-foreground = #0c0c0c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0c0c0c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0037da
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
