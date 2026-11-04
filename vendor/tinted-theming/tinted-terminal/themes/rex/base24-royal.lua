-- vim: ft=lua
-- Royal theme for Rex
-- Scheme Author: FredHappyface (https://github.com/fredHappyface)
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

local name = "base24-royal"
local variant = "dark"

-- This must match themes/ghostty/base24-royal exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Royal theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#100814
palette = 1=#90274b
palette = 2=#23801c
palette = 3=#8fb9f9
palette = 4=#6480af
palette = 5=#664d96
palette = 6=#8aaabd
palette = 7=#49425a
palette = 8=#393446
palette = 9=#d4346c
palette = 10=#2cd845
palette = 11=#fde83a
palette = 12=#8fb9f9
palette = 13=#a479e2
palette = 14=#abd3eb
palette = 15=#9d8bbd
palette = 16=#b49d27
palette = 17=#481325
palette = 18=#241f2a
palette = 19=#312d3c
palette = 20=#413b50
palette = 21=#514965

# Foreground & background colors
background = #100814
foreground = #49425a
cursor-color = #49425a
selection-background = #49425a
selection-foreground = #312d3c
search-background = #8fb9f9
search-foreground = #241f2a
search-selected-background = #b49d27
search-selected-foreground = #241f2a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #9d8bbd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8fb9f9
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
