# Ubuntu22.04 Desktop based on Docker with cuda12.4.0

[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/cbboy/docker-ubuntu22.04-desktop/tags)

## 1.基本使用

### 1.1 准备工作

* 安装nvidia驱动
* 安装docker和nvidia-container-runtime.

### 1.2 快速使用

拉取镜像
```bash
docker pull cbboy/docker-ubuntu22.04-desktop:22.04-cu12.4.0
```

docker-compose.yaml创建并运行多个独立容器
```bash
docker compose up -d
```
* 可自行设置账号密码及端口等

## 2.本地构架镜像

```bash
git clone https://github.com/gezp/docker-ubuntu-desktop.git
cd docker-ubuntu22.04-desktop 
# for 22.04-cu12.4.0  (based on nvidia/cuda)
./docker_build.sh 22.04-cu12.4.0
```

## Acknowledgement

thanks to the authors of following related projects:
* https://github.com/gezp/docker-ubuntu-desktop

## **注意**！！！

> 由于gezp大佬没有构建我想要的版本，所用 copy 一下
> 本次构建只是为了适配实验室服务器的cuda版本，可能存在一些未知bug，有问题提issue，我们一起解决
