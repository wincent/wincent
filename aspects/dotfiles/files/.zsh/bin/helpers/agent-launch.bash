# Shared setup for the Bash agent launchers. Source this file; don't exec it.

agent_launch_resolve_pi_binary() {
  pi_binary="${PI_REAL_BIN:-$HOME/n/bin/pi}"
  if [[ $pi_binary != /* || ! -f $pi_binary || ! -x $pi_binary ]]; then
    printf '%s: PI_REAL_BIN must name an absolute executable file (default: $HOME/n/bin/pi)\n' "${0##*/}" >&2
    return 1
  fi
}

agent_launch_validate_worker() {
  if [[ $# -lt 3 || $1 != -- ]]; then
    printf '%s: expected -- <node> <worker-entrypoint>\n' "${0##*/}" >&2
    return 2
  fi
  if [[ $2 != /* || $3 != /* || ! -x $2 || ! -f $3 ]]; then
    printf '%s: expected absolute Node and worker paths\n' "${0##*/}" >&2
    return 2
  fi
}

agent_launch_export_worker_entrypoint() {
  export PI_SUBAGENT_PI_ENTRYPOINT="$HOME/n/pi/node_modules/@earendil-works/pi-coding-agent/dist/bundle/cli.js"
}

agent_launch_prepare_socket_root() {
  # nono resolves socket grants before launch. Match the pi profile and leave
  # socket_root set for callers that also need to export it explicitly.
  TMPDIR="${TMPDIR:-/tmp}"
  if [[ $TMPDIR != /* || ! -d $TMPDIR ]]; then
    printf '%s: TMPDIR must be an existing absolute directory\n' "${0##*/}" >&2
    return 1
  fi
  export TMPDIR
  socket_root="${TMPDIR%/}/pi-sockets"
  (umask 077; mkdir -p "$socket_root") || return $?
  if [[ -L $socket_root || ! -d $socket_root || ! -O $socket_root ]]; then
    printf '%s: subagent socket root must be an owned directory, not a symlink\n' "${0##*/}" >&2
    return 1
  fi
  chmod 700 "$socket_root"
}

agent_launch_exec_sandbox() {
  local nono="$1" log_kind="$2" profile=pi github_profile
  shift 2

  # Keep nono's stderr logs off the TUI. $$ becomes nono's PID after exec.
  export NONO_LOG_FILE="${NONO_LOG_FILE:-${TMPDIR%/}/nono-$log_kind-$$.log}"
  if [ -n "${NONO_GITHUB_SSH_ACCOUNTS:-}" ]; then
    github_profile="$("$HOME/.zsh/bin/github-proxy-layer" --file "$PWD")" || return $?
    if [ -n "$github_profile" ]; then
      unset GH_TOKEN GITHUB_TOKEN
      profile="$github_profile"
    fi
  fi
  exec "$nono" run --profile "$profile" --allow-cwd "$@"
}

agent_launch_apply_proxy_env() {
  local helper="$1" github_layer generation proxy_env
  local github_args=()
  if [ -n "${NONO_GITHUB_SSH_ACCOUNTS:-}" ]; then
    github_layer="$("$HOME/.zsh/bin/github-proxy-layer" "$PWD")" || return $?
    if [ -n "$github_layer" ]; then
      github_args=(--github-layer "$github_layer")
    fi
  fi
  # Lease for the launcher PID, which the runtime inherits through exec.
  generation="$("$helper" ${github_args[@]+"${github_args[@]}"} acquire "$$")" || return $?
  proxy_env="$("$helper" --generation "$generation" env)" || return $?
  eval "$proxy_env"
}
