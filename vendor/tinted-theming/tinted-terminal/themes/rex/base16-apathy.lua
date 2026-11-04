-- vim: ft=lua
-- Apathy theme for Rex
-- Scheme Author: Jannik Siebert (https://github.com/janniks)
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

local name = "base16-apathy"
local variant = "dark"

-- This must match themes/ghostty/base16-apathy exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Apathy theme for Ghostty
# Scheme Author: Jannik Siebert (https://github.com/janniks)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#031a16
palette = 1=#3e9688
palette = 2=#883e96
palette = 3=#3e4c96
palette = 4=#96883e
palette = 5=#4c963e
palette = 6=#963e4c
palette = 7=#81b5ac
palette = 8=#2b685e
palette = 9=#3e9688
palette = 10=#883e96
palette = 11=#3e4c96
palette = 12=#96883e
palette = 13=#4c963e
palette = 14=#963e4c
palette = 15=#d2e7e4
palette = 16=#3e7996
palette = 17=#3e965b
palette = 18=#0b342d
palette = 19=#184e45
palette = 20=#5f9c92
palette = 21=#a7cec8

# Foreground & background colors
background = #031a16
foreground = #81b5ac
cursor-color = #81b5ac
selection-background = #81b5ac
selection-foreground = #184e45
search-background = #3e4c96
search-foreground = #0b342d
search-selected-background = #3e7996
search-selected-foreground = #0b342d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d2e7e4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #96883e
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
