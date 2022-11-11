#!/usr/bin/env bash
sh_ver="0.0.2"

github="https://raw.githubusercontent.com/Weilence/auto/main"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

update_self() {
    echo -e "${Info} 开始更新脚本..."
    if ! wget --no-check-certificate -O ./vps.sh ${github}/shell/vps.sh; then
        echo -e "${Error} 脚本更新失败 !" && exit 1
    fi
    chmod +x ./vps.sh
    echo -e "${Info} 脚本更新完成 !"
}

install_nginx() {
    echo -e "${Info} 安装nginx"
    yum install -y epel-release
    yum install -y nginx
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
    wget --no-check-certificate $github/config/nginx.conf -O /etc/nginx/nginx.conf
    systemctl enable nginx
    systemctl restart nginx
    start_menu
}

install_xray() {
    echo -e "${Info} 安装xray"
    read -r -p "请输入UUID: " uuid
    read -r -p "请输入域名: " domain
    read -r -p "请输入邮箱: " email

    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
    mkdir -p /usr/local/etc/xray
    wget -O "/usr/local/share/xray/geosite.dat" https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
    wget -O "/usr/local/share/xray/geoip.dat" https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat

    wget --no-check-certificate $github/config/xray.json -O /usr/local/etc/xray/config.json
    sed -i "s/__UUID__/$uuid/g" /usr/local/etc/xray/config.json
    sed -i "s/__CRT__/\/usr\/local\/etc\/xray\/$domain-cert.pem/g" /usr/local/etc/xray/config.json
    sed -i "s/__KEY__/\/usr\/local\/etc\/xray\/$domain-key.pem/g" /usr/local/etc/xray/config.json

    yum install -y socat
    systemctl stop nginx
    curl https://get.acme.sh | sh -s email="$email"
    ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    ~/.acme.sh/acme.sh --issue -d "$domain" --standalone
    ~/.acme.sh/acme.sh --install-cert -d "$domain" \
        --key-file /usr/local/etc/xray/"$domain"-key.pem \
        --fullchain-file /usr/local/etc/xray/"$domain"-cert.pem \
        --reloadcmd "systemctl restart xray"

    systemctl start nginx
    systemctl enable xray
    systemctl restart xray

    start_menu
}

start_menu() {
    clear
    echo -e "一键安装脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
————————————内核————————————
 ${Green_font_prefix}0.${Font_color_suffix} 更新自己
 ${Green_font_prefix}1.${Font_color_suffix} 关闭防火墙和 SELinux
 ${Green_font_prefix}2.${Font_color_suffix} 修改 sshd 端口号
 ${Green_font_prefix}3.${Font_color_suffix} 安装 nginx
 ${Green_font_prefix}4.${Font_color_suffix} 安装 xray
————————————————————————————————"
    read -r -p " 请输入数字 [0-4]:" num
    case "$num" in
    0)
        update_self
        ;;
    1)
        systemctl stop firewalld
        systemctl disable firewalld
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
        start_menu
        ;;
    2)
        read -r -p "请输入sshd端口号 [0-65535]:" port
        sed -i "s/.*Port .*/Port $port/g" /etc/ssh/sshd_config
        systemctl restart sshd
        start_menu
        ;;
    3)
        install_nginx
        ;;
    4)
        install_xray
        ;;
    *)
        clear
        echo -e "${Error}:请输入正确数字 [0-14]"
        sleep 5s
        start_menu
        ;;
    esac
}

start_menu
