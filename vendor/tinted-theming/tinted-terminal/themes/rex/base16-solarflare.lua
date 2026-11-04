-- vim: ft=lua
-- Solar Flare theme for Rex
-- Scheme Author: Chuck Harmston (https://chuck.harmston.ch)
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

local name = "base16-solarflare"
local variant = "dark"

-- This must match themes/ghostty/base16-solarflare exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Solar Flare theme for Ghostty
# Scheme Author: Chuck Harmston (https://chuck.harmston.ch)
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#18262f
palette = 1=#ef5253
palette = 2=#7cc844
palette = 3=#e4b51c
palette = 4=#33b5e1
palette = 5=#a363d5
palette = 6=#52cbb0
palette = 7=#a6afb8
palette = 8=#667581
palette = 9=#ef5253
palette = 10=#7cc844
palette = 11=#e4b51c
palette = 12=#33b5e1
palette = 13=#a363d5
palette = 14=#52cbb0
palette = 15=#f5f7fa
palette = 16=#e66b2b
palette = 17=#d73c9a
palette = 18=#222e38
palette = 19=#586875
palette = 20=#85939e
palette = 21=#e8e9ed

# Foreground & background colors
background = #18262f
foreground = #a6afb8
cursor-color = #a6afb8
selection-background = #a6afb8
selection-foreground = #586875
search-background = #e4b51c
search-foreground = #222e38
search-selected-background = #e66b2b
search-selected-foreground = #222e38

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #f5f7fa
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #33b5e1
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
