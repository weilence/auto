#!/bin/bash

command -v jq >/dev/null 2>&1 || {
    echo >&2 "未安装jq"
    exit 1
}

command -v npm >/dev/null 2>&1 || {
    echo >&2 "未安装npm"
    exit 1
}
json=$(curl https://raw.githubusercontent.com/cnpm/binary-mirror-config/master/package.json 2>/dev/null | jq -r ".mirrors.china.ENVS | to_entries | map(\"export \(.key)='\(.value)'\") | .[]")
rc=
if [[ "$SHELL" = *bash ]]; then
    rc="$HOME/.bashrc"
elif [[ "$SHELL" = *zsh ]]; then
    rc="$HOME/.zshrc"
fi
echo "${json}" >>"${rc}"
# shellcheck disable=SC1090
source "${rc}"
npm config set registry https://registry.npmmirror.com
