-- vim: ft=lua
-- Catppuccin Frappe theme for Rex
-- Scheme Author: https://github.com/catppuccin/catppuccin
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

local name = "base24-catppuccin-frappe"
local variant = "dark"

-- This must match themes/ghostty/base24-catppuccin-frappe exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Catppuccin Frappe theme for Ghostty
# Scheme Author: https://github.com/catppuccin/catppuccin
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#303446
palette = 1=#e78284
palette = 2=#a6d189
palette = 3=#e5c890
palette = 4=#8caaee
palette = 5=#ca9ee6
palette = 6=#81c8be
palette = 7=#c6d0f5
palette = 8=#51576d
palette = 9=#ea999c
palette = 10=#a6d189
palette = 11=#f2d5cf
palette = 12=#85c1dc
palette = 13=#f4b8e4
palette = 14=#99d1db
palette = 15=#babbf1
palette = 16=#ef9f76
palette = 17=#eebebe
palette = 18=#292c3c
palette = 19=#414559
palette = 20=#626880
palette = 21=#f2d5cf

# Foreground & background colors
background = #303446
foreground = #c6d0f5
cursor-color = #c6d0f5
selection-background = #c6d0f5
selection-foreground = #414559
search-background = #e5c890
search-foreground = #292c3c
search-selected-background = #ef9f76
search-selected-foreground = #292c3c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #babbf1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #85c1dc
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
