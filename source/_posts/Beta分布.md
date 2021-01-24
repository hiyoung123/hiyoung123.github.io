---
title: Beta分布
toc: true
mathjax: true
date: 2021-01-24 10:31:42
cover: https://cdn.jsdelivr.net/gh/hiyoung123/images/feature/undraw_coffee_break_h3uu.svg
tags:
  - Beta函数
categories:
  - 概率论与数理统计
excerpt: Beta 分布学习笔记。
---

## 前言

在 [共轭先验分布](https://hiyoungai.com/posts/b6eca691.html) 中已经简单介绍过 Beta 分布了，这里只做简单的笔记记录。更详细的内容可以参考 [【统计学进阶知识（一）】深入理解Beta分布：从定义到公式推导](https://zhuanlan.zhihu.com/p/69606875)。

## 介绍

1. Beta 分布是一种连续型概率密度函数分布, 由形状参数 $a, b$ 决定。
2. Beta 分布可以看作一个概率的概率密度分布，当你不知道一个东西的具体概率是多少时，它可以给出了所有概率出现的可能性大小。
3. 推导过程:$\int_0^1 k\cdot q^a \cdot (1-q)^b dq =1, 则 k= {1 \over \int_0^1 q^a \cdot (1-q)^b dq}, 令 \beta(a+1, b+1) = \int_0^1 q^a \cdot (1-q)^b dq, 则 \beta 分布为 f(a+1, b+1, q) = {1\over \beta(a+1, b+1)} \cdot q^a \cdot (1-q)^b. \\ 将a+1和b+1替换为a和b, 将q 替换为t, \beta 函数为: \beta(\alpha, \beta) = \int_0^1 t^{\alpha -1}(1-t)^(\beta-1) dt, \beta 分布函数为: f(\alpha , \beta, x) = {1\over \beta(\alpha, \beta)} x^{\alpha -1} (1-x)^{\beta -1} $
4. 期望: $\alpha \over \alpha + \beta$
5. 方差: ${\alpha \beta}\over  (\alpha + \beta + 1)(\alpha + \beta)^2$
6. $\beta (\alpha, \beta) = {\Gamma(\alpha) \Gamma(\beta)\over \Gamma(\alpha + \beta)}$
7. Beta 分布的概率分布函数: $F(x) = {1\over B(\alpha, \beta)} \int_0^x x^{\alpha-1}(1-x)^{\beta-1}dx$, 其中 $\beta(\alpha, x, \beta) = \int_0^x x^{\alpha-1}(1-x)^{\beta-1}dx$ 称为不完全Beta函数.则$F(x) = {\beta(\alpha, x, \beta)\over \beta(\alpha, \beta)}$
8. Beta分布与二项分布的关系: 进行 $n$ 次伯努利试验，其出现试验成功的概率 $p$ 服从一个先验概率密度分布 $\beta (\alpha, \beta)$，试验结果出现 $k$ 次试验成功，则试验成功的概率 $p$ 的后验概率密度分布为 $\beta(a+k, \beta+n-k)$
9. Beta分布与均匀分布的关系: 当$\alpha=1, \beta=1$时就是均匀分布.

## 参考

1. https://zhuanlan.zhihu.com/p/69606875
2. https://www.zhihu.com/question/31407058