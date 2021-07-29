#!/bin/bash
# 技术支持 QQ1713829947 http://lwm.icu
# 2021-7-9 16:12:37

__init_ages() {
    _rpm='/mnt/source/res/rpm'
    _file='/mnt/source/res/file'
    mkdir /root/install/
}

__install_rpm() {
    echo 'start install all'
    rpm -ivh --force --nodeps $_rpm/all/*.rpm

}

__yum_repos_d() {
    # 将阿里云源复制进去
    rm -rf /etc/yum.repos.d/epel.repo
    rm -rf /etc/yum.repos.d/CentOS-Base.repo
    cp -rf $_file/yum.repos.d/* /etc/yum.repos.d/

}

__init_system() {
    # 可选关闭
    # chkconfig NetworkManager off
    # service NetworkManager stop

    systemctl stop firewalld.service
    systemctl disable firewalld.service

    sed -i 's,^SELINUX=.*$,SELINUX=disabled,' /etc/selinux/config
    # 开机免输入密码
    sed -i 's,^ExecStart=.*$,ExecStart=-/sbin/agetty --autologin root --noclear %I,' /etc/systemd/system/getty.target.wants/getty@tty1.service
    cat $_file/sysctl/98-sysctl.conf >/etc/sysctl.d/98-sysctl.conf
    cat $_file/script/set-static-ip.sh >/opt/set-static-ip.sh
    chmod 777 /opt/set-static-ip.sh

}

__init_docker() {
    usermod -aG docker root
    mkdir -p /etc/docker
    cat >/etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://bn4ll166.mirror.aliyuncs.com"
    ],
    "data-root": "/data/docker-root",
    "dns": [
        "223.5.5.5",
        "119.29.29.29"
    ],
    "bip": "172.31.255.254/16",
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check=true"
    ],
    "userland-proxy": false,
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "50m",
        "max-file": "1"
    }
}
EOF
    systemctl enable docker

}

__init_ages
__yum_repos_d
__install_rpm >/root/install/install_rpm.log
__init_system
__init_docker


