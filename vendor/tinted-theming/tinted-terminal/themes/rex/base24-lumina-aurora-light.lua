-- vim: ft=lua
-- Lumina Aurora Light theme for Rex
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

local name = "base24-lumina-aurora-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-aurora-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Aurora Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f2faf9
palette = 1=#942a28
palette = 2=#026d43
palette = 3=#9f6116
palette = 4=#425b7a
palette = 5=#754fa5
palette = 6=#007386
palette = 7=#163236
palette = 8=#cdd8d7
palette = 9=#6d2926
palette = 10=#005734
palette = 11=#864e01
palette = 12=#17467d
palette = 13=#733a6e
palette = 14=#005d6d
palette = 15=#163236
palette = 16=#985022
palette = 17=#894c84
palette = 18=#e9f4f3
palette = 19=#dde9e7
palette = 20=#7e8987
palette = 21=#414a49

# Foreground & background colors
background = #f2faf9
foreground = #163236
cursor-color = #163236
selection-background = #163236
selection-foreground = #dde9e7
search-background = #9f6116
search-foreground = #e9f4f3
search-selected-background = #985022
search-selected-foreground = #e9f4f3

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #163236
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #17467d
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
