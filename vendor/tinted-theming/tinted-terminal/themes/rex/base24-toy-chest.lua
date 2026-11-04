-- vim: ft=lua
-- Toy Chest theme for Rex
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

local name = "base24-toy-chest"
local variant = "dark"

-- This must match themes/ghostty/base24-toy-chest exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Toy Chest theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#23364a
palette = 1=#be2d26
palette = 2=#199171
palette = 3=#33a5d9
palette = 4=#325d96
palette = 5=#8a5ddb
palette = 6=#35a08f
palette = 7=#27b684
palette = 8=#2f8288
palette = 9=#dd5943
palette = 10=#30cf7b
palette = 11=#e7d74b
palette = 12=#33a5d9
palette = 13=#ad6bdc
palette = 14=#41c3ad
palette = 15=#d4d4d4
palette = 16=#da8e26
palette = 17=#5f1613
palette = 18=#2c3f57
palette = 19=#326889
palette = 20=#2b9c86
palette = 21=#23d082

# Foreground & background colors
background = #23364a
foreground = #27b684
cursor-color = #27b684
selection-background = #27b684
selection-foreground = #326889
search-background = #33a5d9
search-foreground = #2c3f57
search-selected-background = #da8e26
search-selected-foreground = #2c3f57

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d4d4d4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #33a5d9
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
