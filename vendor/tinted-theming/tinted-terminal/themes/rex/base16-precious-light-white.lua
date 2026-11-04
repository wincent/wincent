-- vim: ft=lua
-- Precious Light White theme for Rex
-- Scheme Author: 4lex4 &lt;4lex49@zoho.com&gt;
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

local name = "base16-precious-light-white"
local variant = "light"

-- This must match themes/ghostty/base16-precious-light-white exactly. CI checks that it does.
local theme = [==[
# vim: ft=ghostty
# Precious Light White theme for Ghostty
# Scheme Author: 4lex4 &lt;4lex49@zoho.com&gt;
# Scheme System: base16
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=#ffffff
palette = 1=#af4947
palette = 2=#557301
palette = 3=#876500
palette = 4=#186daa
palette = 5=#7b4ecb
palette = 6=#087767
palette = 7=#555555
palette = 8=#848484
palette = 9=#af4947
palette = 10=#557301
palette = 11=#876500
palette = 12=#186daa
palette = 13=#7b4ecb
palette = 14=#087767
palette = 15=#555555
palette = 16=#a0570d
palette = 17=#a93e93
palette = 18=#ededed
palette = 19=#dbdbdb
palette = 20=#636363
palette = 21=#555555

# Foreground & background colors
background = #ffffff
foreground = #555555
cursor-color = #555555
selection-background = #555555
selection-foreground = #dbdbdb
search-background = #876500
search-foreground = #555555
search-selected-background = #a0570d
search-selected-foreground = #555555

# Set `macos-icon = custom-style` in your main configuration file to enable theming of the app icon.
#
# Set the ghost color to the lightest foreground:
macos-icon-ghost-color = #555555
# Replace the official icon's blue background with the designated bright blue color:
macos-icon-screen-color = #186daa
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
