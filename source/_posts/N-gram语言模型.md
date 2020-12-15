---
title: N-gram语言模型
toc: true
mathjax: true
tags:
  - NLP
  - N-gram
  - 语言模型
  - 困惑度
categories:
  - 自然语言处理
excerpt: N-gram语言模型笔记，以及代码实现预测下一词。
abbrlink: 853fc4e2
cover: https://cdn.jsdelivr.net/gh/hiyoung123/images/feature/undraw_visual_data_b1wx.svg
date: 2020-02-27 22:59:36
---

## 语言模型

计算文本序列概率的模型叫做语言模型（LMs）。下面简单介绍如何使用 n-gram 模型来估计给定前一个单词的n-gram的最后一个单词的概率，并将概率分配给整个序列。把 n-gram 一些重点内容记录一下：

形式

<center>$P(the|its \ water \ is \ so \ transparent \ that)$</center></br>
简单直观的计算方式使用统计计数

<center>$P(the|its \ water \ is \ so \ transparent \ that) = {C(its \ water \ is \ so \ transparent \ that \ the) \over C(its \ water \ is \ so \ transparent \ that)}$</center></br>
这种方式在有新的句子加入时不利于维护，所以可以使用链式法则求出概率：

<center>$\begin{align} P(x^{(1)},\cdots,x^{(T)}) &= P(x^{(1)})\times P(x^{(2)}|x^{(1)})\times \cdots \times P(x^{(T)}|,\cdots,x^{(1)}) \\ &= \prod^T_{t=1} P(x^{(t)}|x^{(t-1)},\cdots,x^{(1)})\end{align}$</center></br>
但是根据前面整个句子的概率去计算下一个词，计算量太大，并且也不是完全依赖前面所有的词。可以根据前几个词来计算概率，所以有了 n-gram 模型。

为了计算语言模型，我们需要计算词的概率，以及一个词在给定前几个词的情况下的条件概率，即语言模型参数。设训练数据集为一个大型文本语料库，如维基百科的所有条目。词的概率可以通过该词在训练数据集中的相对词频来计算。例如，$P(w_1)$可以计算为 $w_1$ 在训练数据集中的词频（词出现的次数）与训练数据集的总词数之比。因此，根据条件概率定义，一个词在给定前几个词的情况下的条件概率也可以通过训练数据集中的相对词频计算。例如，$P(w_2∣w_1)$可以计算为$w_1,w_2$两词相邻的频率与 $w_1$ 词频的比值，因为该比值即 $P(w_1,w_2)$ 与 $ P( w_1) $ 之比；而 $P(w_3|w_1,w_2)$ 同理可以计算为$w_1、w_2$ 和 $w_3$ 三词相邻的频率与 $w_1$ 和 $w_2$ 两词相邻的频率的比值。以此类推。



## N-gram 语言模型

N-gram 是一个由 n 个连续单词组成的块，它的思想是一个单词出现的概率与它前 n-1 个出现的词有关。也就是每个词依赖于前 n-1 个词。下面是一些常见的术语以及示例，可以帮助你更好的理解 N-gram 语言模型：

* Unigrams：一元文法，由一个单词组成的 token，例如： “the”, “students”, “opened”, ”their”。
* Bigrams：二元文法，也叫一元马尔科夫链。由连续两个单词组成的 token，例如：“the students”, “students opened”, “opened their”。
* Trigrams：三元文法，由连续三个单词组成的 token，例如：“the students opened”, “students opened their”。
* 4-grams：四元文法，由连续四个单词组成的 token，例如：“the students opened their”。

如何估计这些 n-gram 概率？估计概率的一种直观方法叫做极大似然估计（MLE）。可以通过从正态语料库中获取计数，并将计数归一化，使其位于 0 到 1 之间，从而得到 n-gram 模型参数的最大似然估计。

例如，要计算一个给定前一个单词为 x ，y 的 bigram 概率，将计算 bigram C(x y)的计数，并通过共享相同第一个单词 x的所有 bigram 的总和进行标准化。

<center>$P(X_n|X_{n-1}) = {C(X_{n-1} X_n) \over \sum_X C(X_{n-1}X)}$</center></br>
其中分子为 bigram C(x y) 在语料库中的计数，分母为前一个词为 x，后一个为任意词的 bigram 计数的总和。为了简单可以写成下面的形式：

<center>$P(X_n|X_{n-1}) = {C(X_{n-1} X_n) \over C(X_{n-1})}$</center></br>
这样就通过极大似然估计求得了概率值。但是有个问题是，在其他语料库中出现次数很多的句子可能在当前语料库中没有，所以很难进行泛化。下面是 n-gram 模型的稀疏性问题：

1. 如果要求的词没有在文本中出现，也就是分子的概率为 0。解决办法是添加一个很小的值给对应的词，这种方法叫做平滑，例如拉普拉斯平滑。这使得词表中的每个单词都至少有很小的概率。

2. 如果前 n-1 个词没有出现在文本中，也就是分母的概率无法计算。解决办法如使用 “water  is  so  transparent  that“ 替代，这种方法叫做后退。保证作为条件的分母概率值存在。（还有其他平滑技术）

3. 需要注意的是，概率是一个大于 0 小于 1 的数，随着相乘会变得很小。所以通常使用 log 的形式：

   $p_1 \times p_2 \times p_3 \times p_4 = exp(log\ p_1 + log\ p_2 + log \ p_3 + log\ p_4)$

4. 还有的是提高 n 的值会使稀疏性变得更糟糕，还会增加存储量，所以 n-gram 一般不会超过 5。

5. 当n>2时，比如 tigram，可能需要在头部添加两个start-token，后续看看效果如何。



## 平滑技术

上面提到过，一些 OOV 词汇，模型会分配 0 概率，这样是错误的。因而，必须分配给所有可能出现的字符串一个非零的概率值来避免这种错误的发生。平滑（smoothing）技术就是用来解决这类零概率问题的。提高低概率（如零概率），降低高概率，尽量使概率分布趋于均匀。

### 拉普拉斯平滑

Laplace Smoothing，做平滑的最简单的方法是在我们将它们归一化为概率之前，在所有的计数上加1。拉普拉斯平滑在现代 n-gram 模型中并没有得到很好的应用，但它很好地引入了我们在其他平滑算法中看到的许多概念，给出了一个有用的基线，也是文本分类等其他任务的实用平滑算法。下面在 1-gram 上看看拉普拉斯平滑：

<center>$P_{Laplace}(w_i) = {c_i + 1 \over N+V}$</center></br>
### 加法平滑

拉普拉斯平滑也算是加法平滑的一种，加法平滑的一般形式：

<center>$P_{Add-k}(w_n|w_{n-1}) = {C(w_{n-1}w_n)+k \over C(w_{n-1}+kV)}$</center></br>
尽管 add-k 在某些任务(包括文本分类)中很有用，但它在语言建模中仍然不能很好地工作，生成的计数方差很差。

### Katz 平滑

### Kneser-Ney  平滑

### Backoff and Interpolation



## 评估方法

### 困惑度

在 NLP 中，通常使用困惑度（Perplexity，PPL）作为衡量语言模型好坏的内部指标，此外还有外部指标需要人工评价

<center>$\begin{align} P(W) &= P(w_1 w_2 \cdots w_N)^{-{1\over N}} \\ &= \sqrt[N]{1\over P(w_1 w_2 \cdots w_N)} \\ &= \sqrt[N]{\prod^N_{i=1}{1\over P(w_i|w_1\cdots w_{i-1})}} \end{align}$</center></br>
对于 bigram 模型的困惑度：

<center>$PP(W) = \sqrt[N]{\prod^N_{i=1} {1\over P(w_i|w_{i-1})}}$</center></br>
困惑度越低，说明生成的语言越接近真实语言，常用于机器翻译和文本生成等 NLP 任务中。困惑度等价于交叉熵损失函数：

<center>$\begin{align} &= \prod^T_{t=1}({1\over \hat{y}^{(t)}_{x_{t+1}}})^{1\over T} \\  &=exp({1\over T \sum^T_{t=1}}-log\hat{y}^{(t)}_{x_{t+1}}) \\ &= exp(J(\theta)) \end{align}$ </center></br>
## References

1. [N-gram Language Models](https://web.stanford.edu/~jurafsky/slp3/3.pdf)
2. 《统计自然语言处理》- 宗成庆