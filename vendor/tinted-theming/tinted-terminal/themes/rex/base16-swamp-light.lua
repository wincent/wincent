-- vim: ft=lua
-- Swamp Light theme for Rex
-- Scheme Author: Masroof Maindak (https://github.com/masroof-maindak)
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

local name = "base16-swamp-light"
local variant = "light"

-- This must match themes/ghostty/base16-swamp-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Swamp Light theme for Ghostty
# Scheme Author: Masroof Maindak (https://github.com/masroof-maindak)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f1e3d1
palette = 1=#d09700
palette = 2=#908d6a
palette = 3=#993333
palette = 4=#bf7979
palette = 5=#9e5581
palette = 6=#d09700
palette = 7=#64513e
palette = 8=#b5a492
palette = 9=#d09700
palette = 10=#908d6a
palette = 11=#993333
palette = 12=#bf7979
palette = 13=#9e5581
palette = 14=#d09700
palette = 15=#8c7b68
palette = 16=#64513e
palette = 17=#75858c
palette = 18=#ddcebc
palette = 19=#c9b9a7
palette = 20=#a0907d
palette = 21=#786653

# Foreground & background colors
background = #f1e3d1
foreground = #64513e
cursor-color = #64513e
selection-background = #64513e
selection-foreground = #c9b9a7
search-background = #993333
search-foreground = #8c7b68
search-selected-background = #64513e
search-selected-foreground = #8c7b68

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #8c7b68
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #bf7979
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
