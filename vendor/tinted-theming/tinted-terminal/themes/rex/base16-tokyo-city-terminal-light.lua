-- vim: ft=lua
-- Tokyo City Terminal Light theme for Rex
-- Scheme Author: Michaël Ball
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

local name = "base16-tokyo-city-terminal-light"
local variant = "light"

-- This must match themes/ghostty/base16-tokyo-city-terminal-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokyo City Terminal Light theme for Ghostty
# Scheme Author: Michaël Ball
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fbfbfd
palette = 1=#8c4351
palette = 2=#33635c
palette = 3=#8f5e15
palette = 4=#34548a
palette = 5=#5a4a78
palette = 6=#0f4b6e
palette = 7=#28323a
palette = 8=#b7c5d3
palette = 9=#8c4351
palette = 10=#33635c
palette = 11=#8f5e15
palette = 12=#34548a
palette = 13=#5a4a78
palette = 14=#0f4b6e
palette = 15=#171d23
palette = 16=#965027
palette = 17=#7e5140
palette = 18=#f6f6f8
palette = 19=#d8e2ec
palette = 20=#526270
palette = 21=#1d252c

# Foreground & background colors
background = #fbfbfd
foreground = #28323a
cursor-color = #28323a
selection-background = #28323a
selection-foreground = #d8e2ec
search-background = #8f5e15
search-foreground = #171d23
search-selected-background = #965027
search-selected-foreground = #171d23

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #171d23
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #34548a
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
