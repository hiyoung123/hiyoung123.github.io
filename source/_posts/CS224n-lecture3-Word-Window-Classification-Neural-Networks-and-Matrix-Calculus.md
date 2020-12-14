---
title: >-
  CS224n-lecture3 Word Window Classification, Neural Networks, and Matrix
  Calculus
abbrlink: b38e2b22
top: false
toc: true
mathjax: true
tags:
  - NLP
  - CS224n
  - 分类任务
  - NER
categories:
  - 自然语言处理
date: 2020-01-16 14:45:45
excerpt: CS224n 深度学习自然语言处理 2019 版 Lecture-3 学习笔记。
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

一般使用简单传统的 softmax 或者 logistic 回归能进行线性分类，有局限性。而现在的神经网络模型不仅可以学习到线性决策边界还可以学习到非线性的决策边界（依赖于非线性激活单元）。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec3_compare_001.png)

上图左边是传统机器学习的分类决策边界，右边是神经网络学习到的分类决策边界，可以看出神经网络模型是非线性的，更好的处理一些不易区分的数据。

剩下的内容主要是前馈神经网络的介绍，这里不详细介绍了，后续会在深度学习中讲解。

 

## Named Entity Recognition (NER)

命名实体识别，自然语言处理基本任务之一。该技术的主要工作就是从文本中找出命名实体，比如人名，地址名，组织名等。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec3_ner_example.png)

NER 的用途有：

* 跟踪文档中提到的特定实体（组织、个人、地点、歌曲名、电影名等）
* 对于问题回答，答案通常是命名实体
* 许多需要的信息实际上是命名实体之间的关联
* 同样的技术可以扩展到其他 slot-filling 槽填充分类

通常后面是命名实体链接/规范化到知识库，做知识图谱时 NER 是一项不可缺少的技术。

### Named Entity Recognition on word sequences

NER 的实现有多种方法，课程中提出了一种可以通过上下文对词进行分类，然后提取词的子序列来预测实体。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec3_ner_example_001.png)

### Why might NER be hard?

NER 的难点是有的时候很难区分Named Entity的边界，有的时候很难判断一个词是不是 Named Entity，而且 Named Entity 依赖于上下文，同一个名词可能在某些语境中是机构名，在其他语境中又是人名。



## Binary word window classification

通常情况下很少对一个词进行分类，鉴于同一个词在不同上下文可能是不同的 Named Entity，一个思路是通过对该词在某一窗口内附近的词来对其进行分类（这里的类别是人名，地点，机构名等等）。对窗口中的单词向量进行平均，并对平均向量进行分类。但是这种方法的缺点是会丢失词的位置信息。

### Window classification: Softmax

为了不丢失位置信息，可以将取平均向量改成将窗口内的各个词的向量串联起来，组成一个大的向量。

例如对于 museums in Paris are amazing, 我们希望探测到地点名 Paris。假设窗口大小为2，并且通过词向量方法如word2vec 得到窗口内 5 个单词的词向量（前两个 + 后两个 + 中心词），则我们可以将这 5 个向量连在一起得到更大的向量，再对该向量进行分类。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec3_class_softmax_001.png)

其中列向量 $x_{window} = x \in R^{5d}$。

得到了输入向量 $x_{windows}$ 后，就可以使用 softmax 分类器进行分类了，softmax 已经说过很多次就不重复说了：

<center>$\widehat{y}_y = p(y|x) = {exp(W_y \cdot x) \over \sum ^C_{c=1}exp(W_c \cdot x)}$</center>
其中 $\widehat{y}_y$ 是模型的预测值，C 为类别数量。对应的交叉熵损失函数表达式：

<center>$J(\theta) = {1\over N} \sum^N_{i=1} -log({e^{f_{yi}}\over \sum^C_{c=1}e^{f_c}})$</center></br>
这里说明一下，上面的式子不像交叉熵是因为这里把真实值得概率当作 1，所以这个式子只有一个概率分布。然后通过求导、梯度下降优化算法去更新参数。

### Binary classification with unnormalized scores

Binary classification with unnormalized scores 是 Collobert & Weston 在（2008, 2011）年提出的一个方法，并且在 2018 年获得了 ICML 2018 Test of time award。

主要思路就是通过有监督的学习，跟 word2vec 一样，遍历语料库中的所有位置信息，当中心词是一个实际真实的位置实体时，它会得到一个很高的 score。

### Neural Network Feed-forward Computation

使用一个三层的神经网络来计算窗口的得分：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec3_class_score_nn_001.png)

### The max-margin loss

对于目标函数的一些想法，就是让正确窗口的得分 $s$ 越大，而错误窗口的得分 $s_c$ 越小。则朴素的思路是最大化 $s−s_c$ 或最小化 $s_c−s$。让正确窗口的得分和错误窗口的得分差距最大化。

$s $　= score(museums in Paris are amazing)
$s_c$  = score(Not all museums in Paris)

> 注意只有命名实体在窗口的中心位置才认为该窗口为正确的。

目标函数为最大间隔目标函数，它通常作为 SVM 的目标函数：

<center>$J = max(0,1-s+s_c)$</center></br>
同样优化算法使用的是随机梯度下降算法，梯度计算时用到的技术叫做反向传播，以后会在深度学习中介绍。同时需要提醒的是，使用矩阵向量计算，会比迭代的方式计算梯度快的多很多。



## Conclusion

最后剩下时间都是在练习矩阵梯度的计算、雅可比矩阵等其他矩阵知识，重复的内容这里就不再多说，后续会有专门的文章记录一下。

本节课的内容，对于我个人来说感觉没有特别深入的内容，不像之前讲解 word2vec 的时候。提到的分类和 NER 都是很潜的说一下，更像是引出神经网络一样。看来具体的技术内容还需要去阅读其他论文才可以。