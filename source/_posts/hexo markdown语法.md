---
title: hexo markdown语法 #文章的标题
date: 2017-12-22 6:38 #文章生成時間
categories: markdown语法
tags: markdown语法
---

# 目录

  [TOC]

# 文字

**粗体**

*斜体*

***加粗斜体***

~~删除线~~

## 外链接

[花花大世界](http://www.baidu.com)

[也可以这样][1]

[1]: http://www.baidu.com

## 为段落设置阴影

> 设置阴影效果

-------------------

>>> 多层嵌套

-------------------


# 代码

## 一行代码

`欢迎使用花花世界`

## 多行代码

``` python
@requires_authorization
def somefunc(param1='', param2=0):
    '''A docstring'''
    if param1 > param2: # interesting
        print 'Greater'
    return (param2 - param1 + 1) or None
class SomeClass:
    pass
>>> message = '''interpreter
... prompt'''
```

# 列表
## 有序列表
1.  有序1
2.  有序2
3.  有序3

## 无序列表
*   Red
*   Green
*   Blue

-------------------

# 表格

| Item      |    Value | Qty  |
| :-------- | --------:| :--: |
| Computer  | 1600 USD |  5   |
| Phone     |   12 USD |  12  |
| Pipe      |    1 USD | 234  |


-------------------


# 图片
![花花](http://p1chajscf.bkt.clouddn.com/TIM%E5%9B%BE%E7%89%8720171222121939.jpg)
