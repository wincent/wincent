-- vim: ft=lua
-- Windows 10 theme for Rex
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

local name = "base16-windows-10"
local variant = "dark"

-- This must match themes/ghostty/base16-windows-10 exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Windows 10 theme for Ghostty
# Scheme Author: Fergus Collins (https://github.com/ferguscollins)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0c0c0c
palette = 1=#e74856
palette = 2=#16c60c
palette = 3=#f9f1a5
palette = 4=#3b78ff
palette = 5=#b4009e
palette = 6=#61d6d6
palette = 7=#cccccc
palette = 8=#767676
palette = 9=#e74856
palette = 10=#16c60c
palette = 11=#f9f1a5
palette = 12=#3b78ff
palette = 13=#b4009e
palette = 14=#61d6d6
palette = 15=#f2f2f2
palette = 16=#c19c00
palette = 17=#13a10e
palette = 18=#2f2f2f
palette = 19=#535353
palette = 20=#b9b9b9
palette = 21=#dfdfdf

# Foreground & background colors
background = #0c0c0c
foreground = #cccccc
cursor-color = #cccccc
selection-background = #cccccc
selection-foreground = #535353
search-background = #f9f1a5
search-foreground = #2f2f2f
search-selected-background = #c19c00
search-selected-foreground = #2f2f2f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f2f2f2
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3b78ff
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
