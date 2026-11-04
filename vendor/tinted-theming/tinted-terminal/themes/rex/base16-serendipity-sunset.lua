-- vim: ft=lua
-- Serendipity Sunset theme for Rex
-- Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
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

local name = "base16-serendipity-sunset"
local variant = "dark"

-- This must match themes/ghostty/base16-serendipity-sunset exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Serendipity Sunset theme for Ghostty
# Scheme Author: Micheal Andreuzza (https://michaelandreuzza.com/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#202231
palette = 1=#d1918f
palette = 2=#709bbd
palette = 3=#a392dc
palette = 4=#a0b6e8
palette = 5=#a392dc
palette = 6=#d6b4b4
palette = 7=#dee0ef
palette = 8=#8d8f9e
palette = 9=#d1918f
palette = 10=#709bbd
palette = 11=#a392dc
palette = 12=#a0b6e8
palette = 13=#a392dc
palette = 14=#d6b4b4
palette = 15=#202231
palette = 16=#d1918f
palette = 17=#709bbd
palette = 18=#272938
palette = 19=#272938
palette = 20=#6b6d7c
palette = 21=#dee0ef

# Foreground & background colors
background = #202231
foreground = #dee0ef
cursor-color = #dee0ef
selection-background = #dee0ef
selection-foreground = #272938
search-background = #a392dc
search-foreground = #272938
search-selected-background = #d1918f
search-selected-foreground = #272938

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #202231
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a0b6e8
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
