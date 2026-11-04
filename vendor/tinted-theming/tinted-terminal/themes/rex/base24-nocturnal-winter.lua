-- vim: ft=lua
-- Nocturnal Winter theme for Rex
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

local name = "base24-nocturnal-winter"
local variant = "dark"

-- This must match themes/ghostty/base24-nocturnal-winter exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Nocturnal Winter theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0d0d17
palette = 1=#f12d52
palette = 2=#08cd7d
palette = 3=#6095fe
palette = 4=#3081df
palette = 5=#fe2a6c
palette = 6=#09c87a
palette = 7=#dcdcdc
palette = 8=#9e9e9e
palette = 9=#f16c85
palette = 10=#0ae78d
palette = 11=#fefb67
palette = 12=#6095fe
palette = 13=#ff78a2
palette = 14=#0ae78d
palette = 15=#ffffff
palette = 16=#f5f079
palette = 17=#781629
palette = 18=#4c4c4c
palette = 19=#7f7f7f
palette = 20=#bdbdbd
palette = 21=#fbfbfb

# Foreground & background colors
background = #0d0d17
foreground = #dcdcdc
cursor-color = #dcdcdc
selection-background = #dcdcdc
selection-foreground = #7f7f7f
search-background = #6095fe
search-foreground = #4c4c4c
search-selected-background = #f5f079
search-selected-foreground = #4c4c4c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6095fe
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
