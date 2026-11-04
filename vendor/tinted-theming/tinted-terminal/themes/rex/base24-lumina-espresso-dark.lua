-- vim: ft=lua
-- Lumina Espresso Dark theme for Rex
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

local name = "base24-lumina-espresso-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-espresso-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Espresso Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e150e
palette = 1=#cd766e
palette = 2=#95d3b1
palette = 3=#efca86
palette = 4=#96bfe9
palette = 5=#c7ade7
palette = 6=#90cad1
palette = 7=#e5dfd6
palette = 8=#382d24
palette = 9=#db968f
palette = 10=#b5ebcd
palette = 11=#ffe4b4
palette = 12=#b5d8fd
palette = 13=#f6c6f1
palette = 14=#a9e4ec
palette = 15=#e5dfd6
palette = 16=#d9bfa6
palette = 17=#dbadd6
palette = 18=#231911
palette = 19=#2d231b
palette = 20=#74675d
palette = 21=#b8afa9

# Foreground & background colors
background = #1e150e
foreground = #e5dfd6
cursor-color = #e5dfd6
selection-background = #e5dfd6
selection-foreground = #2d231b
search-background = #efca86
search-foreground = #231911
search-selected-background = #d9bfa6
search-selected-foreground = #231911

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e5dfd6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b5d8fd
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
