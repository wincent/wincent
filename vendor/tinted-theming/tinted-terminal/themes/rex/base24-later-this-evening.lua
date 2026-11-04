-- vim: ft=lua
-- Later This Evening theme for Rex
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

local name = "base24-later-this-evening"
local variant = "dark"

-- This must match themes/ghostty/base24-later-this-evening exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Later This Evening theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#212121
palette = 1=#d35a5f
palette = 2=#afba66
palette = 3=#e5d289
palette = 4=#a0b9d5
palette = 5=#bf92d5
palette = 6=#91beb6
palette = 7=#a6a6a6
palette = 8=#6f6f6f
palette = 9=#d3222e
palette = 10=#aabb39
palette = 11=#e4bd39
palette = 12=#6599d5
palette = 13=#aa52d5
palette = 14=#5fbfad
palette = 15=#d9d9d9
palette = 16=#e5af89
palette = 17=#692d2f
palette = 18=#313131
palette = 19=#4f4f4f
palette = 20=#8c8c8c
palette = 21=#bfbfbf

# Foreground & background colors
background = #212121
foreground = #a6a6a6
cursor-color = #a6a6a6
selection-background = #a6a6a6
selection-foreground = #4f4f4f
search-background = #e5d289
search-foreground = #313131
search-selected-background = #e5af89
search-selected-foreground = #313131

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d9d9d9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6599d5
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
