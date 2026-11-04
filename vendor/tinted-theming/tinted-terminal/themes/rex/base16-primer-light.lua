-- vim: ft=lua
-- Primer Light theme for Rex
-- Scheme Author: Jimmy Lin
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

local name = "base16-primer-light"
local variant = "light"

-- This must match themes/ghostty/base16-primer-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Primer Light theme for Ghostty
# Scheme Author: Jimmy Lin
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fafbfc
palette = 1=#d73a49
palette = 2=#28a745
palette = 3=#ffd33d
palette = 4=#0366d6
palette = 5=#ea4aaa
palette = 6=#79b8ff
palette = 7=#2f363d
palette = 8=#959da5
palette = 9=#d73a49
palette = 10=#28a745
palette = 11=#ffd33d
palette = 12=#0366d6
palette = 13=#ea4aaa
palette = 14=#79b8ff
palette = 15=#1b1f23
palette = 16=#f66a0a
palette = 17=#a04100
palette = 18=#e1e4e8
palette = 19=#d1d5da
palette = 20=#444d56
palette = 21=#24292e

# Foreground & background colors
background = #fafbfc
foreground = #2f363d
cursor-color = #2f363d
selection-background = #2f363d
selection-foreground = #d1d5da
search-background = #ffd33d
search-foreground = #1b1f23
search-selected-background = #f66a0a
search-selected-foreground = #1b1f23

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1b1f23
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0366d6
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
