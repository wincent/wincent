-- vim: ft=lua
-- Wryan theme for Rex
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

local name = "base24-wryan"
local variant = "dark"

-- This must match themes/ghostty/base24-wryan exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Wryan theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#101010
palette = 1=#8c4665
palette = 2=#287373
palette = 3=#477ab3
palette = 4=#395573
palette = 5=#5e468c
palette = 6=#31658c
palette = 7=#768488
palette = 8=#505456
palette = 9=#bf4d80
palette = 10=#53a6a6
palette = 11=#9e9ecb
palette = 12=#477ab3
palette = 13=#7e62b3
palette = 14=#6096bf
palette = 15=#c0c0c0
palette = 16=#7c7c99
palette = 17=#462332
palette = 18=#333333
palette = 19=#3d3d3d
palette = 20=#636c6f
palette = 21=#899ca1

# Foreground & background colors
background = #101010
foreground = #768488
cursor-color = #768488
selection-background = #768488
selection-foreground = #3d3d3d
search-background = #477ab3
search-foreground = #333333
search-selected-background = #7c7c99
search-selected-foreground = #333333

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #c0c0c0
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #477ab3
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
