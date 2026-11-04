-- vim: ft=lua
-- Lumina Rayleigh Light theme for Rex
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

local name = "base24-lumina-rayleigh-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-rayleigh-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Rayleigh Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#edf8ff
palette = 1=#94171b
palette = 2=#1e773b
palette = 3=#a35f00
palette = 4=#0160a7
palette = 5=#7244a9
palette = 6=#056271
palette = 7=#1d2f47
palette = 8=#c8d6df
palette = 9=#6c1f1d
palette = 10=#01622a
palette = 11=#874e00
palette = 12=#004c87
palette = 13=#763171
palette = 14=#004d59
palette = 15=#1d2f47
palette = 16=#a14e14
palette = 17=#8d4487
palette = 18=#e3f2fb
palette = 19=#d8e6f0
palette = 20=#7b8891
palette = 21=#3d4a52

# Foreground & background colors
background = #edf8ff
foreground = #1d2f47
cursor-color = #1d2f47
selection-background = #1d2f47
selection-foreground = #d8e6f0
search-background = #a35f00
search-foreground = #e3f2fb
search-selected-background = #a14e14
search-selected-foreground = #e3f2fb

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1d2f47
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #004c87
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
