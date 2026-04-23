#!/bin/sh

green_color=$(tput setaf 2)
red_color=$(tput setaf 1)
reset_color=$(tput sgr0)

1>&2 cat <<EOF

╔═══════════════════════════════════════════════════╗
║ IMPORTANT NOTICE:                                 ║
║                                                   ║
║ You are using an out-of-date template for iTerm2! ║
╚═══════════════════════════════════════════════════╝

To migrate, update the ${red_color}themes-dir${reset_color} & ${red_color}hook${reset_color} in the tinted-terminal entry in
$HOME/.config/tinted-theming/tinty/config.toml:

${red_color}themes-dir${reset_color} = ${green_color}"themes-16/iterm2-applescripts"${reset_color}
${red_color}hook${reset_color} = ${green_color}'''
command cp -f %f ~/Library/Application\\ Support/iTerm2/Scripts/AutoLaunch.scpt \\
    && osascript %f
'''${reset_color}

For more info: https://github.com/tinted-theming/tinted-terminal#iterm2

EOF
