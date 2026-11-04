-- vim: ft=lua
-- Lumina Olive Dark theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-olive-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-olive-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Olive Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1a1b0c
palette = 1=#d3726a
palette = 2=#b5d5c6
palette = 3=#ebc27c
palette = 4=#a2c4f0
palette = 5=#c0baf2
palette = 6=#8bcfd7
palette = 7=#e1dfce
palette = 8=#323422
palette = 9=#e0938c
palette = 10=#b5f7da
palette = 11=#ffdea7
palette = 12=#c4ddff
palette = 13=#f0bbeb
palette = 14=#a3e9f2
palette = 15=#e1dfce
palette = 16=#ffc39b
palette = 17=#d5a2d0
palette = 18=#1f200f
palette = 19=#282918
palette = 20=#6a6e58
palette = 21=#b1b2a5

# Foreground & background colors
background = #1a1b0c
foreground = #e1dfce
cursor-color = #e1dfce
selection-background = #e1dfce
selection-foreground = #282918
search-background = #ebc27c
search-foreground = #1f200f
search-selected-background = #ffc39b
search-selected-foreground = #1f200f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #e1dfce
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #c4ddff
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
