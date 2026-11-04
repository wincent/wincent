-- vim: ft=lua
-- Ocean theme for Rex
-- Scheme Author: Chris Kempson (http://chriskempson.com)
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

local name = "base16-ocean"
local variant = "dark"

-- This must match themes/ghostty/base16-ocean exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Ocean theme for Ghostty
# Scheme Author: Chris Kempson (http://chriskempson.com)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#2b303b
palette = 1=#bf616a
palette = 2=#a3be8c
palette = 3=#ebcb8b
palette = 4=#8fa1b3
palette = 5=#b48ead
palette = 6=#96b5b4
palette = 7=#c0c5ce
palette = 8=#65737e
palette = 9=#bf616a
palette = 10=#a3be8c
palette = 11=#ebcb8b
palette = 12=#8fa1b3
palette = 13=#b48ead
palette = 14=#96b5b4
palette = 15=#eff1f5
palette = 16=#d08770
palette = 17=#ab7967
palette = 18=#343d46
palette = 19=#4f5b66
palette = 20=#a7adba
palette = 21=#dfe1e8

# Foreground & background colors
background = #2b303b
foreground = #c0c5ce
cursor-color = #c0c5ce
selection-background = #c0c5ce
selection-foreground = #4f5b66
search-background = #ebcb8b
search-foreground = #343d46
search-selected-background = #d08770
search-selected-foreground = #343d46

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #eff1f5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8fa1b3
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
