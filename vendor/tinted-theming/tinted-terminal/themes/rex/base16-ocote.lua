-- vim: ft=lua
-- Ocote theme for Rex
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

local name = "base16-ocote"
local variant = "dark"

-- This must match themes/ghostty/base16-ocote exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ocote theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#14100c
palette = 1=#e8635a
palette = 2=#7dc97a
palette = 3=#e8b43a
palette = 4=#82a6e0
palette = 5=#c58ae0
palette = 6=#6dd8c8
palette = 7=#e7dcc6
palette = 8=#6b6253
palette = 9=#e8635a
palette = 10=#7dc97a
palette = 11=#e8b43a
palette = 12=#82a6e0
palette = 13=#c58ae0
palette = 14=#6dd8c8
palette = 15=#faf6ec
palette = 16=#e8843a
palette = 17=#4a3e2c
palette = 18=#211b13
palette = 19=#3a2e1c
palette = 20=#a99f8d
palette = 21=#f1e9d9

# Foreground & background colors
background = #14100c
foreground = #e7dcc6
cursor-color = #e7dcc6
selection-background = #e7dcc6
selection-foreground = #3a2e1c
search-background = #e8b43a
search-foreground = #211b13
search-selected-background = #e8843a
search-selected-foreground = #211b13

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #faf6ec
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #82a6e0
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
