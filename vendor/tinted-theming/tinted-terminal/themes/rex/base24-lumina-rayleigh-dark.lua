-- vim: ft=lua
-- Lumina Rayleigh Dark theme for Rex
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

local name = "base24-lumina-rayleigh-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-rayleigh-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Rayleigh Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#091d30
palette = 1=#d96d65
palette = 2=#96d2a2
palette = 3=#f1cc79
palette = 4=#6fc3ff
palette = 5=#bf9ef1
palette = 6=#afdee6
palette = 7=#d4dfeb
palette = 8=#1f364d
palette = 9=#e59088
palette = 10=#aeedbb
palette = 11=#ffe5ad
palette = 12=#aadaff
palette = 13=#ffc3e0
palette = 14=#b6f4ff
palette = 15=#d4dfeb
palette = 16=#faac77
palette = 17=#eea3c9
palette = 18=#0b2237
palette = 19=#152c42
palette = 20=#567089
palette = 21=#a2b3c5

# Foreground & background colors
background = #091d30
foreground = #d4dfeb
cursor-color = #d4dfeb
selection-background = #d4dfeb
selection-foreground = #152c42
search-background = #f1cc79
search-foreground = #0b2237
search-selected-background = #faac77
search-selected-foreground = #0b2237

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d4dfeb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #aadaff
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
