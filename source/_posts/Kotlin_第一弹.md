---
title: Kotlin基础第一弹
date: 2016-06-01 23:47:44 #文章生成時間
categories: Kotlin
tags: Kotlin
---

Kotlin是一个基于JVM的新的编程语言，由JetBrains开发，由于是Google推荐使用的，可见其重要性，当你真正深入的时候也会发现kotlin的优雅，让你在写代码的时候省时又省力

对于Kotlin的学习网上有好多，现在分享一些
>
> 官方网址 http://kotlinlang.org/docs/reference/
> 
> 别人的总结 https://github.com/youxin11544/Kotlin-learning

在这里不会像官网那样一一的去讲解，自己也是从官网去学习然后去看别人的博客，对于知识而言可能并不深入，但对于初学者而言也值的一看

###Kotlin集合
集合无非是list集合和map集合，如下：

	val list = listOf(1, 2, 3, 4)
	val map = mapOf(1 to "a", 2 to "b", 3 to "c")
是不是很简单，但它只能去遍历不能去操作，why?首先我们以list为例，点进去看一下它里面只有get、indexof、iterator方法，这也就决定了它的职责就是去遍历

那如果想进度读写操作,就需要去使用mutableListOf、mutableMapOf来创建集合了

既然我们创建了一个集合，我们就需要对于进行遍历，和java不同的是kotlin使用了in来遍历

	for(i in list){
        println("i=$i")
    }
也可以使用forEach

	list.forEach {
        println("it=$it")
    }
还有

	list.forEachIndexed{
        index,i->
        println("index=$index   i=$i")
    }
等等。这时候我们可能会有疑问，forEach里面大括号里要写什么呢？其实它里面接受的是一个lamada表达式

	@kotlin.internal.HidesMembers
	public inline fun <T> Iterable<T>.forEach(action: (T) -> Unit): Unit {
	    for (element in this) action(element)
	}
这里就需要说一下了，(T)->Unit表示接受一个T类型参数返回一个Unit类型的函数，Unit也就是java中void类型，我们在调用的时候需要传入
{params->}这种式子，Kotlin规定当参数只有一个的时候可以不用写，默认是it,所以我们也可以这样写

	list.forEach {item->
        println("item=$item")
    }

好了，list说完了，下面说说Map，我们在定义map的时候用到了to,其实是key to value的格式，to充当的是中缀表达式，我们也可以定义自己的中缀表达式

	infix fun <A,B> A.with(that: B):Pair<A,B> = Pair(this,that)

这样我们就可以这样

	val pair = 4 to "d"
    val (key,value) = pair;

ok,集合就先到这里，更多操作可以实际去操作

###Kotlin扩展函数 扩展属性
扩展函数、扩展属性很简单，直接上例子

	val String.lastChar: Char
    	get() = get(length - 1)

	inline fun String.show(): Unit {
	    println("String.show()")
	}
直接使用类名.方法即可，调用的时候就可以"lypop".show()

###Kotlin函数
kotlin函数有个特点就是可以设置默认值

	fun test(a: Int = 1, str: String = "") {
    	print("test(a: Int = 1, str: String = \"\")")
	}

	fun test(str: String = "") {
	    print("test(str: String = \"\")")
	}

	fun test(a: Int = 1, b: Int = 2, str: String = "") {
	    print("test(a: Int = 1, b: Int = 2,str: String = \"\")")
	}

当你调用test()会执行最匹配的方法fun test(str: String = "")，在kotlin也有java的可变参数，只需要在方法写入vararg item: Int即可

###Kotlin可为空
这个比较简单，先上代码

	val str: String? = null
    str?.length

下面的调用也可以使用str!!.length的样式，具体？的使用在之后会经常用到，多多体会就好，这里不做过多的赘述

##Kotlin字符串的使用
字符串的操作这里以分割来说一下

	val str = "com.lypop.android"
    val list = str.split(".")
    if(list is List){
        for(value in list){
            println("value=$value")
        }
    }
就是这么简单的一些调用，当然还有一些其他复杂的操作，例如

	val path = "E:\\md_workspace\\Kotlin_collection.md"

    val afterLast = path.substringAfterLast(".")   //获取到md
    println("afterLast=$afterLast")

    val beforeLast = path.substringBeforeLast(":")
    println("beforeLast=$beforeLast")

    val missingValue = path.substringBeforeLast("?","missing value") //如果没有找到的话则返回第二个参数
    println("missing Value=$missingValue")
是不是相比java的substring更加灵活了，当然对于这种字符串的操作会使用就可以了，当然不知道意思的话，可以进源码查看也可以百度
最后在说两个比较常用的知识点

1. 打印&字符

		println("\$abc")
	
	    println(""" ${'$'}abc """)
2. 使用正则表达式

		val match  = "(.+)\\.(.+)\\.(.+)".toRegex()
	
	    val matchResult = match.matchEntire("com.lypop.one")
	
	    val list1:List<String>? = matchResult?.destructured?.toList()
	    if(list1 != null){
	        for(str in list1){
	            println("str=$str")
	        }
	    }

至此，简单的Kotlin第一段就结束了，相对于java来讲使用起来更加的方便更加高效，快来试试吧！