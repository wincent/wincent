-- vim: ft=lua
-- pandora theme for Rex
-- Scheme Author: Cassandra Fox
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

local name = "base16-pandora"
local variant = "dark"

-- This must match themes/ghostty/base16-pandora exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# pandora theme for Ghostty
# Scheme Author: Cassandra Fox
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#131213
palette = 1=#b00b69
palette = 2=#9ddf69
palette = 3=#ffcc00
palette = 4=#008080
palette = 5=#a24030
palette = 6=#714ca6
palette = 7=#f15c99
palette = 8=#ffbee3
palette = 9=#b00b69
palette = 10=#9ddf69
palette = 11=#ffcc00
palette = 12=#008080
palette = 13=#a24030
palette = 14=#714ca6
palette = 15=#632227
palette = 16=#ff9153
palette = 17=#a24030
palette = 18=#2f1823
palette = 19=#472234
palette = 20=#9b2a46
palette = 21=#81506a

# Foreground & background colors
background = #131213
foreground = #f15c99
cursor-color = #f15c99
selection-background = #f15c99
selection-foreground = #472234
search-background = #ffcc00
search-foreground = #2f1823
search-selected-background = #ff9153
search-selected-foreground = #2f1823

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #632227
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #008080
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
