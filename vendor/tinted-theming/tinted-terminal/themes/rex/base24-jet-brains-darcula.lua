-- vim: ft=lua
-- Jet Brains Darcula theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-jet-brains-darcula"
local variant = "dark"

-- This must match themes/ghostty/base24-jet-brains-darcula exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Jet Brains Darcula theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#202020
palette = 1=#fa5355
palette = 2=#126e00
palette = 3=#6d9df1
palette = 4=#4581eb
palette = 5=#fa54ff
palette = 6=#33c2c1
palette = 7=#979797
palette = 8=#6b6b6b
palette = 9=#fb7172
palette = 10=#67ff4f
palette = 11=#ffff00
palette = 12=#6d9df1
palette = 13=#fb82ff
palette = 14=#60d3d1
palette = 15=#eeeeee
palette = 16=#c2c300
palette = 17=#7d292a
palette = 18=#000000
palette = 19=#555555
palette = 20=#818181
palette = 21=#adadad

# Foreground & background colors
background = #202020
foreground = #979797
cursor-color = #979797
selection-background = #979797
selection-foreground = #555555
search-background = #6d9df1
search-foreground = #000000
search-selected-background = #c2c300
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eeeeee
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6d9df1
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
