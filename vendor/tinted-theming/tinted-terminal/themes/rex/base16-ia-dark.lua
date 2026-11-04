-- vim: ft=lua
-- iA Dark theme for Rex
-- Scheme Author: iA Inc. (modified by aramisgithub)
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

local name = "base16-ia-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-ia-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# iA Dark theme for Ghostty
# Scheme Author: iA Inc. (modified by aramisgithub)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a1a1a
palette = 1=#d88568
palette = 2=#83a471
palette = 3=#b99353
palette = 4=#8eccdd
palette = 5=#b98eb2
palette = 6=#7c9cae
palette = 7=#cccccc
palette = 8=#767676
palette = 9=#d88568
palette = 10=#83a471
palette = 11=#b99353
palette = 12=#8eccdd
palette = 13=#b98eb2
palette = 14=#7c9cae
palette = 15=#f8f8f8
palette = 16=#d86868
palette = 17=#8b6c37
palette = 18=#222222
palette = 19=#1d414d
palette = 20=#b8b8b8
palette = 21=#e8e8e8

# Foreground & background colors
background = #1a1a1a
foreground = #cccccc
cursor-color = #cccccc
selection-background = #cccccc
selection-foreground = #1d414d
search-background = #b99353
search-foreground = #222222
search-selected-background = #d86868
search-selected-foreground = #222222

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8f8f8
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8eccdd
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
