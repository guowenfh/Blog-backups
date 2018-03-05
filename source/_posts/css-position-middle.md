title: CSS之各种居中
date: 2016-01-06 16:16:08
tags: [css,布局]
categories: [前端技术]
---
本博客讨论居中情况设定为**总宽度不定,内容宽度不定**的情况。（改变大小时，仍然居中）。

特别说明：在元素设置`position:absolute;`来设置居中效果时，除去博客下介绍的css3方法外，还可以使用负的`margin`来居中，这样解决了兼容性的问题，但是只适用于宽高已知的情况（因为负的偏移量为元素宽高的一半）。宽高改变时，不再是居中效果。

在这些布局中的子元素，因为其属性设置，都默认为内容宽度。

本博客所有居中的例子，只讨论css的实现，html代码统一如下：

```html
<div class="parent">
    <div class="child">demo</div>
</div>
```

##  1. 水平居中

![水平居中](https://ws1.sinaimg.cn/large/82d12951gy1fewin03e5wj20fi03u0so.jpg)


### 1.1 `inline-block`配合`text-align`

```css
.parent{
    text-align: center;
}
.child{
    display: inline-block;
}
```

> 优点：兼容性非常好，只需要添加只需要在子元素的css中添加`*display:inline`和`*zoom:1`就可兼容到IE6、7；缺点：内部文字也会水平居中，需消除影响。

### 1.2  `table`配合`margin`


```css
.child{
    display:table;
    margin: 0 auto;
}
```

> 优点：设置特别简单，只需对子元素进行设置，支持IE8+，需支持IE6，7时，可更换子元素为表格结构。

### 1.3  `absolute`配合`transform`

```css
.parent{
    position:relative;
}
.child{
    position:absolute;
    left:50%;
    transform: translateX(-50%);
}
```

>  优点：居中元素不对其他元素产生影响。缺点：CSS3新属性支持IE9+，低版本浏览器不支持。

## 2. 垂直居中

![垂直居中](https://ws1.sinaimg.cn/large/82d12951gy1fewin0i911j203u0caa9z.jpg)


### 2.1  `table-cell`配合`vertical-align`

```css
.parent{
    display: table-cell;
    vertical-align:middle;
}
```

>优点：设置简单，只需对父元素进行设置，兼容到IE8+，需兼容地版本浏览器时，可更换`div`为表格结构。

### 2.2  `absolute`配合`tranform`

```css
.parent{
    position:relative;
}
.child{
    position:absolute;
    top: 50%;
    transform: translateY(-50%);
}
```

> 优点：居中元素不对其他元素产生影响。缺点：CSS3新属性支持IE9+，低版本浏览器不支持。

## 3.  水平+垂直居中

![水平垂直居中](https://ws1.sinaimg.cn/large/82d12951gy1fewin0bwwcj208d08d748.jpg)

### 3.1  `inline-block`配合`text-align`加上`table-cell`配合`vertical-align`

```css
.parent{
    display: table-cell;
    vertical-align:middle;
    text-align:center;
}
.child{
    display: inline-block;
}
```

>优点：综合前两中方法，兼容性好！支持IE8+，低版本浏览器也好兼容。缺点：设置较为复杂。


### 3.2  `absolute`配合`transform`

```css
.parent{
    position: relative;
}
.child{
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%,-50%);
}
```
> 优点：居中元素不对其他元素产生影响。缺点：CSS3新属性支持IE9+，低版本浏览器不支持。

### 3.2  `absolute`配合`margin:auto`

```css
.parent{
    position: relative;
}
.child{
    position: absolute;
    top:0;
    left:0;
    right:0;
    bottom:0;
}
```

> 优点：居中元素不对其他元素产生影响。缺点：CSS3新属性支持IE9+，低版本浏览器不支持。

## 4. 全能的`flex`

css3新增布局属性，布局简单，强大，性能略差，只支持IE10+，在移动端使用较多。

### 4.1 水平居中

```css
/*当父元素设置display: flex;时，子元素为flex-item，默认为内容宽度。*/
.parent{
    display: flex;
    justify-content: center;
}
/* 在设置子元素为margin: 0 auto;时，可删除父元素的justify-content: center;同样可以达到居中效果*/
/*  .child{
        margin: 0 auto;
    }*/
```

### 4.2  垂直居中

```css
.parent{
    display: flex;
    align-items: center;
}
```
### 4.3  水平垂直居中

```css
.parent{
    display: flex;
    justify-content: center;
    align-items: center;
}
/*如同flex布局的第一部分一样这里也可以对子元素进行下面的设置：同时删除上面的除去display外的其他属性*/
/*  .child{
        margin:auto;
    } */
```
