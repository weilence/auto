#!/bin/bash

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
curl https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo > /etc/yum.repos.d/CentOS-Base.repo
yum makecache
yum -y install epel-release
yum -y remove git
yum -y remove git-*
yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
yum -y install git

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"