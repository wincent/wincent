if exists("b:__PERL_XPT_VIM__")
    finish
endif
let b:__PERL_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/perl.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
" Based on snipmate's perl templates

XPTemplateDef

XPT xif hint=..\ if\ ..;
`expr^ if `cond^;


XPT xwhile hint=..\ while\ ..;
`expr^ while `cond^;


XPT xunless hint=..\ unless\ ..;
`expr^ unless `cond^;


XPT xforeach hint=..\ foreach\ ..;
`expr^ foreach @`array^;


XPT sub hint=sub\ ..\ {\ ..\ }
sub `fun_name^ {
    `cursor^
}


XPT while hint=while\ (\ ..\ )\ {\ ..\ }
while (`cond^) {
    `cursor^
}


XPT unless hint=unless\ (\ ..\ )\ {\ ..\ }
unless (`cond^) {
    `cursor^
}


XPT eval hint=eval\ {\ ..\ };if...
eval {
    `risky^
};
if ($@) {
    `handle^
}


XPT for hint=for\ (my\ ..;..;++)
for (my $`var^ = 0; $`var^ < `count^; $`var^++) {
    `cursor^
}


XPT foreach hint=foreach\ my\ ..\ (..){}
foreach my $`var^ (@`array^) {
    `cursor^
}


XPT package hint=
package `className^;

use base qw(`parent^);

sub new {
    my $class = shift;
    $class = ref $class if ref $class;
    my $self = bless {}, $class;
    $self;
}

1;


