---
title: >-
  CS224n-lecture3 Word Window Classification, Neural Networks, and Matrix
  Calculus
abbrlink: b38e2b22
tags:
---

> CS224n 深度学习自然语言处理 2019 版 Lecture-3 学习笔记。

本节课主要内容是通过分类和实体命名识别两个任务来认识一下深度学习在 NLP 中的应用，后续又讲解了神经网络以及梯度计算。



## Classification setup and notation 

首先看一下分类任务情况下的一般符号表示，通常会有一个训练数据集，包含的数据一般形式为：

<center>$\begin{Bmatrix}x_i,y_i\end{Bmatrix}^N_{i=1}$</center></br>
其中

* $x_i$ 是输入，例如单词（索引或者是词向量），句子或者文档等。维度一般表示为 d。

* $y_i$ 是我们需要预测的标签，是类别中的一种，例如感情色彩，命名实体或者购买/卖出的决定等。
* N 是数据集的大小。

### Classification intuition

对于基本的二分类任务，通常最简单的办法是使用 softmax/logistic 回归模型，训练权重 w，找到决策边界将数据集进行正确划分。可视化表示：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec3_class_visa_001.png)

使用 softmax 回归的公式为：

<center>$p(y|x) = {exp(W_y,x)\over \sum^C_{c=1} exp(W_Cx)}$</center></br>

### Details of the softmax classifier

将上述的预测函数分为两个步骤介绍：

* 取 W 的第 y 行与 x 相乘：

  <center>$W_y x = \sum^d_{i=1} W_{yi} x_i = f_y$</center></br>

  计算所有的 $f_c, c\in 1,2,\dots,C$。

* 使用 softmax 函数得到归一化的概率：

  <center>$p(y|x) = {exp(f_y)\over \sum^C_{c=1}exp(f_c)} = softmax(f_y)$</center></br>

通俗一点的讲，就是将要预测的数据 x 与每一个分类类别所对应的权重 $W_y$ 相乘（有几个类别就有几组权重），然后将相乘的结果送入到 softmax 中计算分类得分，这样一个输入数据 x 就有了 C 组得分，C 是分类的类别个数。而最终在这些得分里，哪组的得分最高，也就是数据 x 属于该类别的概率最高，最后就认为 x 属于该类别。

### Training with softmax and cross-entropy loss

对于每个训练样本 $(x,y)$，目标函数是最大化正确分类 y 的概率，等价于该类最小化负对数概率（一般优化算法中都喜欢使用最小化，凸优化理论相关的知识）。

<center>$-logp(y|x) = -log({exp(f_y)\over\sum^C_{c=1}exp(f_c)})$</center></br>

###　What is “cross entropy” loss/error?

交叉熵是信息论中的概念，用于衡量两个分布 p 和 q 之间的差异。在这里使用 p 代表真实值，使用 q 代表模型预测值，那么交叉熵损失函数的公式为：

<center>$H(p,q) = -\sum^C_{c=1} p(c)log q(c)$</center></br>

具体交叉熵的介绍可以看我另外一篇博客[信息熵总结](https://hiyoungai.com/posts/686d9456.html)。

### Classification over a full dataset

交叉熵损失函数在整个数据集上的表达形式：

<center>$J(\theta) = {1\over N} \sum^N_{i=1} -log({e^{f_{yi}}\over\sum_{c=1}^Ce^{f_c}})$</center></br>

其中：

<center>$f_y = f_y(x) = W_yx = \sum^d_{j=1}W_{yj}x_j$</center></br>

使用矩阵的方式表示 f：

<center>$f = Wx$</center></br>

### Traditional ML optimization

通常基本的机器学习模型参数 $\theta$ 只包含一列 W：

<center>$\theta = \left[ \begin{matrix} W_{.1} \\ \vdots \\ W_{.d} \end{matrix} \right]$</center></br>

所以只需要根据参数 $\theta$ 的梯度来更新决策边界：

<center>$\nabla_\theta J(\theta) = \left[ \begin{matrix} \nabla W_{.1} \\ \vdots \\ \nabla W_{.d} \end{matrix} \right] \in R^{Cd}$</center></br>



## Neural Network Classifiers



