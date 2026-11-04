-- vim: ft=lua
-- Twilight theme for Rex
-- Scheme Author: David Hart (https://github.com/hartbit)
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

local name = "base16-twilight"
local variant = "dark"

-- This must match themes/ghostty/base16-twilight exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Twilight theme for Ghostty
# Scheme Author: David Hart (https://github.com/hartbit)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e1e1e
palette = 1=#cf6a4c
palette = 2=#8f9d6a
palette = 3=#f9ee98
palette = 4=#7587a6
palette = 5=#9b859d
palette = 6=#afc4db
palette = 7=#a7a7a7
palette = 8=#5f5a60
palette = 9=#cf6a4c
palette = 10=#8f9d6a
palette = 11=#f9ee98
palette = 12=#7587a6
palette = 13=#9b859d
palette = 14=#afc4db
palette = 15=#ffffff
palette = 16=#cda869
palette = 17=#9b703f
palette = 18=#323537
palette = 19=#464b50
palette = 20=#838184
palette = 21=#c3c3c3

# Foreground & background colors
background = #1e1e1e
foreground = #a7a7a7
cursor-color = #a7a7a7
selection-background = #a7a7a7
selection-foreground = #464b50
search-background = #f9ee98
search-foreground = #323537
search-selected-background = #cda869
search-selected-foreground = #323537

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffffff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7587a6
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
