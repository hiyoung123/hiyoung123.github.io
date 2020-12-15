---
title: Ubuntu下划词翻译工具-GoldenDict
toc: true
mathjax: false
tags:
  - 划词翻译
  - GoldenDict
  - 词典
categories:
  - 便捷工具
excerpt: Ubuntu下划词翻译工具-GoldenDict。
abbrlink: 7e57c477
date: 2019-12-27 15:19:09
---

## 简介

[Goldendict](http://goldendict.org/) 是一款跨平台的翻译软件，支持划词翻译等功能。它更像一种词典或者词典的API工具，通过外挂好本地词典或者网站词典进行翻译，返回的样式就是设置词典的样式。

Golendict 有以下几大特点：

* 自定义词本地典库，可加载外挂词典，可自定义分组；
* 自定义在线词典和百科；
* 支持屏幕取词（虽然有时不是很灵），但搭配上 Autohotkey 无敌；
* 支持全文搜索，有生词本且可导出。

官方效果图：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_goldendict_heron-single.png)



## 安装

这里主要介绍一下 Ubuntu 下的安装，其他平台的安装进入[官网](http://goldendict.org/)自行查看。

在 Ubuntu 上安装 Goldendict 比较简单，直接在命令行输入如下命令即可：

```bash
sudo apt-get install goldendict
```



## 配置

### 添加在线词典

我们可以通过如下步骤添加在线词典，左上角菜单栏找到“编辑“选项,然后 编辑->词典->网站->添加：

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_glodendict_add_net_dict.png)

如何获取到在线词典呢？百度搜索必应词典，随便搜索一个单词，例如 welcome，会得到一个网址：
`http://cn.bing.com/dict/search?q=welcome&;qs=n&;form=Z9LH5&;pq=welcome&;sc=0-7&;sp=-1&;sk=&;cvid=127D88B2AD4E4842A79BCB32B430FC33`
然后将其中的 welcome 全部替换成 %GDWORD% 得到：
`http://cn.bing.com/dict/search?q=%GDWORD%&;qs=n&;form=Z9LH5&;pq=%GDWORD%&;sc=0-7&;sp=-1&;sk=&;cvid=127D88B2AD4E4842A79BCB32B430FC33`

* 有道： `http://dict.youdao.com/search?q=%GDWORD%&ue=utf8`
* 必应： `http://cn.bing.com/dict/search?q=%GDWORD%`
* 海词：`http://dict.cn/%GDWORD%`

需要注意的是，添加完在线词典之后需要勾选上才可以使用。

### 添加本地词典

在编辑里选择词典>词典来源>文件，点击添加，我们可以新建一个文件夹来存放我们的字典文件。然后我们将下载好的字典文件解压后，放到这个文件夹中，点击重新扫描就可以识别出本地词典了。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_glodendict_add_local_dict_1.png)

这样我们就可以在词典中查看已经添加进来的词典了。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_glodendict_add_local_dict_2.png)



## 资源

推荐几部精选的词典并附上图片以及下载地址：

### 牛津高阶 8 简体 spx （带发音）

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_glodendict_niujin_dict.png)

[百度网盘](https://pan.baidu.com/s/1MupVJbBl4KxGjQ-PYo2pTQ)

提取码：enp6

### Vocabulary.com Dictionary 英文版（联网发音）

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_glodendict_vocabulary.png)

[百度网盘](https://pan.baidu.com/s/1d2pb-myWwXMZslwwQ1Hg2g)

提取码：fsug

### 简明英汉必应版（增强版升级） 432万词条

[Github](https://github.com/skywind3000/ECDICT-ultimate/releases)

### 星际译王

向大家推荐星际译王的词典[下载网站](http://download.huzheng.org/)，这个网站几乎包含了所有的字典，我们可以选择下载。

![](https://cdn.jsdelivr.net/gh/hiyoung123/images/img/img_tool_glodendict_xingji.png)