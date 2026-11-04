-- vim: ft=lua
-- UwUnicorn theme for Rex
-- Scheme Author: Fernando Marques (https://github.com/RakkiUwU) and Gabriel Fontes (https://github.com/Misterio77)
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

local name = "base16-uwunicorn"
local variant = "dark"

-- This must match themes/ghostty/base16-uwunicorn exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# UwUnicorn theme for Ghostty
# Scheme Author: Fernando Marques (https://github.com/RakkiUwU) and Gabriel Fontes (https://github.com/Misterio77)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#241b26
palette = 1=#877bb6
palette = 2=#c965bf
palette = 3=#a84a73
palette = 4=#6a9eb5
palette = 5=#78a38f
palette = 6=#9c5fce
palette = 7=#eed5d9
palette = 8=#6c3cb2
palette = 9=#877bb6
palette = 10=#c965bf
palette = 11=#a84a73
palette = 12=#6a9eb5
palette = 13=#78a38f
palette = 14=#9c5fce
palette = 15=#e4ccd0
palette = 16=#de5b44
palette = 17=#a3a079
palette = 18=#2f2a3f
palette = 19=#46354a
palette = 20=#7e5f83
palette = 21=#d9c2c6

# Foreground & background colors
background = #241b26
foreground = #eed5d9
cursor-color = #eed5d9
selection-background = #eed5d9
selection-foreground = #46354a
search-background = #a84a73
search-foreground = #2f2a3f
search-selected-background = #de5b44
search-selected-foreground = #2f2a3f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e4ccd0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6a9eb5
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
