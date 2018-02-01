---
title: 性能优化利器(TraceView) #文章的标题
author: 老头
date: 2018-01-31 15:01 #文章生成時間
updated: 2018-01-31 15:01 #更新日期
categories:
- 性能优化
tags: 性能优化
---
### 前言
性能优化开篇第一讲总结TraceView，这个工具是Android SDK中内置的一个工具，通过生成trace文件来展示代码的执行时间、次数便于我们分析。那TraceView的应用场景是什么呢？当我们面对手机运行app执行某个操作过于卡顿时候，我们要在无边际的代码找到罪魁祸首未免太痛苦了，就在这时候就体现了TraceView的强大。它主要解决下面两个场景：
1、调用次数不多，但是每一次执行都很耗时
2、方法耗时不大，但是调用次数太多
前者可能会造成CPU频繁调用，手机发烫的问题，后者则就是卡顿的问题。为了确保应用程序的高性能，每项功能都应该尽可能高效地运行。当你首次启动一个Android应用程序时，主线程就已经创建了，主线程非常重要，因为它负责运行你的代码，并在合适的视图位置发送事件和执行绘图功能。基本上来说，主线程是应用程序所在的线程，有时候，主线程也称为UI线程。如果你触摸屏幕上的按钮，UI线程将会发送一个触摸事件给视图，视图将按钮状态设定为已按下设定，然后向事件队列发送一个有效请求，然后UI线程处理此请求，并通知按钮将其本身绘制为已按下状态。如果你有任何触摸事件的处理代码块，将会在线程中执行，这些触摸处理所用的时间越长，线程的执行时间就会越长，在绘图功能执行完之前，视图将会更新显示状态，让用户能够看到其状态，这里需要记住的是，输入处理代码与渲染和更新代码，共享这个线程的处理周期时间。

### 生成trace文件
要使用TraceView工具就应该知道怎样去生成trace文件，在Android中生成trace文件的方法也挺多，有以下三个方法：
1、使用代码
2、使用Android Studio
3、使用DDMS
这三种的具体打开方法请看
[http://blog.csdn.net/u011240877/article/details/54347396](http://blog.csdn.net/u011240877/article/details/54347396)

这里我们只介绍使用DDMS的方式生成trace文件的情况，因为其他的情况有一些限制（需要root手机、不能直观查看执行时间）
![TraceView工具](http://p1chajscf.bkt.clouddn.com/20180201_traceview.png)
1、执行Start Method profiling开始生成trace文件 -> stop Method profiling停止生成trace文件
2、时间线面板：左侧所代表的线程  右侧该线程中方法的执行情况
3、分析面板：所有方法的各项指标

ok，开始分析生成的trace文件

### TraceView工具的使用
#### 时间线面板的使用
1、main线程就是Android应用的主线程，每个线程的右边对应的是该线程中每个方法的执行信息，每一个小立柱就代表一次方法的调用，当你将鼠标放到立杆上就会显示该方法的调用的详细信息
![时间线面板](http://p1chajscf.bkt.clouddn.com/20180201_traceview1.png)
当你点击该立柱，分析面板就会自动跳转到该方法
2、刚打开的面板是我们采集信息的总览，但是会有一些局部的细节我们看不清，如果我们需要放大的话只需要按下拖动就可以放大了，如果你想回到最初的状态，双击时间线就可以，坐标的凸起部分表示方法的开始，右边的凸起部分表示方法的结束，中间的直线表示方法的持续

#### 分析面板的使用
|    名称 | 意义  |
| --------:| :--: |
| name |  方法的详细信息，包括包名和参数信息   |
|    Incl Cpu Time |  Cpu执行该方法，该方法和其子方法所花费的时间  |
|    Incl Cpu Time % | Cpu执行该方法，该方法及其子方法所花费时间占CPU总执行时间的百分比  |
|    Excl Cpu Time | Cpu执行该方法所花费时间  |
|    Excl Cpu Time % | Cpu执行该方法所花费时间占CPU总执行时间的百分比  |
|    Incl Real Time | 该方法及其子方法执行所花费的实际时间，从执行该方法到结束一共花了多少时间  |
|    Incl Real Time % | 上述时间占总的运行时间的百分比  |
|    Excl Real Time % | 该方法自身的实际允许时间  |
|    Excl Real Time | 上述时间占总的允许时间的百分比  |
|    Calls+Recur    | 调用次数+递归次数  |
|    Calls/Total    | 调用次数和总次数的占比  |
|   Cpu Time/Call   | Cpu执行时间和调用次数的百分比，代表该函数消耗cpu的平均时间  |
|   Real Time/Call  | 实际时间于调用次数的百分比，该表该函数平均执行时间  |
当你点击其中的一个函数可能会出现以下详情
![函数详情列表](http://p1chajscf.bkt.clouddn.com/20180201_traceview2.png)

Parents:调用该方法的父类方法
Children:该方法调用的子类方法
如果该方法含有递归调用，可能还会多出两个类别:
Parents while recursive:递归调用时所涉及的父类方法
Children while recursive:递归调用时所涉及的子类方法

对于这些操作信息都已经讲完了，接下来我们实际应用以下
```java
public void imPrettySureSortingIsFree() {//排序后打印二维数组，一行行打印
    int dimension = 300;
    int[][] lotsOfInts = new int[dimension][dimension];
    Random randomGenerator = new Random();
    for(int i = 0; i < lotsOfInts.length; i++) {
        for (int j = 0; j < lotsOfInts[i].length; j++) {
            lotsOfInts[i][j] = randomGenerator.nextInt();
        }
    }

    for(int i = 0; i < lotsOfInts.length; i++) {
        String rowAsStr = "";
        //排序
        int[] sorted = getSorted(lotsOfInts[i]);
        //拼接打印
        for (int j = 0; j < lotsOfInts[i].length; j++) {
            rowAsStr += sorted[j];
            if(j < (lotsOfInts[i].length - 1)){
                rowAsStr += ", ";
            }
        }
    }
}
```
看到上面的代码我们一眼就能看出来不能够使用字符串的加号而应该改为StringBuilder或者StringBuffer的append方法，例子比较简单主要我们还是学习如何去查找导致app卡顿的代码方法。
在时间线面板上在main线程上找到相同颜色出现频率最多的一个小立柱，点击之后再分析面板就去会定位到该方法，然后分析Cpu执行该方法和其子方法所花费的时间以及调用次数+递归次数来查找当前方法是否是我们应用中发生内存卡顿的方法，当这个方法不是，但是我占时间或者次数较高则可以对其Parent或者Child进行查询,当然也有可能我们找不到相应的方法，但是可以从这里面的方法找到相应的蛛丝马迹
![问题所在](http://p1chajscf.bkt.clouddn.com/20180201_traceview3.png)
ok,我们定位到了这个方法，这时候我们需不需要在查看parent呢？这时候也要看实际情况来决定，在上图中parent是onClick时间，很明显导致内存卡顿的是click调用的方法。
当然找到相应的问题只是其中一步，更多的应该是怎么去发生卡顿的问题进行优化。

那我们在来看一个例子，使用斐波那契递归算法
```java
public int computeFibonacci(int positionInFibSequence) {
    //0 1 1 2 3 5 8
    if (positionInFibSequence <= 2) {
        return 1;
    } else {
        return computeFibonacci(positionInFibSequence - 1)
                + computeFibonacci(positionInFibSequence - 2);
    }
}
```
当递归的深度比较大时就会发生卡顿现象，这里我们令递归的深度为40来进行分析，按上面分析步骤找到出现颜色最多的一个小立柱，一步步就能找到相应的位置，这里就不再多说了，那既然知道了是斐波那契递归引起的卡顿现象，那怎么去优化呢?这里我们可以采用缓存+批处理的思想将递归变为循环遍历，具体步骤如下：
![斐波那契算法改进](http://p1chajscf.bkt.clouddn.com/20180201_traceview4.png)

代码如下：
```java
public int computeFibonacci(int positionInFibSequence) {
    int prev = 0;
    int current = 1;
    int newValue;
    for (int i=1; i<positionInFibSequence; i++) {
        newValue = current + prev;
        prev = current;
        current = newValue;
    }
    return current;
}
```
这里用到了批处理和缓存的技术，这里说一下这两个技术的概念：
一些函数和运算，需要非常大的资源开销，这也会影响计算性能。例如，在执行之前把数据载入特定的内存区域，或者，在搜索之前对数值集进行排序，在执行多次之后，而且次数确实是个很大的数字，资源开销将会严重影响应用程序的性能。批处理是可以帮助解决这种性能问题，它消除每个运算的独立执行开销，好像是所有人都开一辆车，而不是每个都开一辆，从而节省汽油。这种情况最常见于在执行运算之前，你需要准备数据。例如，在查找集合中的值时，最有效的方法是进行排序，然后进行二分法搜索等等。有一点必须弄清楚，这并不是最有效的方法。这只是举一个例子而已，最简单的方法是写一个函数，提供一个集合和一个值，对集合进行排序，然后查看值是否存在于集合之中。对于某些性能要求来说，这样做是可以的。但是，如果有10000个值，而且总共需要数百万租数据，排序所花费的时间，将会增加很多倍，答案很明确。对这组数据一次性完成排序，然后查找所有10000个值，并不是明智的方法。这时就需要用到批处理，我们找到重复的运算，找到之后，进行批处理。
缓存是与批处理相似的概念，这也是目前为止，你能理解的最重要的性能技术。这项技术全面地推动现代计算机科学的发展，以计算机为例，内存的作用是用来存储信息，让CPU能够更快的访问数据，其速度远快于访问硬盘数据。

至此，对于TraceView的总结就结束了，因为工具的使用更多是在实践去摸索，所以使用一篇文章不足以体现TraceView工具的强大，当然工具永远都是用来使用的，真正的找到最好的优化策略才是重中之重

官方也给出了一些性能优化的知识，官网如下：
[https://developer.android.com/training/articles/perf-tips.html](https://developer.android.com/training/articles/perf-tips.html)
