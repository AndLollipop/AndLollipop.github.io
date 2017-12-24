---
title: UI绘制_Paint高级渲染
date: 2016-11-01 23:47:44 #文章生成時間
categories: UI绘制
tags: UI绘制
---
上一篇讲解了Paint的基本使用，从初始化到绘制，学好了基本功接下来要开始Paint的高级渲染的部分在开始之前还是要留一下Paint的基本使用的地址

> Paint的基本使用 http://www.jianshu.com/p/88d718d1945e

开始撸码~

### 正文

先来看一下要搞的效果图

ok,在Android中提供了如下的渲染类

1. BitmapShader

		/**
         * TileMode.CLAMP 拉伸最后一个像素去铺满剩下的地方
         * TileMode.MIRROR 通过镜像翻转铺满剩下的地方。
         * TileMode.REPEAT 重复图片平铺整个画面（电脑设置壁纸）
         */
	    BitmapShader bitMapShader = new BitmapShader(mBitMap,Shader.TileMode.MIRROR,Shader.TileMode.MIRROR);

2. LinearGradient

		/**线性渐变
         * x0, y0, 起始点
         *  x1, y1, 结束点
         * int[]  mColors, 中间依次要出现的几个颜色
         * float[] positions,数组大小跟colors数组一样大，中间依次摆放的几个颜色分别放置在那个位置上(参考比例从左往右)
         *    tile
         */
		LinearGradient linearGradient = new LinearGradient( 0, 0,800, 800, mColors, null, Shader.TileMode.CLAMP);

3. RadialGradient

		RadialGradient mRadialGradient = new RadialGradient(300, 300, 100, mColors, null, Shader.TileMode.REPEAT);

4. SweepGradient

	    SweepGradient mSweepGradient = new SweepGradient(300, 300, mColors, null);

5. ComposeShader

		ComposeShader mComposeShader = new ComposeShader(linearGradient, bitMapShader, PorterDuff.Mode.DST_IN);

使用起来非常的简单，首先我们就使用composeShader来实现第二张图的效果

	//图像渲染
    BitmapShader bitmapShader = new BitmapShader(bitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
    LinearGradient linearGradient = new LinearGradient(0, 0, width, height, Color.GREEN, Color.BLUE, Shader.TileMode.REPEAT);
    RadialGradient radialGradient = new RadialGradient(width / 2, height / 2, width / 2, new int[]{0xffff0000, 0xff00ff00, 0xff0000ff}, null, Shader.TileMode.CLAMP);
    SweepGradient sweepGradient = new SweepGradient(width / 2, height / 2, new int[]{0xffff0000, 0xff00ff00, 0xff0000ff}, null);
	//将图像渲染和环形渐变进行组合，组合的形式是增强
    ComposeShader composeShader = new ComposeShader(bitmapShader, radialGradient, PorterDuff.Mode.MULTIPLY);

    mPaint.setShader(composeShader);
	//绘制矩形区域用于显示组合之后的效果
    canvas.drawRect(0, 0, width, height, mPaint);

然后我们使用BitmapShader来实现放大镜的效果

* 得到放大后图片

		//放大后的整个图片
        Bitmap scaleBitmap = Bitmap.createScaledBitmap(mBitmap, mBitmap.getWidth() * factor, mBitmap.getHeight() * factor, true);
        bitmapShader = new BitmapShader(scaleBitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
* 设置圆形的放大镜并将BitmapShader设置给放大镜Drawable

        mShapeDrawable = new ShapeDrawable(new OvalShape());
        mShapeDrawable.getPaint().setShader(bitmapShader);
        mShapeDrawable.setBounds(0, 0, RADIUS * 2, RADIUS * 2);
        matrix = new Matrix();
* 随着手指滑动，放大镜不断移动位置

		//将放大镜的图片往相反的方向挪动
        matrix.setTranslate(-x * factor + RADIUS, -y * factor + RADIUS);
        mShapeDrawable.getPaint().getShader().setLocalMatrix(matrix);
        //切出手势区域的位置的圆
        mShapeDrawable.setBounds(x - RADIUS, y - RADIUS, x + RADIUS, y + RADIUS);
        invalidate();
使用Android的渲染还能做好多的炫酷的效果，这里就不一一进行说明。

