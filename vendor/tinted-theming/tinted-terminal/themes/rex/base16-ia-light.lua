-- vim: ft=lua
-- iA Light theme for Rex
-- Scheme Author: iA Inc. (modified by aramisgithub)
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

local name = "base16-ia-light"
local variant = "light"

-- This must match themes/ghostty/base16-ia-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# iA Light theme for Ghostty
# Scheme Author: iA Inc. (modified by aramisgithub)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f6f6f6
palette = 1=#9c5a02
palette = 2=#38781c
palette = 3=#c48218
palette = 4=#48bac2
palette = 5=#a94598
palette = 6=#2d6bb1
palette = 7=#181818
palette = 8=#898989
palette = 9=#9c5a02
palette = 10=#38781c
palette = 11=#c48218
palette = 12=#48bac2
palette = 13=#a94598
palette = 14=#2d6bb1
palette = 15=#f8f8f8
palette = 16=#c43e18
palette = 17=#8b6c37
palette = 18=#dedede
palette = 19=#bde5f2
palette = 20=#767676
palette = 21=#e8e8e8

# Foreground & background colors
background = #f6f6f6
foreground = #181818
cursor-color = #181818
selection-background = #181818
selection-foreground = #bde5f2
search-background = #c48218
search-foreground = #f8f8f8
search-selected-background = #c43e18
search-selected-foreground = #f8f8f8

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8f8f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #48bac2
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
