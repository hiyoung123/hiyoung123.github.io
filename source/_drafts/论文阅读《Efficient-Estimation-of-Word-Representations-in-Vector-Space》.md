---
title: 论文阅读《Efficient Estimation of Word Representations in Vector Space》
abbrlink: fcba888f
tags:
---

## 前言

这篇论文发表于 2013 年，作者是 Tomas Mikolov，也就是提出 Word2vec（Google 时期）和 Fasttext（Facebook 时期）的大佬。本篇文章主要讲的就是 Word2vec 框架，也就是从这开始，Mikolov 将大家从语言模型时代带入了词嵌入的时代。



## 摘要

论文提出了两种可以从大规模语料库中学习到词向量表示的模型，可以用于计算词相似度的任务。并且相比以往的模型取得了不错的性能和准确度。在 1.6 亿规模的数据集训练只花了一天的时间。



## 介绍

传统的 NLP 系统和技术都将单词作为基本计算单位，词之间没有相关性，只是认为是词库的索引。这样的选择虽然简单，鲁棒性好和可观察，比如语言模型 N-Gram。虽然可以用到大多数任务中，但是还是具有局限性。

随着计算机算力水平的提高，现在可以实现在大数据集进行复杂模型的计算。最成功的可能就是分布式词表示，广泛用于神经网络语言模型等任务，并且性能表现优于 N-Gram 模型。

### 论文目标

本篇论文的目的是可以从数十亿级别的语料库中训练出高质量的词向量，并且词向量之间具有相似度关系，如意思相近的词挨得比较近，而且每个单词可以具有多个相似度。

该论文还发现了单词的向量表示，不仅可以简单的表示相似性，还可以通过词偏移技术进行代数运算：

<center> $\vec{King} - \vec{Man} + \vec{Woman} = \vec{Queen}$</center> </br></br>

### 先前工作



## 模型结构

### 前向神经网络语言模型（NNLM）

### 循环神经网络语言模型（RNNLM）

### 并行训练

## 新的对数线性模型

### 继续词袋模型（CBOW）

### 跳词模型（Skip-gram）

## 结果

### 任务描述

### 最好结果

### 比较模型结构

### 大规模并行训练模型

### Microsoft Research Sentence Completion Challenge

## Examples of the Learned Relationships

## 结论

