-- vim: ft=lua
-- Alucard theme for Rex
-- Scheme Author: clach04 (https://github.com/clach04)
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

local name = "base24-alucard"
local variant = "light"

-- This must match themes/ghostty/base24-alucard exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Alucard theme for Ghostty
# Scheme Author: clach04 (https://github.com/clach04)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#fffbeb
palette = 1=#cb3a2a
palette = 2=#14710a
palette = 3=#846e15
palette = 4=#644ac9
palette = 5=#a3144d
palette = 6=#036a96
palette = 7=#1f1f1f
palette = 8=#6c664b
palette = 9=#d74c3d
palette = 10=#198d0c
palette = 11=#9e841a
palette = 12=#7862d0
palette = 13=#bf185a
palette = 14=#047fb4
palette = 15=#2c2b31
palette = 16=#a34d14
palette = 17=#792219
palette = 18=#ceccc0
palette = 19=#cfcfde
palette = 20=#4c4a3d
palette = 21=#1f1f1f

# Foreground & background colors
background = #fffbeb
foreground = #1f1f1f
cursor-color = #1f1f1f
selection-background = #1f1f1f
selection-foreground = #cfcfde
search-background = #846e15
search-foreground = #ceccc0
search-selected-background = #a34d14
search-selected-foreground = #ceccc0

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #2c2b31
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7862d0
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
