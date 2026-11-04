-- vim: ft=lua
-- summercamp theme for Rex
-- Scheme Author: zoe firi (zoefiri.github.io)
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

local name = "base16-summercamp"
local variant = "dark"

-- This must match themes/ghostty/base16-summercamp exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# summercamp theme for Ghostty
# Scheme Author: zoe firi (zoefiri.github.io)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c1810
palette = 1=#e35142
palette = 2=#5ceb5a
palette = 3=#f2ff27
palette = 4=#489bf0
palette = 5=#ff8080
palette = 6=#5aebbc
palette = 7=#736e55
palette = 8=#504b38
palette = 9=#e35142
palette = 10=#5ceb5a
palette = 11=#f2ff27
palette = 12=#489bf0
palette = 13=#ff8080
palette = 14=#5aebbc
palette = 15=#f8f5de
palette = 16=#fba11b
palette = 17=#f69be7
palette = 18=#2a261c
palette = 19=#3a3527
palette = 20=#5f5b45
palette = 21=#bab696

# Foreground & background colors
background = #1c1810
foreground = #736e55
cursor-color = #736e55
selection-background = #736e55
selection-foreground = #3a3527
search-background = #f2ff27
search-foreground = #2a261c
search-selected-background = #fba11b
search-selected-foreground = #2a261c

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f8f5de
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #489bf0
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
