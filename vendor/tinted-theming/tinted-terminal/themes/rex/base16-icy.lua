-- vim: ft=lua
-- Icy Dark theme for Rex
-- Scheme Author: icyphox (https://icyphox.ga)
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

local name = "base16-icy"
local variant = "dark"

-- This must match themes/ghostty/base16-icy exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Icy Dark theme for Ghostty
# Scheme Author: icyphox (https://icyphox.ga)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#021012
palette = 1=#16c1d9
palette = 2=#4dd0e1
palette = 3=#80deea
palette = 4=#00bcd4
palette = 5=#00acc1
palette = 6=#26c6da
palette = 7=#095b67
palette = 8=#052e34
palette = 9=#16c1d9
palette = 10=#4dd0e1
palette = 11=#80deea
palette = 12=#00bcd4
palette = 13=#00acc1
palette = 14=#26c6da
palette = 15=#109cb0
palette = 16=#b3ebf2
palette = 17=#0097a7
palette = 18=#031619
palette = 19=#041f23
palette = 20=#064048
palette = 21=#0c7c8c

# Foreground & background colors
background = #021012
foreground = #095b67
cursor-color = #095b67
selection-background = #095b67
selection-foreground = #041f23
search-background = #80deea
search-foreground = #031619
search-selected-background = #b3ebf2
search-selected-foreground = #031619

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #109cb0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #00bcd4
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
