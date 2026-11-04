-- vim: ft=lua
-- Sakura theme for Rex
-- Scheme Author: Misterio77 (http://github.com/Misterio77)
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

local name = "base16-sakura"
local variant = "light"

-- This must match themes/ghostty/base16-sakura exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sakura theme for Ghostty
# Scheme Author: Misterio77 (http://github.com/Misterio77)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#feedf3
palette = 1=#df2d52
palette = 2=#2e916d
palette = 3=#c29461
palette = 4=#006e93
palette = 5=#5e2180
palette = 6=#1d8991
palette = 7=#564448
palette = 8=#755f64
palette = 9=#df2d52
palette = 10=#2e916d
palette = 11=#c29461
palette = 12=#006e93
palette = 13=#5e2180
palette = 14=#1d8991
palette = 15=#33292b
palette = 16=#f6661e
palette = 17=#ba0d35
palette = 18=#f8e2e7
palette = 19=#e0ccd1
palette = 20=#665055
palette = 21=#42383a

# Foreground & background colors
background = #feedf3
foreground = #564448
cursor-color = #564448
selection-background = #564448
selection-foreground = #e0ccd1
search-background = #c29461
search-foreground = #33292b
search-selected-background = #f6661e
search-selected-foreground = #33292b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #33292b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #006e93
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
