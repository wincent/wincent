-- vim: ft=lua
-- Humanoid light theme for Rex
-- Scheme Author: Thomas (tasmo) Friese
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

local name = "base16-humanoid-light"
local variant = "light"

-- This must match themes/ghostty/base16-humanoid-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Humanoid light theme for Ghostty
# Scheme Author: Thomas (tasmo) Friese
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f8f8f2
palette = 1=#b0151a
palette = 2=#388e3c
palette = 3=#ffb627
palette = 4=#0082c9
palette = 5=#700f98
palette = 6=#008e8e
palette = 7=#232629
palette = 8=#c0c0bd
palette = 9=#b0151a
palette = 10=#388e3c
palette = 11=#ffb627
palette = 12=#0082c9
palette = 13=#700f98
palette = 14=#008e8e
palette = 15=#070708
palette = 16=#ff3d00
palette = 17=#b27701
palette = 18=#efefe9
palette = 19=#deded8
palette = 20=#60615d
palette = 21=#2f3337

# Foreground & background colors
background = #f8f8f2
foreground = #232629
cursor-color = #232629
selection-background = #232629
selection-foreground = #deded8
search-background = #ffb627
search-foreground = #070708
search-selected-background = #ff3d00
search-selected-foreground = #070708

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #070708
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0082c9
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
