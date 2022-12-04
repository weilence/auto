#!/bin/bash

pacman -S --noconfirm git-delta
git config --global core.pager delta
git config --global interactive.diffFilter delta --color-only
git config --global delta.navigate true
git config --global delta.light false
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default

