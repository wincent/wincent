-- vim: ft=lua
-- Brush Trees theme for Rex
-- Scheme Author: Abraham White &lt;abelincoln.white@gmail.com&gt;
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

local name = "base16-brushtrees"
local variant = "light"

-- This must match themes/ghostty/base16-brushtrees exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Brush Trees theme for Ghostty
# Scheme Author: Abraham White &lt;abelincoln.white@gmail.com&gt;
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#e3efef
palette = 1=#b38686
palette = 2=#87b386
palette = 3=#aab386
palette = 4=#868cb3
palette = 5=#b386b2
palette = 6=#86b3b3
palette = 7=#6d828e
palette = 8=#98afb5
palette = 9=#b38686
palette = 10=#87b386
palette = 11=#aab386
palette = 12=#868cb3
palette = 13=#b386b2
palette = 14=#86b3b3
palette = 15=#485867
palette = 16=#d8bba2
palette = 17=#b39f9f
palette = 18=#c9dbdc
palette = 19=#b0c5c8
palette = 20=#8299a1
palette = 21=#5a6d7a

# Foreground & background colors
background = #e3efef
foreground = #6d828e
cursor-color = #6d828e
selection-background = #6d828e
selection-foreground = #b0c5c8
search-background = #aab386
search-foreground = #485867
search-selected-background = #d8bba2
search-selected-foreground = #485867

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #485867
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #868cb3
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
