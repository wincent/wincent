-- vim: ft=lua
-- Pasque theme for Rex
-- Scheme Author: Gabriel Fontes (https://github.com/Misterio77)
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

local name = "base16-pasque"
local variant = "dark"

-- This must match themes/ghostty/base16-pasque exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Pasque theme for Ghostty
# Scheme Author: Gabriel Fontes (https://github.com/Misterio77)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#271c3a
palette = 1=#a92258
palette = 2=#c6914b
palette = 3=#804ead
palette = 4=#8e7dc6
palette = 5=#953b9d
palette = 6=#7263aa
palette = 7=#dedcdf
palette = 8=#5d5766
palette = 9=#a92258
palette = 10=#c6914b
palette = 11=#804ead
palette = 12=#8e7dc6
palette = 13=#953b9d
palette = 14=#7263aa
palette = 15=#bbaadd
palette = 16=#918889
palette = 17=#59325c
palette = 18=#100323
palette = 19=#3e2d5c
palette = 20=#bebcbf
palette = 21=#edeaef

# Foreground & background colors
background = #271c3a
foreground = #dedcdf
cursor-color = #dedcdf
selection-background = #dedcdf
selection-foreground = #3e2d5c
search-background = #804ead
search-foreground = #100323
search-selected-background = #918889
search-selected-foreground = #100323

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #bbaadd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8e7dc6
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
