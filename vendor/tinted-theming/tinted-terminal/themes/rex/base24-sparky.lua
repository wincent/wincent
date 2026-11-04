-- vim: ft=lua
-- Sparky theme for Rex
-- Scheme Author: Leila Sother (https://github.com/mixcoac)
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

local name = "base24-sparky"
local variant = "dark"

-- This must match themes/ghostty/base24-sparky exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sparky theme for Ghostty
# Scheme Author: Leila Sother (https://github.com/mixcoac)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#072b31
palette = 1=#ff585d
palette = 2=#78d64b
palette = 3=#fbdd40
palette = 4=#4698cb
palette = 5=#d59ed7
palette = 6=#2dccd3
palette = 7=#f4f5f0
palette = 8=#003b49
palette = 9=#ff7276
palette = 10=#8edd65
palette = 11=#f6eb61
palette = 12=#69b3e7
palette = 13=#f99fc9
palette = 14=#00c1d5
palette = 15=#ffffff
palette = 16=#ff8f1c
palette = 17=#9b704d
palette = 18=#00313c
palette = 19=#003c46
palette = 20=#00778b
palette = 21=#f5f5f1

# Foreground & background colors
background = #072b31
foreground = #f4f5f0
cursor-color = #f4f5f0
selection-background = #f4f5f0
selection-foreground = #003c46
search-background = #fbdd40
search-foreground = #00313c
search-selected-background = #ff8f1c
search-selected-foreground = #00313c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #69b3e7
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
