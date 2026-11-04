-- vim: ft=lua
-- Tomorrow theme for Rex
-- Scheme Author: Chris Kempson (http://chriskempson.com)
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

local name = "base16-tomorrow"
local variant = "light"

-- This must match themes/ghostty/base16-tomorrow exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tomorrow theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#c82829
palette = 2=#718c00
palette = 3=#eab700
palette = 4=#4271ae
palette = 5=#8959a8
palette = 6=#3e999f
palette = 7=#373b41
palette = 8=#b4b7b4
palette = 9=#c82829
palette = 10=#718c00
palette = 11=#eab700
palette = 12=#4271ae
palette = 13=#8959a8
palette = 14=#3e999f
palette = 15=#1d1f21
palette = 16=#f5871f
palette = 17=#a3685a
palette = 18=#e0e0e0
palette = 19=#c5c8c6
palette = 20=#969896
palette = 21=#282a2e

# Foreground & background colors
background = #ffffff
foreground = #373b41
cursor-color = #373b41
selection-background = #373b41
selection-foreground = #c5c8c6
search-background = #eab700
search-foreground = #1d1f21
search-selected-background = #f5871f
search-selected-foreground = #1d1f21

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1d1f21
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4271ae
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
