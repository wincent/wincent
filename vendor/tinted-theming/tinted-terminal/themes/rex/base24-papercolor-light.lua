-- vim: ft=lua
-- PaperColor Light theme for Rex
-- Scheme Author: Nguyen Nguyen (https://github.com/NLKNguyen/papercolor-theme)
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

local name = "base24-papercolor-light"
local variant = "light"

-- This must match themes/ghostty/base24-papercolor-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# PaperColor Light theme for Ghostty
# Scheme Author: Nguyen Nguyen (https://github.com/NLKNguyen/papercolor-theme)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#eeeeee
palette = 1=#af0000
palette = 2=#008700
palette = 3=#5f8700
palette = 4=#0087af
palette = 5=#8700af
palette = 6=#d75f00
palette = 7=#444444
palette = 8=#878787
palette = 9=#d70000
palette = 10=#87af00
palette = 11=#ff00af
palette = 12=#ff8700
palette = 13=#5fafff
palette = 14=#00af00
palette = 15=#0087af
palette = 16=#d70087
palette = 17=#005faf
palette = 18=#e4e4e4
palette = 19=#d0d0d0
palette = 20=#b2b2b2
palette = 21=#005f87

# Foreground & background colors
background = #eeeeee
foreground = #444444
cursor-color = #444444
selection-background = #444444
selection-foreground = #d0d0d0
search-background = #5f8700
search-foreground = #e4e4e4
search-selected-background = #d70087
search-selected-foreground = #e4e4e4

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #0087af
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #ff8700
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
