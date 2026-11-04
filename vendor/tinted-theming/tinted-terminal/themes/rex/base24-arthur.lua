-- vim: ft=lua
-- Arthur theme for Rex
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

local name = "base24-arthur"
local variant = "dark"

-- This must match themes/ghostty/base24-arthur exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Arthur theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1c1c
palette = 1=#cd5c5c
palette = 2=#86af80
palette = 3=#87ceeb
palette = 4=#6495ed
palette = 5=#deb887
palette = 6=#b0c4de
palette = 7=#a19083
palette = 8=#6e5d59
palette = 9=#cc5533
palette = 10=#88aa22
palette = 11=#ffa75d
palette = 12=#87ceeb
palette = 13=#996600
palette = 14=#b0c4de
palette = 15=#ddccbb
palette = 16=#e8ae5b
palette = 17=#662e2e
palette = 18=#3d352a
palette = 19=#554444
palette = 20=#88776e
palette = 21=#bbaa99

# Foreground & background colors
background = #1c1c1c
foreground = #a19083
cursor-color = #a19083
selection-background = #a19083
selection-foreground = #554444
search-background = #87ceeb
search-foreground = #3d352a
search-selected-background = #e8ae5b
search-selected-foreground = #3d352a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ddccbb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #87ceeb
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
