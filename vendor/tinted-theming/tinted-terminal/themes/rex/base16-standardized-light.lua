-- vim: ft=lua
-- standardized-light theme for Rex
-- Scheme Author: ali (https://github.com/ali-githb/base16-standardized-scheme)
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

local name = "base16-standardized-light"
local variant = "light"

-- This must match themes/ghostty/base16-standardized-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# standardized-light theme for Ghostty
# Scheme Author: ali (https://github.com/ali-githb/base16-standardized-scheme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#d03e3e
palette = 2=#31861f
palette = 3=#ad8200
palette = 4=#3173c5
palette = 5=#9e57c2
palette = 6=#00998f
palette = 7=#444444
palette = 8=#767676
palette = 9=#d03e3e
palette = 10=#31861f
palette = 11=#ad8200
palette = 12=#3173c5
palette = 13=#9e57c2
palette = 14=#00998f
palette = 15=#222222
palette = 16=#d7691d
palette = 17=#895025
palette = 18=#eeeeee
palette = 19=#cccccc
palette = 20=#767676
palette = 21=#333333

# Foreground & background colors
background = #ffffff
foreground = #444444
cursor-color = #444444
selection-background = #444444
selection-foreground = #cccccc
search-background = #ad8200
search-foreground = #222222
search-selected-background = #d7691d
search-selected-foreground = #222222

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #222222
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3173c5
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
