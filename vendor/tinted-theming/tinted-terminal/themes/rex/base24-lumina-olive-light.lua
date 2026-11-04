-- vim: ft=lua
-- Lumina Olive Light theme for Rex
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

local name = "base24-lumina-olive-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-olive-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Olive Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f7f6e5
palette = 1=#8a1f1f
palette = 2=#30624e
palette = 3=#a16010
palette = 4=#3264a3
palette = 5=#6355a0
palette = 6=#006f83
palette = 7=#302e16
palette = 8=#d4d3c5
palette = 9=#64201e
palette = 10=#005139
palette = 11=#874e00
palette = 12=#1e508c
palette = 13=#763a72
palette = 14=#00596a
palette = 15=#302e16
palette = 16=#a24113
palette = 17=#8e4c89
palette = 18=#f0efe0
palette = 19=#e5e4d5
palette = 20=#898772
palette = 21=#4a4935

# Foreground & background colors
background = #f7f6e5
foreground = #302e16
cursor-color = #302e16
selection-background = #302e16
selection-foreground = #e5e4d5
search-background = #a16010
search-foreground = #f0efe0
search-selected-background = #a24113
search-selected-foreground = #f0efe0

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #302e16
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1e508c
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
