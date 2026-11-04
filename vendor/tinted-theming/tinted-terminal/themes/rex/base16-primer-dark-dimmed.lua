-- vim: ft=lua
-- Primer Dark Dimmed theme for Rex
-- Scheme Author: Jimmy Lin
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

local name = "base16-primer-dark-dimmed"
local variant = "dark"

-- This must match themes/ghostty/base16-primer-dark-dimmed exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Primer Dark Dimmed theme for Ghostty
# Scheme Author: Jimmy Lin
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1c2128
palette = 1=#f47067
palette = 2=#57ab5a
palette = 3=#c69026
palette = 4=#539bf5
palette = 5=#e275ad
palette = 6=#96d0ff
palette = 7=#909dab
palette = 8=#545d68
palette = 9=#f47067
palette = 10=#57ab5a
palette = 11=#c69026
palette = 12=#539bf5
palette = 13=#e275ad
palette = 14=#96d0ff
palette = 15=#cdd9e5
palette = 16=#e0823d
palette = 17=#ae5622
palette = 18=#373e47
palette = 19=#444c56
palette = 20=#768390
palette = 21=#adbac7

# Foreground & background colors
background = #1c2128
foreground = #909dab
cursor-color = #909dab
selection-background = #909dab
selection-foreground = #444c56
search-background = #c69026
search-foreground = #373e47
search-selected-background = #e0823d
search-selected-foreground = #373e47

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #cdd9e5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #539bf5
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
