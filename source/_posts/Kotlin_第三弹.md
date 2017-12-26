---
title: Kotlin基础第三弹
author: 老头
date: 2016-08-01 23:47:44 #文章生成時間
categories: Kotlin
tags: Kotlin
---

Kotlin是一个基于JVM的新的编程语言，由JetBrains开发，由于是Google推荐使用的，可见其重要性，当你真正深入的时候也会发现kotlin的优雅，让你在写代码的时候省时又省力

>对于Kotlin的学习网上有好多，现在分享一些

>官方网址 http://kotlinlang.org/docs/reference/

>别人的总结 https://github.com/youxin11544/Kotlin-learning

在这里不会像官网那样一一的去讲解，自己也是从官网去学习然后去看别人的博客，对于知识而言可能并不深入，但对于初学者而言也值的一看

### kotlin委托机制

委托模式也是代理模式是软件设计模式中的一项基本技巧，在委托模式中，有两个对象参与处理同一个请求，接受请求的对象将请求委托给另一个对象来处理

在java和Android用到委托机制在AOP里，在java中使用继承InvocationHandler接口的方法来实现代理，而在Android中则使用AspectJ的方式来实现。在这里我们来讲解一下Kotlin的委托模式

1. 类委托
也就是上面讲的委托模式定义，然而在Kotlin中实现起来更加的方便更加的灵活，如：

```java
class MyList(list: ArrayList<String>) : Collection<String> by list {

}
```

这种也是替代继承的方式，直接使用by关键字就将Collection的方法委托给list对象

2. 属性委托
在Kotlin中Delegates类内置了三种委托的方法，分别是lazy、notNull()、observable("")、vetoable("")、Map形式

 - lazy 用于进行懒加载，即第一次使用的时候才执行初始化操作

```java
		//当使用的时候才进行初始化（线程安全的）
		val list: ArrayList<String> by lazy {
	    	ArrayList<String>()
		}
```

 - notNull() 使用于那些无法再初始化阶段就确定属性值的场合

```java
		//初始化str,用于为空属性进行初始化的场景
		var str: String by Delegates.notNull<String>()
```

 - observable() 观察者和java的观察者模式差不多

```java
		//oldValue是变化之前的值  newValue最新的值
		var str: String by Delegates.observable(""){//初始值
	    	property, oldValue, newValue ->
	    	println("${property.name}  old=$oldValue  new=$newValue")
		}
```

 - vetoable（）带条件的委托机制，通过返回的true和false来确定oldValue是上一个还是最初的

```java
		//返回true和observable是一样的效果
		var str1: String by Delegates.vetoable(""){
		    property, oldValue, newValue ->
		    println("${property.name}  old=$oldValue  new=$newValue")
		    true   
		}

		//返回false则标志oldValue永远为初始值
		var str2: String by Delegates.vetoable(""){
		    property, oldValue, newValue ->
		    println("${property.name}  old=$oldValue  new=$newValue")
		    false
		}
```

 - Map 通过一种全新的赋值方法给类属性进行赋值

```java
		class User(val map: Map<String,Any?>){
		    val name: String by map
		    val age: Int by map
		}

		val user = User(mapOf("a" to 1))
```

除此之外我们也可以自定义委托，具体定义可仿照notNull()委托

```java
private class NotNullVar<T: Any>() : ReadWriteProperty<Any?, T> {
    private var value: T? = null

    public override fun getValue(thisRef: Any?, property: KProperty<*>): T {
        return value ?: throw IllegalStateException("Property ${property.name} should be initialized before get.")
    }

    public override fun setValue(thisRef: Any?, property: KProperty<*>, value: T) {
        this.value = value
    }
}
```

你也可以设置可读的委托机制，继承ReadOnlyProperty类即可

### kotlin lambda表达式

首先先给出一个小例子

```java
val action = {i: Int, j: Int -> println("i=$i   j=$j")};
action(1,2)
```

注意的是lambda表达式用{}包裹，箭头前面是参数的参数，箭头后面是函数体；从调用上来说比java简单并且优雅了许多，但是实际用途呢？我们可以为一个函数传一个lambda，如：

```java
fun lambdaTest(arg1: Int, arg2: Int, oper: (a: Int, b: Int) -> Int): Int {
    var result: Int = Int.MIN_VALUE
    if (arg2 != 0) {
        result = oper(arg1, arg2)
    }
    return result
}

fun main(args: Array<String>) {
    lambdaTest(1, 2, { a: Int, b: Int -> a / b })
```

既然是传函数当然也可以传递一个函数进去，常使用::，这里延伸出函数的引用，另外还有属性的引用，这里

```java
listOf(1, 2, 3).forEach(::println)

var name = "1"
val p = ::name
p.set/get
```

当最后一个参数为lambda的时候，可以将大括号放在外面，如：

```java
lambdaTest(1, 2){ a: Int, b: Int -> a / b }
```

用lambda表达式的情况还是挺多的，例如在集合中遍历等操作

```java
val list = arrayListOf(1, 2, 3)
  list.forEach { value -> }
```

### kotlin 运算符重载表达式

```java
class Rmb(var num: Int) {
    operator fun plus(rmb: Any?) {

    }
}
```

这样就可以使用Rmb(1) + Rmb(2)进行计算了，是不是很简单。这种操作和前面讲的中缀表达式一样，只不过中间的是运算符了而已

### kotlin 注解与反射

Kotlin的注解和java是类似的，先确定注解的类型，然后确定生命周期

	@Target(AnnotationTarget.FIELD,
	        AnnotationTarget.CLASS,
	        AnnotationTarget.FUNCTION)
	@Retention(AnnotationRetention.SOURCE)
	annotation class Path

使用的话直接在class前 fun前面

```java
	@Path class UsePath(val p: String) {

	}
```

Kotlin反射则通过
```java
	String::class.java
    String.javaClass
```

这两种方式来得到Class<?>对象，进一步可反射得到相应的属性和方法
