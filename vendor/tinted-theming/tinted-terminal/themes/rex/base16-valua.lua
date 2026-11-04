-- vim: ft=lua
-- Valua theme for Rex
-- Scheme Author: Nonetrix (https://github.com/nonetrix)
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

local name = "base16-valua"
local variant = "dark"

-- This must match themes/ghostty/base16-valua exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Valua theme for Ghostty
# Scheme Author: Nonetrix (https://github.com/nonetrix)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#131f1f
palette = 1=#d7586e
palette = 2=#59d678
palette = 3=#dfe754
palette = 4=#4ed2d2
palette = 5=#a874e0
palette = 6=#76dbd2
palette = 7=#98c1a3
palette = 8=#3e5c53
palette = 9=#d7586e
palette = 10=#59d678
palette = 11=#dfe754
palette = 12=#4ed2d2
palette = 13=#a874e0
palette = 14=#76dbd2
palette = 15=#aacbcb
palette = 16=#e6b466
palette = 17=#c05a8f
palette = 18=#213132
palette = 19=#273d3c
palette = 20=#6d9877
palette = 21=#a5cbb9

# Foreground & background colors
background = #131f1f
foreground = #98c1a3
cursor-color = #98c1a3
selection-background = #98c1a3
selection-foreground = #273d3c
search-background = #dfe754
search-foreground = #213132
search-selected-background = #e6b466
search-selected-foreground = #213132

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #aacbcb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #4ed2d2
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
