-- vim: ft=lua
-- Seafoam Pastel theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-seafoam-pastel"
local variant = "dark"

-- This must match themes/ghostty/base24-seafoam-pastel exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Seafoam Pastel theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#243434
palette = 1=#825d4d
palette = 2=#718c61
palette = 3=#79c3cf
palette = 4=#4d7b82
palette = 5=#8a7167
palette = 6=#719393
palette = 7=#cacaca
palette = 8=#9f9f9f
palette = 9=#cf9379
palette = 10=#98d9aa
palette = 11=#fae79d
palette = 12=#79c3cf
palette = 13=#d6b2a1
palette = 14=#ade0e0
palette = 15=#e0e0e0
palette = 16=#ada16d
palette = 17=#412e26
palette = 18=#757575
palette = 19=#8a8a8a
palette = 20=#b5b5b5
palette = 21=#e0e0e0

# Foreground & background colors
background = #243434
foreground = #cacaca
cursor-color = #cacaca
selection-background = #cacaca
selection-foreground = #8a8a8a
search-background = #79c3cf
search-foreground = #757575
search-selected-background = #ada16d
search-selected-foreground = #757575

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e0e0e0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #79c3cf
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
