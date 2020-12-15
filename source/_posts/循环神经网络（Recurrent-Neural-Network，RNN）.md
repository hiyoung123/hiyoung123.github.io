---
title: 循环神经网络（Recurrent Neural Network，RNN）
toc: true
mathjax: true
tags:
  - RNN
  - BPTT
  - LSTM
  - GRU
categories:
  - 自然语言处理
excerpt: '循环神经网络（Recurrent Neural Network, RNN）是一类用于处理序列数据的神经网络。'
abbrlink: eb3fbcc4
date: 2020-03-02 15:20:06
---

循环神经网络（Recurrent Neural Network, RNN）是一类用于处理序列数据的神经网络，已经在众多自然语言处理任务中取得了巨大成功以及广泛应用。

## 序列数据

序列数据是一种不定长度的数据，最典型的就是人类说的自然语言，还有其他的音乐/股票序列等。它是随着时间变化而变化的，所以有时也称为时间序列。

序列数据根据任务的不同，具有不同的表现形式。输入和输出可能都是序列，也可能只有其中一个是序列，还有可能是两个不同长度的序列。

 

## RNN 应用

RNN 类神经网络在 NLP 起到了重要作用，在很多领域都将性能提高了很多。下面是一些主要的应用场景：

* 语言模型（LM）
  * 预测下一个词。
  * 拼写纠错。
* 翻译模型（NMT）
* 文本摘要/文本生成
* 等等

可以参考 Andrej Karpathy 的博[文章](http://karpathy.github.io/2015/05/21/rnn-effectiveness/)，有更多丰富的应用。

 

## RNN 网络结构

下图是一个简单的 RNN 结构，它由输入层，隐藏层和输出层组成。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_rnn_dl_jiegou_002.png)

从图中可以很容易看出，它的每个时间步 t 的输出 $\hat{y}^{(t)}$ 都与当前时刻的输入 $x^{(t)}$ 和前一时间的隐藏状态 $h^{(t)}$ 有关。

> 通常实践时，t=0 时刻前一个的隐藏状态随机初始化，并且在预测时也为该值。

### 前向传播

下面用公式表示 RNN 的前向传播：

计算 t 时刻的隐藏状态，这里先假设为 tanh，W，V，U为隐藏单元的权重矩阵，。那么完整的表达式为:

<center>$h^{(t)} = tanh(W_{hh}^T h^{(t-1)} + U_{xh}^Tx^{(t)} + b)$</center></br>
然后计算 t 时刻的输出，这里使用 softmax 作为激活函数：

<center>$\begin{align} o^{(t)} &= V_{ho}^Th^{(t)}+c \\ \hat{y}^{(t)} &= softmax(o^{(t)}) \end{align}$</center></br>
> 注意，这里要搞清楚各个参数的下标，表示向量和矩阵的维度，方便在后续代码实现时认清参数。

### 损失函数

一般都是用交叉熵损失函数 - Cross-entropy：

<center>$L = \sum_t L^{(t)} = - \sum_t y^{(t)} log \ \hat{y}^{(t)}$</center></br>
每一次进行计算，都需要前向传播一次，反向传播一次，而且不可以并行计算，所以时间复杂度为 O(t)。同时每个节点都需要存储当前的梯度，所以空间复杂度为 O(t)。

### 反向传播

RNN 的反向传播 Backpropagation Through Time(BPTT) 由于是序列结构的原因，跟前馈神经网络略有不同。BPTT 的中心思想和 BP 算法相同，沿着需要优化的参数的负梯度方向不断寻找更优的点直至收敛，只不过RNN处理时间序列数据，所以要基于时间反向传播，故叫随时间反向传播。

 

## RNN 的局限性

### 梯度消散

梯度消散可以通过改变 RNN 结构如采用 LSTM 的方式抑制。

### 梯度爆炸

梯度爆炸可以采用梯度剪裁（Gradient clipping）的方式避免，如梯度大于 5 的时候就强制梯度等于 5。

### 长期依赖

即当前时刻无法从序列中间隔较大的那个时刻获得需要的信息。在理论上，RNN 完全可以处理长期依赖问题，但实际处理过程中，RNN 表现得并不好。同样采用 LSTM 等变体可以缓解该问题。

 

## 其他结构

RNN 的网络结构根据不同应用可以分为以下几种：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_rnn_one_to_many_001.png)

* One-to-one ，Vanilla Neural Networks
  最简单的结构，然而效果不怎么好
* One-to-many，Image Captioning, image -> sequence of works
  输入一个图片，输出一句描述图片的话；
* Many-to-one，Sentiment Classification, sequence of words -> sentiment
  输入一句话，判断是正面还是负面情绪
* Many-to-many，Machine Translation, seq of words -> seq of words
  有个延时的，譬如机器翻译。
* Many-to-many，Video classification on frame level
  输入一个视频，判断每帧分类。

### Bi-RNN

在上面的标准 RNN 结构里，每个时间步的输出都是依赖于历史信息的，也就是后面的输出会包含了前面的信息内容。但是有时候文本的主要信息在后面，那么前面的输出就没有包含重要信息内容。双向循环神经网络（bi-RNN）为满足这种需要而被发明（Schuster and Paliwal, 1997）。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_birnn_jiegou_001.png)

Bi-RNN 的思路很简单，就是将输入序列从前向后计算一遍，然后从后向前计算一遍，将两个输出合并作为最后的输出。

这样的想法可以扩展到 2 维输入，比如图片，由四个 RNN 组成。每一个沿着四个方向中的一个计算：上、下、左、右。如果RNN 能够学习到承载长期信息，那在 2 维网络中，每个点（i; j）的输出 $O_{ij}$ 就能计算一个能捕捉到大多局部信息但仍依赖于长期输入的表示。相比卷积网络，应用于图像的RNN 计算成本通常更高，但允许同一特征图的特征之间存在长期横向的相互作用（Visin et al., 2015; Kalchbrenner et al., 2015）。

### Deep-RNN

深度 RNN，通过叠加 RNN 层数来实现。下面是三种不同叠加方法：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_deeprnn_jiegou_001.png)



## References

1. http://norvig.com/chomsky.html
2. http://www.deeplearningbook.org/contents/rnn.html
3. http://karpathy.github.io/2015/05/21/rnn-effectiveness/

