-- vim: ft=lua
-- Fun Forrest theme for Rex
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

local name = "base24-fun-forrest"
local variant = "dark"

-- This must match themes/ghostty/base24-fun-forrest exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Fun Forrest theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#241200
palette = 1=#d5252b
palette = 2=#909b00
palette = 3=#7cc9ce
palette = 4=#4698a2
palette = 5=#8c4231
palette = 6=#d98112
palette = 7=#c5ab60
palette = 8=#957f58
palette = 9=#e4591b
palette = 10=#bfc659
palette = 11=#ffca1b
palette = 12=#7cc9ce
palette = 13=#d16349
palette = 14=#e6a96b
palette = 15=#ffe9a3
palette = 16=#bd8a13
palette = 17=#6a1215
palette = 18=#000000
palette = 19=#7e6954
palette = 20=#ad955c
palette = 21=#ddc165

# Foreground & background colors
background = #241200
foreground = #c5ab60
cursor-color = #c5ab60
selection-background = #c5ab60
selection-foreground = #7e6954
search-background = #7cc9ce
search-foreground = #000000
search-selected-background = #bd8a13
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffe9a3
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7cc9ce
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
