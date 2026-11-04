-- vim: ft=lua
-- Digital Rain theme for Rex
-- Scheme Author: Nathan Byrd (https://github.com/cognitivegears)
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

local name = "base16-digital-rain"
local variant = "dark"

-- This must match themes/ghostty/base16-digital-rain exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Digital Rain theme for Ghostty
# Scheme Author: Nathan Byrd (https://github.com/cognitivegears)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#c85a46
palette = 2=#64c83c
palette = 3=#a67a50
palette = 4=#5482af
palette = 5=#9472b4
palette = 6=#468c78
palette = 7=#00ff00
palette = 8=#7c8d7c
palette = 9=#c85a46
palette = 10=#64c83c
palette = 11=#a67a50
palette = 12=#5482af
palette = 13=#9472b4
palette = 14=#468c78
palette = 15=#d8e2dc
palette = 16=#c86428
palette = 17=#b37c5e
palette = 18=#4a806c
palette = 19=#4a8d7e
palette = 20=#919893
palette = 21=#c4cec4

# Foreground & background colors
background = #000000
foreground = #00ff00
cursor-color = #00ff00
selection-background = #00ff00
selection-foreground = #4a8d7e
search-background = #a67a50
search-foreground = #4a806c
search-selected-background = #c86428
search-selected-foreground = #4a806c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d8e2dc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5482af
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
