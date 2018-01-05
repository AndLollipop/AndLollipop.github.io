---
title: 不为人知的ConstraintLayout完全解析 #文章的标题
author: 老头
date: 2018-01-04 18:31 #文章生成時間
updated: 2018-01-04 18:31 #更新日期
categories:
- 玩转UI # 这个是技术所属模块名 你也可以定义多个类别，但至少有为两个
- 技术周 # 这个是我们的计划起名技术周
tags: 玩转UI # 这个是所属的Tag也是最显眼的位置要以技术类别进行划分
---
## 前言
&emsp;&emsp;Constraintlayout这个控件出来也有一段时间了，从之前只是简单的使用，到现在算是有自己的理解。ConstraintLayout顾名思义约束布局，主要的功能就是用来约束子控件行为，类似RelativeLayout控件但更优于它，网上大多推荐使用预览界面进行操作，当然我也不排斥，但是工具永远都是用来用的，我们应该知其然又知其所以然。

在开始之前有必要分享一下自己所翻阅的资料

> 郭霖大神可视化操作 http://blog.csdn.net/guolin_blog/article/details/53122387
> 官方可视化操作  https://developer.android.com/training/constraint-layout/index.html
> 官方ConstraintLayout文档 https://developer.android.com/reference/android/support/constraint/ConstraintLayout.html

## 正文
&emsp;&emsp;以前我们在写布局都要嵌套好多层先不说做敲着有没有劲，就说性能上也会因为嵌套层数过多性能底下，针对这样的问题和初衷才有了学习ConstraintLayout的必要。

&emsp;&emsp;本文我们将从ConstraintLayout的使用、Barrier的使用、Guideline的使用、Placeholder的使用、Group的使用来揭开ConstraintLayout神秘的面纱，OK，开始我们的学习之旅
#### 环境搭建
&emsp;&emsp;在开始之前我们需要依赖ConstraintLayout库

``` java
dependencies {
    implementation 'com.android.support.constraint:constraint-layout:1.1.0-beta3'
}
```
&emsp;&emsp;不知道要依赖那个版本的tx可以查看Googleblog，要引用最新的不然有一些功能将无法使用，具体哪些功能看官网

> https://androidstudio.googleblog.com/2017/10/constraintlayout-110-beta-3-is-now.html

#### ConstraintLayout的使用
对于ConstraintLayout，官方文档中也通过几个方面来进行了讲解，这里和官方文档思路一致一一进行讲解，写了这么多文字不来个图确实委屈了这么高大上的文章

![ConstraintLayout的使用](http://p1chajscf.bkt.clouddn.com/20171225_constraintlayout_custom.png)

如果要问看了这篇文档做干啥，可以明确告诉你，你能做出这个效果进而做出更加复杂的效果。

##### 相对定位（RelativeLayout Position）
相对定位是一个ConstraintLayout布局的基本形态,这些约束允许您定位给定的控件相对于另一个控件。该约束可以是水平轴/垂直轴,具体的写法

``` java
<Button
    android:id="@+id/button02"
    android:layout_width="120dp"
    android:layout_height="180dp"
    android:text="button02"
    app:layout_constraintBaseline_toBaselineOf="@id/button01"
    app:layout_constraintLeft_toRightOf="@id/button01"
    app:layout_constraintRight_toRightOf="parent"/>
```
layout_constraintLeft_toLeftOf 意味着当前控件的左侧和某个控件的左侧对齐<br/>
tools:layout_editor_absoluteY  只是在可视化界面里面有效果

##### 外边距 (Margins)
在外边距ConstraintLayout提供了当约束控件gone掉之后所设置的margin，之所以有这个存在也是考虑在gone掉一个控件的时候不想破坏掉布局结构，来看用法

``` java
layout_goneMarginStart
layout_goneMarginEnd
layout_goneMarginLeft
layout_goneMarginTop
layout_goneMarginRight
layout_goneMarginBottom
```
gone掉的控件会被解析成一个点，并忽略margin，当你为其设置了约束也还是会起作用，经常配合app:layout_goneMargin(在所约束控件gone掉才起作用)来使用

``` java
<android.support.constraint.ConstraintLayout>
    <Button
        android:id="@+id/button01"
        android:layout_width="100dp"
        android:layout_height="60dp"
        android:text="button01" />

    <Button
        android:id="@+id/button02"
        android:layout_width="120dp"
        android:layout_height="100dp"
        android:layout_marginLeft="10dp"
        android:text="消失button01"
        app:layout_constraintLeft_toRightOf="@id/button01"
        app:layout_goneMarginLeft="110dp" />

</android.support.constraint.ConstraintLayout>
```
需要注意的是这里的goneMarginLeft的值是自身MarginLeft+Gone掉Button的宽度

#### 中心位置 (center position)
在ConstraintLayout中如果想让子控件居中,官方称之为不可能发生，通过看官方的图我们可以理解为就好像一个控件左右两边同时用同样的力致使控件居中显示

![](https://developer.android.com/reference/android/support/constraint/resources/images/centering-positioning.png)

具体操作
``` java
<Button
    android:id="@+id/button01"
    android:layout_width="100dp"
    android:layout_height="60dp"
    android:text="button01"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintRight_toRightOf="parent" />
```
为什么要这么理解呢？因为官方有给了一个偏向的属性bias，它的作用就是用来使约束更偏向于哪一边，默认是0.5 <br/>
layout_constraintHorizontal_bias (0最左边 1最右边) <br/>
layout_constraintVertical_bias (0最上边 1 最底边) <br/>
例如定义horizontal 0.9 则会在水平方向上向右偏移至90%

#### 圆定位 (Circular Position)
对于这个也是比较简单的，这里也来一张官方图

![](https://developer.android.com/reference/android/support/constraint/resources/images/circle1.png)

对于这张图我们需要去理解三个属性

> layout_constraintCircle : 约束控件的id   <br/>
> layout_constraintCircleRadius : 该控件中心点和约束控件中心点的距离  <br/>
> layout_constraintCircleAngle : 角度  

![](https://developer.android.com/reference/android/support/constraint/resources/images/circle2.png)

这张图就需要理解一下通过设置之后有什么样的效果显示就可以了

#### 尺寸约束 (dimensions constraints)
在ConstraintLayout布局里为控件设置宽高提供了三种方式
1. 确定尺寸 12dp
2. WRAP_CONTENT
3. 0dp，就等于MATCH_CONSTRAINT

唯一不同的是MATCH_CONSTRAINT,在Google文档中说明对于包含在ConstraintLayout中的控件，不建议使用MATCH_PARENT，对于使用了MATCH_CONSTRAINT的控件将使该控件和约束控件的宽高一致，如果为其设置了margin属性在计算的时候也考虑在内

```
<android.support.constraint.ConstraintLayout>
    <Button
        android:id="@+id/button01"
        android:layout_width="200dp"
        android:layout_height="90dp"
        android:text="button01" />
    <Button
        android:id="@+id/button02"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginLeft="20dp"
        android:layout_marginRight="20dp"
        android:text="Button02"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toBottomOf="@id/button01" />
</android.support.constraint.ConstraintLayout>
```
效果如下：

![](http://p1chajscf.bkt.clouddn.com/20180105_dimensions_constraints.png)

与其一起使用的还有ratio比例,有两种取值<br/>
1. 浮点值，表示宽度和高度之间的比率 （2,0.5）
2. width:height形式的比例 （5:1,1:5）

&emsp;&emsp;当有一个维度设置为MATCH_CONSTRAINT（0dp）时，就可以根据比率来进行计算,如果两个维度均设置为MATCH_CONSTRAINT（0dp），这种情况下，系统会使用满足所有约束条件和比率的最大尺寸，如果需要根据一个维度的尺寸去约束另一个维度的尺寸则可以在比的前面加上W或者H来约束宽高，用逗号隔开<br/>
&emsp;&emsp;这里用“H”表示以高度为约束，高度的最大尺寸就是父控件的高度，“2:1”表示高：宽 = 2 : 1.
则宽度为高度的一半

``` java
<android.support.constraint.ConstraintLayout>
<Button
    android:id="@+id/button03"
    android:layout_width="0dp"
    android:layout_height="100dp"
    android:text="Button02"
    app:layout_constraintDimensionRatio="1:1" />
<Button
    android:id="@+id/button4"
    android:layout_width="0dp"
    android:layout_height="0dp"
    android:layout_marginTop="100dp"
    android:text="button4"
    app:layout_constraintBottom_toBottomOf="parent"
    app:layout_constraintDimensionRatio="H,2:1"
    app:layout_constraintTop_toBottomOf="@id/button03" />
</android.support.constraint.ConstraintLayout>
```
