-- vim: ft=lua
-- Ayu Light theme for Rex
-- Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
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

local name = "base16-ayu-light"
local variant = "light"

-- This must match themes/ghostty/base16-ayu-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ayu Light theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f8f9fa
palette = 1=#f07171
palette = 2=#6cbf49
palette = 3=#f2ae49
palette = 4=#399ee6
palette = 5=#a37acc
palette = 6=#4cbf99
palette = 7=#5c6166
palette = 8=#a0a6ac
palette = 9=#f07171
palette = 10=#6cbf49
palette = 11=#f2ae49
palette = 12=#399ee6
palette = 13=#a37acc
palette = 14=#4cbf99
palette = 15=#404447
palette = 16=#fa8d3e
palette = 17=#e6ba7e
palette = 18=#edeff1
palette = 19=#d2d4d8
palette = 20=#8a9199
palette = 21=#4e5257

# Foreground & background colors
background = #f8f9fa
foreground = #5c6166
cursor-color = #5c6166
selection-background = #5c6166
selection-foreground = #d2d4d8
search-background = #f2ae49
search-foreground = #404447
search-selected-background = #fa8d3e
search-selected-foreground = #404447

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #404447
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #399ee6
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
