-- vim: ft=lua
-- Mona Lisa theme for Rex
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

local name = "base24-mona-lisa"
local variant = "dark"

-- This must match themes/ghostty/base24-mona-lisa exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Mona Lisa theme for Ghostty
# Scheme Author: FredHappyface (https://github.com/fredHappyface)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#110b0d
palette = 1=#9b281b
palette = 2=#626132
palette = 3=#9eb2b3
palette = 4=#515b5c
palette = 5=#9b1d29
palette = 6=#588056
palette = 7=#dab14e
palette = 8=#a26734
palette = 9=#ff4230
palette = 10=#b3b163
palette = 11=#ff9565
palette = 12=#9eb2b3
palette = 13=#ff5b6a
palette = 14=#89cc8e
palette = 15=#ffe597
palette = 16=#c26e27
palette = 17=#4d140d
palette = 18=#341a0d
palette = 19=#874227
palette = 20=#be8c41
palette = 21=#f6d75c

# Foreground & background colors
background = #110b0d
foreground = #dab14e
cursor-color = #dab14e
selection-background = #dab14e
selection-foreground = #874227
search-background = #9eb2b3
search-foreground = #341a0d
search-selected-background = #c26e27
search-selected-foreground = #341a0d

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #ffe597
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #9eb2b3
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
