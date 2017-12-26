---
title: Kotlin_anko实现列表页面
author: 老头
date: 2016-10-01 23:47:44 #文章生成時間
tags: Kotlin
categories: Kotlin
---

上一篇我们介绍了Anko库的使用，这里我们用Anko来做一个简单的RecyclerView列表

废话不说，直接撸代码

### Start

首先我们使用Anko在代码里面写一个RecyclerView，看代码

    verticalLayout {
	    recyclerView {
	        id = R.id.main_rv
	        //设置参数 anko为Activity扩展了act的字段
	        layoutManager = LinearLayoutManager(act)
			//layoutManager = LinearLayoutManager	(this@MainActivity)
            padding = dip(20)
            adapter = this@MainActivity.adapter
            }
        }

接下来我们定义一个Adapter

	class MyAdapter(val ctx: Context, val items: ArrayList<Resp>): RecyclerView.Adapter<MyAdapter.MyViewHolder>(){
	    override fun onBindViewHolder(holder: MyViewHolder?, position: Int) {
	        val resp: Resp = items.get(position)
	        Glide.with(ctx).load(resp.owner.avatar_url).into(holder?.iv)
			//？.代表holder可为空
	        holder?.tv1?.text = resp.name
	        holder?.tv2?.text = resp.full_name
	    }

	    override fun getItemCount(): Int = items.size

	    override fun onCreateViewHolder(parent: ViewGroup?, viewType: Int): MyViewHolder {
	        //with : 在给定对象上调用lambda中的所有方法
	        val view = with(ctx){
	            verticalLayout {
	                orientation = LinearLayout.HORIZONTAL
	                gravity = Gravity.CENTER_VERTICAL
	                imageView {
	                    id = R.id.iv
	                    lparams {
	                        rightMargin = dip(20)
	                        leftMargin = dip(15)
	                        width = dip(80)
	                        height = dip(80)
	                    }
	                    //设置默认图片
	                    imageResource = R.mipmap.ic_launcher

	                }

	                verticalLayout {
	                    orientation = LinearLayout.VERTICAL
	                    textView {
	                        id = R.id.tv1
	                        textSize = 14f
	                        textColor = 0xff0000.opaque
	                    }
	                    textView {
	                        id = R.id.tv2
	                        textSize = 16f
	                        textColor = 0x000000
	                    }
	                }
	            }
	        }

	        val holder = MyViewHolder(view)
	        return holder

	    }

	    class MyViewHolder(itemView: View): RecyclerView.ViewHolder(itemView){
	        //在给定的View上查找指定的id视图
	        val iv: ImageView = itemView.find(R.id.iv)
	        val tv1: TextView = itemView.find(R.id.tv1)
	        val tv2: TextView = itemView.find(R.id.tv2)
	    }
	}

是不是很炫酷，当然这样写感觉代码太多了，我们需要将生成布局的代码单独使用一个类，我们可以定义一个类来继承AnkoComponent来写独立的一个布局，如果安装插件还可以预览界面的效果，具体的代码如下：

	class RecycleUI : AnkoComponent<MyAdapter> {
	    override fun createView(ui: AnkoContext<MyAdapter>): View = with(ui) {
	        verticalLayout {
	            orientation = LinearLayout.HORIZONTAL
	            gravity = Gravity.CENTER_VERTICAL
	            imageView {
	                id = R.id.iv
	                lparams {
	                    rightMargin = dip(12)
	                    width = dip(80)
	                    height = dip(80)
	                }
	            }

	            verticalLayout {
	                textView {
	                    id = R.id.tv1
	                }
	                textView {
	                    id = R.id.tv2
	                }
	            }
	        }
	    }
	}
这里我们也是使用with来生成相应的View视图

最后便是请求数据更新Adapter的操作了

	async(kotlinx.coroutines.experimental.android.UI){
	    //启动子线程
	    val data: Deferred<ArrayList<Resp>>  = bg{
	        //读取assets里面的数据
	        val input = assets.open("data.json")
	        val bytes = input.readBytes()
	        input.close()
			//将得到的json串解析成对象并返回给data
	        Gson().fromJson<ArrayList<Resp>>(String(bytes), getType<ArrayList<Resp>>())
	    }

	    items.clear()
	    items.addAll(data.await())  //这里通过调用await方法会一直等待后台的执行，当执行完毕将赋值给item集合，并更新适配器
	    adapter.notifyDataSetChanged()
