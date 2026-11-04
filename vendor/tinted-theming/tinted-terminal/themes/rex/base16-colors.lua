-- vim: ft=lua
-- Colors theme for Rex
-- Scheme Author: mrmrs (http://clrs.cc)
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

local name = "base16-colors"
local variant = "dark"

-- This must match themes/ghostty/base16-colors exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Colors theme for Ghostty
# Scheme Author: mrmrs (http://clrs.cc)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#111111
palette = 1=#ff4136
palette = 2=#2ecc40
palette = 3=#ffdc00
palette = 4=#0074d9
palette = 5=#b10dc9
palette = 6=#7fdbff
palette = 7=#bbbbbb
palette = 8=#777777
palette = 9=#ff4136
palette = 10=#2ecc40
palette = 11=#ffdc00
palette = 12=#0074d9
palette = 13=#b10dc9
palette = 14=#7fdbff
palette = 15=#ffffff
palette = 16=#ff851b
palette = 17=#85144b
palette = 18=#333333
palette = 19=#555555
palette = 20=#999999
palette = 21=#dddddd

# Foreground & background colors
background = #111111
foreground = #bbbbbb
cursor-color = #bbbbbb
selection-background = #bbbbbb
selection-foreground = #555555
search-background = #ffdc00
search-foreground = #333333
search-selected-background = #ff851b
search-selected-foreground = #333333

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0074d9
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
