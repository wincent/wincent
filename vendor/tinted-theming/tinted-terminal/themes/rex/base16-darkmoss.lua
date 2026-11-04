-- vim: ft=lua
-- darkmoss theme for Rex
-- Scheme Author: Gabriel Avanzi (https://github.com/avanzzzi)
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

local name = "base16-darkmoss"
local variant = "dark"

-- This must match themes/ghostty/base16-darkmoss exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# darkmoss theme for Ghostty
# Scheme Author: Gabriel Avanzi (https://github.com/avanzzzi)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#171e1f
palette = 1=#ff4658
palette = 2=#499180
palette = 3=#fdb11f
palette = 4=#498091
palette = 5=#9bc0c8
palette = 6=#66d9ef
palette = 7=#c7c7a5
palette = 8=#555e5f
palette = 9=#ff4658
palette = 10=#499180
palette = 11=#fdb11f
palette = 12=#498091
palette = 13=#9bc0c8
palette = 14=#66d9ef
palette = 15=#e1eaef
palette = 16=#e6db74
palette = 17=#d27b53
palette = 18=#252c2d
palette = 19=#373c3d
palette = 20=#818f80
palette = 21=#e3e3c8

# Foreground & background colors
background = #171e1f
foreground = #c7c7a5
cursor-color = #c7c7a5
selection-background = #c7c7a5
selection-foreground = #373c3d
search-background = #fdb11f
search-foreground = #252c2d
search-selected-background = #e6db74
search-selected-foreground = #252c2d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e1eaef
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #498091
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
