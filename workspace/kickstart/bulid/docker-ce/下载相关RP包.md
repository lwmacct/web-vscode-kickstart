## 文件说明
本文主题最终作用于目录 /config/workspace/kickstart/bulid/docker-ce/res/rpm
其目的是为了下载 RPM 包, 例如 下载 Docker 的所有依赖

运行一个CentOS 容器,使用容器下载Docker相关依赖

### 进入宿主机命令行模式

```bash
nsenter --mount=/host/1/ns/mnt
```


### 运行一个 CentOS 容器用于下载rpm包
```bash
__run_centos() {
    docker rm -f centos
    docker run -itd --name=centos \
        --hostname=code \
        --restart=always \
        --privileged=true \
        --net=host \
        -v /proc:/host \
        -v /data/docker-data/vscode/workspace/kickstart/bulid/docker-ce/res/rpm/:/rpm \
        centos:7.9.2009
}
__run_centos
```

### 下载安装包
```bash
__download_docker() {
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum makecache fast
    yum install --downloadonly --downloaddir=/rpm/docker-ce docker-ce
}
__download_docker

```
