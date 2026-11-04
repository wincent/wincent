-- vim: ft=lua
-- Vesper theme for Rex
-- Scheme Author: FormalSnake (https://github.com/formalsnake)
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

local name = "base16-vesper"
local variant = "dark"

-- This must match themes/ghostty/base16-vesper exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Vesper theme for Ghostty
# Scheme Author: FormalSnake (https://github.com/formalsnake)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#101010
palette = 1=#de6e6e
palette = 2=#5f8787
palette = 3=#ffc799
palette = 4=#8eaaaa
palette = 5=#d69094
palette = 6=#60a592
palette = 7=#b7b7b7
palette = 8=#333333
palette = 9=#de6e6e
palette = 10=#5f8787
palette = 11=#ffc799
palette = 12=#8eaaaa
palette = 13=#d69094
palette = 14=#60a592
palette = 15=#d5d5d5
palette = 16=#dab083
palette = 17=#876c4f
palette = 18=#232323
palette = 19=#222222
palette = 20=#999999
palette = 21=#c1c1c1

# Foreground & background colors
background = #101010
foreground = #b7b7b7
cursor-color = #b7b7b7
selection-background = #b7b7b7
selection-foreground = #222222
search-background = #ffc799
search-foreground = #232323
search-selected-background = #dab083
search-selected-foreground = #232323

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #d5d5d5
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #8eaaaa
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
