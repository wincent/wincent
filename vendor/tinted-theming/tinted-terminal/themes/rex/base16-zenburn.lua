-- vim: ft=lua
-- Zenburn theme for Rex
-- Scheme Author: elnawe
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

local name = "base16-zenburn"
local variant = "dark"

-- This must match themes/ghostty/base16-zenburn exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Zenburn theme for Ghostty
# Scheme Author: elnawe
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#383838
palette = 1=#dca3a3
palette = 2=#5f7f5f
palette = 3=#e0cf9f
palette = 4=#7cb8bb
palette = 5=#dc8cc3
palette = 6=#93e0e3
palette = 7=#dcdccc
palette = 8=#6f6f6f
palette = 9=#dca3a3
palette = 10=#5f7f5f
palette = 11=#e0cf9f
palette = 12=#7cb8bb
palette = 13=#dc8cc3
palette = 14=#93e0e3
palette = 15=#ffffff
palette = 16=#dfaf8f
palette = 17=#000000
palette = 18=#404040
palette = 19=#606060
palette = 20=#808080
palette = 21=#c0c0c0

# Foreground & background colors
background = #383838
foreground = #dcdccc
cursor-color = #dcdccc
selection-background = #dcdccc
selection-foreground = #606060
search-background = #e0cf9f
search-foreground = #404040
search-selected-background = #dfaf8f
search-selected-foreground = #404040

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7cb8bb
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
