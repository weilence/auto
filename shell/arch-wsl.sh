#!/bin/bash

function update_mirror() {
    cp -a /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    echo 'Server = https://repo.huaweicloud.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
    cat /etc/pacman.d/mirrorlist.bak >> /etc/pacman.d/mirrorlist
    pacman -Suy --noconfirm
}

function install_yay() {
    useradd -m build
    echo "build ALL=(ALL:ALL) NOPASSWD: ALL"  >> /etc/sudoers
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
    echo 'LANG=zh_CN.UTF-8' > /etc/locale.conf
    locale-gen
}

function set_fcitx() {
    pacman -S fcitx5-im fcitx5-chinese-addons wqy-microhei --noconfirm
    echo '
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
    ' >> /etc/profile
}

function start_menu() {
    clear
    echo -e "请选择你要执行的操作
    \r0. 以下我全都要
    \r--------------
    \r1. 更新包管理源
    \r2. 安装yay
    \r3. 设置中文环境
    \r4. 设置输入法
    \r--------------
    \r5. 退出"
    read -p "请输入数字 [0-4]: " num
    case $num in
        0)
            update_mirror
            install_yay
            set_chinese
            set_fcitx
            ;;
        1)
            update_mirror
            start_menu
            ;;
        2)
            install_yay
            start_menu
            ;;
        3)
            set_chinese
            start_menu
            ;;
        4)
            set_fcitx
            start_menu
            ;;
        *)
            echo "输入错误"
            read -s -n1 -p "按任意键继续 ... "
            start_menu
    esac
}

start_menu