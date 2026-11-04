-- vim: ft=lua
-- Noche theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-noche"
local variant = "dark"

-- This must match themes/ghostty/base16-noche exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Noche theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0c0e16
palette = 1=#e2727e
palette = 2=#7cc596
palette = 3=#d8c062
palette = 4=#7aa0e8
palette = 5=#b79ae0
palette = 6=#6dd8d0
palette = 7=#cbd4ec
palette = 8=#5a6178
palette = 9=#e2727e
palette = 10=#7cc596
palette = 11=#d8c062
palette = 12=#7aa0e8
palette = 13=#b79ae0
palette = 14=#6dd8d0
palette = 15=#e6ecfa
palette = 16=#82a6e0
palette = 17=#3a4260
palette = 18=#181c2c
palette = 19=#232a40
palette = 20=#939bb2
palette = 21=#d9e0f3

# Foreground & background colors
background = #0c0e16
foreground = #cbd4ec
cursor-color = #cbd4ec
selection-background = #cbd4ec
selection-foreground = #232a40
search-background = #d8c062
search-foreground = #181c2c
search-selected-background = #82a6e0
search-selected-foreground = #181c2c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e6ecfa
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7aa0e8
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
