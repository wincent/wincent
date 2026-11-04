-- vim: ft=lua
-- Espresso Libre theme for Rex
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

local name = "base24-espresso-libre"
local variant = "dark"

-- This must match themes/ghostty/base24-espresso-libre exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Espresso Libre theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2a211c
palette = 1=#cc0000
palette = 2=#1a921c
palette = 3=#43a8ed
palette = 4=#0066ff
palette = 5=#c5656b
palette = 6=#05989a
palette = 7=#b3b7b0
palette = 8=#737772
palette = 9=#ef2828
palette = 10=#9aff87
palette = 11=#fffa5c
palette = 12=#43a8ed
palette = 13=#ff8089
palette = 14=#34e2e2
palette = 15=#ededec
palette = 16=#efe43a
palette = 17=#660000
palette = 18=#000000
palette = 19=#545753
palette = 20=#939791
palette = 21=#d3d7cf

# Foreground & background colors
background = #2a211c
foreground = #b3b7b0
cursor-color = #b3b7b0
selection-background = #b3b7b0
selection-foreground = #545753
search-background = #43a8ed
search-foreground = #000000
search-selected-background = #efe43a
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ededec
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #43a8ed
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
