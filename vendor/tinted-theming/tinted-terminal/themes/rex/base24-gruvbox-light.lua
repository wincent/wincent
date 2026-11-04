-- vim: ft=lua
-- Gruvbox Light theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming), morhetz (https://github.com/morhetz/gruvbox)
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

local name = "base24-gruvbox-light"
local variant = "light"

-- This must match themes/ghostty/base24-gruvbox-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gruvbox Light theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming), morhetz (https://github.com/morhetz/gruvbox)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fbf1c7
palette = 1=#cc241d
palette = 2=#98971a
palette = 3=#d79921
palette = 4=#458588
palette = 5=#b16286
palette = 6=#689d6a
palette = 7=#3c3836
palette = 8=#bdae93
palette = 9=#9d0006
palette = 10=#79740e
palette = 11=#b57614
palette = 12=#076678
palette = 13=#8f3f71
palette = 14=#427b58
palette = 15=#1d2021
palette = 16=#d65d0e
palette = 17=#9d0006
palette = 18=#ebdbb2
palette = 19=#d5c4a1
palette = 20=#7c6f64
palette = 21=#282828

# Foreground & background colors
background = #fbf1c7
foreground = #3c3836
cursor-color = #3c3836
selection-background = #3c3836
selection-foreground = #d5c4a1
search-background = #d79921
search-foreground = #ebdbb2
search-selected-background = #d65d0e
search-selected-foreground = #ebdbb2

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1d2021
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #076678
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
