-- vim: ft=lua
-- Tokyo Night Terminal Light theme for Rex
-- Scheme Author: Michaël Ball
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

local name = "base16-tokyo-night-terminal-light"
local variant = "light"

-- This must match themes/ghostty/base16-tokyo-night-terminal-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokyo Night Terminal Light theme for Ghostty
# Scheme Author: Michaël Ball
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#d5d6db
palette = 1=#8c4351
palette = 2=#33635c
palette = 3=#8f5e15
palette = 4=#34548a
palette = 5=#5a4a78
palette = 6=#0f4b6e
palette = 7=#4c505e
palette = 8=#9699a3
palette = 9=#8c4351
palette = 10=#33635c
palette = 11=#8f5e15
palette = 12=#34548a
palette = 13=#5a4a78
palette = 14=#0f4b6e
palette = 15=#1a1b26
palette = 16=#965027
palette = 17=#655259
palette = 18=#cbccd1
palette = 19=#dfe0e5
palette = 20=#4c505e
palette = 21=#1a1b26

# Foreground & background colors
background = #d5d6db
foreground = #4c505e
cursor-color = #4c505e
selection-background = #4c505e
selection-foreground = #dfe0e5
search-background = #8f5e15
search-foreground = #1a1b26
search-selected-background = #965027
search-selected-foreground = #1a1b26

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1a1b26
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #34548a
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
