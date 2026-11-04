-- vim: ft=lua
-- Piatto Light theme for Rex
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

local name = "base24-piatto-light"
local variant = "light"

-- This must match themes/ghostty/base24-piatto-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Piatto Light theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#b23771
palette = 2=#66781e
palette = 3=#cda434
palette = 4=#3c5ea8
palette = 5=#a454b2
palette = 6=#1e7878
palette = 7=#515151
palette = 8=#c1c1c1
palette = 9=#db3365
palette = 10=#829429
palette = 11=#cd6f34
palette = 12=#3c5ea8
palette = 13=#a454b2
palette = 14=#175e5e
palette = 15=#212121
palette = 16=#cd6f34
palette = 17=#591b38
palette = 18=#f1f1f1
palette = 19=#e1e1e1
palette = 20=#717171
palette = 21=#414141

# Foreground & background colors
background = #ffffff
foreground = #515151
cursor-color = #515151
selection-background = #515151
selection-foreground = #e1e1e1
search-background = #cda434
search-foreground = #f1f1f1
search-selected-background = #cd6f34
search-selected-foreground = #f1f1f1

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #212121
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3c5ea8
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
