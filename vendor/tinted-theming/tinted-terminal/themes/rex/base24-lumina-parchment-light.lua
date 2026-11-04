-- vim: ft=lua
-- Lumina Parchment Light theme for Rex
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

local name = "base24-lumina-parchment-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-parchment-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Parchment Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f9efda
palette = 1=#912918
palette = 2=#2d7341
palette = 3=#654935
palette = 4=#2e5fb0
palette = 5=#62559d
palette = 6=#006e81
palette = 7=#352516
palette = 8=#d3cdbf
palette = 9=#6b281c
palette = 10=#195e2f
palette = 11=#5f2f00
palette = 12=#284d8a
palette = 13=#6b3770
palette = 14=#005868
palette = 15=#352516
palette = 16=#654935
palette = 17=#87418e
palette = 18=#efe9db
palette = 19=#e4ddcf
palette = 20=#908369
palette = 21=#52462d

# Foreground & background colors
background = #f9efda
foreground = #352516
cursor-color = #352516
selection-background = #352516
selection-foreground = #e4ddcf
search-background = #654935
search-foreground = #efe9db
search-selected-background = #654935
search-selected-foreground = #efe9db

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #352516
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #284d8a
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
