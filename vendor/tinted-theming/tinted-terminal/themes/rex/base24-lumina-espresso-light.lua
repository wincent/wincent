-- vim: ft=lua
-- Lumina Espresso Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
-- Scheme System: base24
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

local name = "base24-lumina-espresso-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-espresso-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Espresso Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fcf0e3
palette = 1=#842120
palette = 2=#15744d
palette = 3=#6d4e36
palette = 4=#2868a3
palette = 5=#7049a1
palette = 6=#007083
palette = 7=#39261b
palette = 8=#d9cec2
palette = 9=#5f201e
palette = 10=#005e3c
palette = 11=#653400
palette = 12=#1a5488
palette = 13=#70386b
palette = 14=#005a6a
palette = 15=#39261b
palette = 16=#89461a
palette = 17=#864b81
palette = 18=#f5eade
palette = 19=#e9ded2
palette = 20=#928373
palette = 21=#524536

# Foreground & background colors
background = #fcf0e3
foreground = #39261b
cursor-color = #39261b
selection-background = #39261b
selection-foreground = #e9ded2
search-background = #6d4e36
search-foreground = #f5eade
search-selected-background = #89461a
search-selected-foreground = #f5eade

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #39261b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1a5488
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
