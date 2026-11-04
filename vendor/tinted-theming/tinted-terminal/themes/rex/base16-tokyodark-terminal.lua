-- vim: ft=lua
-- Tokyodark Terminal theme for Rex
-- Scheme Author: Tiagovla (https://github.com/tiagovla/)
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

local name = "base16-tokyodark-terminal"
local variant = "dark"

-- This must match themes/ghostty/base16-tokyodark-terminal exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Tokyodark Terminal theme for Ghostty
# Scheme Author: Tiagovla (https://github.com/tiagovla/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#11121d
palette = 1=#ee6d85
palette = 2=#95c561
palette = 3=#d7a65f
palette = 4=#7199ee
palette = 5=#a485dd
palette = 6=#38a89d
palette = 7=#a0a8cd
palette = 8=#282c34
palette = 9=#ee6d85
palette = 10=#95c561
palette = 11=#d7a65f
palette = 12=#7199ee
palette = 13=#a485dd
palette = 14=#38a89d
palette = 15=#a0a8cd
palette = 16=#f6955b
palette = 17=#773440
palette = 18=#1a1b2a
palette = 19=#212234
palette = 20=#4a5057
palette = 21=#a0a8cd

# Foreground & background colors
background = #11121d
foreground = #a0a8cd
cursor-color = #a0a8cd
selection-background = #a0a8cd
selection-foreground = #212234
search-background = #d7a65f
search-foreground = #1a1b2a
search-selected-background = #f6955b
search-selected-foreground = #1a1b2a

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #a0a8cd
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #7199ee
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
