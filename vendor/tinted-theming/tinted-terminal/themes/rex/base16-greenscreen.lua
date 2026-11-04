-- vim: ft=lua
-- Green Screen theme for Rex
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

local name = "base16-greenscreen"
local variant = "dark"

-- This must match themes/ghostty/base16-greenscreen exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Green Screen theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#001100
palette = 1=#007700
palette = 2=#00bb00
palette = 3=#007700
palette = 4=#009900
palette = 5=#00bb00
palette = 6=#005500
palette = 7=#00bb00
palette = 8=#007700
palette = 9=#007700
palette = 10=#00bb00
palette = 11=#007700
palette = 12=#009900
palette = 13=#00bb00
palette = 14=#005500
palette = 15=#00ff00
palette = 16=#009900
palette = 17=#005500
palette = 18=#003300
palette = 19=#005500
palette = 20=#009900
palette = 21=#00dd00

# Foreground & background colors
background = #001100
foreground = #00bb00
cursor-color = #00bb00
selection-background = #00bb00
selection-foreground = #005500
search-background = #007700
search-foreground = #003300
search-selected-background = #009900
search-selected-foreground = #003300

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #00ff00
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #009900
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
