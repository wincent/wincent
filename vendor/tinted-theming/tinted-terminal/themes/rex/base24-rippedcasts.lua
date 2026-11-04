-- vim: ft=lua
-- Rippedcasts theme for Rex
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

local name = "base24-rippedcasts"
local variant = "dark"

-- This must match themes/ghostty/base24-rippedcasts exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Rippedcasts theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2b2b2b
palette = 1=#cdaf95
palette = 2=#a7ff60
palette = 3=#86bdc9
palette = 4=#75a5b0
palette = 5=#ff73fd
palette = 6=#59647e
palette = 7=#a8a8a8
palette = 8=#7c7c7c
palette = 9=#eecbad
palette = 10=#bcee68
palette = 11=#e5e500
palette = 12=#86bdc9
palette = 13=#e500e5
palette = 14=#8c9bc3
palette = 15=#e5e5e5
palette = 16=#bfbb1f
palette = 17=#66574a
palette = 18=#000000
palette = 19=#666666
palette = 20=#929292
palette = 21=#bfbfbf

# Foreground & background colors
background = #2b2b2b
foreground = #a8a8a8
cursor-color = #a8a8a8
selection-background = #a8a8a8
selection-foreground = #666666
search-background = #86bdc9
search-foreground = #000000
search-selected-background = #bfbb1f
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e5e5e5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #86bdc9
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
