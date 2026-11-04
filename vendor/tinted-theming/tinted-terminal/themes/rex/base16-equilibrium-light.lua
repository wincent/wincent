-- vim: ft=lua
-- Equilibrium Light theme for Rex
-- Scheme Author: Carlo Abelli
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

local name = "base16-equilibrium-light"
local variant = "light"

-- This must match themes/ghostty/base16-equilibrium-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Equilibrium Light theme for Ghostty
# Scheme Author: Carlo Abelli
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5f0e7
palette = 1=#d02023
palette = 2=#637200
palette = 3=#9d6f00
palette = 4=#0073b5
palette = 5=#4e66b6
palette = 6=#007a72
palette = 7=#43474e
palette = 8=#73777f
palette = 9=#d02023
palette = 10=#637200
palette = 11=#9d6f00
palette = 12=#0073b5
palette = 13=#4e66b6
palette = 14=#007a72
palette = 15=#181c22
palette = 16=#bf3e05
palette = 17=#c42775
palette = 18=#e7e2d9
palette = 19=#d8d4cb
palette = 20=#5a5f66
palette = 21=#2c3138

# Foreground & background colors
background = #f5f0e7
foreground = #43474e
cursor-color = #43474e
selection-background = #43474e
selection-foreground = #d8d4cb
search-background = #9d6f00
search-foreground = #181c22
search-selected-background = #bf3e05
search-selected-foreground = #181c22

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #181c22
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0073b5
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
