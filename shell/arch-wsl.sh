#!/bin/bash

function ignore_windows_path() {
    cat >>/etc/wsl.conf <<EOF

[interop]
appendWindowsPath=false

EOF
}

function install_oh_my_zsh() {
    pacman -Sy --noconfirm zsh git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # 安装zsh-autosuggestions插件
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i -e 's/git/git zsh-autosuggestions/g' ~/.zshrc
}

function update_mirror() {
    cp -a /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    echo 'Server = https://repo.huaweicloud.com/archlinux/$repo/os/$arch' >/etc/pacman.d/mirrorlist
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
    if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        echo -e '
if [ -z "$(ps -aux | grep /usr/bin/dbus-daemon | grep -v grep)" ]; then
    daemonize -e /tmp/dbus-${USER}.log -o /tmp/dbus-${USER}.log -p /tmp/dbus-${USER}.pid -l /tmp/dbus-${USER}.pid -a /usr/bin/dbus-daemon --address="unix:path=$XDG_RUNTIME_DIR/bus" --session --nofork  >>/dev/null 2>&1
fi

if [ -z "$(ps -aux | grep /usr/bin/fcitx5 | grep -v grep)" ]; then
    daemonize -e /tmp/fcitx5.log -o /tmp/fcitx5.log -p /tmp/fcitx5.pid -l /tmp/fcitx5.pid -a /usr/bin/fcitx5 --disable=wayland
fi

export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
export INPUT_METHOD=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
' >>/etc/profile
        source /etc/profile
    fi
}

function start_menu() {
    clear
    echo -e '请选择你要执行的操作
0 一键安装 1-4
---------------
1 更新包管理源
2 设置中文环境
3 WSL2去掉Windows的$PATH环境
4 安装oh my zsh
---------------
yay 安装yay
fcitx 设置输入法
---------------
q 退出'
    read -p "请输入选项: " option
    case $option in
    0)
        update_mirror
        set_chinese
        ignore_windows_path
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
        ignore_windows_path
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
        echo "输入错误"
        read -s -n1 -p "按任意键继续 ... "
        start_menu
        ;;
    esac
}

start_menu
