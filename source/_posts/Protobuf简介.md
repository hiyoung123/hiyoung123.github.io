---
title: Protobuf简介
toc: true
mathjax: true
tags:
  - protobuf
categories:
  - RPC
excerpt: protobuf简介。
abbrlink: 9c355038
date: 2021-05-05 15:17:10
---
# Protobuf

---

* Protobuf 是一套类似 json 的数据传输格式和规范，用于不同应用和进程之间进行通信使用。通信时将数据通过 protobuf 定义的 message 进行打包，编译成二进制流进行传输。

* 优点：

  * 简单
  * 体积小，编码后只有传统的xml 的1/10
  * 解析速度快
  * 多语言支持
  * 更好兼容性

* 两个版本：v2，v3

* 使用

  * 定义protobuf文件：my.helloworld.proto

  * ```protobuf
    package my;
    message helloworld
    {
        required int32 id = 1;
        required string str = 2;
        optional int32 wow = 3;
    }
    
    # required 必须且只有一次
    # optional 可出现0次或者1次
    # repeated 可出现多次包括0次
    # 后面的数字为字段编号
    ```

  * 使用protoc 编译

    ```BASH
    // $SRC_DIR: .proto 所在的源目录
    // --cpp_out: 生成 c++ 代码
    // --python_out：生成 python 代码
    // $DST_DIR: 生成代码的目标目录
    // xxx.proto: 要针对哪个 proto 文件生成接口代码
    protoc -I=$SRC_DIR --cpp_out=$DST_DIR $SRC_DIR/xxx.proto
    ```

  * 然后就可以在程序中使用该数据结构。


