-- vim: ft=lua
-- Atelier Estuary Light theme for Rex
-- Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
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

local name = "base16-atelier-estuary-light"
local variant = "light"

-- This must match themes/ghostty/base16-atelier-estuary-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Atelier Estuary Light theme for Ghostty
# Scheme Author: Bram de Haan (http://atelierbramdehaan.nl)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f4f3ec
palette = 1=#ba6236
palette = 2=#7d9726
palette = 3=#a5980d
palette = 4=#36a166
palette = 5=#5f9182
palette = 6=#5b9d48
palette = 7=#5f5e4e
palette = 8=#878573
palette = 9=#ba6236
palette = 10=#7d9726
palette = 11=#a5980d
palette = 12=#36a166
palette = 13=#5f9182
palette = 14=#5b9d48
palette = 15=#22221b
palette = 16=#ae7313
palette = 17=#9d6c7c
palette = 18=#e7e6df
palette = 19=#929181
palette = 20=#6c6b5a
palette = 21=#302f27

# Foreground & background colors
background = #f4f3ec
foreground = #5f5e4e
cursor-color = #5f5e4e
selection-background = #5f5e4e
selection-foreground = #929181
search-background = #a5980d
search-foreground = #22221b
search-selected-background = #ae7313
search-selected-foreground = #22221b

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #22221b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #36a166
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
