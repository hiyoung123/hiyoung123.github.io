---
title: Brpc框架学习笔记
toc: true
mathjax: true
tags:
  - rpc
  - brpc
  - protobuf
categories:
  - RPC
excerpt: Brpc框架学习笔记
abbrlink: ac01086f
date: 2021-05-07 15:11:34
---

# BRPC

---

* BRPC：better rpc，内部称为baidu-rpc，对 i/o 请求读取，和信息处理，都是并发的。

* 优点：

  * 更友好的接口
  * 服务更加可靠
  * 更好的延迟和吞吐

* 接口简单：三大类 Server（服务端），Channel（客户端），Controller（参数调整）

  



## bvar

* 用于多线程环境下的计数类，方便记录和查看用户程序中的各类数值。
* 本质是将写竞争转移到读上，也就是在自己线程内使用threadlocal记录，等读的时候在累加所有线程的值。
* 所以不适合用于读写都很频繁的环境下。

## bthread

* 是 brpc 中 M:N pthread 的线程库，提高程序的并发度的同时，降低代码的编写难度。
* M:N 是指 M 个 bthread 映射到 N 个 pthread 上，一般情况下 M 比 N 大的多。一个 pthread 只能运行一个 bthread。如果 pthread 挂掉，对应的 bthread 可以等待其他的 pthread 运行他。如果一个 bthread 挂掉，对应的 pthread 可以从其他的 pthread 中拿到一个等待运行的 bthread 去运行。
* 一个 bthread 阻塞，不会影响其他 bthread。如果是因为 bthread 阻塞，那么对应的 pthread 会运行其他的 bthread，如果是 pthread 阻塞，对应的 bthread 会被其他空闲的 pthread 抢去运行。
* 所有 bthread 都阻塞的解决办法？
  * 限制最大并发量，同时请求数小于最大的 worker 数量。
* bthread 和异步接口？
  * 延时不高时使用同步接口，不行的话再使用异步接口，只有在需要多核并行计算的时候才使用 bthread。
  * 延迟判断：qps * latency(in seconds) 结果如果和 cpu 核心处于一个量级，就可以使用同步接口。
* 优点是：充分利用多核，并且与 pthread 相互兼容。
* 缺点是：没有优先级，与阻塞 pthread 混用可能会造成死锁。和 thread_local 使用，可能会出错，因为 bthread 不一定一直运行在固定的一个 pthread 上。

## ExecutionQueue

* 异步串行队列，提供了异步函数串行执行的功能。
* 功能如下
  * 异步有序执行，任务在另一个线程执行，并严格按照提交顺序执行
  * 多个生产者，多个线程可以同时向一个队列添加任务
  * 支持取消一个已经添加的任务
  * 支持 stop
  * 支持高优任务插队
* 与 mutex 相比
  * 共同点：解决多线程的资源竞争问题
  * 优点：不用考虑死锁问题，保证任务顺序执行，
  * 缺点：代码维护困难，所有任务单线程，一个慢了阻塞其他同队列的任务，由于缓存的问题可能占用过高的内存。
  * 选择：临界区小，竞争不激烈，优先使用 mutex。需要有序执行，在复杂环境提高吞吐，使用 ExecutionQueue。

## Client

* Client 对应的类为 Channel。
* client 流程：client 发起请求，从命名服务中找到对应的可用节点列表，根据负载均衡策略从中选择一个节点作为实际访问的节点。
* Init() 函数不是线程安全的，callmethod 是线程安全的，一个 channel 可以被所有线程使用。
* channel 可以被分配到栈上。
* channel 在发送异步请求后，可以被析构
* 与 channel option 搭配使用建立连接，常用的参数为，protocol 协议，负载均衡算法，超时时间，重连次数等。使用 channel.init(ip，option) 建立起通道后，使用 stub 进行函数调用。并结合 controller 使用。
* channel 支持通过 IP、域名、localhost 连接单个主机，和使用命名服务连接集群。
* channel 支持同步和异步调用。
* 组合channel：ParallelChannel
* 异步回调函数运行在一个独立的 bthread 中，不会影响到其他线程，所以可以进行阻塞操作。
* client 端的设置主要有三个：ChannelOption，Controller，和全局Flag
* Controller 的作用是在某次 rpc 调用中，覆盖 option 的设置。
* 一个 controller 对应一次 rpc，需要reset 后才可以被其他 rpc 使用。
* 对端 ip：remote_side，本机ip：local_side
* controller 的特点：
  * 线程不安全，一个controller 只能有一个 使用者
  * 因为不能共享，所以不能使用共享指针管理
  * controller 创建与 rpc之前，析构于 rpc 结束之后，
  * 同步 rpc 的 controller 放在栈上，
  * 异步 rpc 的 controller 绝不能放在栈上，放在堆上。
  * 异步调用前 new controler， 在 回调函数 done 中删除。
* 线程数：没有自己单独的线程池，可以使用gFlag 设置 -bthread_concurrency
* 超时时间：使用 option.timeout_ms 设置总超时，默认24天，使用 option.set_timeout_ms 设置单独的超时
* 重试次数：使用 option.max_try 设置所有最大重试次数，使用 option.set_max_try 设置单独 rpc 的重试。默认3次，0 表示不重试。
  * 触发重试的条件：连接出错 && 没到超时 && 有剩余重试次数 && 错误值需要重试
  * brpc 为了避免雪崩，减少服务器压力，对重试的策略是保守的。
* 熔断：可用节点列表中的节点出现故障，从列表中删除该节点，并周期性做健康检查。默认的熔断策略是三次连接超时（不是rpc超时，如果 rpc 先超时，那么永远也不会发生熔断，所以rpc超时要设置的比连接超时长）。
* 协议：默认使用 protocol
* 连接方式；短连接，单连接，连接池
* 附件：用户自定义数据，不需要经过protocol序列化
* 开启 openssl
* 认证
* 压缩：压缩 request body，默认是不压缩的，选项有 gzip，zlib等。

## Server

* 写 proto 文件定义 service 接口和基类，通过 protobuf 的命令生成对应 pb.cc 和 pb.h 文件。然后导入 pb.h 头文件，继承 service 基类，实现具体的方法。

* 创建 burp::Server，然后将自己实现的service addService 到 server 中，最后 server start 开启服务。

* Controller 同 client ，但是需要使用 static_cast 静态转换。

* RAII机制：在构造时申请资源，在析构时释放资源

* ```
  brpc::ClosureGuard done_guard(done);
  
  done 用来处理一些server端后续事情，比如返回给client response
  每次 rpc 调用，服务端都需要实现 done->run()
  
  使用上述代码，可以避免在函数结束之前，忘记实现 done->run()
  ```

* 设置状态失败；controller.setFailed

* 设置状态码：controller.http_response.set_status_code()

* 添加服务到sever：server.addService（myservice，ownership），ownership 设置为SERVER_OWNS_SERVICE 后 server 析构对于的 service 也一起析构，否则 service 一直存活。

* 启动：server.Start(ip, option)

* 一个 server 只能监听一个端口。

* 停止：stop（time），time无效，stop 不会阻塞，使用 join 可以阻塞。

* 替代 stop 和 join ：RunUntilAskedToQuit

* 达到最大并发数后，立即返回给 client 错误，为了解决雪崩问题，让client选择更好的服务器。

* 限制 server 级并发数：option.max_concurrency

* 限制 method 级并发数：server.MaxConcurrencyOf("函数名") = 10

* 设置自适应流量算法：= “auto”

* bthread_local

* 支持json和protpbuf的相互转换

* 服务的方法可以通过/ServiceName/method 访问，

* 可以通过 addService 的第三个参数设置方法对应的路由。

* protobuf服务传递的是json，

* http服务 proto 文件中函数体不需要设置不需要设置，参数和数据内容通过controller 设置。

* 向自定义数据结构的list里添加数据，需要先 add_filed() 获取到该对象，然后通过对象添加数据，

## 雪崩

* 访问服务器集群时，大部分请求超时，就算减少流量后也需要一段时间才可以恢复。
* 解决办法：
  * brpc 使用最大并发数控制，如果达到最大并发就返回失败，减少积压增多
  * 保守重试，避免出现堆积状态时出现的大量重试，进而造成更严重的堆积
  * brpc 在 bthread 中处理请求，单个请求阻塞不会影响到其他的 请求，也提供了完整的异步调用，防止服务被打满。

## 自动限流

* 动态更改最大并发数。

## 组合Channel

* ParallelChannel
* SelectiveChannel
* PartitionChannel



## 实战

* 编译源码，参考官方文档
* 编译产物：output/include，output/lib，output/bin
* 将 include 内容复制到 /usr/local/include/内
* 将 lib 内容复制到 /usr/local/lib 
* 服务端：
  * 编写 proto 文件：指定 protobuf 版本，指定语言，定义交互消息类，定义 service 基类
  * 使用 protoc 命令生成对应的 pb.h 和 pb.cc 文件。
  * 编写 server 文件，定义 service 类　继承上述生成的基类。
* 客户端：
  * 
