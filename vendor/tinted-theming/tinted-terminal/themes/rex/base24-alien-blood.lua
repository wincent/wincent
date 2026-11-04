-- vim: ft=lua
-- Alien Blood theme for Rex
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

local name = "base24-alien-blood"
local variant = "dark"

-- This must match themes/ghostty/base24-alien-blood exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Alien Blood theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0f160f
palette = 1=#7f2b26
palette = 2=#2f7e25
palette = 3=#00a9df
palette = 4=#2f697f
palette = 5=#47577e
palette = 6=#317f76
palette = 7=#5a6f5c
palette = 8=#46542a
palette = 9=#df8008
palette = 10=#18e000
palette = 11=#bde000
palette = 12=#00a9df
palette = 13=#0058df
palette = 14=#00dfc3
palette = 15=#73f990
palette = 16=#707f23
palette = 17=#3f1513
palette = 18=#112615
palette = 19=#3c4711
palette = 20=#506243
palette = 21=#647d75

# Foreground & background colors
background = #0f160f
foreground = #5a6f5c
cursor-color = #5a6f5c
selection-background = #5a6f5c
selection-foreground = #3c4711
search-background = #00a9df
search-foreground = #112615
search-selected-background = #707f23
search-selected-foreground = #112615

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #73f990
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #00a9df
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
