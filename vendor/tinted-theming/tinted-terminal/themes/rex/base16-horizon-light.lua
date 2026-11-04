-- vim: ft=lua
-- Horizon Light theme for Rex
-- Scheme Author: Michaël Ball (http://github.com/michael-ball/)
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

local name = "base16-horizon-light"
local variant = "light"

-- This must match themes/ghostty/base16-horizon-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Horizon Light theme for Ghostty
# Scheme Author: Michaël Ball (http://github.com/michael-ball/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fdf0ed
palette = 1=#f7939b
palette = 2=#94e1b0
palette = 3=#fbe0d9
palette = 4=#da103f
palette = 5=#1d8991
palette = 6=#dc3318
palette = 7=#403c3d
palette = 8=#bdb3b1
palette = 9=#f7939b
palette = 10=#94e1b0
palette = 11=#fbe0d9
palette = 12=#da103f
palette = 13=#1d8991
palette = 14=#dc3318
palette = 15=#201c1d
palette = 16=#f6661e
palette = 17=#e58c92
palette = 18=#fadad1
palette = 19=#f9cbbe
palette = 20=#948c8a
palette = 21=#302c2d

# Foreground & background colors
background = #fdf0ed
foreground = #403c3d
cursor-color = #403c3d
selection-background = #403c3d
selection-foreground = #f9cbbe
search-background = #fbe0d9
search-foreground = #201c1d
search-selected-background = #f6661e
search-selected-foreground = #201c1d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #201c1d
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #da103f
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
