-- vim: ft=lua
-- Darktooth theme for Rex
-- Scheme Author: Jason Milkins (https://github.com/jasonm23)
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

local name = "base16-darktooth"
local variant = "dark"

-- This must match themes/ghostty/base16-darktooth exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Darktooth theme for Ghostty
# Scheme Author: Jason Milkins (https://github.com/jasonm23)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#1d2021
palette = 1=#fb543f
palette = 2=#95c085
palette = 3=#fac03b
palette = 4=#0d6678
palette = 5=#8f4673
palette = 6=#8ba59b
palette = 7=#a89984
palette = 8=#665c54
palette = 9=#fb543f
palette = 10=#95c085
palette = 11=#fac03b
palette = 12=#0d6678
palette = 13=#8f4673
palette = 14=#8ba59b
palette = 15=#fdf4c1
palette = 16=#fe8625
palette = 17=#a87322
palette = 18=#32302f
palette = 19=#504945
palette = 20=#928374
palette = 21=#d5c4a1

# Foreground & background colors
background = #1d2021
foreground = #a89984
cursor-color = #a89984
selection-background = #a89984
selection-foreground = #504945
search-background = #fac03b
search-foreground = #32302f
search-selected-background = #fe8625
search-selected-foreground = #32302f

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #fdf4c1
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #0d6678
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
