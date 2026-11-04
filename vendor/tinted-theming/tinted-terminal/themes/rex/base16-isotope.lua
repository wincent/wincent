-- vim: ft=lua
-- Isotope theme for Rex
-- Scheme Author: Jan T. Sott
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

local name = "base16-isotope"
local variant = "dark"

-- This must match themes/ghostty/base16-isotope exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Isotope theme for Ghostty
# Scheme Author: Jan T. Sott
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#ff0000
palette = 2=#33ff00
palette = 3=#ff0099
palette = 4=#0066ff
palette = 5=#cc00ff
palette = 6=#00ffff
palette = 7=#d0d0d0
palette = 8=#808080
palette = 9=#ff0000
palette = 10=#33ff00
palette = 11=#ff0099
palette = 12=#0066ff
palette = 13=#cc00ff
palette = 14=#00ffff
palette = 15=#ffffff
palette = 16=#ff9900
palette = 17=#3300ff
palette = 18=#404040
palette = 19=#606060
palette = 20=#c0c0c0
palette = 21=#e0e0e0

# Foreground & background colors
background = #000000
foreground = #d0d0d0
cursor-color = #d0d0d0
selection-background = #d0d0d0
selection-foreground = #606060
search-background = #ff0099
search-foreground = #404040
search-selected-background = #ff9900
search-selected-foreground = #404040

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0066ff
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
