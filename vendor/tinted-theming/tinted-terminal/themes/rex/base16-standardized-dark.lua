-- vim: ft=lua
-- standardized-dark theme for Rex
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

local name = "base16-standardized-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-standardized-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# standardized-dark theme for Ghostty
# Scheme Author: ali (https://github.com/ali-githb/base16-standardized-scheme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#222222
palette = 1=#e15d67
palette = 2=#5db129
palette = 3=#e1b31a
palette = 4=#00a3f2
palette = 5=#b46ee0
palette = 6=#21c992
palette = 7=#c0c0c0
palette = 8=#898989
palette = 9=#e15d67
palette = 10=#5db129
palette = 11=#e1b31a
palette = 12=#00a3f2
palette = 13=#b46ee0
palette = 14=#21c992
palette = 15=#ffffff
palette = 16=#fc804e
palette = 17=#b87d28
palette = 18=#303030
palette = 19=#555555
palette = 20=#898989
palette = 21=#e0e0e0

# Foreground & background colors
background = #222222
foreground = #c0c0c0
cursor-color = #c0c0c0
selection-background = #c0c0c0
selection-foreground = #555555
search-background = #e1b31a
search-foreground = #303030
search-selected-background = #fc804e
search-selected-foreground = #303030

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #00a3f2
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
