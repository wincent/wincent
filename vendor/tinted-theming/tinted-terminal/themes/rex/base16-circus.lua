-- vim: ft=lua
-- Circus theme for Rex
-- Scheme Author: Stephan Boyer (https://github.com/stepchowfun) and Esther Wang (https://github.com/ewang12)
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

local name = "base16-circus"
local variant = "dark"

-- This must match themes/ghostty/base16-circus exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Circus theme for Ghostty
# Scheme Author: Stephan Boyer (https://github.com/stepchowfun) and Esther Wang (https://github.com/ewang12)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#191919
palette = 1=#dc657d
palette = 2=#84b97c
palette = 3=#c3ba63
palette = 4=#639ee4
palette = 5=#b888e2
palette = 6=#4bb1a7
palette = 7=#a7a7a7
palette = 8=#5f5a60
palette = 9=#dc657d
palette = 10=#84b97c
palette = 11=#c3ba63
palette = 12=#639ee4
palette = 13=#b888e2
palette = 14=#4bb1a7
palette = 15=#ffffff
palette = 16=#4bb1a7
palette = 17=#b888e2
palette = 18=#202020
palette = 19=#303030
palette = 20=#505050
palette = 21=#808080

# Foreground & background colors
background = #191919
foreground = #a7a7a7
cursor-color = #a7a7a7
selection-background = #a7a7a7
selection-foreground = #303030
search-background = #c3ba63
search-foreground = #202020
search-selected-background = #4bb1a7
search-selected-foreground = #202020

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #639ee4
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
