-- vim: ft=lua
-- Lumina Quartz Dark theme for Rex
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

local name = "base24-lumina-quartz-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-quartz-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Quartz Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#161719
palette = 1=#c57c74
palette = 2=#9dd7b7
palette = 3=#dfcfb0
palette = 4=#b6ceed
palette = 5=#cbb4ef
palette = 6=#a8d5db
palette = 7=#ccd0d3
palette = 8=#2e2f31
palette = 9=#d59a93
palette = 10=#c2edd5
palette = 11=#ffe5b1
palette = 12=#d6e8ff
palette = 13=#ffd7fa
palette = 14=#c1eff6
palette = 15=#ccd0d3
palette = 16=#f6be9a
palette = 17=#e4bddf
palette = 18=#1a1c1e
palette = 19=#242527
palette = 20=#676a6d
palette = 21=#b0b1b3

# Foreground & background colors
background = #161719
foreground = #ccd0d3
cursor-color = #ccd0d3
selection-background = #ccd0d3
selection-foreground = #242527
search-background = #dfcfb0
search-foreground = #1a1c1e
search-selected-background = #f6be9a
search-selected-foreground = #1a1c1e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ccd0d3
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #d6e8ff
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
