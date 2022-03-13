---
title: "Linux命令学习记录 Man命令"
date: 2022-03-13T14:07:14+08:00
draft: false
tags: ["Linux", "man"]
categories: ["Linux"]
description: ""
---

## 1. 简介

man 命令是 Linux 下的帮助指令，man 是 manual（手册）的缩写。通过 man 指令可以查看 Linux 中的指令手册、指令使用信息等内容。

## 2. 基本使用

### 语法

```
man (选项) (参数)
```

### 选项

```
-a：在所有的man帮助手册中搜索；
-f：等价于whatis指令，显示给定关键字的简短描述信息；
-P：指定内容时使用分页程序；
-M：指定man手册搜索的路径。
-k：关键字搜索
```

### 参数

```
数字：指定从哪本 man 手册中搜索帮助
关键字：指定要搜索帮助的关键字
```

## 3. 手册章节

```
(1) 普通命令，如cd、chmod、lp、mkdir和passwd。
(2) 由内核提供的底层系统调用，如intro和chmod。
(3) C库函数，如beep、HTML::Parser和Mail::Internet。
(4) 特殊文件，如/dev中找到的设备，包括控制台（console）、打印机（lp）和鼠标（mouse）。
(5) 文件格式和约定，如apt.conf、dpkg.cfg、hosts和passwd。
(6) 游戏，如atlantik、bouncingcow、kmahjongg和rubik。
(7) 杂项，包括宏包（macro package）。如ascii、samba和utf-8。
(8) root用户使用的系统管理命令，如mount和shutdown。
```

## 4. 手册内容

```
* NAME（命令名称）—— 命令的名称和简要的介绍。
* SYNOPSIS —— 命令的基本格式。
* DESCRIPTION —— 描述命令功能的概要介绍。
* OPTIONS（选项）—— man 命令最基本的部分：命令的各种选项，以及对每个选项的简短介绍。
* FILES（文件）—— 命令使用的其他文件。
* AUTHOR（作者）—— 编写命令的作者，以及联系信息。
* BUGS（错误）—— 已知的错误，以及如何报告新错误。
* COPYRIGHT（版权声明）—— 它的意义很明显，即版权信息。
* SEE ALSO（参见）—— 其他相关的命令。
```

## 5. 使用示例

可以使用 man man 来查看 man 指令的使用手册。

```
man man
```

查看 ls 指令的使用手册

```
man ls 
```

搜索 top 指令

```
man -k top
```

指定手册章节查看 top 指令

```
man 1 top
```

