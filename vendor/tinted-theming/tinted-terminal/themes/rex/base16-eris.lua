-- vim: ft=lua
-- eris theme for Rex
-- Scheme Author: ed (https://codeberg.org/ed), Tinted Theming (https://github.com/tinted-theming)
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

local name = "base16-eris"
local variant = "dark"

-- This must match themes/ghostty/base16-eris exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# eris theme for Ghostty
# Scheme Author: ed (https://codeberg.org/ed), Tinted Theming (https://github.com/tinted-theming)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0a0920
palette = 1=#f768a3
palette = 2=#a2faa8
palette = 3=#f7d668
palette = 4=#258fc4
palette = 5=#c368f7
palette = 6=#a2faf0
palette = 7=#606bac
palette = 8=#333773
palette = 9=#f768a3
palette = 10=#a2faa8
palette = 11=#f7d668
palette = 12=#258fc4
palette = 13=#c368f7
palette = 14=#a2faf0
palette = 15=#9aaae5
palette = 16=#f78968
palette = 17=#b85600
palette = 18=#13133a
palette = 19=#23255a
palette = 20=#4a5293
palette = 21=#7986c5

# Foreground & background colors
background = #0a0920
foreground = #606bac
cursor-color = #606bac
selection-background = #606bac
selection-foreground = #23255a
search-background = #f7d668
search-foreground = #13133a
search-selected-background = #f78968
search-selected-foreground = #13133a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #9aaae5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #258fc4
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
