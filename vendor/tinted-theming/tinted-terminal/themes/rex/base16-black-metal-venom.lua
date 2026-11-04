-- vim: ft=lua
-- Black Metal (Venom) theme for Rex
-- Scheme Author: metalelf0 (https://github.com/metalelf0)
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

local name = "base16-black-metal-venom"
local variant = "dark"

-- This must match themes/ghostty/base16-black-metal-venom exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Black Metal (Venom) theme for Ghostty
# Scheme Author: metalelf0 (https://github.com/metalelf0)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#000000
palette = 1=#5f8787
palette = 2=#f8f7f2
palette = 3=#79241f
palette = 4=#888888
palette = 5=#999999
palette = 6=#aaaaaa
palette = 7=#c1c1c1
palette = 8=#333333
palette = 9=#5f8787
palette = 10=#f8f7f2
palette = 11=#79241f
palette = 12=#888888
palette = 13=#999999
palette = 14=#aaaaaa
palette = 15=#c1c1c1
palette = 16=#aaaaaa
palette = 17=#444444
palette = 18=#121212
palette = 19=#222222
palette = 20=#999999
palette = 21=#999999

# Foreground & background colors
background = #000000
foreground = #c1c1c1
cursor-color = #c1c1c1
selection-background = #c1c1c1
selection-foreground = #222222
search-background = #79241f
search-foreground = #121212
search-selected-background = #aaaaaa
search-selected-foreground = #121212

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #c1c1c1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #888888
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
