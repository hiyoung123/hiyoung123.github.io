---
title: 利用Python进行数据分析
abbrlink: f5c80354
tags:
---

## 第1章 准备工作

### 什么样的数据

* 表格型数据。
* 多维数组（矩阵）。
* 通过关键列相互联系的多个表。
* 间隔平均或者不平均的时间序列。

大部分数据集都可以转化，或者一部分可以转换为可以进行数据分析建模的数据。

### 为什么要使用Python

### 重要的Python库

* Numpy
* Pandas
* Matplotlib
* IPython和Jupyter
* Scipy
* Scikit-learn
* Statsmodels

### 环境安装

* Anaconda安装
* 编辑器选择
* Python2和Python3



## 第2章 Python语法基础、IPython和Jupyter Notebooks

### Python基础

### IPython基础

可以直接在命令行输入以下命令开启`IPython`

```bash
$ipython
Python 3.7.4 (default, Aug 13 2019, 20:35:49) 
Type 'copyright', 'credits' or 'license' for more information
IPython 6.5.0 -- An enhanced Interactive Python. Type '?' for help.

In [1]: 
```

也可以使用`jupyter notebook`

```bash
$jupyter notebook
[I 12:30:06.158 NotebookApp] The port 8888 is already in use, trying another port.
[I 12:30:06.178 NotebookApp] JupyterLab extension loaded from /home/liuhaiyang/anaconda3/lib/python3.7/site-packages/jupyterlab
[I 12:30:06.178 NotebookApp] JupyterLab application directory is /home/liuhaiyang/anaconda3/share/jupyter/lab
[I 12:30:06.180 NotebookApp] Serving notebooks from local directory: /home/liuhaiyang/PycharmProjects/Python数据分析
[I 12:30:06.180 NotebookApp] The Jupyter Notebook is running at:
[I 12:30:06.180 NotebookApp] http://localhost:8889/?token=043dbd6fc98ea66832adc72a1ef2cd46c782a859a2da71c9
[I 12:30:06.180 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 12:30:06.194 NotebookApp] 
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://localhost:8889/?token=043dbd6fc98ea66832adc72a1ef2cd46c782a859a2da71c9
[I 12:30:06.477 NotebookApp] Accepting one-time-token-authenticated connection from 127.0.0.1

```

打开一个网页版的`notebook`编译器

### IPython常用命令

* Tab补全代码

* 自省`？`

  * 在变量后加一个`?`可以显示变量信息
  * 使用两个`?`可以显示函数的源码
  * 可以搜索命名空间

* `%run`命令

* `%load`命令

* `%paste`和`%cpaste`

  直接运行剪贴板上的代码

* 键盘快捷键

  * `Ctrl + A`将光标移动到一行的开头
  * `Ctrl + E`将光标移动到一行的结尾
  * `Ctrl + K`删除光标到行尾的文本
  * `Ctrl + U`删除光标所在行的文本
  * `Ctrl + F`光标向后移动一个字符
  * `Ctrl + B`光标向前移动一个字符
  * `Ctrl + L`清空屏幕

* 魔法命令`%`

  * `%timeit`
  * `%debug`
  * `%automagic`开启自动魔法命令，则不需要输入`%`
  * `%magic`显示所有魔法命令
  * `%matplotlib`集成`matplotlib`



## 第3章 Python的数据结构、函数和文件



## 第4章 Numpy基础：数组和矢量计算



## 第5章 Pandas入门

使用`loc`定位到具体数据，`loc`默认是索引行的，但是传入两个参数时，第一个索引行，第二个索引列。

```python
df.loc[df.年代列表.isna(),'年代列表'] = '未知' 
```

查看某个列是否有空值

```python
df.isna().any()
```

`loc`和`iloc`的区别：`loc`使用标签索引，`iloc`使用整数（标签所在的索引）去索引。

map和apply的区别：map作用于元素级别，apply作用于列或者行（默认是列也就是所有行，可以通过axis指定）。

排序

rank

统计相关常用函数

* `count`
* `describe`
* `min`和`max`
* `argmin`和`argmax`
* `idxmin`和`idxmax`
* `sum`
* `mean`
* `median`
* `mad`
* `var`
* `std`

相关系数和协方差矩阵：`corr`和`cov`

列值统计：`value_counts()`

列值资格：`isin([])`

填充空值：`fillna()`



## 第6章 数据加载、存储与文件格式

### 读写文本格式的数据

### 二进制数据格式

### Web APIs交互

### 数据库交互



## 第7章 数据清洗和准备

### 处理缺失数据

* 滤掉缺失数据
* 填充缺失数据

### 数据转换

* 移除重复数据
* 利用函数或映射进行数据转换
* 替换值
* 重命名轴索引
* 离散化和面元划分
* 检测和过滤异常值（outlier）
* 排列和随机采样
* 计算指标和哑变量

### 字符串操作

* 字符串对象方法
* 正则表达式
* Pandas的矢量化字符串函数



## 第8章 数据规整：聚合、合并和重塑

