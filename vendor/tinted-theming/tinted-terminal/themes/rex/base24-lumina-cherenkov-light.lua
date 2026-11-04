-- vim: ft=lua
-- Lumina Cherenkov Light theme for Rex
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

local name = "base24-lumina-cherenkov-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-cherenkov-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Cherenkov Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5f8ff
palette = 1=#a32224
palette = 2=#227a3e
palette = 3=#a35f00
palette = 4=#0a4fcc
palette = 5=#7849c1
palette = 6=#087181
palette = 7=#1f2e53
palette = 8=#d1d5df
palette = 9=#792825
palette = 10=#07652c
palette = 11=#874e00
palette = 12=#1d448f
palette = 13=#793474
palette = 14=#005c69
palette = 15=#1f2e53
palette = 16=#b54a04
palette = 17=#90478a
palette = 18=#edf1fb
palette = 19=#e2e6ef
palette = 20=#82868f
palette = 21=#44484f

# Foreground & background colors
background = #f5f8ff
foreground = #1f2e53
cursor-color = #1f2e53
selection-background = #1f2e53
selection-foreground = #e2e6ef
search-background = #a35f00
search-foreground = #edf1fb
search-selected-background = #b54a04
search-selected-foreground = #edf1fb

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1f2e53
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #1d448f
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
