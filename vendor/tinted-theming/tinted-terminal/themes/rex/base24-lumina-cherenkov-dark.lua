-- vim: ft=lua
-- Lumina Cherenkov Dark theme for Rex
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

local name = "base24-lumina-cherenkov-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-cherenkov-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Cherenkov Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#021129
palette = 1=#db6c64
palette = 2=#9ad8a6
palette = 3=#ead293
palette = 4=#4ca1ff
palette = 5=#c7aefe
palette = 6=#8fe7fd
palette = 7=#d7e7f5
palette = 8=#142946
palette = 9=#e79088
palette = 10=#b2f3bf
palette = 11=#ffe6a4
palette = 12=#90bbee
palette = 13=#ffcefa
palette = 14=#bff2ff
palette = 15=#d7e7f5
palette = 16=#fba26f
palette = 17=#ecafe6
palette = 18=#031530
palette = 19=#0a1f3b
palette = 20=#536a8b
palette = 21=#a2b3ca

# Foreground & background colors
background = #021129
foreground = #d7e7f5
cursor-color = #d7e7f5
selection-background = #d7e7f5
selection-foreground = #0a1f3b
search-background = #ead293
search-foreground = #031530
search-selected-background = #fba26f
search-selected-foreground = #031530

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d7e7f5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #90bbee
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
