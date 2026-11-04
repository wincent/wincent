-- vim: ft=lua
-- Catppuccin Mocha theme for Rex
-- Scheme Author: https://github.com/catppuccin/catppuccin
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

local name = "base24-catppuccin-mocha"
local variant = "dark"

-- This must match themes/ghostty/base24-catppuccin-mocha exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Catppuccin Mocha theme for Ghostty
# Scheme Author: https://github.com/catppuccin/catppuccin
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e1e2e
palette = 1=#f38ba8
palette = 2=#a6e3a1
palette = 3=#f9e2af
palette = 4=#89b4fa
palette = 5=#cba6f7
palette = 6=#94e2d5
palette = 7=#cdd6f4
palette = 8=#45475a
palette = 9=#eba0ac
palette = 10=#a6e3a1
palette = 11=#f5e0dc
palette = 12=#74c7ec
palette = 13=#f5c2e7
palette = 14=#89dceb
palette = 15=#b4befe
palette = 16=#fab387
palette = 17=#f2cdcd
palette = 18=#181825
palette = 19=#313244
palette = 20=#585b70
palette = 21=#f5e0dc

# Foreground & background colors
background = #1e1e2e
foreground = #cdd6f4
cursor-color = #cdd6f4
selection-background = #cdd6f4
selection-foreground = #313244
search-background = #f9e2af
search-foreground = #181825
search-selected-background = #fab387
search-selected-foreground = #181825

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #b4befe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #74c7ec
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
