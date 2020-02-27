---
title: CS224n-lecture6 Language Models and Recurrent Neural Networks
toc: true
mathjax: true
tags:
  - NLP
  - CS224n
  - 语言模型
  - RNN
categories:
  - 自然语言处理
excerpt: CS224n 深度学习自然语言处理 2019 版 Lecture-6 学习笔记。
abbrlink: b91e9559
date: 2020-01-24 17:39:38
---

> CS224n 深度学习自然语言处理 2019 版 Lecture-6 学习笔记。

这节课的主要的内容是语言模型和循环神经网络在语言模型中的应用。语言模型是很多自然语言处理任务的基础，比如机器翻译和自然语言生成相关任务等。而循环神经网络又是 NLP 最主要最基础的神经网络，也是现在一些主流神经网络模型的基本模型。

## Language Modeling

语言模型是一个预测下一个单词的任务，通常情况下是已知一个语言序列，预测下一个单词是什么。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_lm_001.png)

更正式的说是跟定一组词序列 $x^{(1)},x^{(2)},\cdots,x^{(t)}$，计算下一个词 $x^{(t+1)}$ 的概率分布：

<center>$P(x^{(t+1)}|x^{(t)},\cdots,x^{(1)})$</center></br>
其中词 $x^{(t+1)}$ 可以是词汇表中的任何一个词，最后得到概率最大的一个词就是预测的词。这样的系统叫做语言模型。

也可以认为语言模型是把概率分配给文本的一种系统，比如有一段文本 $x^{(1)},\cdots,x^{(T)}$，根据语言模型计算得到该文本的概率为：

<center>$\begin{align} P(x^{(1)},\cdots,x^{(T)}) &= P(x^{(1)})\times P(x^{(2)}|x^{(1)})\times \cdots \times P(x^{(T)}|,\cdots,x^{(1)}) \\ &= \prod^T_{t=1} P(x^{(t)}|x^{(t-1)},\cdots,x^{(1)})\end{align}$</center></br>
这样就可以求得一段文本的概率。

 

### Application of Language Modeling

语言模型的应用很广泛，除了在一些 NLP 任务中（如机器翻译，文本生成等）会使用语言模型外，我们生活中也有很多使用语言模型的例子。

输入法的文本预测：我们使用的输入法中，每当你打出一个字或者词后，输入法 app 都会提示你下一个词，这就是语言模型的一个应用。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_lm_002.png)

搜索引擎搜索内容提示：当我们在搜索引擎中输入想要搜索的内容时，会弹出一些向相关的搜索提示。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_lm_003.png)

除了这些，语言在智能客服等等的领域都有发挥作用。

 

## N-gram Language Models
上面说完了什么是语言模型，那么怎么样才能学习一个语言模型呢？传统的做法就是 N-gram 语言模型。那么问题又来了，什么是 N-gram语言模型呢？

N-gram 是一个由 n 个连续单词组成的块，它的思想是一个单词出现的概率与它前 n 个出现的词有关。也就是每个词依赖于前 n 个词。下面是一些常见的术语以及示例，可以帮助你更好的理解 N-gram 语言模型：

* Unigrams：一元文法，由一个单词组成的 token，例如： “the”, “students”, “opened”, ”their”。
* Bigrams：二元文法，由连续两个单词组成的 token，例如：“the students”, “students opened”, “opened their”。
* Trigrams：三元文法，由连续三个单词组成的 token，例如：“the students opened”, “students opened their”。
* 4-grams：四元文法，由连续四个单词组成的 token，例如：“the students opened their”。

更高元的 N-grams 计算概率会变得更加复杂，所以一般情况下都使用的是 unigrams，bigrams 和 trigrams。使用这些 N-gram 的统计数据，去预测文本序列的下一个词是什么。

首先做一个简单的假设，$x^{(t+1)}$ 只依赖前面的 n-1 个词：

<center>$\begin{align}P(x^{(t+1)}|x^{(t)},\cdots,x^{(1)})&=P(x^{(t+1)}|x^{(t)},\cdots,x^{(t-n+2)}) \\ &= {P(x^{(t+1)},x^{(t)},\cdots,x^{(t-n+2)}) \over P(x^{(t)},\cdots,x^{(t-n+2)})} \end{align}$</center></br>
其中第二个等号后面的式子的分子为 n-gram 的概率，分母为 (n-1)-gram 的概率。整个式子为依赖前 n-1 个词的词 $x^{(t+1)}$ 的条件概率。那么如果计算 n-gram 和 (n-1)-gram 的概率呢？

可以通过在大型语料库中，统计他们出现的频数来近似的计算：

<center>$\approx {count(x^{(x+1)},x^{(t)},\cdots,x^{(t-n+2)}) \over count(x^{(t)},\cdots,x{(t-n+2)}}$</center></br>
例如使用 4-gram 语言模型：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_ngram_001.png)

其中，“students opened their” 在语料库中出现了 1000 次，“students opened their books ” 出现了 400 次，那么 $P( books | students \ opened \ their) = 0.4$ ；“students opened their exams ” 出现了 100 次，那么 $P( exams | students \ opened \ their) = 0.1$。

根据之前所说的，这里下一个词是 books 的概率大于 exams ，理应选择 books。但是在文本的上下文中出现过 proctor，这个直接影响了最后的选择，所以 exams 在这里的上下文中应该是比 books 概率更大的。这就是 n-gram 的缺点，下面从几个方面来讨论 n-gram 的缺点。

### Sparsity Problems

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_ngram_002.png)

如上图所示，关于 n-gram 的稀疏性问题：

1. 如果要求的词没有在文本中出现，也就是分子的概率为 0。解决办法是添加一个很小的值给对应的词，这种方法叫做平滑，例如拉普拉斯平滑。这使得词表中的每个单词都至少有很小的概率。
2. 如果前 n-1 个词没有出现在文本中，也就是分母的概率无法计算。解决办法是使用 “opened their“ 替代，这种方法叫做后退。保证作为条件的分母概率值存在。

> 注意：提高 n 的值会使稀疏性变得更糟糕，上文已经提到过，n-gram 一般不会超过 5。

### Storage Problems

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_ngram_003.png)

第二个是存储问题，由于要统计文本在语料库中的计数，增加 n 或增加语料库都会增加模型大小。

> n-gram 实践和基于窗口的神经网络模型略过。

## Recurrent Neural Networks (RNN)

循环神经网络（RNN）模型是一种神经网络族，它有许多种变体，最核心最基本的思想是重复使用相同的权重矩阵 W。它的基本结构如下图所示：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_001.png)

> 本篇文章主要以 cs224n 的课件为主，关于 RNN 的详细讲解后续会有更详细的文章。

从上图的结构中可以看出，它具有三层网络结构，输入层是任意长度的序列，隐藏层是共用一套权重 W ，输出层的内容也是可选择的，根据不同任务可以输出不同长度。同时，由于每个时间步的输出都是结合当前时间步的输入以及上一个时间步的输出，所以它可以学习到文本之前的历史信息。

### A RNN Language Model

下面来看一下 RNN 模型在 LM 中是如何使用的：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_lm_001.png)

根据上图的结构，从下到上的分层来看：

* 输入层：词的 one-hot 编码 $x^{(t)} \in R^{|V|}$，然后经过 word embeddings 词嵌入后转为词向量表示 $e^{(t)} = Ex^{(t)}$。
* 隐藏层：每个时间步的输出 $h^{(t)} = \sigma (W_hh^{(t-1)} + W_ee^{(t)} + b_1)$，其中 $h^{(0)}$ 为初始化时隐藏层的状态。
* 输出层：由于语言模型为预测下一个词，所以在输出层只有一个节点的输出也就是上图中的 $h^{(4)}$。还需要经过一个矩阵变换 $\hat{y}^{(t)} = softmax(Uh^{(t)} + b_2) \in R^{|V|}$也就是说 $h^{(4)}$ 就是我们上文计算的概率值 $\hat{y}^{(4)} = P(x^{(5)}|the \ students \ opened \ their)$。

RNN 的优点：

* 可以处理任意长度的输入序列。
* 每个时间步 t 可以使用之前的时间步的历史信息（理论上）。
* 对于更长的输入，模型的大小没有提高。
* 在每个时间步上应用相同的权重，因此在处理输入时具有对称性。

RNN 的缺点：

* 递归计算速度慢。
* 在实践上，很难去利用更多时间步之前的信息。

### Training a RNN Language Model

现在来看一下如何训练一个 RNN 的语言模型。简单点来说，就是需要一个大的包括词序列（$x^{(1)},\cdots,x^{(T)}$）文本语料库，然后喂给 RNN-LM 模型，计算每个时间步的输出也就是每个词的概率分布 $\hat{y}^{(t)}$。然后像一般的预测问题一样，使用交叉熵损失函数，计算模型预测值和真实值之间的误差：

<center>$J^{(t)}(\theta) = CE(y^{(t)},\hat{y}^{(t)}) = - \sum_{w\in V}y^{(t)}_wlog\hat{y}^{(t)}_w = -log\hat{y}^{(t)}_{x_t+1}$</center></br>
然后对于整个训练集使用评价误差：

<center>$J(\theta) = {1\over T} \sum^T_{t=1}J^{(t)}(\theta)={1\over T}\sum^T_{t=1}-log\hat{y}^{(t)}_{x_t+1}$</center></br>
但是把整个语料库当作一个文本序列计算 loss 和梯度太昂贵了，所以可以把一句话或者一个文档当作文本序列输入到模型中，然后使用随机梯度下降算法进行训练。

> 关于反向回归和梯度计算同样在其他文章中讲解。

### Generating text with a RNN Language Model

像传统的 N-gram 模型一样，RNN-LM 也可以进行文本生成，相比 N-gram 更加流畅，语法正确，但总体上仍然很不连贯。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_lm_002.png)

有趣的是，使用 RNN-LM 模型可以学习到文本中的风格，比如使用奥巴马的演讲作为语料库，那么生成的文本则具有奥巴马演讲的风格。同样如果使用哈利波特作为语料库，那么生成的文本就像是哈利波特的风格。

 

## Evaluating Language Models
语言模型的标准评价指标叫做困惑度（perplexity）：

<center>$perplexity = \prod^T_{t=1} ({1\over P_{LM}(x^{(t+1)}|x^{(t)},\cdots,x^{(1)})})^{1\over T}$</center></br>
这等同于交叉熵损失函数的指数：

<center>$ \begin{align} &= \prod^T_{t=1}({1\over \hat{y}^{(t)}_{x_{t+1}}})^{1\over T} \\  &=exp({1\over T \sum^T_{t=1}}-log\hat{y}^{(t)}_{x_{t+1}}) \\ &= exp(J(\theta))\end{align}$</center></br>
困惑度越低，说明生成的语言越接近真实语言，常用于机器翻译和文本生成等 NLP 任务中。具体内容查看另外一篇博客[信息熵总结](https://hiyoungai.com/posts/686d9456.html)。

下图是语言模型的困惑度变化：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_lm_pre_001.png)

​    

## Why should we care about Language Modeling?

语言模型是一项基准测试任务，它帮助我们衡量我们在理解语言方面的进展。而且语言建模是许多NLP任务的子组件，尤其是那些涉及生成文本或估计文本概率的任务：

* 预测性打字
* 语音识别
* 手写识别
* 拼写/语法纠正
* 作者识别
* 机器翻译
* 摘要
* 对话
* 等等

所以语言模型是 NLP 任务中一个核心应用。

> 注意 RNN 不等于语言模型，RNN 是一类神经网络，语言模型是 NLP 一个任务/应用。

  

## Application of RNN

RNN 除了用于语言模型之外，在 NLP 其他领域也大有用处。

### RNNs can be used for tagging

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_app_001.png)

### RNNs can be used for sentence classification

在分类任务中，可以使用 RNN 学习到句子的表示，然后进行分类。下面有两种计算句子向量的方法。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_app_002.png)

基本方法，用最后一个时间步的输出作为句子的向量表示。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_app_003.png)

第二种方法是将每个时间步的输出取平均或者最大值最为句子的向量表示。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_app_004.png)

### RNNs can be used as an encoder module

主要用于机器翻译/问答系统等任务中。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_app_006.png)

### RNN-LMs can be used to generate text
![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec6_rnn_app_005.png)

   

## Conclusion

语言模型是一个简单容易实现很有趣的任务，有精力的话会去做一下。RNN 是 NLP 和深度学习中非常重要的基本神经网络模型，它的许多变体在现在广泛使用，比如 LSTM/GRU 等，后续会继续讨论这些重要的变体。