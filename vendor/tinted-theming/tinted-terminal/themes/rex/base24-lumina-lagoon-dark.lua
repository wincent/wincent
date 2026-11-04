-- vim: ft=lua
-- Lumina Lagoon Dark theme for Rex
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

local name = "base24-lumina-lagoon-dark"
local variant = "dark"

-- This must match themes/ghostty/base24-lumina-lagoon-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Lagoon Dark theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#042930
palette = 1=#d3726a
palette = 2=#9fd4a9
palette = 3=#e7cf94
palette = 4=#8ec3f9
palette = 5=#c8baf6
palette = 6=#5ad3d6
palette = 7=#d7e6e7
palette = 8=#1c434b
palette = 9=#e0938c
palette = 10=#b8efc2
palette = 11=#ffe6a7
palette = 12=#badcff
palette = 13=#ffcaf9
palette = 14=#9fe6e8
palette = 15=#d7e6e7
palette = 16=#f9b283
palette = 17=#e5b0df
palette = 18=#042e36
palette = 19=#103941
palette = 20=#547c86
palette = 21=#9db6bc

# Foreground & background colors
background = #042930
foreground = #d7e6e7
cursor-color = #d7e6e7
selection-background = #d7e6e7
selection-foreground = #103941
search-background = #e7cf94
search-foreground = #042e36
search-selected-background = #f9b283
search-selected-foreground = #042e36

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d7e6e7
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #badcff
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
