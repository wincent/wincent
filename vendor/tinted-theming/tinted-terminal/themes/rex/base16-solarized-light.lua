-- vim: ft=lua
-- Solarized Light theme for Rex
-- Scheme Author: Ethan Schoonover (modified by aramisgithub)
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

local name = "base16-solarized-light"
local variant = "light"

-- This must match themes/ghostty/base16-solarized-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Solarized Light theme for Ghostty
# Scheme Author: Ethan Schoonover (modified by aramisgithub)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fdf6e3
palette = 1=#dc322f
palette = 2=#859900
palette = 3=#b58900
palette = 4=#268bd2
palette = 5=#6c71c4
palette = 6=#2aa198
palette = 7=#586e75
palette = 8=#839496
palette = 9=#dc322f
palette = 10=#859900
palette = 11=#b58900
palette = 12=#268bd2
palette = 13=#6c71c4
palette = 14=#2aa198
palette = 15=#002b36
palette = 16=#cb4b16
palette = 17=#d33682
palette = 18=#eee8d5
palette = 19=#93a1a1
palette = 20=#657b83
palette = 21=#073642

# Foreground & background colors
background = #fdf6e3
foreground = #586e75
cursor-color = #586e75
selection-background = #586e75
selection-foreground = #93a1a1
search-background = #b58900
search-foreground = #002b36
search-selected-background = #cb4b16
search-selected-foreground = #002b36

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #002b36
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #268bd2
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
