-- vim: ft=lua
-- Tokyo Night Storm theme for Rex
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

local name = "base16-tokyo-night-storm"
local variant = "dark"

-- This must match themes/ghostty/base16-tokyo-night-storm exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokyo Night Storm theme for Ghostty
# Scheme Author: Michaël Ball
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#24283b
palette = 1=#c0caf5
palette = 2=#9ece6a
palette = 3=#0db9d7
palette = 4=#2ac3de
palette = 5=#bb9af7
palette = 6=#b4f9f8
palette = 7=#a9b1d6
palette = 8=#444b6a
palette = 9=#c0caf5
palette = 10=#9ece6a
palette = 11=#0db9d7
palette = 12=#2ac3de
palette = 13=#bb9af7
palette = 14=#b4f9f8
palette = 15=#d5d6db
palette = 16=#a9b1d6
palette = 17=#f7768e
palette = 18=#16161e
palette = 19=#343a52
palette = 20=#787c99
palette = 21=#cbccd1

# Foreground & background colors
background = #24283b
foreground = #a9b1d6
cursor-color = #a9b1d6
selection-background = #a9b1d6
selection-foreground = #343a52
search-background = #0db9d7
search-foreground = #16161e
search-selected-background = #a9b1d6
search-selected-foreground = #16161e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d5d6db
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2ac3de
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
