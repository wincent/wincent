-- vim: ft=lua
-- Bespin theme for Rex
-- Scheme Author: Jan T. Sott
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

local name = "base16-bespin"
local variant = "dark"

-- This must match themes/ghostty/base16-bespin exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Bespin theme for Ghostty
# Scheme Author: Jan T. Sott
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#28211c
palette = 1=#cf6a4c
palette = 2=#54be0d
palette = 3=#f9ee98
palette = 4=#5ea6ea
palette = 5=#9b859d
palette = 6=#afc4db
palette = 7=#8a8986
palette = 8=#666666
palette = 9=#cf6a4c
palette = 10=#54be0d
palette = 11=#f9ee98
palette = 12=#5ea6ea
palette = 13=#9b859d
palette = 14=#afc4db
palette = 15=#baae9e
palette = 16=#cf7d34
palette = 17=#937121
palette = 18=#36312e
palette = 19=#5e5d5c
palette = 20=#797977
palette = 21=#9d9b97

# Foreground & background colors
background = #28211c
foreground = #8a8986
cursor-color = #8a8986
selection-background = #8a8986
selection-foreground = #5e5d5c
search-background = #f9ee98
search-foreground = #36312e
search-selected-background = #cf7d34
search-selected-foreground = #36312e

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #baae9e
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5ea6ea
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
