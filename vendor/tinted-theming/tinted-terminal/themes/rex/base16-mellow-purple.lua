-- vim: ft=lua
-- Mellow Purple theme for Rex
-- Scheme Author: gidsi
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

local name = "base16-mellow-purple"
local variant = "dark"

-- This must match themes/ghostty/base16-mellow-purple exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Mellow Purple theme for Ghostty
# Scheme Author: gidsi
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e0528
palette = 1=#00d9e9
palette = 2=#05cb0d
palette = 3=#955ae7
palette = 4=#550068
palette = 5=#8991bb
palette = 6=#b900b1
palette = 7=#ffeeff
palette = 8=#320f55
palette = 9=#00d9e9
palette = 10=#05cb0d
palette = 11=#955ae7
palette = 12=#550068
palette = 13=#8991bb
palette = 14=#b900b1
palette = 15=#f8c0ff
palette = 16=#aa00a3
palette = 17=#4d6fff
palette = 18=#1a092d
palette = 19=#331354
palette = 20=#873582
palette = 21=#ffeeff

# Foreground & background colors
background = #1e0528
foreground = #ffeeff
cursor-color = #ffeeff
selection-background = #ffeeff
selection-foreground = #331354
search-background = #955ae7
search-foreground = #1a092d
search-selected-background = #aa00a3
search-selected-foreground = #1a092d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8c0ff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #550068
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
