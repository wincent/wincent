-- vim: ft=lua
-- Penumbra Dark theme for Rex
-- Scheme Author: Zachary Weiss (https://github.com/zacharyweiss)
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

local name = "base16-penumbra-dark"
local variant = "dark"

-- This must match themes/ghostty/base16-penumbra-dark exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Penumbra Dark theme for Ghostty
# Scheme Author: Zachary Weiss (https://github.com/zacharyweiss)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#24272b
palette = 1=#ca736c
palette = 2=#47a477
palette = 3=#8d9741
palette = 4=#5794d0
palette = 5=#9481cc
palette = 6=#00a2af
palette = 7=#bebebe
palette = 8=#636363
palette = 9=#ca736c
palette = 10=#47a477
palette = 11=#8d9741
palette = 12=#5794d0
palette = 13=#9481cc
palette = 14=#00a2af
palette = 15=#fffdfb
palette = 16=#ba823a
palette = 17=#bc73a4
palette = 18=#303338
palette = 19=#3e4044
palette = 20=#8f8f8f
palette = 21=#fff7ed

# Foreground & background colors
background = #24272b
foreground = #bebebe
cursor-color = #bebebe
selection-background = #bebebe
selection-foreground = #3e4044
search-background = #8d9741
search-foreground = #303338
search-selected-background = #ba823a
search-selected-foreground = #303338

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fffdfb
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #5794d0
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
