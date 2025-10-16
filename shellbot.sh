#!/bin/bash

# Set the static binary name
script_path="$(realpath "$0")"
script_dir="$(dirname "$script_path")"
binary_name="$script_dir/target/release/shellbot"

console_width=$(tput cols)
startfile=$(mktemp)
trap "rm -f $startfile" EXIT
transcript=$(mktemp)
trap "rm -f $transcript" EXIT
${EDITOR} "$startfile"

separator="───  ⋅ ∙ ∘ ༓ ∘ ⋅ ⋅  ───"
padding_width=$(( (console_width - ${#separator}) / 2 ))
padded_separator=$(printf "%*s%s" ${padding_width} '' "${separator}")
user_input=$(cat "$startfile")
echo -e "🧑 $USER"
echo "$user_input" | fold -s -w "$console_width"
while true; do
    echo "===USER===" >> "$transcript"
    echo "$user_input" >> "$transcript"
    echo "${padded_separator}"
    echo -e "🤖 shellbot"
    echo "===ASSISTANT===" >> "$transcript"
    response_file=$(mktemp)
    # Use 'tee' to simultaneously capture the output and send it to 'fold'
    "$binary_name" < "$transcript" | tee "$response_file" | fold -s -w "$console_width"

    cat "$response_file" >> "$transcript"
    rm "$response_file"

    echo "${padded_separator}"
    echo -e "🧑 $USER"

    input=""
    while true; do
        read -r -e line
        if [ -z "$line" ]; then
            if [ -z "$input" ]; then
                exit
            else
                break
            fi
        fi
        input+="${line}"$'\n'
    done

    user_input=$input
done
