-- vim: ft=lua
-- vice theme for Rex
-- Scheme Author: Thomas Leon Highbaugh thighbaugh@zoho.com
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

local name = "base16-vice"
local variant = "dark"

-- This must match themes/ghostty/base16-vice exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# vice theme for Ghostty
# Scheme Author: Thomas Leon Highbaugh thighbaugh@zoho.com
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#17191e
palette = 1=#ff29a8
palette = 2=#0badff
palette = 3=#f0ffaa
palette = 4=#00eaff
palette = 5=#00f6d9
palette = 6=#8265ff
palette = 7=#8b9cbe
palette = 8=#383a47
palette = 9=#ff29a8
palette = 10=#0badff
palette = 11=#f0ffaa
palette = 12=#00eaff
palette = 13=#00f6d9
palette = 14=#8265ff
palette = 15=#f4f4f7
palette = 16=#85ffe0
palette = 17=#ff3d81
palette = 18=#22262d
palette = 19=#3c3f4c
palette = 20=#555e70
palette = 21=#b2bfd9

# Foreground & background colors
background = #17191e
foreground = #8b9cbe
cursor-color = #8b9cbe
selection-background = #8b9cbe
selection-foreground = #3c3f4c
search-background = #f0ffaa
search-foreground = #22262d
search-selected-background = #85ffe0
search-selected-foreground = #22262d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f4f4f7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #00eaff
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
