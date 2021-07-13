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
    # 该代码不起作用,仅做保留以便下次适配
    echo 'start'
    /bin/systemctl daemon-reload
    /bin/systemctl start docker.service

    mkdir -p /data/docker-images/
    cp -rf $_file/docker-lwmacct-ubuntu-v1.tar.gz /data/docker-images/
    docker load </data/docker-images/docker-lwmacct-ubuntu-v1.tar.gz
    docker images

    echo 'ok'
}

__yum_repos_d() {
    # 将阿里云源复制进去
    rm -rf /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d
    mkdir -p /config/workspace/kickstart/bulid/dcache/res/file/yum.repos.d/

    rm -rf /etc/yum.repos.d/epel.repo
    rm -rf /etc/yum.repos.d/CentOS-Base.repo
    cp -rf $_file/yum.repos.d/* /etc/yum.repos.d/
}

__system_init() {
    # 开机免输入密码
    sed -i 's,^ExecStart=.*$,ExecStart=-/sbin/agetty --autologin root --noclear %I,' /etc/systemd/system/getty.target.wants/getty@tty1.service
}

__init_ages
__yum_repos_d
__install_rpm >/root/install/install_rpm.log
__docker_config
__system_init

# __docker_init >/root/install/docker.log
