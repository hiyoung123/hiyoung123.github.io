---
title: CS224n-lecture1 Introduction and Word Vectors
abbrlink: 2878d2b0
tags:
---

## Human language and word meaning

nltk是什么

wordnet是什么

one-hot

通过上下文表示词

词向量

分布式表示

word2vec:是一个学习词向量的框架。

语料库是文本的主体。

两个向量的内积的含义是什么

**定义**：两个向量**a**与**b**的内积为 **a**·**b** = |**a**||**b**|cos∠(a, b)，特别地，**0**·**a** =**a**·**0** = 0；若**a**，**b**是非零向量，则**a**与**b\**\**正交**的充要条件是**a**·**b** = 0。

softmax

分子加exp是为了防止向量内积为负数，分母归一化将整个公式转变成概率分布。

优化

log的导数

指数的倒数

语言模型

SVD

Skip-gram

CBOW

负采样

层次SoftMax

Jaccard,

Cosine,余弦距离

Euclidean欧氏距离

NCE Noise Contrastive Estimation 噪声对比估计

* 
* Word2vec introduction
* Word2vec objective function gradients
* Optimization basics
* Looking at word vectors