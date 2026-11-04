-- vim: ft=lua
-- Flexoki Light theme for Rex
-- Scheme Author: Steph Ango (https://github.com/kepano/flexoki)
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

local name = "base24-flexoki-light"
local variant = "light"

-- This must match themes/ghostty/base24-flexoki-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Flexoki Light theme for Ghostty
# Scheme Author: Steph Ango (https://github.com/kepano/flexoki)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fffcf0
palette = 1=#af3029
palette = 2=#66800b
palette = 3=#ad8301
palette = 4=#205ea6
palette = 5=#5e409d
palette = 6=#24837b
palette = 7=#403e3c
palette = 8=#cecdc3
palette = 9=#d14d41
palette = 10=#d0a215
palette = 11=#da702c
palette = 12=#3aa99f
palette = 13=#4385be
palette = 14=#879a39
palette = 15=#100f0f
palette = 16=#bc5215
palette = 17=#a02f6f
palette = 18=#f2f0e5
palette = 19=#e6e4d9
palette = 20=#9f9d96
palette = 21=#282726

# Foreground & background colors
background = #fffcf0
foreground = #403e3c
cursor-color = #403e3c
selection-background = #403e3c
selection-foreground = #e6e4d9
search-background = #ad8301
search-foreground = #f2f0e5
search-selected-background = #bc5215
search-selected-foreground = #f2f0e5

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #100f0f
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3aa99f
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
