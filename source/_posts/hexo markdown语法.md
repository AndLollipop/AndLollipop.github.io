---
title: hexo markdown语法 #文章的标题
date: 2017-12-22 6:38 #文章生成時間
categories: markdown语法
tags: markdown语法
---

# 目录

[TOC]

#音乐

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=25715149&auto=1&height=66"></iframe>


## 文字

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

## 分割线

<hr />

## 换行
今天天气不错<br />我们去玩吧

## 插入颜文字

直接去该网址去copy就可以了
[颜文字网址](http://www.yanwenzi.com/zan/)

ヽ(￣ω￣(￣ω￣〃)ゝ

## 表情

1. 静态表情表情的话直接去该网址直接copy就可以了
[好多表情](https://www.emojicopy.com/)

😀😁

2. 动态表情的话可以使用我存入云存储的表情包，如果有其他的可以告诉我，我将其上传去

<img id="github-emoji" src="http://p1q9eyoe7.bkt.clouddn.com/1.gif" height="30" width="30" />

![表情](http://p1q9eyoe7.bkt.clouddn.com/1.gif)

## next主题自带一些样式可以使用

http://fontawesome.io/examples/

<!-- HTML方式: 直接在 Markdown 文件中编写 HTML 来调用 -->
<!-- 其中 class="blockquote-center" 是必须的 -->
<blockquote class="blockquote-center">blah blah blah</blockquote>

<!-- 标签 方式，要求版本在0.4.5或以上 -->
{% centerquote %}blah blah blah{% endcenterquote %}


{% note success %} Content (md partial supported) {% endnote %}

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
