#!/usr/bin/env bash

NVIM_PATH="${LUASNIP_SOURCE}/deps/nvim_multiversion/worktree_master"

# for neovim
export VIMRUNTIME=${NVIM_PATH}/runtime

TMPDIR=/tmp/luasnip_tests
mkdir -p ${TMPDIR}/{config,share,state}

# for tests (neovim)
export XDG_CONFIG_HOME="${TMPDIR}/config"
export XDG_DATA_HOME="${TMPDIR}/share"
export XDG_STATE_HOME="${TMPDIR}/state"
export NVIM_LOG_FILE="${TMPDIR}/nvimlog"

unset XDG_DATA_DIRS
unset XDG_CONFIG_DIRS
unset NVIM

# test suite of neovim assumes cwd.
cd $NVIM_PATH

${NVIM_PATH}/build/bin/nvim -l ${NVIM_PATH}/test/runner.lua \
	-v \
	--helper="${NVIM_PATH}/test/functional/preload.lua" \
	--lpath="${NVIM_PATH}/src/?.lua" \
	--lpath="${NVIM_PATH}/runtime/lua/?.lua" \
	--lpath="${NVIM_PATH}/?.lua" \
	--lpath="${NVIM_PATH}/build/?.lua" \
	--lpath="${LUASNIP_SOURCE}/tests/?.lua" \
	"${TEST_FILE}"
