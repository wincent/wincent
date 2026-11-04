-- vim: ft=lua
-- Sundried theme for Rex
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

local name = "base24-sundried"
local variant = "dark"

-- This must match themes/ghostty/base24-sundried exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sundried theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a1818
palette = 1=#a6463d
palette = 2=#577644
palette = 3=#7898f7
palette = 4=#485a98
palette = 5=#854551
palette = 6=#9c814e
palette = 7=#a9a9a7
palette = 8=#6b6b67
palette = 9=#aa000c
palette = 10=#128c20
palette = 11=#fc6a20
palette = 12=#7898f7
palette = 13=#fc89a0
palette = 14=#fad384
palette = 15=#fffefe
palette = 16=#9c5f2a
palette = 17=#53231e
palette = 18=#302b2a
palette = 19=#4d4d47
palette = 20=#8a8a87
palette = 21=#c8c8c8

# Foreground & background colors
background = #1a1818
foreground = #a9a9a7
cursor-color = #a9a9a7
selection-background = #a9a9a7
selection-foreground = #4d4d47
search-background = #7898f7
search-foreground = #302b2a
search-selected-background = #9c5f2a
search-selected-foreground = #302b2a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fffefe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7898f7
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
