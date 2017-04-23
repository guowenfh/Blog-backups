title: CSS多列布局
date: 2016-01-10 15:30:52
tags: [css,布局]
categories: [前端技术]
---

> 需要注意的是：本篇文章的布局，都未对父元素进行清除浮动的操作，所以在有**一些**使用了float的布局中，需要在parent容器清除浮动，才能在实际情况下使用。（清除浮动的方式在这里不做讨论）

## 一列定宽一列自适应

这部分的html结构如下：

```html
<div class="parent">
    <div class="left">
        <p>left</p>
    </div>
    <div class="right">
        <p>right</p>
        <p>right</p>
    </div>
</div>
```

大家先来看看直接在左侧添加浮动是怎么样的吧：
![一列定宽，文字环绕效果](//ws1.sinaimg.cn/large/82d12951gy1fewi6htc4gj208c02iweg.jpg)

不要觉得诧异！因为float最开始的出现就是为了实现这个文字环绕效果的，只不过被攻城师们玩坏了，用到了布局上；但这肯定不是我们想要的，来看看我们想要的是怎么样的吧！
![一列定宽，一列自适应](//ws1.sinaimg.cn/large/82d12951gy1fewi6hqtixj208c02i0sp.jpg)

这样才对嘛！是我们想要的！下面就来看看css的实现吧：

### 1. `float`+`margin`

```css
.left{
    float: left;
    width: 100px;
}
.right{
    margin-left: 120px;
}
```
优点：兼容IE7+，便于理解；缺点：不兼容IE6，在right内部第一个元素存在清除浮动时，会发生right掉下去的情况。

一起来看看错误的例子：
![一列定宽，错误](//ws1.sinaimg.cn/large/82d12951gy1fewi6huurjj208c03rweh.jpg)
怎么解决呢？

### 2. 改进版---`float`+`margin`+`fix`

优点：兼容性好，兼容所有浏览器；缺点：结构增加，样式复杂。

布局改变如下：
```html
<div class="parent">
    <div class="left">
        <p>left</p>
    </div>
    <!-- html部分在这个地方进行了添加，使用right-fix把原有结构包裹住了 -->
    <div class="right-fix">
        <div class="right">
            <p >right</p>
            <p>right</p>
        </div>
    </div>
</div>
```
css部分：

```css
.left{
    float: left; width: 100px;
    position: relative; /*提升左边的层级*/
}
.right-fix{
    float: right; width: 100%;
    margin-left: -100px;/*处理右边掉下来的情况*/
}
.right{
    margin-left: 120px;
}
```

### 3. `float`+`overflow`

优点：设置简单；

```css
.left{
    float:left;
    width:100px;
    margin-right:20px;
}
.right{
    overflow:hidden;/*触发BFC*/
    /*_zoom:1;*/ /*IE6使用zoom:1来触发BFC*/
}
```
### 3. `table`

HTML结构还是和第一个一样。

优点：加速table渲染，实现布局优先；缺点：代码量大，复杂

```css
.parent{
    display: table; width: 100%;
    table-layout: fixed;/*加速table渲染，实现布局优先*/
}
.left,.right{
    display: table-cell;
}
.left{
    width: 100px;
    padding-right: 20px;
}
```
### 4. `flex`

优点：结构简单；缺点：兼容性差iE10+，性能不好，常用作小范围布局

```css
.parent{
    display: flex;
 }
 .left{
    width: 100px;
    margin-right: 20px;
 }
 .right{
    flex:1;/**/
 }
```


## 多列定宽一列自适应

大家来看看想要达到的效果：
![二列定宽，一列自适应](//ws1.sinaimg.cn/large/82d12951gy1fewi6icb5rj20ci02iaa5.jpg)
其实只是在上面的布局上，中间再加入一个center。
html结构如下：
```html
    <div class="parent">
    <div class="left">
        <p>left</p>
    </div>
    <div class="center">
        <p>center</p>
    </div>
    <div class="right">
        <p>right</p>
        <p>right</p>
    </div>
</div>
```
css部分：把center设置和left一样
```css
.left,.center{
    float: left;
    width: 100px;
    margin-right: 20px;
}
.right{
    overflow: hidden;
}
```

## 一列不定宽,一列自适应
>HTML结构同一列定宽一列自适应。
> 其实就是对一列定宽,一列自适应的后三个进行一下改造

实现效果和上面一样，但是宽度不在固定了！

### 1. `float`+`overflow`

优点：兼容性好，使用最多，结构简单；（其实和上面的改变就是左侧使用内容去撑开高度，因为原来的实现已经达到了这个效果）

```css
.left{
    float:left;
    margin-right:20px;
    /*width:200px;*//*可设置宽度，也可使用内容撑开*/
}
.right{
    overflow:hidden;
}
.left p{width:200px;}/*使用内容去撑开宽度*/
```

### 2. `table`

缺点：支持IE8+，设置复杂。

对css进行如下更改：
```css
.parent{
    display: table; width: 100%;
}
.left,.right{
    display: table-cell;
}
.left{
    width: 0.1%;/*只要足够小就行*/
    padding-right: 20px;
}
.left p{width:200px;}/*使用内容去撑开宽度*/
```
### 3. `flex`

缺点：还是上面的问题
```css
.parent{
    display: flex;
 }
 .left{
    margin-right: 20px;
 }
 .right{
    flex:1;/**/
 }
 .left p{width:200px;}/*使用内容去撑开宽度*/
```


## 两列不定宽，一列自适应。

HTML结构同两列定宽一列自适应。
以`float+overflow`为例，只需要把`center`设置和`left`一样就可以了。
```css
.left,.center{
    float: left;
    margin-right: 20px;
}
```
除了这个方法之外，上面的不定宽中的三个方法都能使用

## 等分布局

html结构如下：
```html
<div class="parent">
    <div class="column"><p>1</p></div>
    <div class="column"><p>2</p></div>
    <div class="column"><p>3</p></div>
    <div class="column"><p>4</p></div>
</div>
```
按照惯例，先来分析一下实现过程。可以看到下图：
![等分布局分析](//ws1.sinaimg.cn/large/82d12951gy1fewi6iwdq9j20h809qwg0.jpg)

其实我们只需要给父容器增加一个G，也就是一个负的margin就可以实现了，下面就来看看吧：

### 1. `float`+`margin`

优点：设置简单；缺点：支持IE8+，在布局变更时，需改变css样式（width：XX%）结构和样式耦合在了一起

```css
p{background:#666;}/*对div中的p标签设置才有间隔效果，所以在设置内容时，也是在p中设置*/
.parent{
    margin-left: -20px;
}
.column{
    float: left;
    width: 25%;
    padding-left: 20px;
    box-sizing: border-box;
}
```
实现效果如下：
![等分布局存在左侧padding](//ws1.sinaimg.cn/large/82d12951gy1fewi6iu7clj20hi08mwf6.jpg)

效果不是就达到了呢？其实还不尽然，可以看到最左边还有一个宽度，我们不想要怎么办？

这并不是一个bug，而是我们的设置导致的，现在来删除上面的` padding-left: 20px;`吧，可以看到成了这样子：
![等分布局未设置padding](//ws1.sinaimg.cn/large/82d12951gy1fewi6hu8grj20hi07it96.jpg)

如果你需要有填充的话，自行设置吧

### 2. `table`+`(fix)`

**html部分在上面的基础上，在最外层增加`<div class="parent-fix">`包裹住`<div class="parent">`**

```css
.parent-fix{
    margin-left: -20px;
}
.parent{
    display: table;
    width:100%;
    table-layout: fixed;/*布局优先，且在单元格未设宽度时，将被内容平分*/
}
.column{
    display: table-cell;
    padding-left: 20px;/*间隔，自行考虑是否取消*/
}
```

### 3. `flex`

```css
.parent{
    display: flex;
}
.column{
    flex: 1;
}
.column+.column{/*给后三列设置间隔*/
    margin-left:20px;
}
```
实现效果如下：
![等分布局FLex](//ws1.sinaimg.cn/large/82d12951gy1fewi6hxdq0j20hn07sgm6.jpg)
**这里使用的是margin，因为flex自动分配剩余空间**

## 等高布局
大家先来看看想要的效果：
![等高布局](//ws1.sinaimg.cn/large/82d12951gy1fewi6hsqgqj208c02idfu.jpg)

是不是很熟悉？html和第一部分一样：
但是两侧高度等同于高度最高的部分。
```html
<div class="parent">
    <div class="left">
        <p>left</p>
    </div>
    <div class="right">
        <p>right</p>
        <p>right</p>
    </div>
</div>
```

在**使用`table`和`flex`布局时就自然实现了等高布局**

这里就不贴了，代码实现参考上面。主要是下面这个方案：

###  `float`实现

实际上没有完全相同，只是达到了效果

```css
.parent{
    overflow: hidden;
}
.left,.right{
    padding-bottom: 9999px;
    margin-bottom: -9999px;
}
.left{
    float: left; width: 100px;
    margin-right: 20px;
}
.right{
    overflow: hidden;
}
```


再一次提醒：实际情况中使用，需要在外层容器清除浮动。
