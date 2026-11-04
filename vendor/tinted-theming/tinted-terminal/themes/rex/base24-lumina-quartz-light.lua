-- vim: ft=lua
-- Lumina Quartz Light theme for Rex
-- Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
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

local name = "base24-lumina-quartz-light"
local variant = "light"

-- This must match themes/ghostty/base24-lumina-quartz-light exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Lumina Quartz Light theme for Ghostty
# Scheme Author: Razik Ikhlef (https://github.com/RazikSF)
# Scheme System: base24
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#f5f7fa
palette = 1=#7d2b28
palette = 2=#217550
palette = 3=#9a642c
palette = 4=#446894
palette = 5=#7653a5
palette = 6=#007092
palette = 7=#30353b
palette = 8=#d2d4d9
palette = 9=#5a2522
palette = 10=#215e41
palette = 11=#82511c
palette = 12=#31547e
palette = 13=#6c3f69
palette = 14=#115a74
palette = 15=#30353b
palette = 16=#874c2a
palette = 17=#82527e
palette = 18=#eef0f5
palette = 19=#e2e5e9
palette = 20=#84868a
palette = 21=#46484b

# Foreground & background colors
background = #f5f7fa
foreground = #30353b
cursor-color = #30353b
selection-background = #30353b
selection-foreground = #e2e5e9
search-background = #9a642c
search-foreground = #eef0f5
search-selected-background = #874c2a
search-selected-foreground = #eef0f5

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #30353b
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #31547e
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
