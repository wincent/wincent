-- vim: ft=lua
-- Codeschool theme for Rex
-- Scheme Author: blockloop
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

local name = "base16-codeschool"
local variant = "dark"

-- This must match themes/ghostty/base16-codeschool exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Codeschool theme for Ghostty
# Scheme Author: blockloop
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#232c31
palette = 1=#2a5491
palette = 2=#237986
palette = 3=#a03b1e
palette = 4=#484d79
palette = 5=#c59820
palette = 6=#b02f30
palette = 7=#9ea7a6
palette = 8=#3f4944
palette = 9=#2a5491
palette = 10=#237986
palette = 11=#a03b1e
palette = 12=#484d79
palette = 13=#c59820
palette = 14=#b02f30
palette = 15=#b5d8f6
palette = 16=#43820d
palette = 17=#c98344
palette = 18=#1c3657
palette = 19=#2a343a
palette = 20=#84898c
palette = 21=#a7cfa3

# Foreground & background colors
background = #232c31
foreground = #9ea7a6
cursor-color = #9ea7a6
selection-background = #9ea7a6
selection-foreground = #2a343a
search-background = #a03b1e
search-foreground = #1c3657
search-selected-background = #43820d
search-selected-foreground = #1c3657

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #b5d8f6
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #484d79
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
