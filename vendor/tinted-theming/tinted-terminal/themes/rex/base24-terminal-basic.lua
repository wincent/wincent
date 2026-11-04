-- vim: ft=lua
-- Terminal Basic theme for Rex
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

local name = "base24-terminal-basic"
local variant = "light"

-- This must match themes/ghostty/base24-terminal-basic exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Terminal Basic theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#990000
palette = 2=#00a600
palette = 3=#0000ff
palette = 4=#0000b2
palette = 5=#b200b2
palette = 6=#00a6b2
palette = 7=#a8a8a8
palette = 8=#7c7c7c
palette = 9=#e50000
palette = 10=#00d900
palette = 11=#e5e500
palette = 12=#0000ff
palette = 13=#e500e5
palette = 14=#00e5e5
palette = 15=#e5e5e5
palette = 16=#999900
palette = 17=#4c0000
palette = 18=#000000
palette = 19=#666666
palette = 20=#929292
palette = 21=#bfbfbf

# Foreground & background colors
background = #ffffff
foreground = #a8a8a8
cursor-color = #a8a8a8
selection-background = #a8a8a8
selection-foreground = #666666
search-background = #0000ff
search-foreground = #000000
search-selected-background = #999900
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e5e5e5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0000ff
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
