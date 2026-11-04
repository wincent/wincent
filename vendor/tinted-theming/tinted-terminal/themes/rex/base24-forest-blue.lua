-- vim: ft=lua
-- Forest Blue theme for Rex
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

local name = "base24-forest-blue"
local variant = "dark"

-- This must match themes/ghostty/base24-forest-blue exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Forest Blue theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#051519
palette = 1=#f8818e
palette = 2=#92d3a2
palette = 3=#39a7a2
palette = 4=#8ed0ce
palette = 5=#5e468c
palette = 6=#31658c
palette = 7=#b8b1a9
palette = 8=#666361
palette = 9=#fb3d66
palette = 10=#6bb48d
palette = 11=#2fc859
palette = 12=#39a7a2
palette = 13=#7e62b3
palette = 14=#6096bf
palette = 15=#e2d8cd
palette = 16=#1a8d63
palette = 17=#7c4047
palette = 18=#333333
palette = 19=#3d3d3d
palette = 20=#8f8a85
palette = 21=#e2d8cd

# Foreground & background colors
background = #051519
foreground = #b8b1a9
cursor-color = #b8b1a9
selection-background = #b8b1a9
selection-foreground = #3d3d3d
search-background = #39a7a2
search-foreground = #333333
search-selected-background = #1a8d63
search-selected-foreground = #333333

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e2d8cd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #39a7a2
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
