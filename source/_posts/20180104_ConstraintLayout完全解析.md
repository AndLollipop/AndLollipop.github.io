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
### 前言
&emsp;&emsp;Constraintlayout这个控件出来也有一段时间了，从之前只是简单的使用，到现在算是有自己的理解。ConstraintLayout顾名思义约束布局，主要的功能就是用来约束子控件行为，类似RelativeLayout控件但更优于它，网上大多推荐使用预览界面进行操作，当然我也不排斥，但是工具永远都是用来用的，我们应该知其然又知其所以然。

在开始之前有必要分享一下自己所翻阅的资料

> 郭霖大神可视化操作<br/> http://blog.csdn.net/guolin_blog/article/details/53122387 <br/>
> 官方可视化操作 <br/> https://developer.android.com/training/constraint-layout/index.html <br/>
> 官方ConstraintLayout文档 <br/> https://developer.android.com/reference/android/support/constraint/ConstraintLayout.html

### ConstraintLayout的使用
&emsp;&emsp;以前我们在写布局都要嵌套好多层先不说做敲着有没有劲，就说性能上也会因为嵌套层数过多导致性能低下，针对这样的问题和初衷才有了学习ConstraintLayout的必要。

&emsp;&emsp;本文我们将从ConstraintLayout的使用、Barrier的使用、Guideline的使用、Placeholder的使用、Group的使用来揭开ConstraintLayout神秘的面纱，OK，开始我们的学习之旅
#### 环境搭建
&emsp;&emsp;在开始之前我们需要依赖ConstraintLayout库

``` java
dependencies {
    implementation 'com.android.support.constraint:constraint-layout:1.1.0-beta3'
}
```
&emsp;&emsp;不知道要依赖那个版本的tx可以查看Googleblog，最好引用最新的库，不然有一些功能将无法使用，具体哪些功能看官网

https://androidstudio.googleblog.com/2017/10/constraintlayout-110-beta-3-is-now.html

&emsp;&emsp;对于ConstraintLayout，官方文档中也通过几个方面来进行了讲解，可能是因为英文的原因加上官网例子很少导致很难去理解这些知识点，本文将和官方文档讲解思路一致对其进行顺序讲解，好了，写了这么多文字不来个图确实委屈了这么高大上的文章

![ConstraintLayout的使用](http://p1chajscf.bkt.clouddn.com/20171225_constraintlayout_custom.png)

&emsp;&emsp;可能大家想知道学了这个能做出什么，这里可以告诉你的是学了之后可以使用一层布局写出上面的效果并且可以使用一层布局做出更加复杂的效果。

#### 相对定位（RelativeLayout Position）
&emsp;&emsp;相对定位是一个ConstraintLayout布局的基本形态,这些约束允许您定位给定的控件相对于另一个控件。该约束可以是水平轴/垂直轴,具体的写法

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
&emsp;&emsp;layout_constraintLeft_toLeftOf 意味着当前控件的左侧和某个控件的左侧对齐
这里也提一下如果你使用拖拽方式将会在生成tools:layout_editor_absoluteY代码，这代码只是在可视化界面里面有效果

#### 外边距 (Margins)
&emsp;&emsp;在外边距ConstraintLayout提供了当约束控件gone掉之后所设置的margin，之所以有这个属性的存在大概Google也是考虑在gone掉一个控件的时候不想破坏掉其布局结构，来看用法

* layout_goneMarginStart
* layout_goneMarginEnd
* layout_goneMarginLeft
* layout_goneMarginTop
* layout_goneMarginRight
* layout_goneMarginBottom

&emsp;&emsp;gone掉的控件会被解析成一个点，并忽略margin，当你为其设置了约束也还是会起作用，经常配合app:layout_goneMargin(在所约束控件gone掉才起作用)来使用

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
&emsp;&emsp;需要注意的是这里的goneMarginLeft的值是自身MarginLeft+Gone掉Button的宽度+Gone掉Button的Margin

#### 中心位置 (center position)
&emsp;&emsp;在ConstraintLayout中如果想让子控件居中,在官方文档中称之为不可能发生，通过看官方的图我们可以理解为就好像一个控件左右两边同时用同样的力致使控件居中显示,就像下图所展示的那样

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
&emsp;&emsp;这样理解可能更加深刻一点，当然之所以这么去理解是因为官方又给了叫偏向的属性bias(需要结合约束来使用)，它的作用就是用来使约束更偏向于哪一边，默认是0.5 <br/>
* layout_constraintHorizontal_bias (0最左边 1最右边)
* layout_constraintVertical_bias (0最上边 1 最底边)

例如定义horizontal 0.9 则会在水平方向上向右偏移至90%

#### 圆定位 (Circular Position)
&emsp;&emsp;对于这个也是比较简单的，这里也来一张官方图，通过看官方图也就知道使用之后的效果啦~

![](https://developer.android.com/reference/android/support/constraint/resources/images/circle1.png)

对于这张图我们需要去理解三个属性

* layout_constraintCircle : 约束控件的id   <br/>
* layout_constraintCircleRadius : 该控件中心点和约束控件中心点的距离  <br/>
* layout_constraintCircleAngle : 角度  

![](https://developer.android.com/reference/android/support/constraint/resources/images/circle2.png)

这张图就需要理解一下通过设置之后有什么样的效果显示就可以了

#### 尺寸约束 (dimensions constraints)
在ConstraintLayout布局里为控件设置宽高提供了三种方式
* 确定尺寸 12dp
* WRAP_CONTENT
* 0dp，就等于MATCH_CONSTRAINT

&emsp;&emsp;唯一不同的是MATCH_CONSTRAINT,在Google文档中说明对于包含在ConstraintLayout中的控件，不建议使用MATCH_PARENT。对于使用了MATCH_CONSTRAINT的控件将使该控件和约束控件的宽高一致，如果为其设置了margin属性在计算的时候也考虑在内

``` java
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
给个效果体会一下：

![](http://p1chajscf.bkt.clouddn.com/20180105_dimensions_constraints.png)

与MATCH_CONSTRAINT一起使用的还有ratio比例,它代表这自身宽高比例。有两种取值：<br/>
1. 浮点值，表示宽度和高度之间的比率 （2,0.5）
2. width:height形式的比例 （5:1,1:5）

&emsp;&emsp;当有一个维度设置为MATCH_CONSTRAINT（0dp）时，就可以根据比率来进行计算,如果两个维度均设置为MATCH_CONSTRAINT（0dp），这种情况下，系统会使用满足所有约束条件和比率的最大尺寸，如果需要根据一个维度的尺寸去约束另一个维度的尺寸则可以在比的前面加上W或者H来约束宽高，用逗号隔开<br/>

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
&emsp;&emsp;这里用“H”表示以高度为约束，高度的最大尺寸就是父控件的高度，“2:1”表示高：宽 = 2 : 1.则宽度为高度的一半
#### 链 (Chains)
&emsp;&emsp;如何创建一个链呢，只需要一组控件通过双向链接在一起就构成了一个链，官方也给出了图形，这里也引用一下便于理解

![链的创建](https://developer.android.com/reference/android/support/constraint/resources/images/chains.png)

这似乎并无卵用，然而重点是链的样式

![链的样式](https://developer.android.com/reference/android/support/constraint/resources/images/chains-styles.png)

&emsp;&emsp;这看起来似乎和rn的flex布局类似，如果你要是学过rn的话对于链会有更好的理解，下面来对每个样式进行说明
* spread - 元素将被展开（默认样式）
* 加权链 - 在spread模式下，如果某些小部件设置为MATCH_CONSTRAINT，则它们将拆分可用空间
* spread_inside - 类似，但链的端点将不会扩展
* packed - 链的元素将被打包在一起。 孩子的水平或垂直偏差属性将影响包装元素的定位

对于使用该知识点的地方常见的就是底部的TAB平分屏幕,给个代码体会一下
``` java
<Button
    android:id="@+id/button01"
    android:layout_width="100dp"
    android:layout_height="wrap_content"
    android:text="button01"
    app:layout_constraintHorizontal_chainStyle="spread"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintRight_toLeftOf="@id/button02"
    app:layout_constraintHorizontal_bias="1.0"/>

<Button
    android:id="@+id/button02"
    android:layout_width="100dp"
    android:layout_height="wrap_content"
    android:text="button02"
    app:layout_constraintLeft_toRightOf="@id/button01"
    app:layout_constraintRight_toLeftOf="@id/button03" />

<Button
    android:id="@+id/button03"
    android:layout_width="100dp"
    android:layout_height="wrap_content"
    android:text="button02"
    app:layout_constraintLeft_toRightOf="@id/button02"
    app:layout_constraintRight_toRightOf="parent" />
```
### Barrier、Guideline的使用
&emsp;&emsp;为什么要放在一起来进行讲解呢？因为Barrier和Guideline都是虚拟视图，更重要的是都是用来进行约束控件。当然也有不同之处：
1. Barrier是有多个View的大小来决定的，通过constraint_referenced_ids 用来指定哪些View来进行约束，barrierDirection 用来Barrier相对于约束View的方向
2. Guidelin在布局里面充当辅助线，android:orientation 决定线的方向是水平还是竖直方向,其它的属性
  * layout_constraintGuide_begin
  * layout_constraintGuide_end
  * layout_constraintGuide_percent

当orientation为水平的时候
    begin=100dp 为距离顶部100dp有个辅助线
    end=100dp 为距离底部100dp有个辅助线
    percent=0.8 为距离顶部80%有个辅助线

好了，一图胜千言，让我们在搞一个ImageView位置在右下角类似FloatActionBar的效果
``` java
<android.support.constraint.ConstraintLayout>

    <android.support.constraint.Guideline
        android:id="@+id/vertical_guideline"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        app:layout_constraintGuide_percent="0.8" />

    <android.support.constraint.Guideline
        android:id="@+id/horizontal_guideline"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        app:layout_constraintGuide_percent="0.8" />

    <ImageView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/ic_launcher_round"
        app:layout_constraintLeft_toRightOf="@id/vertical_guideline"
        app:layout_constraintTop_toBottomOf="@id/horizontal_guideline" />

</android.support.constraint.ConstraintLayout>
```

![](http://p1chajscf.bkt.clouddn.com/20180106_guideline.png)

### Placeholder的使用
&emsp;&emsp;Placeholder顾名思义，就是用来一个占位的东西，它可以把自己的内容设置为ConstraintLayout内的其它view。因此它用来写布局的模版，也可以用来动态修改UI的内容。

&emsp;&emsp;每个PlaceHolder都设置了自己的app:content属性，比如app:content="@+id/edit"，表示用id为edit的控件来填充这个位置，OK，通过下面的代码熟悉一下
``` Java
<android.support.constraint.ConstraintLayout>
    <android.support.constraint.Placeholder
        android:id="@+id/placeholder_action"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        app:content="@+id/kongjian"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <ImageView
        android:id="@+id/kongjian"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_kongjian"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toLeftOf="@id/qq" />

    <ImageView
        android:id="@+id/qq"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_qq"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintLeft_toRightOf="@id/kongjian"
        app:layout_constraintRight_toLeftOf="@id/tw" />

    <ImageView
        android:id="@+id/tw"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_tw"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintLeft_toRightOf="@id/qq"
        app:layout_constraintRight_toLeftOf="@id/wechat" />

    <ImageView
        android:id="@+id/wechat"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_wechat"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintLeft_toRightOf="@id/tw"
        app:layout_constraintRight_toRightOf="parent" />

</android.support.constraint.ConstraintLayout>
```

``` java
constraintLayout = findViewById(R.id.constraintLayout);
findViewById(R.id.kongjian).setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        TransitionManager.beginDelayedTransition(constraintLayout);
        placeholder_action.setContentId(v.getId());
    }
});
```

![](http://p1chajscf.bkt.clouddn.com/20180106_placeholder.gif)

&emsp;&emsp;另外注意一下，我们在实际开发中可能会将使用placeholder的模板单独拿出来，但是拿出来之后就没有了提示，这里我们可以使用tools:parentTag="android.support.constraint.ConstraintLayout"，这样在编辑的时候就会让它按照ConstraintLayout来处理。

### Group的使用
&emsp;&emsp;该组件的可见性将应用于所引用的控件，这是一种便利的方法，可以轻松的隐藏一组窗口部件而无需以编程方式维护该集合，对于Group的使用比较简单，这里给出相应的使用代码，不多说，上代码
``` java
<android.support.constraint.ConstraintLayout>
    <Button
        android:id="@+id/button1"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Button1" />

    <Button
        android:id="@+id/button2"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Button2"
        app:layout_constraintTop_toBottomOf="@id/button1" />

    <Button
        android:id="@+id/button3"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="隐藏显示"
        app:layout_constraintTop_toBottomOf="@id/button2" />

    <android.support.constraint.Group
        android:id="@+id/group"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:visibility="visible"
        app:constraint_referenced_ids="button1,button2" />
</android.support.constraint.ConstraintLayout>
```
### 实战
最后开始撸我们开始展示的布局
``` java
<android.support.constraint.ConstraintLayout
    android:padding="8dp">

    <android.support.constraint.Guideline
        android:id="@+id/guideline1"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        app:layout_constraintGuide_begin="20dp" />

    <android.support.constraint.Guideline
        android:id="@+id/guideline2"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        app:layout_constraintGuide_begin="5dp" />

    <ImageView
        android:id="@+id/img"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/head"
        app:layout_constraintBottom_toTopOf="@id/name"
        app:layout_constraintLeft_toLeftOf="@id/guideline1"
        app:layout_constraintTop_toTopOf="@id/guideline2" />

    <android.support.constraint.Barrier
        android:id="@+id/img_barrier"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        app:barrierDirection="right"
        app:constraint_referenced_ids="img" />

    <TextView
        android:id="@+id/name"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Lypop"
        android:textColor="@android:color/white"
        android:textSize="16sp"
        app:layout_constraintLeft_toLeftOf="@id/guideline1"
        app:layout_constraintRight_toRightOf="@id/img_barrier"
        app:layout_constraintTop_toBottomOf="@id/img" />

    <android.support.constraint.Barrier
        android:id="@+id/name_barrier"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        app:barrierDirection="bottom"
        app:constraint_referenced_ids="name" />

    <TextView
        android:id="@+id/id"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginLeft="10dp"
        android:text="名字ID：123456789"
        android:textColor="@android:color/white"
        android:textSize="14sp"
        app:layout_constraintBottom_toTopOf="@id/sex"
        app:layout_constraintLeft_toRightOf="@id/img"
        app:layout_constraintTop_toTopOf="@id/guideline2"
        app:layout_constraintVertical_chainStyle="spread" />

    <TextView
        android:id="@+id/sex"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginLeft="10dp"
        android:text="性别：man"
        android:textColor="@android:color/white"
        android:textSize="14sp"
        app:layout_constraintBottom_toTopOf="@id/sign"
        app:layout_constraintLeft_toRightOf="@id/img"
        app:layout_constraintTop_toBottomOf="@id/id" />

    <TextView
        android:id="@+id/sign"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginLeft="10dp"
        android:text="个性签名：我思故我在"
        android:textColor="@android:color/white"
        android:textSize="14sp"
        app:layout_constraintBottom_toBottomOf="@id/name_barrier"
        app:layout_constraintLeft_toRightOf="@id/img"
        app:layout_constraintTop_toBottomOf="@id/sex" />

    <ImageView
        android:id="@+id/bottom1"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_tw"
        app:layout_constraintBottom_toTopOf="@id/share1"
        app:layout_constraintHorizontal_chainStyle="spread"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toLeftOf="@id/bottom2" />

    <ImageView
        android:id="@+id/bottom2"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_qq"
        app:layout_constraintBottom_toTopOf="@id/share2"
        app:layout_constraintLeft_toRightOf="@id/bottom1"
        app:layout_constraintRight_toLeftOf="@id/bottom3" />

    <ImageView
        android:id="@+id/bottom3"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_kongjian"
        app:layout_constraintBottom_toTopOf="@id/share3"
        app:layout_constraintLeft_toRightOf="@id/bottom2"
        app:layout_constraintRight_toLeftOf="@id/bottom4" />

    <ImageView
        android:id="@+id/bottom4"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:src="@mipmap/share_wechat"
        app:layout_constraintBottom_toTopOf="@id/share4"
        app:layout_constraintLeft_toRightOf="@id/bottom3"
        app:layout_constraintRight_toRightOf="parent" />

    <TextView
        android:id="@+id/share1"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="分享1"
        android:textSize="18sp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintHorizontal_chainStyle="spread"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toLeftOf="@id/share2" />

    <TextView
        android:id="@+id/share2"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="分享2"
        android:textSize="18sp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toRightOf="@id/share1"
        app:layout_constraintRight_toLeftOf="@id/share3" />

    <TextView
        android:id="@+id/share3"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="分享3"
        android:textSize="18sp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toRightOf="@id/share2"
        app:layout_constraintRight_toLeftOf="@id/share4" />

    <TextView
        android:id="@+id/share4"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="分享4"
        android:textSize="18sp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toRightOf="@id/share3"
        app:layout_constraintRight_toRightOf="parent" />

</android.support.constraint.ConstraintLayout>
```
&emsp;&emsp;这里面有一点需要注意的是，如何才能将下面的名字和头像居中，这里采用的是Barrier的特性，只需要给名字控件添加向左依赖和向右和Barrier的依赖即可居中，看下图

![](http://p1chajscf.bkt.clouddn.com/20180107_constraintlayout_show.png)

### 结束语
&emsp;&emsp;OK，ConstraintLayout就讲解完毕，虽然这些可以通过拖拽来进行操作可能还会完成的更好，但是还是那句话我们要做到知其然又知其所以然。

**我思故我在**

源码下载地址：https://github.com/AndLollipop/ConstraintLayout

-------------------
### 修正
1、在头像和下面的名字可以让TextView左右和ImageView进行约束来达到文字和图片中间对齐

``` java
<ImageView
    android:id="@+id/img"
    android:layout_width="62dp"
    android:layout_height="60dp"
    android:layout_marginLeft="30dp"
    android:layout_marginRight="20dp"
    android:src="@mipmap/head"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintRight_toLeftOf="@id/barrier"
    app:layout_constraintTop_toTopOf="@id/guideline1" />

<TextView
    android:id="@+id/name"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_marginTop="10dp"
    android:text="hahhjha"
    app:layout_constraintLeft_toLeftOf="@id/img"
    app:layout_constraintRight_toRightOf="@id/img"
    app:layout_constraintTop_toBottomOf="@id/img" />
```
