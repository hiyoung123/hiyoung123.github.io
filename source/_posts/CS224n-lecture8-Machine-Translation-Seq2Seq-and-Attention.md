---
title: 'CS224n-lecture8 Machine Translation, Seq2Seq and Attention'
toc: true
mathjax: true
tags:
  - NLP
  - CS224n
  - 机器翻译
  - Seq2seq
  - Attention
  - BLEU
categories:
  - 自然语言处理
excerpt: CS224n 深度学习自然语言处理 2019 版 Lecture-8 学习笔记。
abbrlink: 7f15f578
date: 2020-01-26 18:05:28
---

> CS224n 深度学习自然语言处理 2019 版 Lecture-8 学习笔记。

本节课的内容是 NLP 的一个重要领域 - 机器翻译（Machine Translation, MT）。同时也介绍了很重要的 Seq2seq 和 Attention。这三点内容在 NLP 中是很核心的，Seq2seq 和 Attention 不光用于机器翻译，在很多 NLP 任务中都可能遇到，同时 Attention 也不光可以用于 NLP ，也可以用于 CV 领域中。

 

## Pre-Neural Machine Translation
### Machine Translation

机器翻译（MT）就是将一个句子 x 从一种语言（源语言）通过计算机转换成另外一种语言（目标语言）的句子 y 的任务。

早期的机器翻译研究是从 1950 年代开始，从俄语翻译到英语，背景原因是由于冷战的需求。主要的核心内容使用的是基于规则的方法进行翻译。

### Statistical Machine Translation

到了 1990 - 2010 年代，统计机器翻译（SMT）占领了主导地位。其核心思想是：从数据中学习到概率模型。比如进行从法语到英语的翻译，在给定一个法语句子 x 的同时，找到最好的英语句子 y：

<center>$argmax_y P(y | x)$</center></br>
然后通过贝叶斯规则将目标函数差分成两部分分别去计算：

<center>$ = argmax_y P(x|y)P(y)$</center></br>
其中前一个概率 $P(x | y)$ 是翻译模型，从平行语料库中学习得到，后一个概率 $P(y)$ 是语言模型，从正常语料库中学得，以便使得到的翻译语句可以接近自然语言。

### Learning alignment for SMT

那么如何学习到翻译模型 $P(x|y)$ 呢？首先第一点就是要加大平行语料库。

进一步分解，实际上需要考虑的是：$P(x,a|y)$，其中 a 是对齐，即法语句子 x 和英语句子 y 之间的单词级对应。

对齐（Alignment）是翻译语句中特定词语之间的对应关系。

> 注意：一些词是没有对应关系的。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_align_001.png)

对齐可以是多对一的关系：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_align_002.png)

也可以是一对多的关系：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_align_003.png)

还可以是多对多的关系（短语对短语）:

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_align_004.png)

对于 $P(x,a|y)$ 需要学习多种因素的组合，比如：

* 特定词对齐的概率（也取决于单词位置信息）。
* 特定词的特定频率的概率（对应词的数量）。

### Decoding for SMT

如何计算 argmax ？ 可以列出所有可能的 y 并计算概率，但是这样计算量太昂贵了。所以使用启发式的搜索算法来搜索最佳的翻译语句，丢弃那些概率低的结果。这个过程叫做 decoding。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_smt_decoding_001.png)

一个 SMT 系统是巨大的研究领域，效果最好的系统是极其复杂的，需要大量人工去研究特征工程，需要大量的人工维护。

​	

## Neural Machine Translation

### What is Neural Machine Translation?

神经网络机器翻译（NMT）是一种使用单一神经网络去做机器翻译的方法。其主要的结构包括两个 RNN ，这种结构称为 Seq2seq。它的结构图如下所示：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_nmt_s2s_001.png)

Seq2seq 不仅仅用于 MT ，在其他 NLP 领域也发挥这很大的作用：

* 文本摘要（长文本 -> 短文本）
* 对话系统（上一句 -> 下一句）
* 语法分析（输入文本 -> 输出分析序列）
* 代码生成（自然语言 -> Python 代码）

Seq2seq 模型的实质是一个条件语言模型（Conditional Language Model）：

* Language Model：因为 decoder 是在预测目标句子 y 的下一个单词。
* Conditional：因为预测也是在知道源序列 x 的条件下进行的。

NMT 是直接计算概率 $P(y|x)$：

<center>$P(y|x) = P(y_1|x)P(y_2|y_1,x)P(y_3|y_1,y_2,x)\cdots P(y_T|y_1,\cdots,y_{T-1},x)$</center></br>
关于 Seq2seq 的论文：[论文阅读《Sequence to Sequence Learning with Neural Networks》](https://hiyoungai.com/posts/d1bb6beb.html)

### Training a Neural Machine Translation system

如何训练一个 NMT 系统呢？同样的，还是首先需要一个尽量大的语料库。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_nmt_s2s_002.png)

从上图看出损失函数的梯度可以一直反向传播到 encoder，模型可以整体优化，所以 Seq2Seq 也被看做是 end2end 模型。

### Greedy decoding

在上文说到，在计算 argmax 时需要用搜索算法，也就是 decoding 的过程，很费算力。在 Seq2seq 的 decoder 中用到的一种算法叫做 Greedy decoding。即每一步均选取概率最大的单词并将其作为下一步的 decoder input。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_nmt_s2s_greedy_001.png)

但是 Greedy decoding 有个问题是，每一步选取最大概率的词不一定在全局是最优的选择，并且没有办法回退重新选择。

为了解决这一个问题，主要有两种方法，第一种是穷举搜索，但是这样计算量太大。第二种就是下面要介绍的 Beam Search。

### Beam search decoding

Greedy decoding 每一步取最大概率，而穷举的方法是每一步取所有的可能。Beam search decoding 的核心思想就是介于两者之间的，每一个时间步只关注前 k 个最有可能的翻译情况。这样既保证了不会丢失其他概率的翻译，也减少了计算量。一般情况下 k 的取值在 5 - 10 之间。

对于预测出来的翻译 $y_1,\cdots,y_t$，它的得分为 log 概率：

<center>$score(y_1,\cdots,y_t) = logP_{LM}(y_1,\cdots,y_t|x)=\sum^t_{i=1}logP_{LM}(y_i|y_1,\cdots,y_{i-1},x)$</center></br>
分数总是负的，越高表示预测的翻译越好，寻找高得分的假设，跟踪每一步的top k。虽然 Beam search 不能找到全局最优解，但是相对于 Greedy 和穷举来说效果已经很好了。

### Beam search decoding example

Beam search 的主要流程如下：

* 计算下一个单词的概率分布。
* 取前 k 个单词并计算分数。
* 对于每一次的 k 个假设，找出最前面的 k 个单词并计算分数
* 在 $k^2$ 的假设中，保留 k 个最高的分值，如 t = 2 时，保留分数最高的 hit 和 was

在下图中，beam size = k = 2，蓝色的字为分数：$score(y_1,\cdots,y_t)=\sum^t_{i=1}logP_{LM}(y_i|y_1,\cdots,y_{i-1},x)$。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_nmt_beam_search_001.png)

总的来说，在每一个时间步计算下一个词时，使用上述的分数计算公式计算得分，留下 k 个最高的得分，然后再分别预测下一个词，每个时间步都只留下最高的 k 个选项即可。

那么什么时候搜索结束呢？在 Greedy decoding 中，通常在模型产生一个 *<END>* token 的时候才终止解码。在 Beam search 中，不同的假设可能会产生 *<END>* token，所以当一个假设产生了 *<END>* token 后就结束该假设，而继续其它假设的搜索。通常情况下，Beam search 直到产生长度为 T 的句子，或者 至少有 n 个候选句子时结束，T 和 n 都是预先设定的超参数。

解码完成后，就有了一些候选的翻译句子，那么如何从这些候选句子中选择一条作为预测句子呢？在解码完成后，每一个假设得到的句子都会有自己的得分：

<center>$score(y_1,\cdots,y_t)=logP_{LM}(y_1,\cdots,y_t|x)=\sum^t_{i=1}logP_{LM}(y_i|y_1,\cdots,y_{i-1},x)$</center></br>
但是越长的句子对应的得分会变得越低，所以需要对得分进行归一化处理：

<center>${1\over t} \sum^t_{i=1}log P_{LM}(y_i|y_1,\cdots,y_{i-1},x)$</center></br>
这样就可以在候选翻译句子中选择得分最高的作为预测句子。

### Advantages and Disadvantages of NMT 

相比较传统的 SMT，NMT 有很多优点：

* 更好的性能
  * 句子更通顺
  * 更好的利用上下文
  * 更好的使用短语相似性
* 一个单一模型可以实现端到端的优化
  * 没有单独的子组件
* 不需要太多的人为影响
  * 没有特征工程
  * 对所有的平行语料使用同一种方法即可

但是相比较 SMT，MNT 也是有缺点的：

* 可解释性较差

  * 很难去 Debug

* 很难控制

  * 不能使用特殊的规则或者方针去进行翻译
  * 安全问题

  

## How do we evaluate Machine Translation?

### BLEU

BLEU(Bilingual Evaluation Understudy)，是将机器翻译出来的句子与人工翻译的句子进行比较，计算 n-gram 对应出现的概率，并且为了防止一些句子太短，还需要加上惩罚项，得出一个得分。

虽然 BLEU 很有用，但不是完美的，很多方法翻译出来的句子，虽然正确，但是却有很低的 BLEU 评分。 

​	

## Attention

Attention 注意力是为了解决 Seq2seq 的信息瓶颈问题而诞生的，回顾一下上文的 Seq2seq 结构图：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cs224n_19_lec8_nmt_attention_001.png)

在 encoder 的过程中，需要将输入的所有信息都 encode 到 encoder 的最后一个 hidden state 上，这通常是不现实的，随着源句子的长度增大，hidden state 会记录的信息也就越多，其中包括一些无用的信息。而模型很难去存储更多的信息，所以需要进行取舍，也就是将有用的信息进行保留，这也就是注意力名字的由来。

Attention 的核心思想是：在解码器的每个时间步中，使用与编码器的直接连接来聚焦于源序列的特定部分。具体讲解请参考 [Attention注意力机制介绍](https://www.jianshu.com/p/4868162a679b)。

​	

## Conclusion

NMT 是 NLP 一个重要领域，现如今已经取得了很大的成功，比如Google翻译，百度翻译等。这都归功于 Seq2seq 和 Attention 机制。虽然许多困难仍然存在，比如平行语料库的缺失，未登录词的处理，在较长文本维护上下文（Attention可以缓解该问题）等等。但是目前来看最好的机器翻译系统已经可以媲美人类的翻译。