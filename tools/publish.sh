#!/usr/bin/env zsh
emulate -R zsh
setopt errexit

0=${(%):-%N}

REPO=mafredri/zsh-async

run() {
	dirty="$(git status --porcelain | grep -v '^??')" || true
	if [[ -n $dirty ]]; then
		print error: uncommitted changes, aborting...
		print $dirty
		exit 1
	fi

	v=$(git tag --list 'v*' --sort=-v:refname | head -n1 | tr -d v)
	vv=(${(@s,.,)v})
	case $1 in
		major) ((vv[1]++)); vv[2]=0; vv[3]=0;;
		minor) ((vv[2]++)); vv[3]=0;;
		patch) ((vv[3]++));;
		*) print 'error: unknown semver method $1, use patch, minor or major'; exit 1;;
	esac
	nv=${(j,.,)vv}

	print "Current version is v${v}"
	print -n "Publish v${nv} (Y/n): "
	read -r -k1
	case $REPLY in
		[Yy$'\n']) print;;
		[Nn]) print; exit 0;;
		*) print $'\n'error: bad response $REPLY; exit 1;;
	esac

	sed -i '' \
		-e "s/# version: .*/# version: v${nv}/" \
		-e "s/ASYNC_VERSION=.*/ASYNC_VERSION=${nv}/" \
		async.zsh

	git add async.zsh
	git commit -m "v${nv}"
	git tag "v${nv}" -m "Release v${nv}"
	git push --follow-tags

	changes=(${(f)"$(git log --format='* %s %h' v${v}...v${nv}~1)"})
	body=($changes '' https://github.com/${REPO}/compare/v${v}...v${nv})

	typeset -a params=(
		tag=v${nv}
		title=v${nv}
		body="$(urlencode ${(F)body})"
	)

	open https://github.com/${REPO}/releases/new'?'${(j.&.)params}
}

# https://stackoverflow.com/questions/28971539/zsh-script-to-encode-full-file-path
urlencode() {
	setopt localoptions extendedglob
	local input=(${(s::)*})
	print ${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
}

if [[ -z $1 ]]; then
	1=patch
fi

(cd ${0:h}/..; run $1)
