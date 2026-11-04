-- vim: ft=lua
-- Fish Tank theme for Rex
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

local name = "base24-fish-tank"
local variant = "dark"

-- This must match themes/ghostty/base24-fish-tank exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Fish Tank theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#222436
palette = 1=#c60049
palette = 2=#abf157
palette = 3=#b1bdf9
palette = 4=#525fb8
palette = 5=#976f81
palette = 6=#968662
palette = 7=#ccc9c9
palette = 8=#8c7f63
palette = 9=#d94a8a
palette = 10=#daffa8
palette = 11=#fee6a8
palette = 12=#b1bdf9
palette = 13=#fda4cc
palette = 14=#a4bc86
palette = 15=#f6ffec
palette = 16=#fdcd5e
palette = 17=#630024
palette = 18=#03063c
palette = 19=#6c5a30
palette = 20=#aca496
palette = 21=#eceffc

# Foreground & background colors
background = #222436
foreground = #ccc9c9
cursor-color = #ccc9c9
selection-background = #ccc9c9
selection-foreground = #6c5a30
search-background = #b1bdf9
search-foreground = #03063c
search-selected-background = #fdcd5e
search-selected-foreground = #03063c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f6ffec
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b1bdf9
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
