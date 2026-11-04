-- vim: ft=lua
-- Idea theme for Rex
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

local name = "base24-idea"
local variant = "dark"

-- This must match themes/ghostty/base24-idea exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Idea theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#202020
palette = 1=#fb5255
palette = 2=#98b61b
palette = 3=#6c9bed
palette = 4=#437ee6
palette = 5=#9d73b0
palette = 6=#248886
palette = 7=#515151
palette = 8=#c5c5c5
palette = 9=#fc6f72
palette = 10=#98b61b
palette = 11=#ffff0a
palette = 12=#6c9bed
palette = 13=#fc7efe
palette = 14=#248886
palette = 15=#171717
palette = 16=#ccb343
palette = 17=#7d292a
palette = 18=#acacac
palette = 19=#fffefe
palette = 20=#8b8b8b
palette = 21=#171717

# Foreground & background colors
background = #202020
foreground = #515151
cursor-color = #515151
selection-background = #515151
selection-foreground = #fffefe
search-background = #6c9bed
search-foreground = #acacac
search-selected-background = #ccb343
search-selected-foreground = #acacac

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #171717
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #6c9bed
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
