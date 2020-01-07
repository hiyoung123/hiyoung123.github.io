---
title: CS224n-lecture2 Word Vectors and Word Senses
abbrlink: ad770643
tags:
---

> CS224n 深度学习自然语言处理 2019 版 Lecture-2 学习笔记。 

在这节课程中，首先回顾了上一节的内容：word2vec，以及两个主要模型 Skip-gram 和 CBOW。还有就是一些技术优化，如负采样等。我们知道，word2vec 的主要思想是通过词的上下文窗口去进行训练，是一种预测模型通过中词预测上下文，或者通过上下文预测中心词。那为什么不可以直接通过共现计数来统计共现词呢？这就是本节课的主要内容，一部分讲了基于共现矩阵的模型，最后又提出了一个基于两者的新模型 - GloVe.

## why not capture co-occurrence counts directly?

### Co-occurrence Matrix

在 NLP 中构建共现矩阵有两种方法：

* Windows：与 Word2vec 类似，通过指定一个窗口，每个单词周围 window 内出现的单词都认为是共现的，对应计数增加，可以捕捉到位置（POS）信息和语义（semantic）信息。
* Word-document：我们假设在同一篇文章中出现的单词关联性更大。假设单词 $i$ 出现在文章 $j$ 中，则矩阵元素 $X_{i j}$ 计数加一，当处理完所有文档后，就会得到一个 $|V| \times M$ 的矩阵。其中 $|V|$ 为词汇表大小，M 为文档数量。这一构建共现矩阵的方法也是 Latent Semantic Analysis (LSA) 浅语义分析中使用的经典方法。

下面我们来举例说明一下 windows 方法，假设我们的数据包含以下几个句子：

1. I like deep learning.

2. I like NLP.

3. I enjoy flying。

则我们可以得到如下的word-word co-occurrence matrix：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec2_window_matrix_001.png)

在这里设置的 window 为 1，所以只取中心词周围一个词的距离计数。比如单词 “I” 与 “like” 在上面的三句话中在 window 为 1的距离内共同出现了 2 次，所以矩阵中对应位置是 2。统计完所有的词后就得到了一个 co-occurrence matrix。通过共现矩阵的共现计数来衡量两个单词之间的相关性。

> 一般情况下 window 取 5 ~ 10。而且从上图可以看出，矩阵是对称的，与左右上下文无关。

共现矩阵的缺点也很明显，随着词汇量增加，矩阵也在不断地变大，而且变得更稀疏，需要更多的存储空间。后续的分类模型也会由于矩阵的稀疏性而存在稀疏性问题，使得效果不佳。我们需要对这一矩阵进行降维，获得像 word2vec 那样的低维 (25-1000) 的稠密向量。

### SVD 奇异值分解

奇异值分解 SVD (Single Value Decomposition) 就是一种常用的降维模型。通过 SVD 可以将共现矩阵 X 分解成 $UΣV^⊤$ 的形式，其中 $Σ$ 是对角线矩阵，对角线上的值是矩阵的奇异值。$U$ 和 $V$ 是对应行和列的正交基。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec2_svd_001.png)

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

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec2_svd_002.png)

### Hacks to X (several used in Rohde et al. 2005)

不管是什么模型，一些高频词对模型的结果影响很大，比如一些虚词（the, he, she）等等。一般有如下几个方法对高频词进行处理：

* 使用 log 进行缩放
* $min(X, t), t\approx 100$
* 直接舍去
* 在基于window的计数中，提高更加接近的单词的计数
* 使用 Person 相关系数替代共现计数，如果值为复数则用 0 代替。

在论文《An Improved Model of Semantic Similarity Based on Lexical Co-Occurrence Rohde et al. ms., 2005》中的COALS模型，通过改善计数，取得了不错的效果：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec2_hacktoX_001.png)

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec2_hacktoX_002.png)

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

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec2_compare_001.png)

