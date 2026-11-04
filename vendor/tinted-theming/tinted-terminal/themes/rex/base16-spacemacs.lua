-- vim: ft=lua
-- Spacemacs theme for Rex
-- Scheme Author: Nasser Alshammari (https://github.com/nashamri/spacemacs-theme)
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

local name = "base16-spacemacs"
local variant = "dark"

-- This must match themes/ghostty/base16-spacemacs exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Spacemacs theme for Ghostty
# Scheme Author: Nasser Alshammari (https://github.com/nashamri/spacemacs-theme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1f2022
palette = 1=#f2241f
palette = 2=#67b11d
palette = 3=#b1951d
palette = 4=#4f97d7
palette = 5=#a31db1
palette = 6=#2d9574
palette = 7=#a3a3a3
palette = 8=#585858
palette = 9=#f2241f
palette = 10=#67b11d
palette = 11=#b1951d
palette = 12=#4f97d7
palette = 13=#a31db1
palette = 14=#2d9574
palette = 15=#f8f8f8
palette = 16=#ffa500
palette = 17=#b03060
palette = 18=#282828
palette = 19=#444155
palette = 20=#b8b8b8
palette = 21=#e8e8e8

# Foreground & background colors
background = #1f2022
foreground = #a3a3a3
cursor-color = #a3a3a3
selection-background = #a3a3a3
selection-foreground = #444155
search-background = #b1951d
search-foreground = #282828
search-selected-background = #ffa500
search-selected-foreground = #282828

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8f8f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4f97d7
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
