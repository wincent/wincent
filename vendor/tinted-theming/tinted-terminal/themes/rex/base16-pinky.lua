-- vim: ft=lua
-- pinky theme for Rex
-- Scheme Author: Benjamin (https://github.com/b3nj5m1n)
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

local name = "base16-pinky"
local variant = "dark"

-- This must match themes/ghostty/base16-pinky exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# pinky theme for Ghostty
# Scheme Author: Benjamin (https://github.com/b3nj5m1n)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#171517
palette = 1=#ffa600
palette = 2=#ff0066
palette = 3=#20df6c
palette = 4=#00ffff
palette = 5=#007fff
palette = 6=#6600ff
palette = 7=#f5f5f5
palette = 8=#383338
palette = 9=#ffa600
palette = 10=#ff0066
palette = 11=#20df6c
palette = 12=#00ffff
palette = 13=#007fff
palette = 14=#6600ff
palette = 15=#f7f3f7
palette = 16=#00ff66
palette = 17=#df206c
palette = 18=#1b181b
palette = 19=#1d1b1d
palette = 20=#e7dbdb
palette = 21=#ffffff

# Foreground & background colors
background = #171517
foreground = #f5f5f5
cursor-color = #f5f5f5
selection-background = #f5f5f5
selection-foreground = #1d1b1d
search-background = #20df6c
search-foreground = #1b181b
search-selected-background = #00ff66
search-selected-foreground = #1b181b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f7f3f7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #00ffff
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
