-- vim: ft=lua
-- Brewer theme for Rex
-- Scheme Author: Timothée Poisot (http://github.com/tpoisot)
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

local name = "base16-brewer"
local variant = "dark"

-- This must match themes/ghostty/base16-brewer exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Brewer theme for Ghostty
# Scheme Author: Timothée Poisot (http://github.com/tpoisot)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#0c0d0e
palette = 1=#e31a1c
palette = 2=#31a354
palette = 3=#dca060
palette = 4=#3182bd
palette = 5=#756bb1
palette = 6=#80b1d3
palette = 7=#b7b8b9
palette = 8=#737475
palette = 9=#e31a1c
palette = 10=#31a354
palette = 11=#dca060
palette = 12=#3182bd
palette = 13=#756bb1
palette = 14=#80b1d3
palette = 15=#fcfdfe
palette = 16=#e6550d
palette = 17=#b15928
palette = 18=#2e2f30
palette = 19=#515253
palette = 20=#959697
palette = 21=#dadbdc

# Foreground & background colors
background = #0c0d0e
foreground = #b7b8b9
cursor-color = #b7b8b9
selection-background = #b7b8b9
selection-foreground = #515253
search-background = #dca060
search-foreground = #2e2f30
search-selected-background = #e6550d
search-selected-foreground = #2e2f30

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fcfdfe
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #3182bd
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
