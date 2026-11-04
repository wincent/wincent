-- vim: ft=lua
-- Lumina Nebula Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-nebula-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-nebula-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Nebula Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f8f4ff
palette = 1=#932222
palette = 2=#007650
palette = 3=#955b01
palette = 4=#3f5777
palette = 5=#5d40b1
palette = 6=#016e90
palette = 7=#2d2c46
palette = 8=#d6d1df
palette = 9=#6c2421
palette = 10=#005f40
palette = 11=#7a4a00
palette = 12=#0e417f
palette = 13=#72356e
palette = 14=#005975
palette = 15=#2d2c46
palette = 16=#934916
palette = 17=#894884
palette = 18=#f2edfb
palette = 19=#e6e1ef
palette = 20=#888391
palette = 21=#4a4551

# Foreground & background colors
background = #f8f4ff
foreground = #2d2c46
cursor-color = #2d2c46
selection-background = #2d2c46
selection-foreground = #e6e1ef
search-background = #955b01
search-foreground = #f2edfb
search-selected-background = #934916
search-selected-foreground = #f2edfb

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2d2c46
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0e417f
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
