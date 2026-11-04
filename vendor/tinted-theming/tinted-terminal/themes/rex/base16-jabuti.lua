-- vim: ft=lua
-- Jabuti theme for Rex
-- Scheme Author: https://github.com/notusknot
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

local name = "base16-jabuti"
local variant = "dark"

-- This must match themes/ghostty/base16-jabuti exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Jabuti theme for Ghostty
# Scheme Author: https://github.com/notusknot
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#292a37
palette = 1=#ec6a88
palette = 2=#3fdaa4
palette = 3=#e1c697
palette = 4=#3fc6de
palette = 5=#be95ff
palette = 6=#ff7eb6
palette = 7=#c0cbe3
palette = 8=#45475d
palette = 9=#ec6a88
palette = 10=#3fdaa4
palette = 11=#e1c697
palette = 12=#3fc6de
palette = 13=#be95ff
palette = 14=#ff7eb6
palette = 15=#ffffff
palette = 16=#efb993
palette = 17=#8b8da9
palette = 18=#343545
palette = 19=#3c3e51
palette = 20=#50526b
palette = 21=#d9e0ee

# Foreground & background colors
background = #292a37
foreground = #c0cbe3
cursor-color = #c0cbe3
selection-background = #c0cbe3
selection-foreground = #3c3e51
search-background = #e1c697
search-foreground = #343545
search-selected-background = #efb993
search-selected-foreground = #343545

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3fc6de
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
