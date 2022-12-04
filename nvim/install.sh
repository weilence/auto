#!/bin/bash

# 检查当前是否是wsl2系统
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
# 安装win32yank.exe
  curl -sLo/tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
  chmod +x /tmp/win32yank.exe
  sudo mv /tmp/win32yank.exe /usr/local/bin/
fi

ln -sv . ~/.config/nvim

