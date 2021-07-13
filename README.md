# 这个仓库代码有什么用
## 简介
使用 kickstart  构建 一个CentOS ISO, 可预装任意软件, 做大量的系统预配置,满足业务场景  
kickstart   可做到无人值守安装, 无需在装系统时做大量设置  
最主要解决系统安装后无外网安装应用的难题  

本仓库代码对应语雀文档 https://www.yuque.com/uuu/centos/kickstart

# 如何使用这份代码?

在一台装有 Docker 和 Git 的 Linux 上, 按以下步骤操作  
主要是为了运行一个web vscode  
更多关于 web vscode https://www.yuque.com/uuu/vscode/web-vscode

1. 使用 Git 命令拉取到指定文件夹
   ```bash
    git clone https://gitee.com/lwmacct/web-vscode-kickstart.git /data/docker-data/vscode
   ```
2. 使用 Docker 运行 web-vscode 
   ```bash
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
   ```
3. WEB 编辑器运行起来后查看当前设备IP,使用 8443 端口访问 http://youIP:8443
