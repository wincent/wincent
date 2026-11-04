-- vim: ft=lua
-- Cerulean Signal Dark theme for Rex
-- Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
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

local name = "base16-cerulean-signal-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-cerulean-signal-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cerulean Signal Dark theme for Ghostty
# Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#101722
palette = 1=#ff8a9a
palette = 2=#70e1b0
palette = 3=#e2c85f
palette = 4=#7dd3ff
palette = 5=#ff74d4
palette = 6=#58d9df
palette = 7=#dce6f2
palette = 8=#8fa0b5
palette = 9=#ff8a9a
palette = 10=#70e1b0
palette = 11=#e2c85f
palette = 12=#7dd3ff
palette = 13=#ff74d4
palette = 14=#58d9df
palette = 15=#f7f9fc
palette = 16=#f5a35c
palette = 17=#d59b7d
palette = 18=#131c29
palette = 19=#173a5a
palette = 20=#aab8ca
palette = 21=#f1f6fc

# Foreground & background colors
background = #101722
foreground = #dce6f2
cursor-color = #dce6f2
selection-background = #dce6f2
selection-foreground = #173a5a
search-background = #e2c85f
search-foreground = #131c29
search-selected-background = #f5a35c
search-selected-foreground = #131c29

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f7f9fc
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7dd3ff
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
