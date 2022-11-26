#!/bin/bash

function systemd_enable() {
    cat >/etc/wsl.conf <<EOF
[boot]
systemd=true
EOF
}

function install_oh_my_zsh() {
    pacman -Sy --noconfirm zsh git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # 安装zsh-autosuggestions插件
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    sed -i -e 's/git/git zsh-autosuggestions/g' ~/.zshrc
}

function update_mirror() {
    cp -a /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    echo "Server = https://repo.huaweicloud.com/archlinux/\$repo/os/\$arch" >/etc/pacman.d/mirrorlist
    cat /etc/pacman.d/mirrorlist.bak >>/etc/pacman.d/mirrorlist
    pacman -Sy --noconfirm
}

function install_yay() {
    useradd -m build
    echo "build ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers
    pacman -S --needed git base-devel
    su - build -c "
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin
        makepkg -si
        yay -S daemonize --noconfirm
    "
}

function set_chinese() {
    sed -i 's/#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
    echo 'LANG=zh_CN.UTF-8' >/etc/locale.conf
    locale-gen
}

function set_fcitx() {
    pacman -S fcitx5-im fcitx5-chinese-addons wqy-microhei --noconfirm
    cat >>/etc/profile <<EOF
export INPUT_METHOD=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
    # shellcheck disable=SC1091
    source /etc/profile
}

function start_menu() {
    clear
    cat <<EOF
请选择你要执行的操作
0 一键安装 1-4
---------------
1 更新包管理源
2 设置中文环境
3 WSL2去掉Windows的\$PATH环境
4 安装oh my zsh
---------------
yay 安装yay
fcitx 设置输入法
---------------
q 退出
EOF
    read -r -p "请输入选项: " option
    case $option in
    0)
        update_mirror
        set_chinese
        systemd_enable
        install_oh_my_zsh
        ;;
    1)
        update_mirror
        start_menu
        ;;
    2)
        set_chinese
        start_menu
        ;;
    3)
        systemd_enable
        start_menu
        ;;
    4)
        install_oh_my_zsh
        start_menu
        ;;
    yay)
        install_yay
        start_menu
        ;;
    fcitx)
        set_fcitx
        start_menu
        ;;
    q) ;;
    *)
        read -r -n1 -p "输入错误, 按任意键继续..."
        start_menu
        ;;
    esac
}

start_menu
