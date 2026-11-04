-- vim: ft=lua
-- Sleepy Hollow theme for Rex
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

local name = "base24-sleepy-hollow"
local variant = "dark"

-- This must match themes/ghostty/base24-sleepy-hollow exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Sleepy Hollow theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#121213
palette = 1=#b93934
palette = 2=#90773e
palette = 3=#8085ef
palette = 4=#5e62b4
palette = 5=#a07c7b
palette = 6=#8eaea9
palette = 7=#968684
palette = 8=#665e6c
palette = 9=#d9443e
palette = 10=#d6b04e
palette = 11=#f66713
palette = 12=#8085ef
palette = 13=#e1c2ba
palette = 14=#a4dbe7
palette = 15=#d1c7a9
palette = 16=#b45600
palette = 17=#5c1c1a
palette = 18=#572000
palette = 19=#4e4b60
palette = 20=#7e7278
palette = 21=#af9a91

# Foreground & background colors
background = #121213
foreground = #968684
cursor-color = #968684
selection-background = #968684
selection-foreground = #4e4b60
search-background = #8085ef
search-foreground = #572000
search-selected-background = #b45600
search-selected-foreground = #572000

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d1c7a9
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8085ef
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
