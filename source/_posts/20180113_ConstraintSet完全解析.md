---
title: ConstraintSet完全解析 #文章的标题
author: 老头
date: 2018-01-13 22:32 #文章生成時間
updated: 2018-01-13 22:32 #更新日期
categories:
- 技术周 # 这个是我们的计划起名技术周
- 玩转UI # 这个是技术所属模块名 你也可以定义多个类别，但至少有为两个
tags: 玩转UI # 这个是所属的Tag也是最显眼的位置要以技术类别进行划分
---

### 前言
&emsp;&emsp;在看这篇文章的tx，如果想了解ConstraintLayout的使用请移步：[constraintlayout完全解析](http://andly.vip/2018/01/04/20180104_ConstraintLayout%E5%AE%8C%E5%85%A8%E8%A7%A3%E6%9E%90/)

>官方网址：
https://developer.android.com/reference/android/support/constraint/ConstraintSet.html

### ConstraintSet对控件影响
&emsp;&emsp;对于ConstraintSet，官方文档解释到它是用来存储约束和将这些约束附加到ConstraintLayout上，之后又给了一个简单的小例子讲解了一下ConstraintSet的使用，这里也将官网代码一并拷出

``` Java
ConstraintSet mConstraintSet1 = new ConstraintSet();
ConstraintSet mConstraintSet2 = new ConstraintSet();
ConstraintLayout mConstraintLayout;
boolean mOld = true;
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Context context = this;
    mConstraintSet2.clone(context, R.layout.state2);
    setContentView(R.layout.state1);
    mConstraintLayout = (ConstraintLayout) findViewById(R.id.activity_main);
    mConstraintSet1.clone(mConstraintLayout);
}

public void foo(View view) {
    TransitionManager.beginDelayedTransition(mConstraintLayout);
    if (mOld = !mOld) {
        mConstraintSet1.applyTo(mConstraintLayout);
    }  else {
        mConstraintSet2.applyTo(mConstraintLayout);
    }
}
```
&emsp;&emsp;就是这个样纸的，看起来很清晰，从将约束存储到ConstraintSet中到为ConstraintLayout设置一个新的约束，全程毫无尿点，但是运行之后发现有个类很强大，那就是TransitionManager，这个类用来管理开始场景和结束场景的过渡动画的，对于TransitionManager类本文最后将会讲解。

ConstraintSet类集成了约束的方法，这些方法和在xml里面是同样的效果，当然还有一些约束方法放到了ConstraintLayout.layoutParams里面，Ok,直接上效果

![ConstraintSet控制图片的放大和缩小](http://p1chajscf.bkt.clouddn.com/20180114_constraintSet01.gif)

在之前要做这么一个效果可能要使用属性动画来实现，会有很多的计算和控制，在ConstraintSet里面完全不用，在保证使用一层ConstraintLayout布局嵌套的情况下来做各种动画确实感觉舒服了许多，代码实现起来很简单。

``` Java
constraintlayout = findViewById(R.id.constraintlayout);
set.clone(constraintlayout);
normal.clone(constraintlayout);
iv_img.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        TransitionManager.beginDelayedTransition(constraintlayout);
        if (flag) {
            set.connect(R.id.iv_img, ConstraintSet.LEFT, ConstraintSet.PARENT_ID, ConstraintSet.LEFT);
            set.connect(R.id.iv_img, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP);
            set.connect(R.id.iv_img, ConstraintSet.RIGHT, ConstraintSet.PARENT_ID, ConstraintSet.RIGHT);
            set.connect(R.id.iv_img, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM);
            set.constrainHeight(R.id.iv_img, 0);
            set.constrainWidth(R.id.iv_img, 0);
            set.setDimensionRatio(R.id.iv_img, "W,1:1");
            set.applyTo(constraintlayout);
            flag = false;
        } else {
            flag = true;
            normal.applyTo(constraintlayout);
        }

    }
});
```
这里需要注意的是connect所传的参数，再加上上一篇的ConstraintLayout使用理解这些东西就小case了，这里需要定义两个ConstraintSet控制一个正常一个放大效果，当然你可以像在属性动画那样添加一个加速器。

![ConstraintSet的ConstraintLayout。LayoutParams加速器](http://p1chajscf.bkt.clouddn.com/20180114_constraintSet02.gif)

``` Java
// API 19才会起作用
Transition changeBounds = new ChangeBounds();
changeBounds.setDuration(1000);
changeBounds.setInterpolator(new BounceInterpolator());
TransitionManager.beginDelayedTransition(constraintlayout, changeBounds);
```
OK，对于这些还是不够的，还需要结合ConstraintLayout.LayoutParams来操作，就像ViewGroup.LayoutParams一样

``` Java
params = (ConstraintLayout.LayoutParams) ivLB.getLayoutParams();
params.circleRadius = params.circleRadius + number;
ivLB.setLayoutParams(params);
```
这里和在布局中操作圆定位效果是一样<br/>
layout_constraintCircle : 约束控件的id <br/>
layout_constraintCircleRadius : 该控件中心点和约束控件中心点的距离 <br/>
layout_constraintCircleAngle : 角度

### ConstraintSet对布局影响
ConstraintSet在操作布局的时候非常简单，只需要将一个布局生成一个Scene场景，然后场景进行场景之间的切换即可，效果：

![](http://p1chajscf.bkt.clouddn.com/20180114_constraintSet03.gif)

``` Java
before.clone(constraintLayout);
after.clone(this, R.layout.activity_layout02_after);
```
通过布局初始化ConstraintSet,其他操作和上面一样就可以来回切换布局了

### TransitionManager解析
在上面的例子中都用到了TransitionManager，官方解释到这个类用来管理场景变化所引起的转换集，其中调用对象的setTransition(Scene, Transition) 或setTransition(Scene, Scene, Transition)使一种场景像另一种场景进行转化。TransitionManager的转化有两种形式
1. TransitionManager.go(scene1);
2. transitionManager.transitionTo(scene3)

在开始之前先来介绍一下Scene（场景）
>A scene represents the collection of values that various properties in the View hierarchy will have when the scene is applied. A Scene can be configured to automatically run a Transition when it is applied, which will animate the various property changes that take place during the scene change.

这个类存储着一个根view下的各种view的属性。通常使用getSceneForLayout (ViewGroup sceneRoot,int layoutId,Context context)来获取实例。

``` Java
mScene1 = Scene.getSceneForLayout(relativelayout, R.layout.transition_scene1, this);
mScene2 = Scene.getSceneForLayout(relativelayout, R.layout.transition_scene2, this);
mScene3 = Scene.getSceneForLayout(relativelayout, R.layout.transition_scene3, this);
```
场景有了，接下来的就是使用transitionManager进行转化了。默认情况下转化使用了autotransition,如果希望有不同的转换行为，可以在代码中进行设置,也可以在xml里面进行设置

1. 代码进行设置 <br/>
类似于ChangeBounds类的还有以下几种，他们都是继承Transiton类<br/>

  ChangeBounds:边界创建移动和缩放动画<br/>
  ChangeTransform:创建缩放和旋转动画<br/>
  ChangeClipBounds:View的剪切区域setClipBound(Rect rect)<br/>
  ChangeImageTransform:ImageView的尺寸动画<br/>
  Fade,Slide,Explode:visibility的子类，渐入，滑动，爆炸动画<br/>
  AutoTransition:TransitionManager的默认动画

2. 布局中进行设置 <br/>
在XML资源文件里面的res目录声明，transitionManager标签里面包含transition标签，描述从一个场景到另一个场景的转化,例如：

``` Java
<transitionManager xmlns:android="http://schemas.android.com/apk/res/android">
    <transition android:fromScene="@layout/transition_scene1"
                android:toScene="@layout/transition_scene2"
                android:transition="@transition/changebounds"/>
</transitionManager>
```

``` Java
TransitionInflater inflater = TransitionInflater.from(this);
transitionManager = inflater.inflateTransitionManager(R.transition.transition_mgr, relativelayout);
}
transitionManager.transitionTo(mScene1);
```
上面的情况是有明确场景的时候来使用，还有一种就是修改控件的宽高等部分属性值则使用beginDelayedTransition，这种形式不是一个真正的场景，通过调用TransitionManager的beginDelayedTransition的方法来告诉TransitionManager在下一帧进行过渡变换，在APIDemo中也有相应的例子

``` Java
TransitionManager.beginDelayedTransition(relativelayout);
setNewSize(R.id.iv_kongjian, 30, 30);
setNewSize(R.id.iv_qq, 30, 30);
setNewSize(R.id.iv_wechat, 30, 30);
setNewSize(R.id.iv_tw, 30, 30);
```
效果和上面类似，下面将给出源码地址，感兴趣tx可以去试试。
https://github.com/AndLollipop/ConstraintSet
