-- vim: ft=lua
-- Marrakesh theme for Rex
-- Scheme Author: Alexandre Gavioli (http://github.com/Alexx2/)
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

local name = "base16-marrakesh"
local variant = "dark"

-- This must match themes/ghostty/base16-marrakesh exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Marrakesh theme for Ghostty
# Scheme Author: Alexandre Gavioli (http://github.com/Alexx2/)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#201602
palette = 1=#c35359
palette = 2=#18974e
palette = 3=#a88339
palette = 4=#477ca1
palette = 5=#8868b3
palette = 6=#75a738
palette = 7=#948e48
palette = 8=#6c6823
palette = 9=#c35359
palette = 10=#18974e
palette = 11=#a88339
palette = 12=#477ca1
palette = 13=#8868b3
palette = 14=#75a738
palette = 15=#faf0a5
palette = 16=#b36144
palette = 17=#b3588e
palette = 18=#302e00
palette = 19=#5f5b17
palette = 20=#86813b
palette = 21=#ccc37a

# Foreground & background colors
background = #201602
foreground = #948e48
cursor-color = #948e48
selection-background = #948e48
selection-foreground = #5f5b17
search-background = #a88339
search-foreground = #302e00
search-selected-background = #b36144
search-selected-foreground = #302e00

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #faf0a5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #477ca1
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
