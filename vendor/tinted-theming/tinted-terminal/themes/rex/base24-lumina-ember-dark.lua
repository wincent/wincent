-- vim: ft=lua
-- Lumina Ember Dark theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-ember-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-ember-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Ember Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#171511
palette = 1=#cb7870
palette = 2=#a9cc97
palette = 3=#e5cc88
palette = 4=#94bedc
palette = 5=#bbb5e3
palette = 6=#91c7cd
palette = 7=#e4ddd0
palette = 8=#2f2d28
palette = 9=#da9890
palette = 10=#c5e5b5
palette = 11=#ffe6a2
palette = 12=#b0d7f4
palette = 13=#f0bcdf
palette = 14=#aae1e7
palette = 15=#e4ddd0
palette = 16=#e59b7c
palette = 17=#d7a2c6
palette = 18=#1c1a15
palette = 19=#25231e
palette = 20=#6b6963
palette = 21=#b3b1ad

# Foreground & background colors
background = #171511
foreground = #e4ddd0
cursor-color = #e4ddd0
selection-background = #e4ddd0
selection-foreground = #25231e
search-background = #e5cc88
search-foreground = #1c1a15
search-selected-background = #e59b7c
search-selected-foreground = #1c1a15

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e4ddd0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b0d7f4
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
