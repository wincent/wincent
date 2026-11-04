-- vim: ft=lua
-- Apprentice theme for Rex
-- Scheme Author: Romain Lafourcade (https://github.com/romainl)
-- Scheme System: base24
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

local name = "base24-apprentice"
local variant = "dark"

-- This must match themes/ghostty/base24-apprentice exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Apprentice theme for Ghostty
# Scheme Author: Romain Lafourcade (https://github.com/romainl)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#262626
palette = 1=#af5f5f
palette = 2=#5f875f
palette = 3=#87875f
palette = 4=#5f87af
palette = 5=#5f5f87
palette = 6=#5f8787
palette = 7=#bcbcbc
palette = 8=#444444
palette = 9=#ff8700
palette = 10=#87af87
palette = 11=#ffffaf
palette = 12=#87afd7
palette = 13=#8787af
palette = 14=#5fafaf
palette = 15=#ffffff
palette = 16=#ff8700
palette = 17=#af5f5f
palette = 18=#303030
palette = 19=#3a3a3a
palette = 20=#6c6c6c
palette = 21=#dfdfdf

# Foreground & background colors
background = #262626
foreground = #bcbcbc
cursor-color = #bcbcbc
selection-background = #bcbcbc
selection-foreground = #3a3a3a
search-background = #87875f
search-foreground = #303030
search-selected-background = #ff8700
search-selected-foreground = #303030

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #87afd7
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
