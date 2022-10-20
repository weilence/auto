#!/bin/bash

function update_repo() {
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    curl https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo >/etc/yum.repos.d/CentOS-Base.repo
    yum makecache
    yum -y install epel-release
}

function update_git() {
    yum -y remove git git-*
    yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
    yum -y install git
}

function install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # 安装zsh-autosuggestions插件
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i -e 's/git/git zsh-autosuggestions/g' ~/.zshrc
}

update_repo
update_mirror
install_oh_my_zsh
