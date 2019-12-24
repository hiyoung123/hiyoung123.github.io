---
title: CS224n-lecture1 Introduction and Word Vectors
abbrlink: 2878d2b0
tags:
---

>  CS224n 深度学习自然语言处理2019版Lecture-1学习笔记。 

这次的课程相比以往没有那么多的介绍，而是简短的介绍了人类语言的作用和特殊之外就开始讲主要课程。所以这里也不说多余的废话，直接进入主题。

## Human language and word meaning

### How do we represent the meaning of a word?

词是自然语言组成的基本单位（汉语体系是以字为基本单位），它表达了最基本的意思，通过不同词的不同排列组合才形成了我们丰富的语言世界。所以想让机器了解自然语言，首先要解决最基本的问题就是要让机器明白词的含义**meaning of a word**。

### WordNet

> WordNet是由Princeton 大学的心理学家，语言学家和计算机工程师联合设计的一种基于认知语言学的英语词典。它不是光把单词以字母顺序排列，而且按照单词的意义组成一个“单词的网络”。-- 百度百科

说白了$WordNet$是一个网络词典，包含同义词集和上位词(“is a”关系) **synonym sets and hypernyms**。在$WordNet$中，用一个词的同义词和上位词来表示这个词的意思。

我们可以通过Python库来访问WordNet，看看它具体是什么样子的。

> 让jupter-notebook使用conda的虚拟环境：conda install nb_conda
>
> 通过nltk访问wordnet之前，需要执行nltk.download('wordnet')去下载对应的数据。

```python
from nltk.corpus import wordnet as wn
poses = { 'n':'noun', 'v':'verb', 's':'adj (s)', 'a':'adj', 'r':'adv'}
for synset in wn.synsets("good"):
    print("{}: {}".format(poses[synset.pos()],
            ", ".join([l.name() for l in synset.lemmas()])))
```

同义词集效果如下：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec1_wn_1.png)

```python
from nltk.corpus import wordnet as wn
panda = wn.synset("panda.n.01")
hyper = lambda s: s.hypernyms()
list(panda.closure(hyper))
```

上位词效果如下：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n-19-lec1-wn-2.png)

NLTK：Natural Language Toolkit，自然语言处理工具包，在NLP领域中，最常使用的一个Python库。

$WordNet$作为资源库很好，但是有一些缺点：

* 缺少语义差别，如上面实验的”proficient”被列为“good”的同义词，只是在某些场景下是可行的。
* 缺少新词或者词的新含义，需要不断的去更新。
* 主观的，是通过建立者的主观意识创建的。
* 需要人类劳动来创造和调整。
* 无法计算单词相似度。

### 独热编码（one-hot）

在传统的自然语言处理中，我们把词语看作离散的符号: hotel, conference, motel - a **localist** representation。单词可以通过独热向量（one-hot vectors，只有一个1，其余均为0的稀疏向量）。

<center> $motel=[0 0 0 0 0 0 0 0 0 0 1 0 0 0 0]$</center>
<center>$hotel=[0 0 0 0 0 0 0 1 0 0 0 0 0 0 0]$</center> </br></br>

向量的维度等于词库的词个数。虽然 one-hot 编码可以用作词的向量表示，但是弊端也是很明显的：

* 当语料库也就是词库的单词个数过大时，one-hot 编码的词向量的维度也会很大。
* 由于one-hot 编码都是由0-1组成，并且只有表示该词的位置是１，其余位置都是０，所以过于稀疏。
* 并且用one-hot 编码的词之间都是正交的（两个词向量的内积为０），所以无法表示两个词的相关性。

### 通过上下文表示词

> 分布式语义：一个单词的意思是由经常出现在它附近的单词给出的。

这个很容易理解，一个词实际所表达的意思往往取决于它所在的句子。有点物以类聚，人以群分的感觉。这个概念被称为现代统计$NLP$最成功的理念之一，所以才有了后来的$Word2Vec$词嵌入框架。

当一个单词$w$出现在文本中时，它的上下文$context$是出现在其附近的一组单词（在一个固定大小的窗口$Window$中）。在大量的语料库中，词$w$会出现在不同的语句中，所以也就有了许多不同的上下文$context$。我们可以通过这些$context$去得到该词的有效表示。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n-19-lec1-context.png)

### 词向量（Word Vector）

词向量也叫词的表示（word representations）或者词嵌入（word embeddings），它是一种分布式表示。上文说的独热和通过上下文表示都属于分布式表示，但是独热编码的方式是稀疏的高纬的，而通过上下文表示得到的向量是低纬度的稠密的（dense）。我们希望在相似的$context$下的$word vector$也较为相似。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec1_dens_vector.png)

词向量在NLP中非常重要，一个训练好的词向量模型，可以很好的表达出词与词之间的关系。使得可以很好的进行下游任务的处理，有助于提高模型的性能和准确率。



## Word2Vec

### Word2vec introduction

$Word2Vec(Mikolov et al. 2013)$是一个学习词向量的框架，通过模型将自然语言的单词映射到n维空间中，这个n就是词向量的维度。在该空间中，语义相近的词向量位置相对比较接近。

它的主要思路是：

* 我们有大量的语料文本 (corpus means 'body' in Latin. 复数为corpora)。
* 固定词汇表中的每个单词都由一个向量表示。
* 文本中的每个位置$t$，其中有一个中心词$c$和上下文$context$单词$o$。
* 使用$c$和$o$的词向量的相似性来计算给定$c$的$o$的概率$P(o|c)$（反之亦然）。
* 不断调整词向量来最大化这个概率。

下图为窗口大小$j=2$时的$P(w_t+j|w_t)$计算过程，center word分别为$into$和$banking$。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec1_w2v_ov.png)

当我们扫到下一个位置时，banking就成为center word。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec1_w2v_ov1.png)

### Word2vec objective function

对于每个位置$t=1,\dots,T$，其中$T$为一句话中单词的个数。在大小为$m$的固定窗口$Window$内预测上下文单词，给定中心词$w_j$。

<center>$Likelihood = L(\theta) = \prod_{t=1}^T \prod_{-m \leq j \leq m , j\neq 0} P(w_{t+j}|w_t;\theta)$</center></br></br>

其中，$\theta$是所有需要优化的变量。

目标函数$J(\theta)$也叫代价函数或者损失函数。上述公式中求乘的方式最后得到一个非常小的值，因为每个概率$P$都是小于１大于０的小数，通过不断相乘（我们知道小于１的小数乘以一个小于１的小数会比这两个小数值更小）最后得到一个非常小的小数。所以我们通常会转为求对数，也就是在上述公式的两边加上$Log$，其中右边就可以转化为对数求和的形式。同时根据凸优化理论，我们将求最大转为求最小，变形后的目标函数为（平均）负对数似然：

<center>$J(\theta) = -{1\over T}LogL(\theta) = -{1\over T}\sum^T_{t=1} \sum_{-m\leq j\leq m,j\neq 0}LogP(w_{t+j}|w_t;\theta)$</center></br></br>



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
