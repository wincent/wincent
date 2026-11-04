-- vim: ft=lua
-- Wombat theme for Rex
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

local name = "base24-wombat"
local variant = "dark"

-- This must match themes/ghostty/base24-wombat exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Wombat theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#171717
palette = 1=#ff605a
palette = 2=#b1e869
palette = 3=#a5c7ff
palette = 4=#5da9f6
palette = 5=#e86aff
palette = 6=#82fff6
palette = 7=#b2afa6
palette = 8=#5c5b58
palette = 9=#f58b7f
palette = 10=#dcf88f
palette = 11=#eee5b2
palette = 12=#a5c7ff
palette = 13=#ddaaff
palette = 14=#b6fff9
palette = 15=#fefffe
palette = 16=#ead89c
palette = 17=#7f302d
palette = 18=#000000
palette = 19=#313131
palette = 20=#87857f
palette = 21=#ded9ce

# Foreground & background colors
background = #171717
foreground = #b2afa6
cursor-color = #b2afa6
selection-background = #b2afa6
selection-foreground = #313131
search-background = #a5c7ff
search-foreground = #000000
search-selected-background = #ead89c
search-selected-foreground = #000000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fefffe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a5c7ff
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
