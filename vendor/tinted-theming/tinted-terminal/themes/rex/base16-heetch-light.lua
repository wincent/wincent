-- vim: ft=lua
-- Heetch Light theme for Rex
-- Scheme Author: Geoffrey Teale (tealeg@gmail.com), Tinted Theming (https://github.com/tinted-theming)
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

local name = "base16-heetch-light"
local variant = "light"

-- This must match themes/ghostty/base16-heetch-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Heetch Light theme for Ghostty
# Scheme Author: Geoffrey Teale (tealeg@gmail.com), Tinted Theming (https://github.com/tinted-theming)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#feffff
palette = 1=#f80059
palette = 2=#5bb66a
palette = 3=#bd9701
palette = 4=#5ba2b6
palette = 5=#8f6c97
palette = 6=#47f9f5
palette = 7=#5a496e
palette = 8=#9c92a8
palette = 9=#f80059
palette = 10=#5bb66a
palette = 11=#bd9701
palette = 12=#5ba2b6
palette = 13=#8f6c97
palette = 14=#47f9f5
palette = 15=#190134
palette = 16=#bd0152
palette = 17=#58425d
palette = 18=#dedae2
palette = 19=#bdb6c5
palette = 20=#7b6d8b
palette = 21=#392551

# Foreground & background colors
background = #feffff
foreground = #5a496e
cursor-color = #5a496e
selection-background = #5a496e
selection-foreground = #bdb6c5
search-background = #bd9701
search-foreground = #190134
search-selected-background = #bd0152
search-selected-foreground = #190134

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #190134
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5ba2b6
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
