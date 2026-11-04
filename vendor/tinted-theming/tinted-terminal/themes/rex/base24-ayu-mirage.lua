-- vim: ft=lua
-- Ayu Mirage theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
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

local name = "base24-ayu-mirage"
local variant = "dark"

-- This must match themes/ghostty/base24-ayu-mirage exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ayu Mirage theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1f2430
palette = 1=#f28779
palette = 2=#d5ff80
palette = 3=#ffd173
palette = 4=#73d0ff
palette = 5=#d4bfff
palette = 6=#95e6cb
palette = 7=#cccac2
palette = 8=#4a5059
palette = 9=#ff6666
palette = 10=#87d963
palette = 11=#ffcc66
palette = 12=#80b0ff
palette = 13=#b692ff
palette = 14=#5ccfe6
palette = 15=#f3f4f5
palette = 16=#ffad66
palette = 17=#f27983
palette = 18=#242936
palette = 19=#323844
palette = 20=#707a8c
palette = 21=#d9d7ce

# Foreground & background colors
background = #1f2430
foreground = #cccac2
cursor-color = #cccac2
selection-background = #cccac2
selection-foreground = #323844
search-background = #ffd173
search-foreground = #242936
search-selected-background = #ffad66
search-selected-foreground = #242936

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f3f4f5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #80b0ff
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
