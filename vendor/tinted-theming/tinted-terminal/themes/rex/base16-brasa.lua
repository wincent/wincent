-- vim: ft=lua
-- Brasa theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-brasa"
local variant = "dark"

-- This must match themes/ghostty/base16-brasa exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Brasa theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a0f0a
palette = 1=#f2685a
palette = 2=#b8c24a
palette = 3=#f0b23a
palette = 4=#9aa6e0
palette = 5=#e68aa2
palette = 6=#6bc8b8
palette = 7=#f0d8c0
palette = 8=#7a6150
palette = 9=#f2685a
palette = 10=#b8c24a
palette = 11=#f0b23a
palette = 12=#9aa6e0
palette = 13=#e68aa2
palette = 14=#6bc8b8
palette = 15=#fbead8
palette = 16=#ff7a4d
palette = 17=#5a3a28
palette = 18=#2b1c14
palette = 19=#45261a
palette = 20=#b59d88
palette = 21=#f6e1cc

# Foreground & background colors
background = #1a0f0a
foreground = #f0d8c0
cursor-color = #f0d8c0
selection-background = #f0d8c0
selection-foreground = #45261a
search-background = #f0b23a
search-foreground = #2b1c14
search-selected-background = #ff7a4d
search-selected-foreground = #2b1c14

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fbead8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #9aa6e0
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
