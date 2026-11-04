-- vim: ft=lua
-- Banana Blueberry theme for Rex
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

local name = "base24-banana-blueberry"
local variant = "dark"

-- This must match themes/ghostty/base24-banana-blueberry exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Banana Blueberry theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#191322
palette = 1=#ff6a7e
palette = 2=#00bc9b
palette = 3=#91fff3
palette = 4=#22e8df
palette = 5=#dc3969
palette = 6=#55b6c1
palette = 7=#c6c9cd
palette = 8=#727985
palette = 9=#fd9ea1
palette = 10=#97c378
palette = 11=#f9e46a
palette = 12=#91fff3
palette = 13=#da70d5
palette = 14=#bcf2fe
palette = 15=#feffff
palette = 16=#e5c62f
palette = 17=#7f353f
palette = 18=#16141e
palette = 19=#485161
palette = 20=#9ca1a9
palette = 21=#f1f1f1

# Foreground & background colors
background = #191322
foreground = #c6c9cd
cursor-color = #c6c9cd
selection-background = #c6c9cd
selection-foreground = #485161
search-background = #91fff3
search-foreground = #16141e
search-selected-background = #e5c62f
search-selected-foreground = #16141e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #feffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #91fff3
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
