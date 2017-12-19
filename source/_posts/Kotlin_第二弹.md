---
title: Kotlin基础第二弹
date: 2016-06-01 23:47:44 #文章生成時間
categories: Kotlin
tags: Kotlin
---
Kotlin是一个基于JVM的新的编程语言，由JetBrains开发，由于是Google推荐使用的，可见其重要性，当你真正深入的时候也会发现kotlin的优雅，让你在写代码的时候省时又省力

>对于Kotlin的学习网上有好多，现在分享一些

>官方网址 http://kotlinlang.org/docs/reference/

>别人的总结 https://github.com/youxin11544/Kotlin-learning

在这里不会像官网那样一一的去讲解，自己也是从官网去学习然后去看别人的博客，对于知识而言可能并不深入，但对于初学者而言也值的一看


###kotlin类
对于类，我们先要说下在Kotlin中接口有啥特点

	interface OnClickListener{
    val name: String
    fun test(){
        println("OnClickListener test")
    }
    fun action()
	}
和java的接口相比，kotlin的接口更加强大还可以写方法的实现，还有一个那就是接口open类型的可以被直接继承

	class Child1 : OnClickListener,OnClickListener1{
	    override val name: String = ""
	    override fun test() {
	        super<OnClickListener>.test()
	    }
	
	    override fun action() {
	    }
	
	    override fun action1() {
	    }
	}
当你需要在子类方法调用父类的方法的时候直接super<OnClickListener>即可

对于抽象类

	abstract class ABParent{
    	abstract fun test()
	}
	
	class ABChild: ABParent(){
	    override fun test() {
	
	    }
	}
也是直接可以继承的，里面的abstract方法默认是open修饰

对于普通类就需要给父类用open进行修饰才能进行继承，因为对于类来说默认是final类型的，接下来我们就需要对类进行一些研究，对于java类分为内部类、外部类、静态类等等，kotlin当然也会有区分

	class ClassA{
	    var name: String = "lypop"
	
	    class NestClass{
	        fun test(){
	            //name = "" 嵌套类不能访问外部类的属性和方法
	        }
	    }

	    //内部类  存在外部类的引用  可以访问外部类的属性和方法
	    inner class InnerClass{
	        fun test(){
	            name = "change Name"
	        }
	    }
	
	    //创建伴生对象
	    companion object {
	        var comName = "aaa"
	        fun companionTest(){
	            println("companionTest")
	        }
	    }
	
	    //定义静态内部类
	    object InnerStaticClass{
	        fun test(){
	            comName = "==="
	        }
	    }

	}
	//定义静态外部类
	object StaticOuterClass{
	    val age: Int = 22
	}

这里我们需要注意：

1. 嵌套类不能访问外部类的属性和方法,内部类才可以访问

2. 因为kotlin没有static关键字，如果要在类中定义静态的方法和属性需要来创建伴生对象，在使用的时候可以ClassA.companion.comName也可以直接ClassA.comName访问
3. 静态内部类可以访问伴生对象的属性和方法，就和java中静态内部类可以访问外部类定义的静态属性和静态方法是一样的

接下来一个便是匿名内部类的写法

	val obj = object: OnClickListener2{
        override fun test() {
            println("object test()")
        }
   	}
该内部类实现了OnClickListener2的接口，将对象赋值给了obj

最后也就是Kotlin的数据类，和java中的Bean类一样，只有类属性和相应的get/set方法

	data class Person(val name: String)

###kotlin类构造方法
类的构造方法和java有些不同，kotlin分为主构造方法和次构造方法

	class User(name: String) {//主构造方法

    var name: String = ""
    var pwd: String = ""
    //次构造器
    constructor(name: String, pwd: String) : this(name) {
        this.name = name
        this.pwd = pwd
    }

    //初始化器
    init {
        this.name = name
    }
	}

这里需要注意的是：

1. 次构造方法必须要去初始化主构造方法
2. 当主构造方法需要权限等修饰的时候constructor必须要加上，其他的情况可以不写
3. 对于初始化字段可以放在init初始化器中进行初始化

至此，Kotlin的第二讲完了，每天的坚持，总有一天会获得收获。

~ 共勉