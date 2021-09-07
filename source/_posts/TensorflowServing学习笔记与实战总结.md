---
title: TensorflowServing学习笔记与实战总结
toc: true
mathjax: true
tags:
  - TensorflowServing
  - Tensorflow
categories:
  - 深度学习
excerpt: TensorflowServing学习笔记与实战总结。
abbrlink: 8d71e860
date: 2021-09-07 15:21:58
---

# TensorFlowServing

---

## 介绍

* 支持热更新：在模型文件目录创建更大的版本目录即可，旧版本停用，直接使用新的版本。

## Docker部署

### 模型准备

使用Tensorflow训练好的模型需要保存为 tfs 格式的模型文件。

```bash
└── 0
    ├── assets
    ├── saved_model.pb
    └── variables
        ├── variables.data-00000-of-00002
        ├── variables.data-00001-of-00002
        └── variables.index
```

* 目录0：表示版本号，但不是 url 中的 v1
* saved_model.pb：保存的网络模型结构
* variables：参数的序列化数据

如果是 keras 保存的 h5 文件，需要转为 tfs 格式的模型文件

```python
# 使用了keras model.save_weights()保存参数的模型文件转换
model.load_weights(bast_model_filepath)
model.save('output/tfs/1/', save_format='tf')

# 使用了keras model.save()保存全部模型的文件转换
model = tf.keras.models.load_model(model_path.h5, custom_objects={自定义的loss或者metric}) 
model.save('output/tfs/1/', save_format='tf')
```

### 拉取Docker镜像

使用如下命令，拉取 tensorflow serving 镜像

```bash
docker pull tensorflow/serving
```

### 运行Tensorflow/serving镜像

```bash
docker run -p 8555:8501 --name demo1 -v 本地模型文件目录:/models/demo1 -e MODEL_NAME=demo1 tensorflow/serving
```

* docker run：运行docker 命令执行 tensorflow/serving
* -p ：将docker 内部的8501端口，映射到外部的8555 ，外部可以通过localhost:8555 访问
* --name: 指定容器名字
* -v：将本地模型文件目录（版本号上一级）挂在到docker内的/models/demo1上，demo1 需要与MODEL_NAME 一致
* -e MODEL_NAME：模型名称

## 访问服务

### ResfulAPI 和 HTTP 访问

可以使用 resful 或者 http 通过 8501 映射的端口访问

* 访问服务版本信息

  ```bash
  GET：http://localhost:8555/v1/models/demo1
  ```

* 访问服务meta数据

  ```bash
  GET: http://localhost:8555/v1/models/demo1/metadata
  ```

* 服务预测

  ```bash
  POST: http://localhost:8555/v1/models/demo1:predict 
  
  data = {
  	"请求数据使用json格式，字段参考meta数据信息"
      "inputs":{
          "text_right": [[0, 0]],
          "text_left":[[0, 0]]
      }
  }
  
  ```

  ### Grpc访问

  使用 8500 映射的端口访问 rpc 服务。

## 参考

* https://zhuanlan.zhihu.com/p/96917543
* https://blog.csdn.net/qq_35306993/article/details/103312908
