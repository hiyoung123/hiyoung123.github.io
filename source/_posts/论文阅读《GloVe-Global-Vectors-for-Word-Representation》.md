---
title: '论文阅读《GloVe: Global Vectors for Word Representation》'
toc: true
mathjax: true
top: false
tags:
  - NLP
  - 人工智能
  - 全局词向量
  - GloVe
  - 共现矩阵
categories:
  - 自然语言处理
excerpt: '论文《GloVe: Global Vectors for Word Representation》阅读笔记。'
abbrlink: fb292938
date: 2020-01-12 17:29:02
---

## 前言

本篇论文是 CS224n 课程教师 Manning 大神所在的小组发布的，主要是介绍一种新的词向量表示模型 - GloVe。该模型结合了 Word2vec 框架和共现计数两种方法的优点：上下文窗口和全局矩阵分解，可以学习到全局的词向量表示。主要特点有计算速度快，对于大型和小型语料库都有不错的性能表现。这种模型能在词语类比任务的准确率能够达到 75%，并且在词相似度计算和命名实体识别（named entity recognition）中的表现也能比其他模型要好。下面我们来看一下这篇论文的主要内容吧。



## 介绍

词向量学习的主要两个模型：

* 全局矩阵分解方法，如隐语义分析（LSA）。
* 上下文窗口方法，如 Skip-gram 模型。

目前这两种方法都存在这缺陷，比如 LSA 可以很好的利用全局统计信息，但是在类比任务上没有好的表现。而 Skip-gram 正好相反，在词类比任务中有更好的表现，却无法利用全局统计信息。

论文作者提出了一种特殊的加权最小二乘模型，在训练全局 word - word 共现矩阵时可以有效的利用全局统计信息。该模型在词类比任务中可以达到 75% 的最优性能指标。并且在相似度任务和命名实体识别（NER）任务中也比其他模型要好。



## 相关工作

### 矩阵分解

矩阵分解方法最早可以追溯到 LSA，但是原本是 word - document 共现矩阵，在 GloVe 中作者改为 word - word 共现矩阵。word - word 共现矩阵比起 word - document 矩阵更加稠密，虽然 word - word 中也会有一些稀疏，但后续会有方法进行处理。这种方法的优点是可以学习到全局统计信息，并且通过降维技术，可以将稀疏矩阵压缩到 8 或者 9 个数量级的稠密矩阵。

### 基于窗口方法

这类是以 word2vec 为代表的方法，主要通过滑动窗口学习词上下文关系，可以很好的学习到语义关系，但是不能有效的使用统计信息。



## GloVe 模型

作者认为词与词之间共现的统计数据是作为词向量的重要依据，因此 Glove 词向量的本质也是意图利用这种共现的次数来构造。首先介绍一些符号：

* $X$：word - word 共现矩阵
* $X_{ij}$：单词 $j$ 在单词 $i$ 的上下文出现的次数
* $X_i=\sum_k X_{ik}$：表示任何单词出现在单词 $i$ 的上下文总次数
* $P_{ij}=P(j|i)=X_{ij}/X_i$：表示单词 $j$ 出现在单词 $i$ 的上下文的概率

下面通过一个例子来说明一下上面各个符号的具体含义：

考虑两个在某些方面比较类似的词：$i$ 代表 ice，$j$ 代表 steam。这两个词的关系可以通过研究它们与某个词 $k$ 的共现概率之比来得到。例如，$k$ 是某个和 ice 相关但是和 steam 无关的词，比如 k = solid，那么 $P_{ik}/P_{jk}$ 将会很大；而当 $k$ 和steam 相关但是和 ice 无关时，比如 k = gas，这个比值将会很小。还有 $k$ 和两个词都相关（k=water）或者和两个词都不相关（k=fashion），这个比值将接近于1。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_paper_glove_example_001.png)

上面的例子表明，词向量的学习应该从共现概率的比值开始而不是概率本身。由于 $P_{ik}/P_{jk}$ 依赖于三个单词 $i,j$ 和 $k$，因此模型的一般形式如下：

<center>$F(w_i,w_j,\widetilde{w}_k) = {P_{ik}\over P_{jk}}$</center></br>
其中 $w∈R^d$ 表示词向量，$\widetilde{w}∈R^d$ 表示上下文词向量。

我们希望 F 能在向量空间中编码 $P_{ik}/P_{jk}$这个信息。由于向量空间是线性的，最自然的方法就是对向量做差。因此 F 变成如下形式：

<center>$F((w_i - w_j),\widetilde{w}_k) = {P_{ik} \over P_{jk}}$</center></br>
由于公式右边是一个实数，而左边的参数是向量，尽管 F 可以代表像神经网络一样的复杂结构，但这样的结构会打乱我们希望获得的线性结构，因此为了避免这种情况，首先对参数做点积：

<center>$F((w_i - w_j)^T \widetilde{w}_k) = {P_{ik} \over P_{jk}}$</center></br>
我们注意到 $w_i$ 到 $w_j$ 的距离与 $w_j$ 到 $w_i$ 的距离是相等的，并且共现矩阵是一个对称的矩阵，即 $X^T==X$，我们把 $w_i$ 称为主单词，$\widetilde{w}_k$ 称为 $w_i$ 的上下文的某个单词，从某种角度看，$w_i$ 与 $\widetilde{w}_k$ 的角色是可以互换的，它们的地位是相等的，那么我们就希望模型 F 能隐含这种特性。再看看上式：

<center>$F((w_i - w_j)^T \widetilde{w}_k) = {P_{ik} \over P_{jk}} \neq {P_{ki} \over P_{kj}}$ </center></br>
于是作者在外面嵌套了一层指数运算（将差形式转换为商形式），因此：

<center>$F((w_i - w_j)^T \widetilde{w}_k) = {P_{ik} \over P_{jk}} = {F(w_i^T \widetilde{w}_k) \over F(w_j^T \widetilde{w}_k)}$ </center></br>
从而如下表达式成立：

<center>$F(w^T_i \widetilde{w}_k) = P_{ik} = {X_{ik} \over X_i}$</center></br>
可以从上述表达式看出 $F=exp$，进而在上述式子两边加上 $log$：

<center>$w_i^T \widetilde{w}_k = log(P_{ik}) = log(X_{ik}) - log(X_i)$</center></br>
这个时候仔细观察上式，会发现一个对称性的问题，即：

<center>$w_i^T \widetilde{w}^k = w_k^T \widetilde{w}_i$</center></br>
但是右边的式子交换并不相等，而此时我们也发现 $log(X_i)$ 也独立于 k，因此我们将其吸纳进的 $w_i$ 偏置项 $b_i$，然后同时引入 $\widetilde{w}_k$ 的偏置项 $\widetilde{b}_k$，最终得到：

<center>$w_i^T \widetilde{w}_k+b_i+\widetilde{b}_i = log(X_{ik})$</center></br>
作者认为这样的处理存在一个弊端，即对于一个词，他的每一个共现词都享有相同的权重来决定该词的词向量，而这在常理上的理解是不合理的，因此，作者引入了一种带权的最小二乘法来解决这种问题，最终的损失函数就为：

<center>$J = \sum_{i,j=1}^V f(X_{ij})(w_i^T\widetilde{w}_j+b_i+\widetilde{b}_j - log(X_{ij}))^2$</center></br>
其中，权重方程 $f(X_{ij})$ 应该具有一下特点：

* f(0) = 0
* f(x) 是增函数，这样低频词不会被 over weight。
* 当 x 很大时，f(x) 相对小一些，这样高频词也不会被 over weight。

定义与图像如下：

<center>$f(x) =
\begin{cases}
(x/x_{max})^\alpha \qquad & x \lt x_{max} \\
1 \qquad & otherwise
\end{cases}$</center></br>

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_paper_glove_f_visa_001.png)

作者经过实验得出，$\alpha = 0.75$ 能得到最好的模型效果。接下来的论文部分还讨论了 Glove 词向量与其他词向量的关系以及复杂度，这里不继续展开说明，后续会在另一篇各种词向量模型比较中详细说明，有兴趣的读者可以仔细阅读一下原论文。



## 实验

### 评估方法

将 GloVe 模型得到的词向量分别用于 Word analogies, Word similarity, Named entity recognition，在相同的数据集上和CBOW,SVD 等方法进行比较：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_paper_glove_compare_001.png)

### 训练细节

* 语料库中的词汇都符号化和并变为小写，建立一个含有400,000个常用词的词汇表。
* 利用上下文窗口来计数得到共现矩阵 X。在利用上下文窗口时需要设定窗口的大小（论文采用了上下文各10个单词的窗口长度）和是否需要区分上文和下文等。
* 乘以一个随距离 d 递减的权重项，即与单词 i 距离为 d 的单词在计数时要乘上权重 1/d，表示距离越远的词可能相关性越小。
* 采用 AdaGrad 的方法迭代 50 次（非监督学习，没有用神经网络）。
* 模型产生两个词向量集 $W$ 和 $ \widetilde{W}$，如果 X 是对称矩阵，则 $W$ 和 $\widetilde{W}$ 在除了初始化的不同以外其他部分应该相同，二者表现应该接近。将$W$ 和 $ \widetilde{W}$的加和作为最终词向量，并且能够使得这些词向量在某些任务上的表现变好。 



## 总结

虽然论文中 GloVe 有着指标上的领先，但在实际使用中 word2vec 的使用率相对来说更多一些，可能的原因是 word2vec 可以更快地提供一个相对来说不错的 word embedding 层的初始值。毕竟词向量的主要作用还是为下游任务提供良好的词表示，所以在实际应用过程中，哪个词向量模型在对应的任务中效果好我们就使用哪个模型。