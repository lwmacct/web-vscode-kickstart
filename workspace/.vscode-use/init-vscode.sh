#!/usr/bin/env bash
exit 0
# 以下命令可进入宿主机命令行模式
__host() {
    nsenter --mount=/host/1/ns/mnt
}


__run_vscode() {
    docker rm -f vscode
    #rm -rf /data/docker-data/vscode
    docker pull registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.9.3-ls78-base
    docker run -itd --name=vscode \
        --hostname=code \
        --restart=always \
        --privileged=true \
        --net=host \
        -e PASSWORD="" \
        -v /proc:/host \
        -v /data/docker-data/vscode:/config \
        registry.cn-hangzhou.aliyuncs.com/lwmacct/code-server:v3.9.3-ls78-base
}
__run_vscode
