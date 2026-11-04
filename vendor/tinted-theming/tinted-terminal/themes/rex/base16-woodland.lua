-- vim: ft=lua
-- Woodland theme for Rex
-- Scheme Author: Jay Cornwall (https://jcornwall.com)
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

local name = "base16-woodland"
local variant = "dark"

-- This must match themes/ghostty/base16-woodland exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Woodland theme for Ghostty
# Scheme Author: Jay Cornwall (https://jcornwall.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#231e18
palette = 1=#d35c5c
palette = 2=#b7ba53
palette = 3=#e0ac16
palette = 4=#88a4d3
palette = 5=#bb90e2
palette = 6=#6eb958
palette = 7=#cabcb1
palette = 8=#9d8b70
palette = 9=#d35c5c
palette = 10=#b7ba53
palette = 11=#e0ac16
palette = 12=#88a4d3
palette = 13=#bb90e2
palette = 14=#6eb958
palette = 15=#e4d4c8
palette = 16=#ca7f32
palette = 17=#b49368
palette = 18=#302b25
palette = 19=#48413a
palette = 20=#b4a490
palette = 21=#d7c8bc

# Foreground & background colors
background = #231e18
foreground = #cabcb1
cursor-color = #cabcb1
selection-background = #cabcb1
selection-foreground = #48413a
search-background = #e0ac16
search-foreground = #302b25
search-selected-background = #ca7f32
search-selected-foreground = #302b25

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e4d4c8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #88a4d3
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
