-- vim: ft=lua
-- Darcula theme for Rex
-- Scheme Author: jetbrains
-- Scheme System: base16
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

local name = "base16-darcula"
local variant = "dark"

-- This must match themes/ghostty/base16-darcula exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Darcula theme for Ghostty
# Scheme Author: jetbrains
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2b2b2b
palette = 1=#4eade5
palette = 2=#6a8759
palette = 3=#bbb529
palette = 4=#9876aa
palette = 5=#cc7832
palette = 6=#629755
palette = 7=#a9b7c6
palette = 8=#606366
palette = 9=#4eade5
palette = 10=#6a8759
palette = 11=#bbb529
palette = 12=#9876aa
palette = 13=#cc7832
palette = 14=#629755
palette = 15=#ffffff
palette = 16=#689757
palette = 17=#808080
palette = 18=#323232
palette = 19=#323232
palette = 20=#a4a3a3
palette = 21=#ffc66d

# Foreground & background colors
background = #2b2b2b
foreground = #a9b7c6
cursor-color = #a9b7c6
selection-background = #a9b7c6
selection-foreground = #323232
search-background = #bbb529
search-foreground = #323232
search-selected-background = #689757
search-selected-foreground = #323232

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #9876aa
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
