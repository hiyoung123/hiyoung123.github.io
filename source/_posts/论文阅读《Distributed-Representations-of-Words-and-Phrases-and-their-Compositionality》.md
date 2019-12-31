---
title: 论文阅读《Distributed Representations of Words and Phrases and their Compositionality》
abbrlink: 28911bbb
top: false
cover: false
toc: true
mathjax: true
tags:
  - NLP
  - 人工智能
  - 分布式词表示
  - Hierarchical Softmax
  - 负采样
  - Skip-gram
categories:
  - 自然语言处理
date: 2019-12-31 17:45:45
excerpt: 论文《Distributed Representations of Words and Phrases and their Compositionality》阅读笔记。
---

## 前言

Tomas Mikolov 大神的另一篇论文，本篇讲解 skip-gram 模型以及优化和扩展。主要包括层次 Softmax，负采样等内容。还有的就是使用 skip-gram 模型学习短语的表示。



## 介绍

最近提出的 skip-gram 模型是一种高效的学习高质量分布式向量表示的方法，可以捕获到大量精确的词之间的关系。在本篇论文中，提出了几个提高质量和训练速度的方法。词表示的一个缺陷是对词序不受影响（基于词袋模型，所以不考虑词序），所以有些短语无法得到正确的表示。为了解决这个问题，作者想出来一个办法，可以使模型正确的学习到数百万短语的词向量。

Skip-gram 模型的训练不涉及密集的矩阵乘法，这使得训练非常快速，大概一天内可以训练超过 1000 亿个单词。经过良好学习后的词向量甚至可以进行线性运算，比如：

<center>$\vec{Madrid} - \vec{Spain} + \vec{France} = \vec{Paris}$</center></br>
注意，这里的等于指代的是运算后得到的词向量与$\vec{Paris}$的距离（比如余弦距离）最接近。

Skip-gram 的模型结构：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_paper_002_sg_001.png)

该论文提出了几点优化扩展，比如对高频率词进行重采样，可以提高训练速度（大约 2倍 - 10倍），并且提高了低频词的向量表示。此外还提出了一种简化的噪声对比估计（Noise Contrastive Estimation, NCE），与之前使用层次 Softmax 相比，能够更快的训练和更好的表示频繁单词。

从基于单词的模型扩展到基于短语的模型相对简单，文中使用数据驱动的方法识别大量的短语，然后将短语作为单独的标记来处理。为了评估短语向量的质量，作者开发了一套包含单词和短语的类比推理任务测试集，效果如下：

<center>$\vec{Montreal Canadiens} - \vec{Montreal} + \vec{Toronto} = \vec{TorontoMaple Leafs}$</center></br>
最后作者惊奇的发现（作者总会惊奇的发现点什么。。。），对词向量进行简单的运算可以得到一些有意思的结果，比如：

<center>$\vec{俄罗斯} + \vec{河} = \vec{伏尔加河}$</center>
<center>$\vec{德国} + \vec{首都} = \vec{柏林}$</center></br>



## Skip-gram 模型

Skip-gram 的训练目标是能够预测文本中某个词周围可能出现的词。比如，现在有一份文档（去掉标点符号）由 T 个词组成，$w_1,w_2,w_3,\dots,w_T$， skip-gram 的目标函数就是最大化它们的平均对数概率：

<center>${1\over T}\sum^T_{t=1} \sum_{-c\leq j \leq c,j\neq 0}logP(w_{t+j}|w_t)$</center></br>
其中 c 是上下文窗口大小，c 的值越大，对于中心词来说上下文词越多，会产生更多的训练实例，从而导致更高的准确度。但是代价是花费更多的训练时间。其中概率 $P(w_{t+j}|w_t)$使用 Softmax 函数计算：

<center>$P(w_O|w_I) = {exp(v_{w_O}^T v_{w_I})\over \sum^W_{w=1} exp(v_w^T v_{w_I})}$</center></br>
其中，$v_{w_i}$和$v_{w_O}$是输入输出向量，W 是词汇表中单词个数。这个公式是不切实际的，因为计算$log P(w_O|w_I)$的代价很高，通常与 W 成正比，而 W 一般比较大（$10^5–10^7$）。所以为了优化这个计算量，推出了下面的方法。

### 层次 Softmax

Hierarchical Softmax 层次 Softmax，使用霍夫曼二叉树来表示输出层，W 个词分别作为叶子节点，每个节点都表示其子节点的相对概率。总词汇中的每个词都有一条从二叉树根部到自身的路径。用 n(w,j) 来表示从根节点到 w 词这条路径上的第 j 个节点，用 ch(n) 来表示 n 的任意一个子节点，设如果 x 为真则$[x]=1$，否则$[x]=-1$。那么 Hierarchical Softmax 可以表示为：

<center>$P(w|w_I) = \prod^{L(w)-1}_{j=1}\sigma ([[n(w,j+1)=ch(n(w,j))]]\cdot v_{n(w,j)}^T v_{w_I})$ </center></br>
其中：

<center>$\sigma (x) = sigmoid(x) = {1 \over 1 + exp(-x)} $</center></br>
$\sum^W_{w=1}P(w|w_I)=1$ 是可以验证的，这样一来 $logP(w_O|w_I)$ 和 $∇logP(w_O|w_I)$ 的计算开销就和 $L(w_O)$ 成比例。而 $L(w_O)$ 不会超过 $log⁡W$。

最大的优点：

* 由于是二叉树，在输出层不需要计算 W 个节点，而只需要计算 log(W) 即可。
* 由于使用霍夫曼树是高频的词靠近树根，这样高频词需要更少的时间会被找到。这对于神经网络语言模型是简单且高效的加速训练技术。

### 负采样

Noise Contrastive Estimation (NCE) 噪声对比估计，假设一个好的模型可以通过逻辑回归（logistic regression）来区分正常数据和噪声。这与 Collobert 和 Weston 通过将数据排列在噪声之上来训练的合页损失函数（hinge loss）比较相似（论文原话，没搞懂什么意思，没具体研究过）。

因为 skip-gram 更关注于学习高质量的词向量表达，所以可以在保证词向量质量的前提下对 NCE 进行简化。于是定义了 NEG(Negative Sampling)：

<center>$log\sigma(v_{w_O}^T v_{w_I}) + \sum^k_{i=1}E_{w_i - P_n(w)}[log\sigma(-v_{w_i}^Tv_{w_I})]$</center></br>
这个公式用来替代 skip-gram 目标函数中的 $logP(w_O|w_I)$。 其中$P_n(w)$ 是词 n 周围的噪声词分布（NCE 和 NEG 都有这个参数）。这个公式是用逻辑回归从 k 个负例中区别出目标词汇 $w_O$。对于小的训练集 k 的最佳取值是 5-20， 对于大的训练集 k 的取值会更小，大概 2-5。NCE 和 NEG 的区别在于 NCE 在计算时需要样本和噪音分布的数值概率，而 NEG 只需要样本。

### 高频词的二次采样

在非常大的语料库中，最频繁的单词很容易出现数亿次（例如**in**、**the**和**a**），这样的词通常比罕见的词提供的信息价值更少。为了解决低频词和高频词之间的不平衡，论文提出了一种简单的二次采样方法，即每个词都有一定的概率被丢弃，这个概率计算方式为：

<center>$P(w_i) = 1 - \sqrt{t\over f(w_i)}$</center></br>
其中$f(w_i)$是词$w_i$的频率，t 是一个阈值，一般在 $10^{-5}$ 左右。当某个词的频率高于 t 就有一定概率被淘汰掉，所以高频率的词越容易被淘汰。

这个方法是启发式的，但是在实践中很有效（个人认为通过重采样平衡数据，可以更好的学习到低频词。同时随机性丢弃又增加了数据多样性，提高了泛化能力，符合深度学习理论）。



## 实验结果

为了训练 Skip-gram 模型，作者们使用了一个由各种新闻文章组成的大型数据集（一个包含 10 亿字的内部 Google 数据集）。从词汇中剔除了所有在训练数据中发生的少于 5 次的单词，从而产生了 692K 的词汇量。对比了各种 Skip-gram 模型在单词模拟测试集上的性能。NCE 代表噪声对比估计，NEG 代表了负采样，HS-Huffman 代表霍夫曼层次 Softmax。测试集使用的依然是之前构造的推理测试集。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_paper_002_subsampling_001.png)

从图中可以看出，效果最好的是 NEG。



## 学习短语

正如前面所讨论的，许多短语的含义并不是由单个单词的含义组成的。要学习短语的向量表示，首先要找到经常出现在一起的单词，并且组成一个 Token 作为一个词处理。简单地使用 n-gram, 会大大增大单词表, 并不是一种恰当的做法。文章使用了一个基于 unigram, bigram 的数据驱动方法，对于两个词 $w_i,w_j$：

<center>$score(w_i,w_j) = {count(w_iw_j) - \delta \over	count(w_i) \times count(w_j)}$</center></br>
其中$\delta$是惩罚项，用来避免太多无关的词被组合到一起。同时文章提出了一个数据集，用于评价该模型得到的短语质量（文章结尾给出地址）。

### 短语 Skip-gram 结果

与训练词向量相同，超参数使用 300 维度的词向量和大小为 5 的 window。对比结果如下：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_paper_002_resul_phrase_001.png)

为了最大限度地提高短语类任务的准确性，作者增加了训练数据量，使用了大约 330 亿个单词的数据集。使用层次结构的 softmax, 1000的维度，以及整个上下文。这使得模型的准确率达到了 72%。当将训练数据集的大小减少到 6B 个单词时，准确率降低了 66%，这表明大量的训练数据是至关重要的。

下图展示了不同模型的实际效果：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_paper_002_example_phrase_001.png)

通过比较，作者们发现，似乎最好的短语表示是通过一个层次 softmax 和 Subsampling 结合的模型来学习的。



## 可加性/合成性

通过对训练目标的考察，可以解释向量的可加性。词向量与 Softmax 非线性的输入呈线性关系。通过训练单词向量来预测句子中周围的单词，向量可以被看作是单词出现时上下文的分布。这些值与输出层计算的概率呈对数关系，因此两个词向量的和与两个上下文分布的乘积有关。乘积在这里充当 AND 函数：两个词向量都赋予高概率的词将具有高概率，而其他词将具有低概率。因此，如果“伏尔加河”与“俄语”和“河流”这两个词频繁出现在同一句话中，那么这两个词的向量之和就会形成一个与“伏尔加河”向量相近的特征向量。



## 词向量比较

本文使用 skip-gram 模型与传统词向量模型做了对比：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_paper_002_result_word_vec_001.png)

从对比结果可以看出，skip-gram 有明显的优势，可能这是由于 skip-gram 使用了大量级的数据集训练得到的词向量。尽管如此，skip-gram 的训练时间依然比其他模型要少的很多。



## 总结

论文指出, 在他们的实验中, 发现不同的问题具有不同的最优超参数配置。影响性能的最关键的决策是：

* 架构的选择
* 词向量的维度
* 采样率
* 训练窗口的大小

以上介绍的用于优化 skip-gram 的技术同样适用于 CBOW。除此之外，论文中提出的用于获取短语的模型算法也值得研究研究。



## References

官方数据集与代码：https://code.google.com/archive/p/word2vec/source/default/source