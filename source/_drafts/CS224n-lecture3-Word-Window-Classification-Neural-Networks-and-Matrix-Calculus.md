---
title: >-
  CS224n-lecture3 Word Window Classification, Neural Networks, and Matrix
  Calculus
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



## Classification intuition

