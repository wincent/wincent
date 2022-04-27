export LANG=en_US.UTF-8
export LC_TIME=en_AU.UTF-8

if [[ $(uname -s) = Darwin ]]; then
  # Override insanely low open file limits on macOS.
  ulimit -n 65536
  ulimit -u 1064

  # Mitigate: https://github.blog/2022-04-12-git-security-vulnerability-announced/
  export GIT_CEILING_DIRECTORIES=/Users
else
  export GIT_CEILING_DIRECTORIES=/home
fi

if [ -d "$HOME/.zshenv.d" ]; then
  for EXTENSION_FILE in $(find $HOME/.zshenv.d/ -name '*.zsh'); do
    source "$EXTENSION_FILE"
  done
fi
