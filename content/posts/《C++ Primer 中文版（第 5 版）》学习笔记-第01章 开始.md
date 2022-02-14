---
title: "《C++ Primer 中文版（第 5 版）》学习笔记-第01章 开始"
date: 2022-02-14T16:57:17+08:00
draft: false
tags: ["C++", "C++ Primer"]
categories: ["C++"]
description: ""
---

## 1.1 编写一个简单的 C++ 程序

### 1.1.1 Example

```c++
int main()
{
	return 0;
}
```

* 每个 C++ 程序必须包含一个或者多个函数，其中一个必须命名为 `main` 函数。
* 一个函数必须包含四部分：返回类型、函数名、形参列表和函数体。

### 1.1.2 编译、运行程序

* 程序源码存在一个或者多个文件中，通常称为源文件，常见后缀 `.cc`、`.cxx`、`.cpp`、`.cp` 以及 `.c`。

* 常见编译器：`g++`、`gcc`、`cl`

* 编译流程

  ```bash
  源代码 test.c
  预处理 test.i
  编译   test.s
  汇编   test.o
  链接   test.ext/test.out
  ```

* 编译命令

  ```bash
  g++ -std=c++11 -Wall -o prog01 prog01.cpp
  ```

* 运行可执行文件

  ```bash
  ./prog01
  ```

* 查看运行状态

  ```bash
  echo %ERRORLEVEL% # windows
  echo $? # UNIX
  ```

* 编译多个文件

  ```bash
  g++ -std=c++11 -Wall prog01.cpp Sales_item.cc -o prog01
  ```

* g++ 常用命令

  ```bash
  -std=c++11     # 指定c++版本
  -Wall          # 输出所有编译警告信息
  -E             # 预处理
  -S             # 编译
  -c             # 汇编
  -o             # 指定可执行文件并进行链接阶段
  -g             # 输出调试信息
  -fPIC          # 链接动态库
  -Dmacro=XXX    # 定义宏
  -llibrarytest  # 链接 librarytest 库
  -L             # 指定库文件路径
  -I             # 
  ```

## 1.2 初始输入输出

### 1.2.1 标准输入输出对象

* 标准输入输出库：`iostream`，包括 `istream` 和 `ostream`。
* 一个流就是一个字符序列，是从 IO 设备读出或者写入 IO 设备的。随着时间推移，字符是顺序生成或者消耗。
* 标准库定义了 4 个 IO 对象：`cin` 标准输入、`cout` 标准输出、`cerr` 标准错误、`clog` 标准日志信息。

### 1.2.2 一个使用 IO 库的程序

```c++
#include <iostream>
int main()
{
    std::cout << "Enter two numbers:" << std::endl;
    int vl = 0, v2 = 0;
    std::cin >> v1 >> v2;
    std::cout << "The sum of " << v1 << " and" << v2 << " is" << v1 + v2 << std::endl;
    return 0;
}
```

* 标准库的头文件使用 `<>`，非标准库的头文件使用 `""`
* `<<` 称为输出运算符，接收两个运算对象，左侧的运算对象必须是 `ostream` 对象，右侧的运算对象是要打印的值。与之对称的是输入运算符 `>>` 。
* 字符串字面常量，是被两个双引号包着的字符序列。
* `endl` 称为操纵符，效果是结束当前行，并把设备关联的缓冲区的内入刷新到设备中，保证执行到当前语句时，程序所产生的输出真正的写入到输出流中，而不是停留在缓存区。
* `std` 是标准库的命名空间，命名空间的作用是防止命名冲突。
* `::` 是作用域运算符，作用是访问标准库中的名字。

## 1.3  注释简介

* 注释的作用是帮助人类读者理解程序。

* 注释分为单行注释 `//` 和界定符注释 `/**/`（也叫多行注释）。

* 注释界定符 `/**/` 不能嵌套。

* 双引号内的注释会被忽略。

  ```c++
  #define SALESITEM_H
  /*
   * 多行注释格式
   * 每一行加一个*
   */
  ```

## 1.4 控制流

### 1.4.1 while 语句

```c++
#include <iostream>
int main()
{
    int sum = 0, val = 1;
    // 只要 val 的值小于等于 10， while 循环就会继续执行
    while (val <= 10) {
        sum += val;
        ++val;
    }
    std::cout << "Sum of 1 to 10 inclusive is " << sum << std::endl;
    return 0;
}
```

* while 语句反复执行一段代码，直到条件为假为止。
* 复合赋值运算符 `a += b`，表示 `a = a+b`
* 前缀递增运算符 `++a`，表示 `a = a+1`

### 1.4.2 for 语句

```c++
#include <iostream>
int main()
{
	int sum = 0;
    // 从 1 加到 10
    for (int val = 1; val <= 10; ++val)
    {
        sum += val; // 等价于 sum = sum + val
    }
    std::cout << "Sum of 1 to 10 inclusive is " << sum << std::endl;
    return 0;
}
```

循环头由三部分组成：

- 一个初始化语句（init-statement）
- 一个循环条件（condition）
- 一个表达式（expression）

### 1.4.3 读取数量不定的输入数据

```c++
#include <iostream>
int main()
{
    int sum = 0, value = 0;
    // 读取数据直到遇到文件尾，计算所有读入的值的和
    while (std::cin>>value) {
        sum += value;
    }
    std::cout << "Sum is: " << sum << std::endl;
    return 0;
}
```

### 1.4.4 if 语句

```c++
#include <iostream>
int main()
{
    // currVal 是要统计的数
    int currVal = 0, val = 0;
    // 读取第一个数
    if (std::cin>>currVal) {
        int cnt = 1;
        while (std::cin>>val) {
            if (val == currVal) {
                ++cnt;
            } else {
                std::cout << currVal << " occurs" << cnt << " times" << std::endl;
                currVal = val;
                cnt = 1;
            }
        }
        std::cout << currVal << " occurs" << cnt << " times" << std::endl;
    }
    return 0;
}
```

* if 语句支持条件执行，条件中可以出现 `==` 条件运算符页可以出现 `=` 赋值运算符，注意区分。

> 编译器可以检查形式上的错误，包括：语法错误、类型错误、声明错误。

## 1.5 类简介

* 使用类来定义数据结构。通常自己定义的类要放在头文件中，头文件的后缀通常时 `.h` 或者 `.hpp`、`.hxx`。

* 文件重定向操作

  ```bash
  addItems < infile > outfile
  
  addItems 是可执行程序
  < infile 表示从infile文件中获取数据，作为addItems程序的参数
  > outfile 表示addItems的输出输入到 outfile 中
  
  ```

* 成员函数是类的一部分的函数，也叫做方法。调用成员函数的方法为 `类对象.函数名`。

## 1.6 书店程序

```c++
#include <iostream>
#include "Sales_item.h"

int main()
{
    Sales_item total;
    if (std::cin>>total) {
        Sales_item trans;
        while (std::cin>>trans) {
            if (total.isbn() == trans.isbn()) {
                total += trans;
            } else {
                std::cout << total << std::endl;
                total = trans;
            }
        }
        std::cout << total << std::endl;
    } else {
        std::cerr << "No data ? " << std::endl;
        return -1;
    }
    return 0;
}
```

