-- vim: ft=lua
-- Bluloco Dark theme for Rex
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

local name = "base24-bluloco-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-bluloco-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Bluloco Dark theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e2027
palette = 1=#f71041
palette = 2=#23974a
palette = 3=#189ffd
palette = 4=#285afe
palette = 5=#8c62fd
palette = 6=#366f99
palette = 7=#b1bac9
palette = 8=#7b8494
palette = 9=#fb496d
palette = 10=#37bc58
palette = 11=#f6bd47
palette = 12=#189ffd
palette = 13=#fb57f6
palette = 14=#4fabad
palette = 15=#fefefe
palette = 16=#fc7e57
palette = 17=#7b0820
palette = 18=#494f5c
palette = 19=#60697a
palette = 20=#969faf
palette = 21=#ccd5e4

# Foreground & background colors
background = #1e2027
foreground = #b1bac9
cursor-color = #b1bac9
selection-background = #b1bac9
selection-foreground = #60697a
search-background = #189ffd
search-foreground = #494f5c
search-selected-background = #fc7e57
search-selected-foreground = #494f5c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fefefe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #189ffd
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
