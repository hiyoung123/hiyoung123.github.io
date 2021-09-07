---
title: Thrift框架学习笔记
toc: true
mathjax: true
tags:
  - thrift
  - rpc
categories:
  - RPC
excerpt: Thrift框架学习笔记。
abbrlink: 9937f9bc
date: 2021-05-06 15:15:23
---

# Thrift

---

* Thrift 是 Facebook 2007 年开发的跨语言 RPC 框架。

* 服务端使用 IDL 文件（.thrift）定义接口函数和数据类型，客户端可以通过 thrift 的编译环境生成各种语言的 接口文件。这样客户端不管使用 java 语言还是python都可以直接调用服务端的接口函数。

* Thrift 为服务端程序提供很多的工作模式，比如线程池模型，非阻塞模型等。

* Thrift 协议栈

  * User Code：开发者自己的逻辑代码
  * ServiceClient：Processor，TService，ServiceClient
    * TService：服务端，负责接收Client请求，并将请求转发给 Processor 进行处理。支持高并发。
    * Processor：对Client的请求作出处理，向Message中写入和读出数据。
    * ServiceClient：客户端。
  * TProtocol：负责结构化数据组成Message，序列化和反序列化。
  * TTransport：负责以字节流的方式传输和接收Message，是Thrift对底层I/O模块的封装。每一个I/O对应一个TTransport。如 TSocket，TFileTransport。
  * 底层I/O：实际负责传输数据，包括Socket，文件，等。

* Thrift 的工作内容

  * 通过 IDL 定义数据结构和接口函数。
  * 利用代码生成器生成代码。
  * 编写业务逻辑。

* IDL （.thrift文件）

  * service（类），struct（结构体），enum（枚举），exception (错误)

* 生成代码

  ```bash
  thrift --gen java test.thrift # 生成java代码
  ```

* 服务端编码基本步骤

  * 实现服务处理接口 impl，需要继承上述命令生成的 iface。
  * 创建Processor，并把 impl 加到 processor 里。
  * 创建Transport
  * 创建Protocol
  * 创建Server
  * 启动Server

* 客户端编码基本步骤

  * 创建Transport
  * 创建Protocol
  * 基于Protocol 创建 client
  * 打开 Transport
  * 调用服务相应函数

* Transport 类型

  * Tsocket：Socket 
  * TFramedTransport：帧
  * TMemoryTransport：内存 I/O
  * TZipTransport：压缩文件

* Protocol 类型

  * TBinaryProtocol：二进制
  * TCompactProtocol：压缩类型
  * TJsonProtocol：Json类型
  * TSimpleJsonProtocol：
  * TDebugProtocol：使用人类可读的text

* Server 服务类型：

  * TNonblockingServer：多线程，非阻塞 I/O，处理大量并发请求
  * THsHaServer：半同步、半异步服务器模型，基于TNonblocking 实现
  * TThreadPoolServer：基于多线程，阻塞 I/O ，消耗的系统资源更高，但是有更好的吞吐量。
  * TSimpleServer：用于测试，单线程，阻塞 I/O

  


