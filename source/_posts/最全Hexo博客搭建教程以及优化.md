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
#  最全Hexo博客搭建教程以及优化

> 使用Hexo+Github搭建一个免费的个人博客

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

####  npm加速

一般国内通过`npm`下载东西会比较慢，所以需要添加阿里的源进行加速。

```bash
npm config set registry https://registry.npm.taobao.org
```

### 3.安装Git

为了把本地的网页文件上传到`Github`上面去，我们需要用到分布式版本控制工具 `git`。关于`git`和`Github`这里就不多介绍了。同样分为两个版本：

####  Linux

在Linux平台比较方便，直接使用命令就可以安装：

```bash
sudo apt-get install git
```

安装完成后即可享用。

####  Windows

需要去官网下载[Git]( https://git-scm.com/download/win )，下载完成后按照向导安装即可。

> 注意：在安装的最后一步添加路径时选择 Use Git from the Windows Command Prompt 。这是把Git添加到了环境变量中，以便可以在cmd中使用。而本人推荐使用下载附带的git bash进行操作，比较方便。

对于git的讲解和使用，大家可以自行到网上查找。`Hexo`搭建的过程中，已经封装好一个git命令，可以直接使用`hexo`的命令将生成的静态网站代码同步到`github`的仓库里。但是如果想要自己同步源码的话，那么就需要掌握一下git命令了。在这里我只列举一下常用的命令：

```bash
git init #初始化一个git库，生成.git文件夹，里面保存的是该git库的记录和配置
git remote add origin 远程仓库地址 #将本地仓库和远程仓库链接起来
git pull #同步代码
git status #检查本地仓库修改状态
git add 文件名 或者 git add .  #将本地修改的文件加入缓存
git commit 文件名 -m "描述" 或者 git commit . -m "描述"  #提交缓存，并描述该提交
git push -u origin code 
# 将本地的提交推送到远程仓库.-u是代表输入账号密码，如果你已经配置了git的公钥，那么可直接push.
```

### 4.注册Github

`Git`安装完成之后就可以去[Github]( https://github.com/ )上注册账号并创建仓库， 用来存放我们的网站了。

>  Github是基于 Git 做版本控制的代码托管平台，同时也是全球最大的代（同）码（性）托（交）管（友）网站。 

创建完账户之后新建一个项目仓库`New repository`，如下所示 

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_github_new_rep.png)

接着输入仓库名，后面一定要加`.github.io`后缀，README初始化也要勾上。 如下图配置（因为我的已经存在相同的仓库，所以报错）

> 要创建一个和你用户名相同的仓库，后面加.github.io，只有这样将来要部署到GitHub page的时候，才会被识别，也就是http://xxxx.github.io，其中xxx就是你注册`GitHub`的用户名 

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_github_creat_rep.png)

然后项目就建成了，点击`Settings`，向下拉到最后有个`GitHub Pages`，点击`Choose a theme`选择一个主题。然后等一会儿，再回到`GitHub Pages`，点击新出来的链接，就会进入到`github page`的界面。看到这个界面就说明`Github`的`page`已经可以使用了，接下来我们进入`Hexo`的搭建。

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
