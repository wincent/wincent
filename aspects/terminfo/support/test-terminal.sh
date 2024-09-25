#!/bin/sh

# Based on:
# - https://github.com/termstandard/colors
# - https://hellricer.github.io/2019/10/05/test-drive-your-terminal.html

echo "# 24-bit (true-color)"
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
echo

echo "# text decorations"
printf '\e[1mbold\e[22m\n'
printf '\e[2mdim\e[22m\n'
printf '\e[3mitalic\e[23m\n'
printf '\e[1;3mbold + italic\e[22;23m\n'
printf '\e[4munderline\e[24m\n'
printf '\e[4:1mthis is also underline\e[24m\n'
printf '\e[21mdouble underline\e[24m\n'
printf '\e[4:2mthis is also double underline\e[24m\n'
printf '\e[4:3mcurly underline\e[24m\n'
printf '\e[58;5;10;4mcolored underline\e[59;24m\n'
printf '\e[5mblink\e[25m\n'
printf '\e[7mreverse\e[27m\n'
printf '\e[8minvisible\e[28m <- invisible (but copy-pasteable)\n'
printf '\e[9mstrikethrough\e[29m\n'
printf '\e[53moverline\e[55m\n'
echo

echo "# magic string (see https://en.wikipedia.org/wiki/Unicode#Web)"
echo "é Δ Й ק م ๗ あ 叶 葉 말"
echo

echo "# emojis"
echo "😃😱😵"
echo

echo "# right-to-left ('w' symbol should be at right side)"
echo "שרה"
echo

echo "# sixel graphics"
printf '\eP0;0;0q"1;1;64;64#0;2;0;0;0#1;2;100;100;100#1~{wo_!11?@FN^!34~^NB
@?_ow{~$#0?BFN^!11~}wo_!34?_o{}~^NFB-#1!5~}{o_!12?BF^!25~^NB@??ow{!6~$#0!5?
@BN^!12~{w_!25?_o{}~~NFB-#1!10~}w_!12?@BN^!15~^NFB@?_w{}!10~$#0!10?@F^!12~}
{o_!15?_ow{}~^FB@-#1!14~}{o_!11?@BF^!7~^FB??_ow}!15~$#0!14?@BN^!11~}{w_!7?_
w{~~^NF@-#1!18~}{wo!11?_r^FB@??ow}!20~$#0!18?@BFN!11~^K_w{}~~NF@-#1!23~M!4?
_oWMF@!6?BN^!21~$#0!23?p!4~^Nfpw}!6~{o_-#1!18~^NB@?_ow{}~wo!12?@BFN!17~$#0!
18?_o{}~^NFB@?FN!12~}{wo-#1!13~^NB@??_w{}!9~}{w_!12?BFN^!12~$#0!13?_o{}~~^F
B@!9?@BF^!12~{wo_-#1!8~^NFB@?_w{}!19~{wo_!11?@BN^!8~$#0!8?_ow{}~^FB@!19?BFN
^!11~}{o_-#1!4~^NB@?_ow{!28~}{o_!12?BF^!4~$#0!4?_o{}~^NFB!28?@BN^!12~{w_-#1
NB@???GM!38NMG!13?@BN$#0?KMNNNF@!38?@F!13NMK-\e\'
