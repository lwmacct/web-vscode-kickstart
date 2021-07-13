#!/bin/bash
# 技术支持 QQ1713829947 http://lwm.icu
# 2021-7-9 16:12:37

__init_ages() {
    _rpm='/mnt/source/res/rpm'
    _file='/mnt/source/res/file'
    mkdir /root/install/
}

__install_rpm() {
    echo 'start install base'
    rpm -ivh --force --nodeps $_rpm/base/*.rpm

    echo 'start install dcache'
    rpm -ivh --force --nodeps $_rpm/dcache/*.rpm

    echo 'start install device'
    rpm -ivh --force --nodeps $_rpm/device/*.rpm

    echo 'start install docker-ce'
    rpm -ivh --force --nodeps $_rpm/docker-ce/*.rpm

}

__docker_config() {
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

__docker_init() {
    systemctl daemon-reload
    systemctl start docker
    docker load <"$_file/docker-lwmacct-ubuntu-v1.tar.gz"
    docker images
}

__init_ages
__install_rpm >/root/install/install_rpm.log
__docker_config
__docker_init >/root/install/docker.log
# 开机免输入密码
sed -i 's,^ExecStart=.*$,ExecStart=-/sbin/agetty --autologin root --noclear %I,' /etc/systemd/system/getty.target.wants/getty@tty1.service
