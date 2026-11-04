-- vim: ft=lua
-- Elementary theme for Rex
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

local name = "base24-elementary"
local variant = "dark"

-- This must match themes/ghostty/base24-elementary exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Elementary theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#181818
palette = 1=#d61b15
palette = 2=#59a413
palette = 3=#0855fe
palette = 4=#053a8c
palette = 5=#e40038
palette = 6=#2594e0
palette = 7=#c5c5c5
palette = 8=#737373
palette = 9=#fb1b18
palette = 10=#6ac118
palette = 11=#fdc70e
palette = 12=#0855fe
palette = 13=#fb004f
palette = 14=#3ea7fc
palette = 15=#eeeeee
palette = 16=#fdb40b
palette = 17=#6b0d0a
palette = 18=#242424
palette = 19=#4a4a4a
palette = 20=#9c9c9c
palette = 21=#eeeeee

# Foreground & background colors
background = #181818
foreground = #c5c5c5
cursor-color = #c5c5c5
selection-background = #c5c5c5
selection-foreground = #4a4a4a
search-background = #0855fe
search-foreground = #242424
search-selected-background = #fdb40b
search-selected-foreground = #242424

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eeeeee
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0855fe
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
