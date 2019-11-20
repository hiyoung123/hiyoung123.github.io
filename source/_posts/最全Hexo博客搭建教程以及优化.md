---
title: 最全Hexo博客搭建教程以及优化
top: true
cover: false
toc: true
mathjax: true
tags:
  - Hexo
  - 博客
categories:
  - 网站搭建与优化
abbrlink: 4dbbde95
date: 2019-11-16 11:50:59
password:
summary:
---
##  前言

一边上班一边搭建博客，忙了大概有一周左右的时间，终于把博客都调好了。我使用的是`Hexo`框架，主题是闪念之狐的[hexo-theme-matery](https://github.com/blinkfox/hexo-theme-matery/blob/develop/README_CN.md)，本文介绍的也是该主题的配置，大家如果喜欢可以去下载使用。

本文除了介绍了闪念主题的一些基础配置之外，也介绍了一些我个人和在其他大佬处看到的功能定制。只要你懂得操作软件，懂得键盘打字，那么就可以通过本教程搭建一个完全`免费`的个人博客。如果你是技术大佬，那么更可以通过修改源码去定制更好的功能。本文也记录了一些我搭建过程中遇到的坑，希望可以帮你在搭建过程中少走一些弯路，同时如果你也遇到一些本文没有记载的*bug*，也请你给我留言，让我们一起学习解决，多谢。

## 第一部分：准备

### 1.Hexo介绍

[Hexo](https://hexo.io/zh-cn/)是一款快速、简洁且高效的基于`Node.js`的静态博客框架，四大特性：

* 超快速度：`Node.js` 所带来的超快生成速度，让上百个页面在几秒内瞬间完成渲染。
* 支持Markdown：`Hexo` 支持 `GitHub Flavored Markdown` 的所有功能，甚至可以整合 `Octopress` 的大多数插件。
* 一键部署：只需一条指令即可部署到 `GitHub Pages`, `Heroku`或其他平台。
* 插件和可扩展性：强大的 `API` 带来无限的可能，与数种模板引擎`（EJS，Pug，Nunjucks）`和工具`（Babel，PostCSS，Less/Sass）`轻易集成。

这使得很多非编程人员可以很轻松，很自由的定制博客。废话不多说，开始进入搭建环境把。

### 2.安装Node环境

####  Linux

直接命令行输入：

```bash
sudo apt-get install nodejs
sudo apt-get install npm
```

或者到[官网](http://nodejs.cn/download/)下载：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_download_nodejs_1.png)

下载完成后解压到指定文件夹，然后配置环境变量（目的是为了在终端可以任意位置使用它）：

首先打开`~/.bashrc`文件

```bash
vim ~/.bashrc
```

在文件的最下端填写如下代码

```bash
export PATH=${PATH}:$HOME/node-v12.13.0-linux-x64/bin/
```

因为我下载的是`64`位`12.13.0`版本，并且放到了根目录`home`下，你可以根据自己的需求进行更改上面的路径。保存退出后，执行命令让修改生效。

```bash
source ~/.bashrc
```

然后在终端输入`npm -v`和`node -v`验证是否安装配置成功

```bash
$npm -v
6.13.0

$node -v
v12.13.0
```

#### Windows

下载稳定版或者最新版都可以[Node.js](http://nodejs.cn/download/)，安装选项全部默认，一路点击`Next`。最后安装好之后，按`Win+R`打开命令提示符，输入`node -v`和`npm -v`，如果出现版本号，那么就安装成功了。

### 3.安装Git

### 4.注册Github

## 第二部分：搭建

### 1.安装Hexo
### 2.部署到Github
### 3.绑定个人域名
### 4.写文章、发布文章
### 5.备份博客源文件
## 第三部分：定制
### 1.更换主题
### 2.设置文章模板
### 3.添加404页面
### 4.添加二级菜单
### 5.图片添加水印
### 6.动态标签栏
### 7.添加豆瓣插件
### 8.统一友链卡片样式
### 9.添加交换友链卡片
### 10.修改各菜单首图样式
### 11.在文章中添加网易云音乐
### 12.建站时间、卜算子计数
### 13.关于页面添加简历
### 14.添加评论插件
### 15.添加RSS插件
### 16.添加搜索插件
### 17.添加代码高亮插件
### 18.修改打赏功能
### 19.
## 第四部分: 优化
### 1.URL优化
### 2.SEO优化
### 3.加载速度优化
### 4.图片懒加载
### 5.CDN优化
## 第五部分: Debug
### 1.解决部分菜单页面，标签栏不显示中文标题
