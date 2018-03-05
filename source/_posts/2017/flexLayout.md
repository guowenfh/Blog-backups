title: FlexBox 布局详解
date: 2017-05-31 22:52:54
tags: [css]
categories: [前端技术]
---
> 很久没有写博客了，这里把之前学习 flex 布局的一篇笔记整理了一下。发布到博客上。赶一个五月的末班车吧。还是得坚持啊!!

flex 弹性布局
FlexBox 可控制子元素:
- 水平或垂直排成一行
- 控制子元素的对齐方式
- 控制子元素的高度／宽度
- 控制子元素的显示顺序
- 控制子元素是否折行

** `display:flex;` 创建  Flexbox 元素 **
在 flex 布局中必须理解的概念就是区分主轴和辅轴(侧轴):
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x85jz1oj21420ei0ty.jpg)
<!--more-->

在项目中我们使用 `display:flex;` 创建  `Flexbox` 元素，那么该元素就成为了一个 `flex container`( 弹性的容器)。
其在**文档流中的直接子元素**将成为 `flex item`。
 `flex item` 子元素**在容器内 **排列的方向称为**主轴**，跟主轴垂直的方向称为 **辅轴**。

## 方向相关属性

### `flex-direction`

- 设置子元素排列方向 (其实也就是主轴的排列方向)
- 取值 `row` | `row-reverse` | `column` | `column-reverse`
- 默认 `row`: 

其中不同的设置，效果大致如下 : 
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x85yqm6j21dc0fs761.jpg)

###  `flex-wrap`

- 元素在主轴方向排放时，能否换行
- 取值:`nowrap` | `wrap` | `wrap-reverse`
- 默认 `nowrap`，不换行

```less
/*base css*/
.container{
    width: 400px;
    margin: 20px;
    line-height: 40px;
    font-size: 20px;
    color: #fff;
    display:flex;
}

.item{
    margin: 10px;
    width: 100px;
    line-height: 40px;
    text-align: center;
}
```

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x88k4xfj21ci0koah7.jpg)

### 合并属性: `flex-flow` ， 上面两个属性的缩写
- `<'flex-direction'>` ||  `<'flex-wrap'>`
- 默认:  `flex-flow: row nowrap;`

这里直接结合两个属性看就好。

###  `order`

- 指定摆放时的顺序，从小到大
- 取值:默认 0 ，(支持负值和正值)

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x86pdw6j215c0eojv0.jpg)

## 弹性相关属性，都是设置在子元素上的

### `flex-basis` 

- 设置 `flex item` 的初始宽／高
- 取值: `main-size` | `<width>`
- 默认: `main-size`: 主轴方向的宽度 (根据 `flex-direction`设置，水平排列时，设置的是宽度；垂直排列时，设置的高度)

### `flex-grow` 

- 定义每一个子元素在盒子内的弹性
- **拓展盒子剩余空间的能力**(空间富余时)
- 取值: `<number>`
- 取值:默认 0 ，整数小数都可
- 剩余空间的分配规则 : `flex-basis + flow-grow/sum(flow-grow)*remain` remain 表示多余的空间

这里可以看到 只设置 `flex-basis` 相当与设置元素的 `width`

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x87orwsj21oo0i6tdg.jpg)
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x89zp9dj21pg0i8tdl.jpg)
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x894rf9j21os0heq7w.jpg)

### `flex-shrink` 

- **定义元素收缩的能力**(空间不足时)
- 取值: `<number>`
- 取值 : 默认 1  ，平方(值为 0 时，不收缩)
- 不足空间收缩的规则 : `flex-basis + flow-grow/sum(flow-grow)*remain` remain 表示不足的空间 (负值)

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x89licsj21jq0dm791.jpg)
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x88lxkpj21ou0esdkp.jpg)
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x8ab53yj21k00eadld.jpg)

### 合并属性:  `flex`

- `<'flex-grow'>` ||  `<'flex-shrink'>` ||  `<'flex-basis'>`
- 默认:  `flex: 0 1 main-size;` 看上面

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x8ahj86j21nm0jawjp.jpg)
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x8bk20gj21oq0jqgqz.jpg)

## 对齐 相关的属性

### `justify-content`

- 设置子元素在主轴方向上的对其方式
- 取值: `flex-start` | `flex-end` | `center` | `space-between` | `space-around`
- 默认 `flex-start` 

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x85umuij20u00wcwid.jpg)

例子:切换主轴方向时
![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x8bqzo7j214m0xcahf.jpg)


### `align-items`

- 设置在辅轴上的对齐方式。
- 取值: `flex-start` | `flex-end` | `center` | `baseline` | `stretch`
- 默认 `stretch` 

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x86vni3j20uc0xc78v.jpg)

### `align-self` 设置在子元素上

- 单独设置子元素在辅轴方向的对齐方式
- 取值: `flex-start` | `flex-end` | `center` | `baseline` | `stretch`
- 默认 `stretch` 

### `align-content`

- **多行内容** 设置在辅轴方向上，行的对齐方式
- - 取值: `flex-start` | `flex-end` | `center` | `space-between` |  `space-around` |`stretch`
- 默认 `stretch`  拉伸

![](https://ws1.sinaimg.cn/large/82d12951gy1fg4x86wizij20ta0x2jww.jpg)


