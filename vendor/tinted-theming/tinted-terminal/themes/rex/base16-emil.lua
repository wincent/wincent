-- vim: ft=lua
-- emil theme for Rex
-- Scheme Author: limelier
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

local name = "base16-emil"
local variant = "light"

-- This must match themes/ghostty/base16-emil exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# emil theme for Ghostty
# Scheme Author: limelier
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#efefef
palette = 1=#f43979
palette = 2=#0073a8
palette = 3=#ff669b
palette = 4=#471397
palette = 5=#6916b6
palette = 6=#2155d6
palette = 7=#313145
palette = 8=#7c7c98
palette = 9=#f43979
palette = 10=#0073a8
palette = 11=#ff669b
palette = 12=#471397
palette = 13=#6916b6
palette = 14=#2155d6
palette = 15=#1a1a2f
palette = 16=#d22a8b
palette = 17=#8d17a5
palette = 18=#bebed2
palette = 19=#9e9eaf
palette = 20=#505063
palette = 21=#22223a

# Foreground & background colors
background = #efefef
foreground = #313145
cursor-color = #313145
selection-background = #313145
selection-foreground = #9e9eaf
search-background = #ff669b
search-foreground = #1a1a2f
search-selected-background = #d22a8b
search-selected-foreground = #1a1a2f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #1a1a2f
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #471397
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
