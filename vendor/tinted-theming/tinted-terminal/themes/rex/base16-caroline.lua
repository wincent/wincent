-- vim: ft=lua
-- caroline theme for Rex
-- Scheme Author: ed (https://codeberg.org/ed)
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

local name = "base16-caroline"
local variant = "dark"

-- This must match themes/ghostty/base16-caroline exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# caroline theme for Ghostty
# Scheme Author: ed (https://codeberg.org/ed)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1213
palette = 1=#c24f57
palette = 2=#806c61
palette = 3=#f28171
palette = 4=#684c59
palette = 5=#a63650
palette = 6=#6b6566
palette = 7=#a87569
palette = 8=#6d4745
palette = 9=#c24f57
palette = 10=#806c61
palette = 11=#f28171
palette = 12=#684c59
palette = 13=#a63650
palette = 14=#6b6566
palette = 15=#e3a68c
palette = 16=#a63650
palette = 17=#893f45
palette = 18=#3a2425
palette = 19=#563837
palette = 20=#8b5d57
palette = 21=#c58d7b

# Foreground & background colors
background = #1c1213
foreground = #a87569
cursor-color = #a87569
selection-background = #a87569
selection-foreground = #563837
search-background = #f28171
search-foreground = #3a2425
search-selected-background = #a63650
search-selected-foreground = #3a2425

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e3a68c
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #684c59
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
