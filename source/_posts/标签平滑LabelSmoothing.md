---
title: 标签平滑LabelSmoothing
toc: true
mathjax: true
cover: >-
  https://cdn.jsdelivr.net/gh/hiyoung123/images/feature/undraw_my_app_re_gxtj.svg
tags:
  - Trick
  - 损失函数
  - 正则化
categories:
  - 深度学习
excerpt: Label Smoothing 是一种在分类任务中，防止过拟合的正则化方法，是对损失函数的修正，可以有效的提高模型的泛化能力。
abbrlink: 1632aa17
date: 2021-04-04 21:38:48
---

>  论文：[《When does label smoothing help？》](https://arxiv.org/pdf/1906.02629.pdf) 

标签平滑（Label Smoothing）是最近我在比赛中学到的上分 Trick，然后找到相应的论文学习一下，看看它是如何对模型提高性能的。

## 交叉熵损失函数的问题

在分类任务中，最常见的损失函数是交叉熵损失。给定一个数据，经过神经网络模型的计算后输出一个值，我们称为置信度 $z$，然后经过 Softmax 归一化后得到该数据属于各个类别的概率值。

<center>$q_i = {exp(z_i)\over \sum_{j=1}^K exp(z_j)}$</center></br>

然后根据与之对应的真实 label 计算 loss：

<center>$loss = -\sum_{i=1}^K p_i log q_i $</center></br>

其中 $p_i$ 是预测的概率值，而对于真实标签 $q_i$ 我们总是使用 one-hot 编码来表示，所以如果真是标签的类别为 $i$ ，那么 $q_i=1$，而对于其他类别 $q_{\neq i}=0$。

训练模型的目的就是为了最小化损失函数，让预测值与真实标签尽可能相等。所以通过一段时间的训练后，通过最小化交叉熵损失函数，会得到最优的概率分布。

<center>$p_i = \begin{cases} 1, &if (i=y) \\ 0, & if (i\neq y) \end{cases}$</center></br>

同时置信度 $z$ 也有如下分布

<center>$z_i = \begin{cases} +\infty, &if(i =y) \\ 0, & if(i\neq y) \end{cases}$</center></br>

因为只有当 $z_i$ 趋近于 $+\infty$ 时，$p_i$ 才可能等于 1 。

交叉熵损失函数会尽可能的扩大正负输出概率之间的差值，也就是标签为 $q_i$ 的样本，输出概率 $p_i$ 尽可能的无限趋近于 1。但是这种过于追求完全准确，会让模型过于自信，在训练集上会有好的效果，但是缺少泛化能力，也就是在验证集（未知数据）上没有很好的效果，也就是模型过拟合。

## 什么是标签平滑

Label Smoothing 是一种在分类任务中，防止过拟合的正则化方法，是对损失函数的修正，可以有效的提高模型的泛化能力。在计算交叉熵损失时，对输出的概率做一些调整，并不是一味的追求预测概率为 1，而是得到些许平滑的 $1-\xi$ ，从而使它对自己的答案不那么自信。

调整后的概率分布为

<center>$p_{i_{update}} = \begin{cases}(1-\xi), & if(i=y) \\ {\xi\over K-1}, & if(i\neq y) \end{cases}$</center></br>

调整后的交叉熵损失函数为

<center>$loss_{i_{update}} = \begin{cases}(1-\xi)*loss , & if(i=y)\\ \xi * loss, & if(i\neq y) \end{cases}$</center></br>

最终模型抑制正负样本输出概率的差值，使模型有更好的泛化能力。

## Pytorch实现

```python
import torch.nn as nn
import torch.nn.functional as F
class LabelSmoothingCrossEntropy(nn.Module):
    def __init__(self, eps=0.1, reduction='mean'):
        super(LabelSmoothingCrossEntropy, self).__init__()
        self.eps = eps
        self.reduction = reduction

    def forward(self, output, target):
        c = output.size()[-1]
        log_preds = F.log_softmax(output, dim=-1)
        if self.reduction=='sum':
            loss = -log_preds.sum()
        else:
            loss = -log_preds.sum(dim=-1)
            if self.reduction=='mean':
                loss = loss.mean()
        return loss*self.eps/c + (1-self.eps) * F.nll_loss(log_preds, target, reduction=self.reduction)
```

## 实验结果



## 在知识蒸馏中的效果

论文中最后讨论了在知识蒸馏中，即使在 Teacher Model 中使用 Label Smoothing 会提高性能，但是 Student Model 却没有好的性能。

标签平滑产生的模型是不好的 Teacher Model  的原因是通过强制将最终的分类划分为更紧密的集群，使 Teacher Model 删除了更多的细节，将重点放在类之间的核心区别上。

这种舍入有助于 Teacher Model 更好地处理不可见数据。然而，丢失的信息最终会对它教授 Student Model 的能力产生负面影响。 

## 总结

Label Smoothing 被证实在需要任务中有良好的性能表现，除了 CV 领域，在 NLP 领域也起到了不小作用。个人感觉，它之所以提高了模型泛化能力，原理与对抗训练有些类似，只不过是对抗训练是在计算梯度时添加了干扰噪声，而 Label Smoothing 是在计算 loss 的时候添加的噪声。那么如果我们换个位置添加噪声，是不是又是一个新的 Trick 了呢？