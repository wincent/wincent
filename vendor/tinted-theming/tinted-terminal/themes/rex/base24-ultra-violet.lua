-- vim: ft=lua
-- Ultra Violet theme for Rex
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

local name = "base24-ultra-violet"
local variant = "dark"

-- This must match themes/ghostty/base24-ultra-violet exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ultra Violet theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#242728
palette = 1=#ff0090
palette = 2=#b5ff00
palette = 3=#7febff
palette = 4=#47dffb
palette = 5=#d630ff
palette = 6=#0effbb
palette = 7=#c1c2c2
palette = 8=#818484
palette = 9=#fb57b4
palette = 10=#deff8b
palette = 11=#ebdf86
palette = 12=#7febff
palette = 13=#e681ff
palette = 14=#68fcd2
palette = 15=#f9f9f4
palette = 16=#fff727
palette = 17=#7f0048
palette = 18=#232628
palette = 19=#626566
palette = 20=#a1a3a3
palette = 21=#e1e1e1

# Foreground & background colors
background = #242728
foreground = #c1c2c2
cursor-color = #c1c2c2
selection-background = #c1c2c2
selection-foreground = #626566
search-background = #7febff
search-foreground = #232628
search-selected-background = #fff727
search-selected-foreground = #232628

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f9f9f4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7febff
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
