-- vim: ft=lua
-- Corduroy Dark theme for Rex
-- Scheme Author: taysatte (https://github.com/taysatte)
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

local name = "base16-corduroy-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-corduroy-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Corduroy Dark theme for Ghostty
# Scheme Author: taysatte (https://github.com/taysatte)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#141016
palette = 1=#e8758a
palette = 2=#55a0a0
palette = 3=#f0bd9c
palette = 4=#dc92a3
palette = 5=#cf98c4
palette = 6=#f0a89b
palette = 7=#ddd8df
palette = 8=#7d7082
palette = 9=#e8758a
palette = 10=#55a0a0
palette = 11=#f0bd9c
palette = 12=#dc92a3
palette = 13=#cf98c4
palette = 14=#f0a89b
palette = 15=#5a5160
palette = 16=#f0a89b
palette = 17=#9a8d9e
palette = 18=#1b151e
palette = 19=#221a26
palette = 20=#9a8d9e
palette = 21=#ddd8df

# Foreground & background colors
background = #141016
foreground = #ddd8df
cursor-color = #ddd8df
selection-background = #ddd8df
selection-foreground = #221a26
search-background = #f0bd9c
search-foreground = #1b151e
search-selected-background = #f0a89b
search-selected-foreground = #1b151e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #5a5160
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #dc92a3
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
