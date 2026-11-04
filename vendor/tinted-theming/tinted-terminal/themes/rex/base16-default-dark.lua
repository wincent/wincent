-- vim: ft=lua
-- Default Dark theme for Rex
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

local name = "base16-default-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-default-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Default Dark theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#181818
palette = 1=#ab4642
palette = 2=#a1b56c
palette = 3=#f7ca88
palette = 4=#7cafc2
palette = 5=#ba8baf
palette = 6=#86c1b9
palette = 7=#d8d8d8
palette = 8=#585858
palette = 9=#ab4642
palette = 10=#a1b56c
palette = 11=#f7ca88
palette = 12=#7cafc2
palette = 13=#ba8baf
palette = 14=#86c1b9
palette = 15=#f8f8f8
palette = 16=#dc9656
palette = 17=#a16946
palette = 18=#282828
palette = 19=#383838
palette = 20=#b8b8b8
palette = 21=#e8e8e8

# Foreground & background colors
background = #181818
foreground = #d8d8d8
cursor-color = #d8d8d8
selection-background = #d8d8d8
selection-foreground = #383838
search-background = #f7ca88
search-foreground = #282828
search-selected-background = #dc9656
search-selected-foreground = #282828

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8f8f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7cafc2
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
