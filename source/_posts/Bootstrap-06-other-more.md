title: Bootstrap入门笔记之（六）其它内置组件：进度条、列表组、面板等
date: 2016-03-01 01:41:42
tags: [Bootstrap]
categories: [Bootstrap]
---


> 博客之外
> 
> 只剩最后一天，二月份就结束了。距离上一篇博客已经有着整整一个月的时间，这一个月的时间，感觉技术上的成长又被搁置了，没有了之前闭关学习的心无旁骛，那段时间成长真的飞快。
> 在家喝酒，玩耍，到现在实习入职了一个星期，整整一个月时间，学习效率都十分的低，也可以说基本没学到什么新东西。今天是2月最后一天，不能再这样下去，好了懊恼的时间，不能太多，应该着眼当下，现在是2016-02-29 21:40，开始把bootstrap入门理论基础部分完结了吧，下一步就该进入一个新的阶段了！我将一直前行，加油！


---

## 缩略图

其实在我们日常使用的网页中，随处都可以看到有缩略图的存在，比如淘宝的商品列表，慕课网上的课程列表等等，Bootstrap自然不会放过那么常见效果，它将这样的效果独立成为了一个模块组件，使用`.thumbnail`样式类，Boostrap缩略图的默认设计仅需最少的标签就能展示带链接的图片。


我们需要配合Bootstrap的栅格系统来达到一个不错的显示效果。在Bootstrap中文网中，我们可以看到这样的示例代码:

```html
<div class="container">
    <div class="row">
        <div class="col-xs-6 col-md-3">
            <a href="#" class="thumbnail">
                <img src="..." alt="...">
                <!-- 此处应对图片做一些样式设置height: 180px;width: 100%; display: block;等 -->
            </a>
        </div>
        ...
    </div>
</div>
```

我们将上面代码中的列复制3份，改变浏览器的大小，我可以看到因为栅格系统的存在，我们的缩略图已经变成了响应式的。这是栅格系统起到的效果那么`.thumbnail`又起到了什么效果呢？
我们可以看到图片周围有了一圈边框，并且在边框与图片之间有着4px的padding，除此之外bootstrap还人性化的为我们的缩略图效果提供了hover效果。

**添加标题、描述内容、按钮**

我们当然不可能仅仅只展示一张可点击的图片就完了，我们时常还会配上相关的说明文字以及一些按钮等等。在已有的缩略图的基础上，我们需要使用`.caption`容器，并且在这个容器中放置其它的内容，来达到统一的显示效果。


```html
<!-- 添加到上面代码中的.thumbnail容器内，a标签后 -->
<div class="caption">
    <h2>说明文字</h2>
    <p>这里是说明文字</p>
    <button class="btn btn-info">按钮</button>
    <button class="btn btn-success">按钮</button>
</div>
```

看看效果吧：

![缩略图展示](/images/Bootstrap/06-thumbnail.jpg)

## 警示框

其实在我们的网页中，总是避免不了各种的提示信息，比如我们的登陆界面中，总是避免不了输入错误的情况，就需要使用警示框来提示用户错误信息。Bootstrap为我们提供了一组这样的样式类。

Bootstrap使用`.alert`来控制警示框的大小边距等样式，然后再用：成功：`.alert-success`、信息：`.alert-info`、警告：`.alert-warning`和错误：`.alert-danger`、这样的一组样式类,来表示不同的情景颜色。   

```html
<div class="alert alert-success" role="alert">恭喜您操作成功！</div>
<!-- ...等等 -->
```

![缩略图展示](/images/Bootstrap/06-alert.jpg)

关闭

除了展示效果之外，如果你还引入了Bootstrap的js文件。那么我们的还可以为我们的警示框非常简单的创造一些交互效果。

```html
<div class="alert alert-success alert-dismissable">
    success操作成功
    <button class="close" data-dismiss="alert">
        <span class="glyphicon glyphicon-remove"></span>
    </button>
</div>
```

可以看到效果如下：（点击后面的icon便可以关闭该提示信息）

![缩略图交互](/images/Bootstrap/06-alert-close.jpg)


那么好的效果，在实现的时候需要注意一些什么呢？主要有三个步骤：

1. 在普通的警示框`.alert`的基础上，添加`。alert-dismissable`类
2. 在button标签中加入`close`类，实现警示框**关闭按钮**的样式（我在上面使用了Bootstrap自带的icon图标来实现关闭按钮）
3. 在关闭按钮上添加自定义属性`data-dismiss="alert"`（Bootstrap中是通过这样的自定义属性，再使用JS检测来实现关闭效果的）

**警示框的链接**

有时我警示框中除了错误信息之外，还会加入一个链接地址，以便于用户在在新的页面中查找问题去处理他的错误。

Bootstrap仅仅使用了一个`.alert-link`的类就实现了这样的效果，主要是对于链接样式的**高亮显示**、**加粗**，并且**颜色相应加深**。（除此之外在hover上去后有下划线）


## 进度条

Bootstrap框架对于进度条提供了一个基本样式，一个100%宽度的背景色，然后一个子容器高亮，表示完成进度。其实制作这样进度条非常容易，一般使用两个容器，外容器具有一定的宽度，设置一个背景色，他的子元素设置一个宽度（父容器的宽度比例值`如60%`），同时设置一个高亮的背景色。

Bootstrap也是这样实现的，外层容器使用`.progress`类，子容器使用`.progress-bar`类（别忘记设置宽度）如：

```html
<div class="progress">
       <div class="progress-bar" style="width:80%"></div>
</div>
```

同样它也提供了四个不同的情景颜色。`.progress-bar-info`..等，添加到**子容器**原有的类后即可

除了色彩，还可以使进度条的变为条纹的，只需要将`progress-striped`添加到原有的**父容器**类后，它同样具有彩色效果。更进一步的是，若在其后再添加一个`.active`类，可以实现动态的条纹进度条。（必须两个同时使用，使用css3动画实现）我们来试试：

```html
<div class="progress progress-striped active">
    <div class="progress-bar progress-bar-danger" style="width:80%"></div>
</div>
<!-- .... -->
```

![条纹进度条](/images/Bootstrap/06-progress-striped.jpg)

我们还可以在一个进度条内，将不同状态的进度条放置在一起，水平排列，形成叠加进度条，这个就自己试试吧！^_^

**带标签的显示条**
使用很简单，只需要在子容器中添加相应的数字就可以了，不过下面这段代码会有什么效果呢？不妨也自己去试试吧！(在源码中搜索`aria-valuenow="0"`可看到原因)

```
<div class="progress">
    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
</div>
```

## 媒体对象

媒体对象一般包括以下几个部分：

1. 媒体对像的容器：常使用`.media`类名表示，用来容纳媒体对象的所有内容
2. 媒体对像的对象：常使用`.media-object`表示，就是媒体对象中的对象，常常是图片
3. 媒体对象的主体：常使用`.media-body`表示，就是媒体对像中的主体内容，可以是任何元素，常常是图片侧边内容
4. 媒体对象的标题：常使用`.media-heading`表示，就是用来描述对象的一个标题，此部分可选
5. `.pull-left`或者`.pull-right`来控制媒体对象中的对象浮动方式。(如图片在左或者在右)

那么我们可以看到的结构如下：

```html
<div class="media">
    <a class="pull-left" href="#">
        <img class="media-object" src=".." alt="...">
    </a>
    <div class="media-body">
        <h4 class="media-heading">Bootstrap</h4>
        <div>默认样式的媒体对象组件允许在一个内容块的左边或右边展示一个多媒体内容（图像、视频、音频）。</div>
    </div>
</div>
```
可以实现最普通的图片在左，标题与介绍文字在右的媒体对象组。

我们在论坛中常常能看到和Bootstrap中文官网媒体对象组模块类似的阶梯状媒体对象，它是怎么实现的呢？
其实很简单，我们只需要在上一级的`.media-body`容器最后添加新的额媒体对象容器`.media`就可以实现这样的阶梯效果

![媒体对象](/images/Bootstrap/06-media.jpg)

除了这样的阶梯形式，我们还可以在论坛评论系统中看到，评论是平铺着下来的，也就是媒体对象列表。

我们只需要将原来的`.media`放在`.media-list`容器中就可以实现，不过既然都说了是列表，那我们还是直接使用ul>li的排列方式吧:

```html
<ul class="media-list">
    <li class="media">…</li>
    <li class="media">…</li>
    <li class="media">…</li>
</ul>
```
Bootstrap同样帮我们清除了，媒体对象列表中的ul>li的默认样式，使展示更急美观


## 列表组

列表组是Bootstrap框架新增的一个组件，可以用来制作列表清单、垂直导航等效果，也可以配合其他的组件制作出更漂亮的组件。它主要包括两个部分：

1. `.list-group`：列表组容器，**常用的是ul元素**，当然也可以是ol或者div元素
2. `.list-group-item`：列表项，**常用的是li元素**，当然也可以是div元素

如：

### 带徽章的列表组

带徽章的列表组其实就是将Bootstrap框架中的徽章组件和基础列表组结合在一起的一个效果。具体做法很简单，只需要在`.list-group-item`中添加徽章组件`.badge`：

```html
<ul class="list-group">
    <li class="list-group-item">玩转Bootstrap  <span class="badge">5</span></li>
    <li class="list-group-item">基础Bootstrap的网页开发  <span class="badge">12</span></li>
</ul>
```

可以实现笑效果如下：

![带徽章的列表](/images/Bootstrap/06-list-badge.jpg)

如果在列表组中，我们希望列表项是链接的话，Bootstrap为我们提供了两种方案：

1. 直接将链接置于li`.list-group-item`容器内，它会有链接下划线的存在
2. 将ul.list-group>li.list-group-item的结构换成div.list-group>a.list-group-item，此时与默认的列表组显示无异(emmet会吧？那就能理解我的代码的意思...)

### 自定义列表组

除了上面默认的列表组之外，为了更清晰的展示内容，Bootstrap实现了自定义列表组，主要是新增了两个类：

1. `.list-group-item-heading`：用来定义列表项头部样式
2. `.list-group-item-text`：用来定义列表项主要内容

结构如下编写：
```html
<div class="list-group">
    <a href="##" class="list-group-item">
        <h4 class="list-group-item-heading">图解CSS3</h4>
        <p class="list-group-item-text">...</p>
    </a>
    <a href="##" class="list-group-item">
        <h4 class="list-group-item-heading">Sass中国</h4>
        <p class="list-group-item-text">...</p>
    </a>
</div>
```

### 列表项的状态设置

和其他的组件一样，列表组也两个状态效果：

- `.active`：表示当前状态
- `.disabled`：表示禁用状态

只需要在相应的列表项上添加。`class="list-group-item active">`，主要对于该项的背景颜色进行高亮，以及其中的**徽章**进行了**高亮处理**

禁用状态，只是添加了一个灰色的背景色，以及文字的暗色处理

除了上面的两个最常用的状态之外，Bootstrap为我们的列表组也提供了不同的情景颜色，只需要在列表项中添加`.list-group-item-danger`这一系列的类。


## 面板

同样作为一个新增的组件，基础面板非常简单，就是一个div容器运用了`.panel`样式，产生一个具有边框的文本显示块。由于`.panel`不控制主题颜色，所以在`.panel`的基础上增加一个控制颜色的主题`.panel-default`，另外在里面添加了一个`.div.panel-body`来放置面板主体内容：

```html
<div class="panel panel-default">
    <!-- panel-default就是那一系列的情景类，设置不同的可以设置不同的颜色 -->
    <div class="panel-body">我是一个基础面板，带有默认主题样式风格</div>
</div>
```

### 带有头和尾的面板

基础面板看上去太简单了，Bootstrap为了丰富面板的功能，特意为面板增加“面板头部”和“页面尾部”的效果：

1. `.panel-heading`：用来设置面板头部样式
2. `.panel-footer`：用来设置面板尾部样式


```html
<div class="panel panel-default">
    <!-- 这里对于不同的情景颜色，面板头的颜色改变十分明显 -->
    <div class="panel-heading">图解CSS3</div>
    <div class="panel-body">…</div>
    <div class="panel-footer">作者：大漠</div>
</div>
```

### 面板中嵌套表格

其实面板作为一个用于处理，别的组件完成不了的情况的组件，一般情况下可以把面板理解为一个区域，所以在使用面板的时候，都会在`.panel-body`放置需要的内容，可能是**图片、表格或者列表等**。

如果在面板中嵌套表格，只需要将编写好的表格直接放置在面板中即可，不过有着如下两种形式：

```html
<div class="panel panel-default">
    <div class="panel-heading">图解CSS3</div>
    <div class="panel-body">…</div>
    <!-- 这里是放在panel-body后面，实际上我们还可以将table放在panel-body里面 -->
    <table class="table table-bordered">…</table>
    <div class="panel-footer">作者：大漠</div>
</div>
```

两个效果最大的差异是：

1. 放在`.panel-body`**内**的表格，实际上就是简单的嵌套，设置了一些padding值等。
2. 房在`.panel-body`**后**的表格，会与面板融合在一起，与面板相接的地方，不会有着边框的展示，而是直接展示面板的边框

**在面板中嵌套列表组时，同样是这样的两个差异**


--- 

到这里我们的Bootstrap基础理论入门就结束了，实际上花了很多时间都是在理论上，并且中间还停歇了很长的时间。下一步我们需要做的就是在实战中去不断掌握它，了解它的细节，帮助我们能够缩短搭建时间、快速的搭建网站，并且让其在不同的终端下达到一个非常好的显示效果。

现在各个方面还是有很多不足，坚持学习，继续改进，加油！我的目标可是web全栈呢！

2016-03-01 01:40

