-- vim: ft=lua
-- Lumina Aurora Dark theme for Rex
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

local name = "base24-lumina-aurora-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-aurora-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Aurora Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#041212
palette = 1=#d86f66
palette = 2=#6cd79d
palette = 3=#e9d487
palette = 4=#c5d8ed
palette = 5=#bf9ef1
palette = 6=#84d2db
palette = 7=#d6e3e2
palette = 8=#182a2a
palette = 9=#e59289
palette = 10=#a7eac2
palette = 11=#ffe791
palette = 12=#d7eaff
palette = 13=#ffc9f9
palette = 14=#9decf6
palette = 15=#d6e3e2
palette = 16=#fcb07c
palette = 17=#e7ade1
palette = 18=#061717
palette = 19=#0f2020
palette = 20=#5a6d6d
palette = 21=#a7b4b4

# Foreground & background colors
background = #041212
foreground = #d6e3e2
cursor-color = #d6e3e2
selection-background = #d6e3e2
selection-foreground = #0f2020
search-background = #e9d487
search-foreground = #061717
search-selected-background = #fcb07c
search-selected-foreground = #061717

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d6e3e2
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #d7eaff
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
