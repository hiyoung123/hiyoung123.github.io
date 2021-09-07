---
title: Pandas常用代码总结
toc: true
mathjax: true
tags:
  - pandas
  - python
categories:
  - 数据分析
excerpt: Pandas常用代码总结。
abbrlink: ed5d9995
date: 2021-09-07 15:18:53
---

# Pandas 常用代码

---

## 01. 加载库

```python
import pandas as pd
```

## 02. 读取CSV文件

```python
df = pd.read_csv(file)
```

## 03. 显示头/尾数据

```python
df.head(n) # 显示头n行数据，默认5行
df.tail(n) # 显示尾n行数据，默认5行
```

## 04. 查看数值型特征统计信息

```python
df.describe()
```

## 05. 查看数据表基本信息

```python
df.info()
```

## 06. 查看列名

```python
df.columns
```

## 07. 查看空值

```python
df.isnull()
df.isna()
df.isna().any() # 查看是否有缺失值
df.isna().sum(axis=0) # 查看列缺失值数量
df.isna().sum(axis=1) # 查看行缺失值数量
```

## 08. 查看某一列的唯一值

```python
df[列名].unique()
```

## 09. 查看数据表维度

```python
df.shape
```

## 10. 查看数据表值（转为矩阵）

```python
df.values
```

## 11. 查看某列值数量

```python
df[列名].value_counts()
```

## 12. 删除重复数据

```python
df[列名].drop_duplicates() # 删除后出现的重复数据
df[列名].drop_duplicates(keep='last') # 删除先出现的重复数据
```

## 13. 空值填充

```python
df.fillna(value=0) # 使用0填充
df[列名].fillna(df[列名].mean()) # 使用某列均值进行填充
```

## 14. 更改列名

```python
df.rename(columns={old: new})
```

## 15. 数据替换

```python
df[列名].replace('', '')
```

## 16. 判断是否包含某值

```python
df[列名].isin([''])
```

## 17. 删除空值

```python
df.dropna() # 默认删除含有空值的行
df.dropna(how = 'all') # 删除所有列都是空的行
df.dropna(how = 'any') # 只要包含空值的行就删除
df.dropna(axis = 1)  # 删除含有空值的列
df.dropna(axis=1,how="all") # 删除全部为缺失值的列
df.dropna(axis=0,subset = ["Age", "Sex"]) # 删除 Age Sex 两列中有缺失值的行。
```

## 18. 将函数做用于数据

```python
df.apply(function, axis=0) # axis=0 列 axis=1 行
df.applymap(function, ) # 对每一个元素进行操作
df[列].map(fuction,) # 对一列数据进行操作
```

## 19. 数据排序

```python
df.sort_values(ascending=False)
```

## 20. 删除空白字符

```python
df.replace(to_replace=r'^\s*$',value=np.nan,regex=True,inplace=True)
```

 






