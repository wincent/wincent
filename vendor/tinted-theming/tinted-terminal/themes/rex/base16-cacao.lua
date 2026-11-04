-- vim: ft=lua
-- Cacao theme for Rex
-- Scheme Author: Teshre
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

local name = "base16-cacao"
local variant = "dark"

-- This must match themes/ghostty/base16-cacao exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Cacao theme for Ghostty
# Scheme Author: Teshre
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#160f0c
palette = 1=#e0705c
palette = 2=#9ac97a
palette = 3=#e8a84a
palette = 4=#a89ad0
palette = 5=#ce8ab0
palette = 6=#74c8b0
palette = 7=#e8d6c4
palette = 8=#766052
palette = 9=#e0705c
palette = 10=#9ac97a
palette = 11=#e8a84a
palette = 12=#a89ad0
palette = 13=#ce8ab0
palette = 14=#74c8b0
palette = 15=#f4e6d6
palette = 16=#c77b4a
palette = 17=#4e382a
palette = 18=#241913
palette = 19=#3a281e
palette = 20=#af9b8b
palette = 21=#eedecd

# Foreground & background colors
background = #160f0c
foreground = #e8d6c4
cursor-color = #e8d6c4
selection-background = #e8d6c4
selection-foreground = #3a281e
search-background = #e8a84a
search-foreground = #241913
search-selected-background = #c77b4a
search-selected-foreground = #241913

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f4e6d6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a89ad0
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
