-- vim: ft=lua
-- Front End Delight theme for Rex
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

local name = "base24-front-end-delight"
local variant = "dark"

-- This must match themes/ghostty/base24-front-end-delight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Front End Delight theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1b1b1d
palette = 1=#f8501a
palette = 2=#565746
palette = 3=#3393c9
palette = 4=#2c70b7
palette = 5=#f02d4e
palette = 6=#3ba0a5
palette = 7=#98ac9c
palette = 8=#71ac7c
palette = 9=#f64319
palette = 10=#74eb4c
palette = 11=#fcc224
palette = 12=#3393c9
palette = 13=#e75e4e
palette = 14=#4ebce5
palette = 15=#acacac
palette = 16=#f9761d
palette = 17=#7c280d
palette = 18=#242426
palette = 19=#5eac6c
palette = 20=#85ac8c
palette = 21=#acacac

# Foreground & background colors
background = #1b1b1d
foreground = #98ac9c
cursor-color = #98ac9c
selection-background = #98ac9c
selection-foreground = #5eac6c
search-background = #3393c9
search-foreground = #242426
search-selected-background = #f9761d
search-selected-foreground = #242426

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #acacac
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3393c9
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
