---
title: NLP系列－中文分词（基于词典）
top: false
cover: false
toc: true
mathjax: false
img: https://cdn.jsdelivr.net/gh/hiyoung123/cdn/img/img_nlp_fenci_bg.jpg
tags:
  - 自然语言处理
  - nlp
  - 中文分词
categories:
  - 自然语言处理
abbrlink: 9eeee454
date: 2019-11-19 14:50:34
password:
summary:
---

#  NLP系列－中文分词（基于词典）

##  中文分词概述

　　词是最小的能够独立活动的有意义的语言成分，一般分词是自然语言处理的第一项核心技术。英文中每个句子都将词用空格或标点符号分隔开来，而在中文中很难对词的边界进行界定，难以将词划分出来。在汉语中，虽然是以字为最小单位，但是一篇文章的语义表达却仍然是以词来划分的。因此处理中文文本时，需要进行分词处理，将句子转为词的表示，这就是中文分词。

## 中文分词的三个难题

分词规则，消除歧义和未登录词识别：

* 构建完美的分词规则便可以将所有的句子正确的划分，但是这根本无法实现，语言是长期发展自然而然形成的，而且语言规则庞大复杂，很难做出完美的分词规则。
* 在中文句子中，很多词是由歧义性的，在一句话也可能有多种分词方法。比如：”结婚/的/和尚/未结婚/的“，“结婚/的/和/尚未/结婚/的”，人分辨这样的句子都是问题，更何况是机器。
* 此外对于未登陆词，很难对其进行正确的划分。

##  目前主流分词方法

基于规则，基于统计以及二者混合。本篇主要介绍一下基于规则词典进行分词。

##  基于规则的分词

　　主要是人工建立词库也叫做词典，通过词典匹配的方式对句子进行划分。其实现简单高效，但是对未登陆词很难进行处理。主要有正向最大匹配法，逆向最大匹配法以及双向最大匹配法。

###  正向最大匹配法FMM

`FMM`的步骤是：

1. 从左向右取待分汉语句的m个字作为匹配字段，m为词典中最长词的长度。
2. 查找词典进行匹配。
3. 若匹配成功，则将该字段作为一个词切分出去。
4. 若匹配不成功，则将该字段最后一个字去掉，剩下的字作为新匹配字段，进行再次匹配。
5. 重复上述过程，直到切分所有词为止。

代码实现：

```python
def cut(self,text):
    result = []
    index = 0
    text_size = len(text)
    while text_size > index:
        for size in range(self.window_size+index,index,-1):
            piece = text[index:size]
            if piece in self.word_dict:　#查看是否存在于词典中
                index = size - 1
                break
        index = index + 1
        result.append(piece)
    return result
```

分词效果：

![FMM分词结果](https://cdn.jsdelivr.net/gh/hiyoung123/cdn/img/img_nlp_fenci_fmm.png)

###  逆向最大匹配法RMM

　　`RMM`的基本原理与`FMM`基本相同，不同的是分词的方向与`FMM`相反。`RMM`是从待分词句子的末端开始，也就是从右向左开始匹配扫描，每次取末端m个字作为匹配字段，匹配失败，则去掉匹配字段前面的一个字，继续匹配。

代码实现：

```python
def cut(self,text):
    result = []
    index = len(text)
    window_size = min(index,self.window_size)
    while index > 0:
        for size in range(index-window_size,index):
            piece = text[size:index]
            if piece in self.word_dict:　#查看是否存在于词典中
                index = size + 1
                break
        index = index - 1
        result.append(piece)
    result.reverse()　#因为是从后向前分词，所以需要将结果逆序
    return result
```

分词效果：

![RMM分词结果](https://cdn.jsdelivr.net/gh/hiyoung123/cdn/img/img_nlp_fenci_rmm.png)

###  双向最大匹配法Bi-MM

　　`Bi-MM`是将正向最大匹配法得到的分词结果和逆向最大匹配法得到的结果进行比较，然后按照最大匹配原则，选取词数切分最少的作为结果。据`SunM.S.`和`Benjamin K.T.(1995)`的研究表明，中文中`90.0%`左右的句子，正向最大匹配法和逆向最大匹配法完全重合且正确，只有大概`9.0%`的句子两种切分方法得到的结果不一样，但其中必有一个是正确的（歧义检测成功），只有不到`1.0%`的句子，使用正向最大匹配法和逆向最大匹配法的切分虽然重合但是错的，或者两种方法切分不同但结果都不对（歧义检测失败）。

双向最大匹配的规则是：

1. 如果正反向分词结果词数不同，则取分词数量少的那个。
2. 如果分词结果词数相同：
   - 分词结果相同，没有歧义，返回任意一个。
   - 分词结果不同，返回其中单字数量较少的那个。

上述例子中词数相同，但结果不同，逆向最大匹配法的分词结果单字个数是`1`，所以返回的是逆向最大匹配法的结果。

代码实现：

```python
def cut(self,text):
    res_fmm = self.FMM.cut(text)
    res_rmm = self.RMM.cut(text)
    if len(res_fmm) == len(res_rmm):
        if res_fmm == res_rmm :
            return res_fmm
        else:
            f_word_count = len([w for w in res_fmm if len(w)==1])
            r_word_count = len([w for w in res_rmm if len(w)==1])
            return res_fmm if f_word_count < r_word_count else res_rmm
    else:
        return res_fmm if len(res_fmm) < len(res_rmm) else res_rmm
```

分词效果：

![BIMM分词结果](https://cdn.jsdelivr.net/gh/hiyoung123/cdn/img/img_nlp_fenci_bimm.png)

　　可能有人会问，如果单字的数量也相同怎么办？如果你明白了中文分词的原理和实际用处的话，那么这个问题的答案自然会知晓。中文分词目前仍然没有完全准确的结果，一句话可以分成不同的分词结果。如果单字数量也相同，按照正常的逻辑那么会继续比较双字词，但是这样却没有可比性，在中文中大多数都是双字词，所以即使双字词的数量相同，但是结果可能却有很多种可能。

　　我们比较单字词的数量，取数量少的那个结果，只是为了大概率更准确一些，因为中文字单字为词的情况比较少，大多数是双字或多字词。但是针对一些特殊的句子，这种判断方法不见得结果是最优的。虽然如此，但是基于规则的中文分词仍然是目前为止最简单高效的方法。



##  总结

　　基于规则的分词，一般较为简单高效，但是词典的维护很大的人力维护，同时对于未登录词也没有很好的解决办法。双向最大匹配结合了正反两种方法的结果，结果较为准确，在实用中文信息处理中使用广泛。



##  参考

* 《Python自然语言处理实战-核心技术与算法》涂铭，刘祥，刘树春 著
* 《统计自然语言处理》 宗成庆 著
*   详细代码可参考[GitHub](https://github.com/hiyoung123/NLP)



