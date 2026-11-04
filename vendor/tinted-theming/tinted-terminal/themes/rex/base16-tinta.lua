-- vim: ft=lua
-- Tinta theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-tinta"
local variant = "dark"

-- This must match themes/ghostty/base16-tinta exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tinta theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#101012
palette = 1=#d0726a
palette = 2=#9aa890
palette = 3=#c8b86a
palette = 4=#8a9ab0
palette = 5=#b0a0b8
palette = 6=#80b8b4
palette = 7=#d8d6d0
palette = 8=#62626a
palette = 9=#d0726a
palette = 10=#9aa890
palette = 11=#c8b86a
palette = 12=#8a9ab0
palette = 13=#b0a0b8
palette = 14=#80b8b4
palette = 15=#eeece6
palette = 16=#e8843a
palette = 17=#4a4a50
palette = 18=#202023
palette = 19=#2c2c30
palette = 20=#9d9c9d
palette = 21=#e3e1db

# Foreground & background colors
background = #101012
foreground = #d8d6d0
cursor-color = #d8d6d0
selection-background = #d8d6d0
selection-foreground = #2c2c30
search-background = #c8b86a
search-foreground = #202023
search-selected-background = #e8843a
search-selected-foreground = #202023

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eeece6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8a9ab0
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
