-- vim: ft=lua
-- Stella theme for Rex
-- Scheme Author: Shrimpram
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

local name = "base16-stella"
local variant = "dark"

-- This must match themes/ghostty/base16-stella exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Stella theme for Ghostty
# Scheme Author: Shrimpram
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2b213c
palette = 1=#c79987
palette = 2=#acc79b
palette = 3=#c7c691
palette = 4=#a5aad4
palette = 5=#c594ff
palette = 6=#9bc7bf
palette = 7=#998bad
palette = 8=#655978
palette = 9=#c79987
palette = 10=#acc79b
palette = 11=#c7c691
palette = 12=#a5aad4
palette = 13=#c594ff
palette = 14=#9bc7bf
palette = 15=#ebdcff
palette = 16=#8865c6
palette = 17=#c7ab87
palette = 18=#362b48
palette = 19=#4d4160
palette = 20=#7f7192
palette = 21=#b4a5c8

# Foreground & background colors
background = #2b213c
foreground = #998bad
cursor-color = #998bad
selection-background = #998bad
selection-foreground = #4d4160
search-background = #c7c691
search-foreground = #362b48
search-selected-background = #8865c6
search-selected-foreground = #362b48

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ebdcff
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #a5aad4
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
