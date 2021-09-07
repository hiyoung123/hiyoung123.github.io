---
title: Docker学习笔记
toc: true
mathjax: true
tags:
  - Docker
  - 虚拟容器
categories:
  - Docker
excerpt: Docker学习笔记。
abbrlink: 4a3d459a
date: 2021-09-07 15:24:54
---

1. Mac 安装docker

   ```bash
   brew cask install docker
   ```

2. 概念

   * 镜像：类，分层存储，前一层是后一层的基础，每一层的修改都只会在自己的一层进行修改，不会干扰到其他层。比如删除前一层的数据，并不是真正删除，而是在当前层不引用。而文件实际还是随着镜像在一起，比较臃肿。
   * 容器：实例，相当于进程，有自己独立的用户空间。容器是运行在镜像之上的一层，有自己的存储层。容器存储层随着容器的消亡而消亡，生命周期一致。好的编写规范是，使用宿主存储或者数据卷，生命周期独立于容器，删除容器后数据也不会消失。
   * 仓库

3. 添加镜像源

   mac : preference - > docker engine - > 

   ```json
     "registry-mirrors": [
       "https://hub-mirror.c.163.com",
       "https://mirror.baidubce.com"
     ]
   ```

4. 获取镜像

   ```bash
   docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]
   ```

5. 运行镜像

   ```bash
   docker run -it -rm ubuntu:18.04 bash
   ```

6. 退出镜像

   ```bash
   exit
   docker ps // 查看运行的docker id
   docker kill dockerid
   ```

7. 列出镜像

   ```bash
   docker image ls
   ```

8. 查看占有空间

   ```bash
   docker system df
   ```

9. 虚悬镜像（None-image）

   ```bash
   docker image ls -f dangling=true
   ```

10. 删除虚悬镜像

    ```bash
    docker image prune
    ```

11. 中间层镜像

    ```bash
    docker image ls -a
    ```

12. 删除镜像

    ```bash
    docker image rm [选项] <镜像1> [<镜像2> ...]
    ```

13. 理解构建

    ```bash
    docker commit  # 类似git commit 将存储层的修改添加到镜像中,慎用!!!
    ```

14. 进入容器

    ```bash
    docker exec -it webserver bash
    ```

15. 查看修改

    ```bash
    docker diff webserver
    ```

16. 查看修改历史

    ```bash
    docker history
    ```

17. 定制docker Dockerfile 是文本文件，其中包含了一条条操作docker的指令。

    * FROM：指定基本镜像，是文件中必须的一条命令。（scratch空白镜像）

    * RUN：执行命令行命令。

    * 没执行一条命令都会新建一层，这里的层相当于git中的patch。

    * 一条条的写是非常不符合规范的，产生更多的层并且有其他副产物，使镜像过于臃肿，最大层数是127层。可以将多条命令使用一个RUN命令执行，这样就只新建一层。

    * 支持 # 注释， \ 换行。

    * 建议最后执行一下清理工作，将无用的不需要的东西删除掉。

    * 构建镜像

      ```bash
      docker build -t name:version 上下文路径
      ```

    * 通过指定上下文路径告知docker引擎需要使用的本地文件路径。

    * 可以使用类似git 的 .dockerignore 来避免一些不需要docker引擎知道的文件。

    * 其他构建方法：github，压缩包，标准输入输出。

18. Dockerfile 其他指令

    * COPY：从本地上下文文件中复制到镜像中
    * ADD：更高级的COPY命令，通常用于复制后解压。
    * CMD：指定默认的容器启动命令。运行容器时可以指定命令替换这个默认的命令。
    * ENV：设置镜像的环境变量。
    * VOLUME：指定挂载数据卷路径。
    * WORKDIR：指定工作目录
    * USER：指定当前用户。
    * LABEL：为镜像添加元数据，比如作者等。
    * SHELL：指定shell。
    * 多阶段构建

19. manifest

20. 容器不是虚拟机，没有后台。

    


