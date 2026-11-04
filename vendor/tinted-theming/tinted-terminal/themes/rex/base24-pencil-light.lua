-- vim: ft=lua
-- Pencil Light theme for Rex
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

local name = "base24-pencil-light"
local variant = "light"

-- This must match themes/ghostty/base24-pencil-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Pencil Light theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f1f1f1
palette = 1=#c30771
palette = 2=#10a778
palette = 3=#20bbfc
palette = 4=#008ec4
palette = 5=#523c79
palette = 6=#20a5ba
palette = 7=#b3b3b3
palette = 8=#676767
palette = 9=#fb007a
palette = 10=#5fd7af
palette = 11=#f3e430
palette = 12=#20bbfc
palette = 13=#6855de
palette = 14=#4fb8cc
palette = 15=#212121
palette = 16=#a89c14
palette = 17=#610338
palette = 18=#212121
palette = 19=#424242
palette = 20=#8d8d8d
palette = 21=#d9d9d9

# Foreground & background colors
background = #f1f1f1
foreground = #b3b3b3
cursor-color = #b3b3b3
selection-background = #b3b3b3
selection-foreground = #424242
search-background = #20bbfc
search-foreground = #212121
search-selected-background = #a89c14
search-selected-foreground = #212121

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #212121
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #20bbfc
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
