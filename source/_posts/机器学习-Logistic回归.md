---
title: 机器学习-Logistic回归
top: false
cover: false
toc: true
mathjax: true
tags:
  - 机器学习
  - 逻辑回归
  - Logistic
  - Sigmoid
  - Softmax
categories:
  - 机器学习
abbrlink: c237bc03
date: 2019-11-27 22:19:51
password:
summary:
---

# 机器学习-Logistic回归

## 简介

Logistic回归是机器学习中最常用最经典的分类方法之一，有的人称为逻辑回归或逻辑斯蒂回归。虽然它称为回归模型，但是却处理的是分类问题，这主要是因为它的本质是一个线性模型加上一个映射函数sigmoid，将线性模型得到的连续结果映射到离散型上。它常用于二分类问题，在多分类问题的推广叫做softmax。 

## Logisitc回归

由于Logistic回归是将线性模型的输出$ \theta x+b$经过$f(z)$数处理后，映射到离散值上形成分类问题，所以我们可以假设分类值$y=\{0，1\}$，所以Logistic回归模型可以写成：$h(x)=f(θx+b) $，也就是当$ \theta x+b$的值大于0时$h(x)=+1$，当$θx+b$的值小于0时$h(x)=-1$。但是这样的$f(z)$函数称为单位阶跃函数，但是它的数学性质不好，不连续也不方便求导，所以我们使用它的替代函数sigmoid函数也叫s型函数，我们用$g(x)$表示。这样线性模型的输出经过sigmoid的映射就变成了求出样本属于哪一类别的概率，即$θx+b>0$的话，那么样本属于分类1的概率大一点，如果$θx+b<0$的话就是样本属于1的概率小属于类别0的概率大一些。图1是单位阶跃函数（红线）与sigmoid函数（黑线）。 

![图1](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_ml_logic_sigmoid.webp)

sigmoid的函数表达式为： 

 <center> $y={1\over1+e^{-z}}$ <br><br> </center >


其中z在Logistic回归中就是$θx+b$。那么为什么要用sigmoid函数呢？ 

## Sigmoid函数

从概率的角度看Logistic回归，如果将样本分为正类的概率看成$h(x)$，那么分为负类的概率就是$1-h(x)$，则Logistic回归模型的概率表达式符合$0-1$分布： 

<center> $P(y=1|x;θ) = h_θ(x)$ <br><br> </center >
<center> $P(y=0|x;θ) = 1 - h_θ(x)$ <br><br> </center >


对上式结合就是Logistic回归的概率分布函数，也就是从概率角度的目标函数： 

<center> $P(y|x;θ) = (h_θ(x))^y(1 - h_θ(x))^{1-y}$  <br><br> </center >


我们对该式进行变换，可以得到指数族分布，最后可以得出函数$h(x)$就是sigmoid函数。以下是推导过程： 

![图2](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_logist_sigmoid_process.webp)

其中图2中的p是图4中的$h(x)$，而图2的z是线性模型的输出$θx+b$。这样从指数族分布就可以推出sigmoid函数。换一个思路，我们将一个事件发生的概率$p$与其不发生的概率$1-p$的比值叫做几率，对其取对数后称为对数几率（logit）：

<center> $log{p\over{1-p}}$ <br><br> </center >


令它等于线性函数θx+b，最后也可以推出$p$就是sigmoid函数，也就是图2的后半段，这样说明了sigmoid函数的值是概率值。另外，如果我们不让对数几率函数等于线性函数，让他等于其他的函数呢？这也是可以的，只不过是sigmoid函数中$z$的表达方式改变而已。 

## 求解Logistic回归模型参数

 我们重新整理一下Logistic回归的目标函数，他的最终形式为： 

<center> $h_θ(x) = g(θ^Tx) = {1\over{1 + e^{-θ^Tx}}}$ <br><br> </center >


因为这是一个概率问题，所以我们可以使用极大似然估计的方式求解Logistic回归的参数$θ$。以下是求导过程： 

![图3](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_loggist_process.webp)

 其中$g()$函数是sigmoid函数，它的导数为： 

<center> $g\prime(x) = ({1\over{1 + e^{-x}}})\prime= {e^{-x}\over(1 + e^{-x})^2}$ <br><br> </center >
<center> $= {1\over{1 + e^{-x}}}\cdot{e^{-x}\over{1 + e^{-x}}} = {1\over{1 + e^{-x}}}\cdot(1 - {1\over{1 + e^{-x}}})$ <br><br> </center >
<center> $= {g(x)\cdot(1 - g(x))}$ <br><br> </center >


这样图3得到的结果就是关于$θ$的梯度，我们通过梯度提升算法（因为目标函数是最大似然估计，求极大值所以用梯度上升，如果想用梯度下降，可以对似然函数取负就是求极小值）更新$θ$，最后就求出Logistic回归模型的参数$θ$，这与线性回归方法相同（有没有发现他们的更新梯度的目标函数也相同）。 

<center> $\theta_j:= \theta_j +  \alpha (y^{(i)} - h_\theta(x^{(i)}))x_j^{(i)}$ <br><br> </center >


以上就是Logistic回归模型的建立与参数估计过程，下面我们要说一下他在多分类问题中的推广-----softmax回归。 

## Softmax函数

Softmax与Logistic回归的主要区别就是，Logistic处理二分类问题，只有一组权重参数$θ$。而softmax处理多分类问题，如果有k个类别，那么Softmax就有k组权值参数。每组权值对应一种分类，通过k组权值求解出样本数据对应每个类别的概率，最后取概率最大的类别作为该数据的分类结果。它的概率函数为： 

<center> $p(c=k|x;\theta) = {exp(\theta^T_kx)\over{\sum^k_{I=1}exp(\theta^T_ix)}},k = 1,2,3\cdots$ <br><br> </center >


Softmax经常用于神经网络的最后一层，用于对神经网络已经处理好的特征进行分类。

## 总结

个人实现了一个二分类的逻辑回归，并与sklearn中的logistic回归做对比：

![图4](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_logist_compare_result.webp)

数据只使用了鸢尾花数据的0/1两个类别，由于本代码实现的比较简单，只能处理类别为0/1的数据，有兴趣的朋友可以自己做补充，本代码只做参考。 

详细代码可参考[Github]( https://github.com/hiyoung123/ML )

