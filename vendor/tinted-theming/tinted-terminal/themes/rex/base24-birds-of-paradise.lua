-- vim: ft=lua
-- Birds Of Paradise theme for Rex
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

local name = "base24-birds-of-paradise"
local variant = "dark"

-- This must match themes/ghostty/base24-birds-of-paradise exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Birds Of Paradise theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2a1e1d
palette = 1=#be2d26
palette = 2=#6ba08a
palette = 3=#b8d3ed
palette = 4=#5a86ac
palette = 5=#ab80a6
palette = 6=#74a5ac
palette = 7=#cdbe9b
palette = 8=#ab8664
palette = 9=#e84526
palette = 10=#94d7ba
palette = 11=#d0d04f
palette = 12=#b8d3ed
palette = 13=#d09dca
palette = 14=#92ced6
palette = 15=#fff9d4
palette = 16=#e99c29
palette = 17=#5f1613
palette = 18=#573d25
palette = 19=#9a6b49
palette = 20=#bca280
palette = 21=#dfdab7

# Foreground & background colors
background = #2a1e1d
foreground = #cdbe9b
cursor-color = #cdbe9b
selection-background = #cdbe9b
selection-foreground = #9a6b49
search-background = #b8d3ed
search-foreground = #573d25
search-selected-background = #e99c29
search-selected-foreground = #573d25

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fff9d4
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #b8d3ed
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
