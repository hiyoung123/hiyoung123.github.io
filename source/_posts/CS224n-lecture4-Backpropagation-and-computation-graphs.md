---
title: CS224n-lecture4 Backpropagation and computation graphs
toc: true
mathjax: true
tags:
  - NLP
  - CS224n
  - 反向回归
  - 矩阵梯度
  - 超参数
categories:
  - 自然语言处理
excerpt: CS224n 深度学习自然语言处理 2019 版 Lecture-4 学习笔记。
abbrlink: cc5eafd6
date: 2020-01-21 22:03:43
---

> CS224n 深度学习自然语言处理 2019 版 Lecture-4 学习笔记。

本节课分为三大部分：矩阵梯度计算，反向传播，神经网络模型的一些组件和超参数。前两部分以后会有专门的博客讲解，本篇主要说一下第三部分。

## Derivative wrt a weight matrix

## Computation Graphs and Backpropagation

## We have models with many params

### 正则化

实际上一个完整模型的损失函数还包括正则项，它是所有参数 $\theta$ 的正则化。例如使用 $L_2$ 正则：

<center>$J(\theta) = {1\over N} \sum^N_{i=1}-log({e^{f_{y_i}} \over \sum^C_{c=1} e^{f_e}})+\lambda \sum_k \theta^2_k$</center></br>

正则化的目的是防止模型过拟合，也就是在训练集上效果很好，但是在测试集上效果差。把所有参数加和算到损失里，这样可以抑制模型学习的强度。其中 $\lambda$ 是抑制因子，用于调节正则化的强度。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec4_reg_001.png)

### 向量化

在深度学习里更准确的说应该叫做矩阵化。传统的机器学习中的训练方法，是通过迭代的方式，一个数据一个数据的传入模型。但是这样速度很慢，可以将数据组合成矩阵，一起喂给模型去训练，使用矩阵运算可以大幅度提高训练速度。

```python
from numpy import random
N = 500 # number of windows to classify
d = 300 # dimensionality of each window
C = 5 # number of classes
W = random.rand(C,d)
wordvectors_list = [random.rand(d,1) for i in range(N)]
wordvectors_one_matrix = random.rand(d,N)

%timeit [W.dot(wordvectors_list[i]) for i in range(N)]
%timeit W.dot(wordvectors_one_matrix)
```

上面的代码对比迭代和矩阵运算的结果：

1000 loops, best of 3: 639 μs per loop
10000 loops, best of 3: 53.8 μs per loop

### 非线性

神经网络单元中会加入非线性激活函数，使得神经网络模型可以进行非线性计算。下面是一些常用的非线性激活函数：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec4_none_linear_001.png)

* sigmoid，常用于逻辑回归，神经网络中偶尔会在最后一层使用。
* tanh，是一个重新放缩和移动的 sigmoid (两倍陡峭，[-1,1])。
* logistic 和 tanh 仍然被用于特定的用途，但不再是构建深度网络的默认值。

因为 tanh 计算缓慢，所以提出了 ReLu 以及变体：

​	![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec4_none_linear_002.png)

非零范围内只有一个斜率，这一位置梯度十分有效的传递给了输入，所以模型非常有效的训练，但是由于 ReLu 会有一定概率使单元失活，所以在零范围内进行了修改。稍后会在一篇博客中全面比较各个非线性激活函数。

### 参数初始化

通常必须将权重初始化为小的随机值，这样才能在激活函数的有效范围内， 即存在梯度可以使其更新。也为了避免对称性妨碍学习。

一般情况下初始化隐藏层偏差为 0，如果权重为 0 则输出，偏差为最优值。初始化其他所有权重为 Uniform(-r, r)，选择使使数字既不会很大也不会很小的 r。

学习框架中的 Xavier，方差与 fan-in 前一层维度和 fan-out 后一层维度成反比：

<center>$Var(W_i) = {2\over n_{in} + n_{out}}$</center></br>

### 优化器

这是机器学习和深度学习中重要的一部分，通常情况下都使用的是我们熟知的 SGD 随机梯度下降。然而，要得到好的结果通常需要手动调整学习速度。或者在复杂的神经网络中，或者为了安全考虑，可以使用自适应优化器。

* Adagrad
* RMSprop
* Adam : 非常好用的一个优化器，大多数情况下可用。
* SparseAdam

后续也会单独写一篇博客对比各个优化器。

### 学习率

学习率一般有两种使用方法，一种是固定学习率，从 r = 0.001 开始以 10 的次方数量级变化选择一个合适的学习率。

* 太大：模型可能会发散或不收敛
* 太小：你的模型可能训练不出很好的效果

另外一种是变化的学习率，通常可以获得更好的效果。

* 每隔 k 个阶段(epoch)将学习速度减半

* epoch = 遍历一次数据 (打乱或采样的)
* 通过一个公式：$ lr=lr_0e^{−kt},\ \ for \ \  epoch \ \ t $
* 还有更新奇的方法，比如循环学习率(q.v.)

更高级的优化器仍然使用学习率，但它可能是优化器缩小的初始速度——因此可以从较高的速度开始。



