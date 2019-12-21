---
title: Windows下命令行工具-Cmder
toc: true
mathjax: false
tags:
  - cmder
categories:
  - 便捷工具
excerpt: Windows下程序员必备命令行神器-Cmder的安装与配置。
abbrlink: 7d402318
date: 2019-12-21 20:35:51
---

## 简介

在Linux操作系统下工作久的程序员，在Windows上开发很难适应windows自带的cmd命令行。在此推荐一款开发神器 - Cmder，让你可以在Windows下也可以像Linux中那样使用命令行。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cmder_main.png)



## 下载

[官网地址]( https://cmder.net/ )

进入官网以后，有Mini版和完整版，建议完整版，完整版功能更齐全，还可以使用`git`，下载好解压文件包以后就可以使用。 

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cmder_download.png)

解压位置随意，但是个人建议解压到C盘下。如果你解压到了C盘，打开cmder.exe时可能会失败，因为需要使用管理员权限才可以打开。此时我们只需要右键点击Cmder.exe，选择属性 - > 兼容性 - > 勾选以管理员身份运行此程序即可（如下图），这样以后每次打开都不需要使用管理员身份运行了，同时在其他文件夹下使用右键开启也不会报错了。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cmder_add_auth.png)



## 配置环境变量

在系统变量PATH添加cmder.exe的路径，使可以在任何位置都可以执行Cmder。

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cmder_add_path.png)



## 添加到右键菜单

对开始菜单按钮右击，选择打开windows powershell的管理员模式，执行以下命令即可： 

```bash
Cmder.exe /REGISTER ALL
```

执行完该命令后，在任何文件夹下点击鼠标右键就可以执行Cmder了。



## 如何从右键菜单删除

我们可以通过修改注册表的方式，删除掉右键菜单中不想要的选项。

* 点击左下角开始菜单 -> 运行（输入regedit）->  确定或者回车。

* 在打开的注册表中找到：HKEY_CLASSES_ROOT，并点HKEY_CLASSES_ROOT前面的小三角；找到Directory，点击前面的小三角；找到Background，点击前面的小三角；打开shell，可以看到Cmder，看清楚哦，不是cmd是Cmder。右键点击它然后选择删除即可。

* 接下来关闭注册表，在桌面上右击鼠标就能看到Cmder选项被删除啦！

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cmder_delte_reg.png)



## 界面设置

首先使用`windows+alt+p`进入界面设置
![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_cmder_setting.png)



## 快捷键

```bash
Tab       自动路径补全
Ctrl+T    建立新页签
Ctrl+W    关闭页签
Ctrl+Tab  切换页签
Alt+F4    关闭所有页签
Alt+Shift+1 开启cmd.exe
Alt+Shift+2 开启powershell.exe
Alt+Shift+3 开启powershell.exe (系统管理员权限)
Ctrl+1      快速切换到第1个页签
Ctrl+n      快速切换到第n个页签( n值无上限)
Alt + enter 切换到全屏状态
Ctr+r       历史命令搜索
Win+Alt+P   开启工具选项视窗
```

