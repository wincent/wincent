-- vim: ft=lua
-- Classic Light theme for Rex
-- Scheme Author: Jason Heeris (http://heeris.id.au)
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

local name = "base16-classic-light"
local variant = "light"

-- This must match themes/ghostty/base16-classic-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Classic Light theme for Ghostty
# Scheme Author: Jason Heeris (http://heeris.id.au)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5f5f5
palette = 1=#ac4142
palette = 2=#90a959
palette = 3=#f4bf75
palette = 4=#6a9fb5
palette = 5=#aa759f
palette = 6=#75b5aa
palette = 7=#303030
palette = 8=#b0b0b0
palette = 9=#ac4142
palette = 10=#90a959
palette = 11=#f4bf75
palette = 12=#6a9fb5
palette = 13=#aa759f
palette = 14=#75b5aa
palette = 15=#151515
palette = 16=#d28445
palette = 17=#8f5536
palette = 18=#e0e0e0
palette = 19=#d0d0d0
palette = 20=#505050
palette = 21=#202020

# Foreground & background colors
background = #f5f5f5
foreground = #303030
cursor-color = #303030
selection-background = #303030
selection-foreground = #d0d0d0
search-background = #f4bf75
search-foreground = #151515
search-selected-background = #d28445
search-selected-foreground = #151515

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #151515
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6a9fb5
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
