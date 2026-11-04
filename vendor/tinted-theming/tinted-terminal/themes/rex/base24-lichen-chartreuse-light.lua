-- vim: ft=lua
-- Lichen Chartreuse Light theme for Rex
-- Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
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

local name = "base24-lichen-chartreuse-light"
local variant = "light"

-- This must match themes/ghostty/base24-lichen-chartreuse-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lichen Chartreuse Light theme for Ghostty
# Scheme Author: Aaron Colichia (https://aaron.colichia.org/)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5f7f2
palette = 1=#a34740
palette = 2=#2f7462
palette = 3=#506b29
palette = 4=#356e8a
palette = 5=#6e5689
palette = 6=#356569
palette = 7=#2d302b
palette = 8=#687161
palette = 9=#a34740
palette = 10=#506b29
palette = 11=#875e20
palette = 12=#3b6d86
palette = 13=#8a4f67
palette = 14=#3f6464
palette = 15=#151613
palette = 16=#8b5d27
palette = 17=#8a4f67
palette = 18=#ecefe7
palette = 19=#cfe4ae
palette = 20=#4e5149
palette = 21=#232420

# Foreground & background colors
background = #f5f7f2
foreground = #2d302b
cursor-color = #2d302b
selection-background = #2d302b
selection-foreground = #cfe4ae
search-background = #506b29
search-foreground = #ecefe7
search-selected-background = #8b5d27
search-selected-foreground = #ecefe7

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #151613
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3b6d86
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
