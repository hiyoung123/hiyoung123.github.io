---
title: 文本去重算法-SimHash
toc: true
mathjax: true
tags:
  - 文本去重
  - 局部敏感哈希
  - simhash
  - 汉明距离
  - 哈希算法
  - hash
categories:
  - 自然语言处理
excerpt: Google 出品的一款简单高效的文本去重算法 - simhash。
abbrlink: 3e122ce4
date: 2021-06-18 20:41:18
---

## 介绍

SimHash 算法是 Google 出品的一款短小精悍，用来处理海量文本去重的算法。

它的大概思路是，将文本通过 hash 映射到一个低纬向量中，然后使用局部敏感 hash 的思想，将向量映射为二进制向量。最后通过计算文本间的 hamming 距离，从而判断文本是否相同。

SimHash 算法具有实现简单，计算速度快的优点。但是因为是通过 hash 计算，所以会因为 hash 碰撞从而出现误判的问题。并且相比 bloom filter 和 single 去重算法，simhash 的准确率略有不足。

不过由于局部敏感 hash 的原因，simhash 是求两个文本近似相似，而不是像 bloom filter 那样必须完全一致才是相同的。就算两个文档有些许的内容不同，通过 simhash 也可能会得到结果为相同的文档，这个可以通过调节计算 hamming 距离的阀值控制。

## 算法流程

* 分词：将文本进行分词处理。

* Hash：将每个词进行 Hash 处理成固定长度（一般为 64 位或 128 位）的二进制特征编码，即每一位非 0 即 1。

* 加权：根据每个词的权重（如 TF-IDF）对特征编码进行加权：

  $W = Hash * Weight$

  其中，如果对应位的 hash 值为 0，那么 hash 乘上权重的负数

  $ W = Hash * -Weight $

* 合并：将所有词计算后的 $W$ 进行按位累加。

* 降维：对于上述累加结果的每一位，如果大于 0 则置 1 ，否则置 0。从而得到每一位都是 0/1 的 SimHash 编码。

* 计算：通过上述方法得到了两个文本的 SimHash 编码，然后计算两者的汉明距离，得到的距离如果小于等于 n（一般为 3），则表示两个文本是相同的。

![img](http://images.yanyiwu.com/simhash.jpg)

详细代码：https://github.com/hiyoung123/simhash

## 去重算法



