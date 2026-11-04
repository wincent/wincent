-- vim: ft=lua
-- Pnevma theme for Rex
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

local name = "base24-pnevma"
local variant = "dark"

-- This must match themes/ghostty/base24-pnevma exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Pnevma theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1c1c
palette = 1=#a36666
palette = 2=#90a57d
palette = 3=#a1bdce
palette = 4=#7fa5bd
palette = 5=#c79ec4
palette = 6=#8adbb4
palette = 7=#aeaead
palette = 8=#6b6a67
palette = 9=#d78787
palette = 10=#afbea2
palette = 11=#e4c9af
palette = 12=#a1bdce
palette = 13=#d7beda
palette = 14=#b1e7dd
palette = 15=#efefef
palette = 16=#d7af87
palette = 17=#513333
palette = 18=#2f2e2d
palette = 19=#4a4845
palette = 20=#8d8c8a
palette = 21=#d0d0d0

# Foreground & background colors
background = #1c1c1c
foreground = #aeaead
cursor-color = #aeaead
selection-background = #aeaead
selection-foreground = #4a4845
search-background = #a1bdce
search-foreground = #2f2e2d
search-selected-background = #d7af87
search-selected-foreground = #2f2e2d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #efefef
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a1bdce
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
