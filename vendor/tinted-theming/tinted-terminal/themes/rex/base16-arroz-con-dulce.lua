-- vim: ft=lua
-- Arroz con Dulce theme for Rex
-- Scheme Author: Richard Martinez
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

local name = "base16-arroz-con-dulce"
local variant = "light"

-- This must match themes/ghostty/base16-arroz-con-dulce exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Arroz con Dulce theme for Ghostty
# Scheme Author: Richard Martinez
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fff8e7
palette = 1=#a11d48
palette = 2=#a2380c
palette = 3=#855500
palette = 4=#5940a0
palette = 5=#8c1f68
palette = 6=#98263e
palette = 7=#4a2c20
palette = 8=#c8a77a
palette = 9=#a11d48
palette = 10=#a2380c
palette = 11=#855500
palette = 12=#5940a0
palette = 13=#8c1f68
palette = 14=#98263e
palette = 15=#21110b
palette = 16=#a3470a
palette = 17=#653221
palette = 18=#f7ebd3
palette = 19=#ead6b8
palette = 20=#765b45
palette = 21=#321c14

# Foreground & background colors
background = #fff8e7
foreground = #4a2c20
cursor-color = #4a2c20
selection-background = #4a2c20
selection-foreground = #ead6b8
search-background = #855500
search-foreground = #21110b
search-selected-background = #a3470a
search-selected-foreground = #21110b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #21110b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5940a0
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
