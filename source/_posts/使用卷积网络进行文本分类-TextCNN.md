---
title: 使用卷积网络进行文本分类-TextCNN
toc: true
mathjax: true
cover: >-
  https://cdn.jsdelivr.net/gh/hiyoung123/images/feature/undraw_Share_opinion_re_4qk7.svg
tags:
  - 卷积网络
  - CNN
  - 文本分类
  - TextCNN
  - NLP
categories:
  - 自然语言处理
excerpt: 在 2014 年，kim 大神提出了，在文本词向量之上使用卷积网络 CNN 进行文本分类，在使用少量超参数和使用静态词向量的情况下，可以取得不错的成果。
abbrlink: 96025b39
date: 2021-04-19 22:20:01
---

> 论文：[《Convolutional Neural Networks for Sentence Classification》](https://arxiv.org/pdf/1408.5882.pdf)

在 2014 年，kim 大神提出了，在文本词向量之上使用卷积网络 CNN 进行文本分类，在使用少量超参数和使用静态词向量的情况下，可以取得不错的成果。

## TextCNN

下面一层一层的研究 TextCNN 的结构。下面两张图，第一张是该论文中的原图，而第二张是另一篇论文 [《A Sensitivity Analysis of (and Practitioners’ Guide to) Convolutional Neural Networks for Sentence Classification》](https://arxiv.org/pdf/1510.03820.pdf) 中的配图，个人感觉更清楚明了一些。

![img](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_textcnn_001.png)

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_textcnn_002.png)

### 输入层

与传统 NLP 深度学习模型一样，首先都需要将文本转化为词向量的形式，也就是通过 Embedding 层将文本映射成词向量组成的矩阵。而这个词向量矩阵可以是静态的（static），也可以是非静态的（no-static）。静态的矩阵，就是在训练的过程中不跟着变化，而非静态的矩阵是随着模型训练一起更新。

矩阵的来源一般都是随机初始化一个，从框架中默认生成的一个 vocab_size * embedding_dim 的矩阵。或者是预训练好的词向量，我们只要直接加载到 Embedding 层中使用即可（通常效果更好）。

在该篇论文中，作者使用了 CNN-rand 方式、CNN-static 方式、CNN-non-static 方式和 CNN-multichannel 共四种方式。

* CNN-rand：随机初始化词向量矩阵，在训练中随着模型训练一起改变。
* CNN-static：使用预训练的词向量矩阵，论文中使用了 Word2vec 预训练词向量。但是在训练的过程中保持不变，模型只学习其他参数。
* CNN-non-static：使用了预训练词向量，并且在模型训练的过程中，一起学习。
* CNN-multichannel：一个模型，使用多个词向量矩阵，每个词向量矩阵都可以进行后续的卷积操作，正好符合卷积网络的多通道概念。论文中使用了两个通道，区别是其中一个是 static ，另一个是 non-static。两个通道都是用的是 Word2vec 预训练词向量。

使用预训练词向量可以更好的利用词向量的先验知识，而让词向量参与训练可以与当前任务更好的结合起来，使词向量更适应当前的任务。

>  但是貌似多通道的效果没有很好。

### 卷积层

我们知道，卷积神经网络 CNN 是用于图像领域的，在图片的局部进行卷积操作，从而可以提取到局部特征。但是如何在文本领域使用呢？

可以把输入文本经过 Embedding 映射后的文本矩阵看作是一个 embedding_size * seq_len 的图片，这样卷积核可以是把长设置为词向量的维度 embedding_size，宽为 filter_size。这样卷积核就成为一个滑动窗口，在文本上横着移动，进行卷积操作（如上图 1 中的黄框和红框）。

论文中使用了 2，3，4 三个大小的 filter_size，相当于文本的 2-gram，3-gram 和 4-gram，可以充分的提取文本的结构特征。一共使用了 100 个 feature map。

卷积网络的通道一般都是用于图像中的像素（r，g，b），在这里由于使用了 2 个 Embedding 矩阵，所以卷积的通道数量就是 2。

### 池化层

经过不同尺寸的卷积核得到了不同尺寸的 feature map，因此需要使用池化操作将其维度统一。

池化的种类有很多，这里就不多介绍了，论文中使用的是 1-max-pooling，提取出每个 feature map 的最大值。经过池化操作后，将各个结果合并起来，交给全连接层最后输出分类结果。

## 优点

* 模型简单，可解释强，参数少，效果不错。
* 相比于 RNN 类模型，TextCNN 的收敛速度要快很多。

## Pytorch实现

这里的实现没有使用论文中的多通道：

```python
class TextCNN(nn.Module):
    def __init__(self, config):
        super(TextCNN, self).__init__()
        if config.embedding_pretrained is not None:
            self.embedding = nn.Embedding.from_pretrained(config.embedding_pretrained, freeze=False)
        else:
            self.embedding = nn.Embedding(config.vocab_size, config.embedding_dim, padding_idx=config.vocab_size - 1)
        self.convs = nn.ModuleList(
            [nn.Conv2d(1, config.num_filters, (k, config.embedding_dim)) for k in config.filter_sizes])
        self.dropout = nn.Dropout(config.dropout)
        self.fc = nn.Linear(config.num_filters * len(config.filter_sizes), config.num_labels)

    def conv_and_pool(self, x, conv):
        x = F.relu(conv(x)).squeeze(3)
        x = F.max_pool1d(x, x.size(2)).squeeze(2)
        return x

    def forward(self, x):
        out = self.embedding(x['text'])
        out = out.unsqueeze(1)
        out = torch.cat([self.conv_and_pool(out, conv) for conv in self.convs], 1)
        out = self.dropout(out)
        out = self.fc(out)
        return out
```

## 实验结果

## 总结

TextCNN 不仅结构简单，收敛速度快，效果也非常好，通常作为文本分类任务的 baseline 。在 NLP 领域中，很多技术都是从 CV 领域借鉴来的，CNN 只是其中之一，但确实是很好用的一个方法。CNN 学习结构特征的特性，可以使其在很多地方发挥出不错的作用，所以我们可以在很多 NLP 的模型中看到 CNN 的身影。