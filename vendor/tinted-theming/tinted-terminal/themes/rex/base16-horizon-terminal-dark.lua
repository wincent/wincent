-- vim: ft=lua
-- Horizon Terminal Dark theme for Rex
-- Scheme Author: Michaël Ball (http://github.com/michael-ball/)
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

local name = "base16-horizon-terminal-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-horizon-terminal-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Horizon Terminal Dark theme for Ghostty
# Scheme Author: Michaël Ball (http://github.com/michael-ball/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1e26
palette = 1=#e95678
palette = 2=#29d398
palette = 3=#fac29a
palette = 4=#26bbd9
palette = 5=#ee64ac
palette = 6=#59e1e3
palette = 7=#cbced0
palette = 8=#6f6f70
palette = 9=#e95678
palette = 10=#29d398
palette = 11=#fac29a
palette = 12=#26bbd9
palette = 13=#ee64ac
palette = 14=#59e1e3
palette = 15=#e3e6ee
palette = 16=#fab795
palette = 17=#f09383
palette = 18=#232530
palette = 19=#2e303e
palette = 20=#9da0a2
palette = 21=#dcdfe4

# Foreground & background colors
background = #1c1e26
foreground = #cbced0
cursor-color = #cbced0
selection-background = #cbced0
selection-foreground = #2e303e
search-background = #fac29a
search-foreground = #232530
search-selected-background = #fab795
search-selected-foreground = #232530

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e3e6ee
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #26bbd9
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
