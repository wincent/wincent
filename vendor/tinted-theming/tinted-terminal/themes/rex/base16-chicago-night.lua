-- vim: ft=lua
-- Chicago Night theme for Rex
-- Scheme Author: Wendell, Ryan &lt;ryanjwendell@gmail.com&gt;
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

local name = "base16-chicago-night"
local variant = "dark"

-- This must match themes/ghostty/base16-chicago-night exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Chicago Night theme for Ghostty
# Scheme Author: Wendell, Ryan &lt;ryanjwendell@gmail.com&gt;
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1e2a24
palette = 1=#c60c30
palette = 2=#009b3a
palette = 3=#f9e300
palette = 4=#522398
palette = 5=#e27ea6
palette = 6=#00a1de
palette = 7=#a7b8af
palette = 8=#5f7368
palette = 9=#c60c30
palette = 10=#009b3a
palette = 11=#f9e300
palette = 12=#522398
palette = 13=#e27ea6
palette = 14=#00a1de
palette = 15=#dbe3de
palette = 16=#f9461c
palette = 17=#62361b
palette = 18=#2a3b32
palette = 19=#364c40
palette = 20=#8a9a91
palette = 21=#c1cdc7

# Foreground & background colors
background = #1e2a24
foreground = #a7b8af
cursor-color = #a7b8af
selection-background = #a7b8af
selection-foreground = #364c40
search-background = #f9e300
search-foreground = #2a3b32
search-selected-background = #f9461c
search-selected-foreground = #2a3b32

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #dbe3de
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #522398
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
