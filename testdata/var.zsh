# Test variables

# Declaration and assignment.
x=var.zsh
arr=(one two three)
local a=b
typeset -U c=()

print $x
print ${x}

print $x:t  # TODO: ":t" should probably get highlighted.
print ${x:t}

print ${arr[1]}
print $arr[1]   # TODO: [1] should probably get highlighted the same?
print ${arr[@]}
print $arr[@]

print ${(j:x:)arr}
print ${(j/x/)arr}

print $@ $# $_ $0
