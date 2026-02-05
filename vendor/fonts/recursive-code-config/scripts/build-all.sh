# !/bin/bash

# A basic script to build all premade onfigs in the project for release

set -e

rm -rf ./fonts

configs=$(ls ./premade-configs)

for config in $configs; do
    python3 scripts/instantiate-code-fonts.py ./premade-configs/$config
done
