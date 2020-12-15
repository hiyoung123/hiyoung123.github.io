---
title: CS224n-lecture2 Word Vectors and Word Senses
abbrlink: ad770643
top: false
toc: true
mathjax: true
tags:
  - NLP
  - CS224n
  - GloVe
  - 词向量
categories:
  - 自然语言处理
date: 2020-01-08 17:45:45
cover: https://cdn.jsdelivr.net/gh/hiyoung123/images/feature/undraw_investing_7u74.svg
excerpt: CS224n 深度学习自然语言处理 2019 版 Lecture-2 学习笔记。
---

> CS224n 深度学习自然语言处理 2019 版 Lecture-2 学习笔记。 

在这节课程中，首先回顾了上一节的内容：word2vec，以及两个主要模型 Skip-gram 和 CBOW。还有就是一些技术优化，如负采样等。我们知道，word2vec 的主要思想是通过词的上下文窗口去进行训练，是一种预测模型通过中词预测上下文，或者通过上下文预测中心词。那为什么不可以直接通过共现计数来统计共现词呢？这就是本节课的主要内容，一部分讲了基于共现矩阵的模型，最后又提出了一个基于两者的新模型 - GloVe.



## Why not capture co-occurrence counts directly?

### Co-occurrence Matrix

在 NLP 中构建共现矩阵有两种方法：

* Windows：与 Word2vec 类似，通过指定一个窗口，每个单词周围 window 内出现的单词都认为是共现的，对应计数增加，可以捕捉到位置（POS）信息和语义（semantic）信息。
* Word-document：我们假设在同一篇文章中出现的单词关联性更大。假设单词 $i$ 出现在文章 $j$ 中，则矩阵元素 $X_{i j}$ 计数加一，当处理完所有文档后，就会得到一个 $|V| \times M$ 的矩阵。其中 $|V|$ 为词汇表大小，M 为文档数量。这一构建共现矩阵的方法也是 Latent Semantic Analysis (LSA) 浅语义分析中使用的经典方法。

下面我们来举例说明一下 windows 方法，假设我们的数据包含以下几个句子：

1. I like deep learning.

2. I like NLP.

3. I enjoy flying。

则我们可以得到如下的word-word co-occurrence matrix：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_window_matrix_001.png)

在这里设置的 window 为 1，所以只取中心词周围一个词的距离计数。比如单词 “I” 与 “like” 在上面的三句话中在 window 为 1的距离内共同出现了 2 次，所以矩阵中对应位置是 2。统计完所有的词后就得到了一个 co-occurrence matrix。通过共现矩阵的共现计数来衡量两个单词之间的相关性。

> 一般情况下 window 取 5 ~ 10。而且从上图可以看出，矩阵是对称的，与左右上下文无关。

共现矩阵的缺点也很明显，随着词汇量增加，矩阵也在不断地变大，而且变得更稀疏，需要更多的存储空间。后续的分类模型也会由于矩阵的稀疏性而存在稀疏性问题，使得效果不佳。我们需要对这一矩阵进行降维，获得像 word2vec 那样的低维 (25-1000) 的稠密向量。

### SVD 奇异值分解

奇异值分解 SVD (Single Value Decomposition) 就是一种常用的降维模型。通过 SVD 可以将共现矩阵 X 分解成 $UΣV^⊤$ 的形式，其中 $Σ$ 是对角线矩阵，对角线上的值是矩阵的奇异值。$U$ 和 $V$ 是对应行和列的正交基。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_svd_001.png)

为了减少维度同时尽量保存有效信息，可保留对角矩阵的最大 k 个值，并将矩阵 $U$,$V$ 的相应的行列保留。这是经典的线性代数算法，对于大型矩阵而言，计算代价比较高。

使用代码演示一下上面例子：

```python
import numpy as np
la = np.linalg
words = ["I", "like", "enjoy", "deep", "learning", "NLP", "flying", "."]
X = np.array([[0,2,1,0,0,0,0,0],
              [2,0,0,1,0,1,0,0],
              [1,0,0,0,0,0,1,0],
              [0,1,0,0,1,0,0,0],
              [0,0,0,1,0,0,0,1],
              [0,1,0,0,0,0,0,1],
              [0,0,1,0,0,0,0,1],
              [0,0,0,0,1,1,1,0]])

U, s, Vh = la.svd(X, full_matrices=False)

```

可以通过下图看一下，降维到 2 个维度的词向量：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_svd_002.png)

### Hacks to X (several used in Rohde et al. 2005)

不管是什么模型，一些高频词对模型的结果影响很大，比如一些虚词（the, he, she）等等。一般有如下几个方法对高频词进行处理：

* 使用 log 进行缩放
* $min(X, t), t\approx 100$
* 直接舍去
* 在基于window的计数中，提高更加接近的单词的计数
* 使用 Person 相关系数替代共现计数，如果值为复数则用 0 代替。

在论文《An Improved Model of Semantic Similarity Based on Lexical Co-Occurrence Rohde et al. ms., 2005》中的COALS模型，通过改善计数，取得了不错的效果：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_hacktoX_001.png)

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_hacktoX_002.png)

在向量中出现的有趣的句法模式：语义向量基本上是线性组件，虽然有一些摆动，但是基本是存在动词和动词实施者的方向。

### 计数模型和 Word2vec 对比

基于计数（LSA，HAL等模型）：使用整个矩阵的全局统计数据来直接估计。

* 优点
  * 训练快速
  * 统计数据高效利用
* 缺点
  * 主要用于捕捉单词相似性
  * 对大量数据给予比例失调的重视

直接预测：定义概率分布并试图预测单词

* 优点
  * 提高其他任务的性能
  * 能捕获除了单词相似性以外的复杂的模式
* 缺点
  * 与语料库大小有关的量表
  * 统计数据的低效使用

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_compare_001.png)



## GloVe 模型

将两个流派的想法结合起来，在神经网络中使用计数矩阵 - GloVe (Global Vectors的缩写)。表示可以有效的利用全局的统计信息。那么如何利用 word-word co-occurrence count 并能学习到词语背后的含义呢？

首先我们在上文说到的共现矩阵符号基础上加入几个符号，$X_i = \sum _k X_{i k}$ 代表所有出现在单词 $i$ 的上下文中的单词次数，用$P_{i j} = P{j|i} = X_{i j} / X_i$ 来表示单词 $j$ 出现在单词 $i$ 上下文中的概率。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_001.png) 

> 重点不是单一的概率大小，重点是他们之间的比值，其中蕴含着meaning component。

例如我们想区分热力学上两种不同状态ice冰与蒸汽 steam，它们之间的关系可通过与不同的单词 x 的 co-occurrence probability 的比值来描述，例如对于 solid 固态，虽然 $P(solid | icce)$ 与 $P(solid|steam)$ 本身很小，没有什么有效信息。但是他们的比值 $P(solid|ice) \over P(solid|steam)$ 却较大，因为solid更常用来描述 ice​ 的状态而不是 ​steam​ 的状态，所以在 ice 的上下文中出现几率较大。

对于 gas 则恰恰相反，而对于 water 这种描述 ice 与 steam 均可或者 fashion 这种与两者都没什么联系的单词，则比值接近于1。所以相较于单纯的 co-occurrence probability，实际上 co-occurrence probability 的相对比值更有意义。

那么问题来了，如何在词向量空间中以线性 meaning component 的形式捕获共现概率的比值？

* Log-bilinear model：$w_i \cdot w_j = logP(i|j)$
* Vector differences：$w_x \cdot (w_a - w_b) = log{P(x|a)\over P(x|b)}$

基于这些直接给出了 GloVe 的损失函数：

<center>$J = \sum_{i,j=1}^V f(X_{ij})(w_i^T \widetilde{w}_j+b_i+\widetilde{b}_j -logX_{ij})^2$</center></br>
GloVe 模型的优点有：

* 训练快速
* 可扩展到大型语料库
* 即使使用小的语料库和小的向量，也能获得良好的性能

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_002.png)



## How to evaluate word vectors?

和一般的 NLP 的评估一样，非为内在和外在：

* 内在
  * 在特定子任务中的表现
  * 计算速度快
  * 有助于理解系统
  * 不清楚是否真的有帮助，除非与真正的任务建立相关性
* 外在
  * 对实际任务的评估
  * 计算精确度可能需要很长时间
  * 不清楚子系统是问题所在，是交互问题，还是其他子系统
  * 如果用另一个子系统替换一个子系统可以提高精确度

### Intrinsic word vector evaluation

可以通过类比的形式评估词向量，比如 man 和 woman 之间的关系是男女性别的差异，那么 king 和什么词也有这种关系呢？下图表示了这种类比评估的方法：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_eval.png)

整体思想在第一节课中已经提到过，并且还有用于测试的测试集合，这里不多说了。

### Glove Visualizations

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_vs_001.png)

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_vs_002.png)

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_vs_003.png)

从图中可以看出，具有相同类比含义的几组词都是平行的。

### Analogy evaluation and hyperparameters

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_compare_001.png)

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_compare_002.png)

从上面两个对比数据可以看出：

* 300 是一个很好的词向量维度
* 不对称上下文（只使用单侧的单词）不是很好，但是这在下游任务重可能不同
* window size 设为 8 对 Glove 来说比较好

与 Skip-gram + Neg 对比，可以看出训练时间越长效果越好：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_css224n_19_lec2_glove_compare_003.png)

从下面这组对比数据可知，数据集越大越好，并且维基百科数据集比新闻文本数据集要好。这是因为 Wiki 百科是解释性文本语料库，里面包含了文本本身的含义与相关语句。而新闻类的文本只是在胡说八道（@_@ 哈哈教授原话！）。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_cs224n_19_lec2_glove_compare_004.png)



## 总结

总的来说，各种词向量模型各有好坏，每篇论文选取的数据肯定都是对自己的模型有利的，所以不能只靠论文中的数据就去一味选取模型，自己使用的时候要根据实际任务以及各个模型的优缺点去选取模型。



## 推荐阅读

[论文阅读《GloVe: Global Vectors for Word Representation》](https://hiyoungai.com/posts/fb292938.html)

