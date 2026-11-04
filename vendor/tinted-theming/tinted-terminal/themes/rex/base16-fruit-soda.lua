-- vim: ft=lua
-- Fruit Soda theme for Rex
-- Scheme Author: jozip
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

local name = "base16-fruit-soda"
local variant = "light"

-- This must match themes/ghostty/base16-fruit-soda exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Fruit Soda theme for Ghostty
# Scheme Author: jozip
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f1ecf1
palette = 1=#fe3e31
palette = 2=#47f74c
palette = 3=#f7e203
palette = 4=#2931df
palette = 5=#611fce
palette = 6=#0f9cfd
palette = 7=#515151
palette = 8=#b5b4b6
palette = 9=#fe3e31
palette = 10=#47f74c
palette = 11=#f7e203
palette = 12=#2931df
palette = 13=#611fce
palette = 14=#0f9cfd
palette = 15=#2d2c2c
palette = 16=#fe6d08
palette = 17=#b16f40
palette = 18=#e0dee0
palette = 19=#d8d5d5
palette = 20=#979598
palette = 21=#474545

# Foreground & background colors
background = #f1ecf1
foreground = #515151
cursor-color = #515151
selection-background = #515151
selection-foreground = #d8d5d5
search-background = #f7e203
search-foreground = #2d2c2c
search-selected-background = #fe6d08
search-selected-foreground = #2d2c2c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2d2c2c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #2931df
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
