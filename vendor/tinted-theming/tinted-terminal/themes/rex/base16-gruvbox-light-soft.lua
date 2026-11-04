-- vim: ft=lua
-- Gruvbox light, soft theme for Rex
-- Scheme Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
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

local name = "base16-gruvbox-light-soft"
local variant = "light"

-- This must match themes/ghostty/base16-gruvbox-light-soft exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gruvbox light, soft theme for Ghostty
# Scheme Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f2e5bc
palette = 1=#9d0006
palette = 2=#79740e
palette = 3=#b57614
palette = 4=#076678
palette = 5=#8f3f71
palette = 6=#427b58
palette = 7=#504945
palette = 8=#bdae93
palette = 9=#9d0006
palette = 10=#79740e
palette = 11=#b57614
palette = 12=#076678
palette = 13=#8f3f71
palette = 14=#427b58
palette = 15=#282828
palette = 16=#af3a03
palette = 17=#d65d0e
palette = 18=#ebdbb2
palette = 19=#d5c4a1
palette = 20=#665c54
palette = 21=#3c3836

# Foreground & background colors
background = #f2e5bc
foreground = #504945
cursor-color = #504945
selection-background = #504945
selection-foreground = #d5c4a1
search-background = #b57614
search-foreground = #282828
search-selected-background = #af3a03
search-selected-foreground = #282828

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #282828
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #076678
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
