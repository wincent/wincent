-- vim: ft=lua
-- Material theme for Rex
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

local name = "base24-material"
local variant = "light"

-- This must match themes/ghostty/base24-material exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Material theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#eaeaea
palette = 1=#b7141e
palette = 2=#457b23
palette = 3=#53a4f3
palette = 4=#134eb2
palette = 5=#550087
palette = 6=#0e707c
palette = 7=#c3c3c3
palette = 8=#6d6d6d
palette = 9=#e83a3f
palette = 10=#7aba39
palette = 11=#fee92e
palette = 12=#53a4f3
palette = 13=#a94dbb
palette = 14=#26bad1
palette = 15=#d8d8d8
palette = 16=#f5971d
palette = 17=#5b0a0f
palette = 18=#212121
palette = 19=#424242
palette = 20=#989898
palette = 21=#eeeeee

# Foreground & background colors
background = #eaeaea
foreground = #c3c3c3
cursor-color = #c3c3c3
selection-background = #c3c3c3
selection-foreground = #424242
search-background = #53a4f3
search-foreground = #212121
search-selected-background = #f5971d
search-selected-foreground = #212121

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d8d8d8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #53a4f3
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
