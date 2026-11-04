-- vim: ft=lua
-- Gruvbox dark, pale theme for Rex
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

local name = "base16-gruvbox-dark-pale"
local variant = "dark"

-- This must match themes/ghostty/base16-gruvbox-dark-pale exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Gruvbox dark, pale theme for Ghostty
# Scheme Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#262626
palette = 1=#d75f5f
palette = 2=#afaf00
palette = 3=#ffaf00
palette = 4=#83adad
palette = 5=#d485ad
palette = 6=#85ad85
palette = 7=#dab997
palette = 8=#8a8a8a
palette = 9=#d75f5f
palette = 10=#afaf00
palette = 11=#ffaf00
palette = 12=#83adad
palette = 13=#d485ad
palette = 14=#85ad85
palette = 15=#ebdbb2
palette = 16=#ff8700
palette = 17=#d65d0e
palette = 18=#3a3a3a
palette = 19=#4e4e4e
palette = 20=#949494
palette = 21=#d5c4a1

# Foreground & background colors
background = #262626
foreground = #dab997
cursor-color = #dab997
selection-background = #dab997
selection-foreground = #4e4e4e
search-background = #ffaf00
search-foreground = #3a3a3a
search-selected-background = #ff8700
search-selected-foreground = #3a3a3a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ebdbb2
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #83adad
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
