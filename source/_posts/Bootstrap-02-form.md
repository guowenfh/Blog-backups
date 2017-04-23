title: Bootstrap入门笔记之（二）表单
date: 2016-01-18 23:26:45
tags: [Bootstrap]
categories: [Bootstrap]

---


>关于表单的应用自然不需要多说，只要您的的网站可以用户登录，那么不可能不用到表单！表单主要功能是用来与用户做交流的一个网页控件，JavaScript发明之初最大的作用也就是用来进行表单操作。所以表单是每一个前端开发者必须要熟练掌握的东西。

良好的表单设计能够让网页与用户更好的沟通。表单中常见的元素主要包括：**文本输入框、下拉选择框、单选按钮、复选按钮、文本域和按钮等**。其中每个控件所起的作用都各不相同，而且不同的浏览器对表单控件渲染的风格都各有不同。传统的HTML表单就不在这样进行讲解了，下面就开始Bootstrap表单的学习吧！

## 一. 基础表单

在Bootstrap对于基础表单没有做太多的定制效果，仅仅是对于一些元素的**margin、padding和border**进行了一些细化设置。
当然，也不会那么简单，在Bootstrap框架中，通过定制了一个类名`form-control`，也就是说，使用了类名`form-control`，将会实现一些设计上的定制效果。从源码中（2551行，嗯，善用搜索）可以得出结论如下：

1. 宽度变成了100%
2. 设置了一个浅灰色（`#ccc`）的边框
3. 具有4px的圆角
4. 设置阴影效果，并且元素得到焦点之时，阴影和边框效果会有所变化
5. 设置了placeholder(输入框的提示文字)的颜色为`#999`

这个类一般用于输入框，对于其他的类型使用，嗯，你可以试试自己尝试一下。

```html
<form role="form">
  <div class="form-group"><!-- form-group这个类在在这里用于控制表单之间的间隔，之后会有另外介绍 -->
    <label for="exampleInputEmail1">邮箱：</label>
    <input type="email" class="form-control" id="exampleInputEmail1" placeholder="请输入您的邮箱地址">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">密码</label>
    <input type="password" class="form-control" id="exampleInputPassword1" placeholder="请输入您的邮箱密码">
  </div>
</form>
```
一般来说效果是这样的：
![基础表单](//ws1.sinaimg.cn/large/82d12951gy1fewhzpflvuj20c6043glk.jpg)

### 内联表单

还是上面那一段代码：我们只需要给**form**加上下面`.form-inline`这个类就可以实现表单元素在一行排列：

![内联表单](//ws1.sinaimg.cn/large/82d12951gy1fewhzpj8kmj20dz01oq2t.jpg)

它的实现原理很简单，其实就是在添加了这个类后，将内部的表单元素设置为了内联块（inline-block）。

我们继续改变屏幕大小会发现小到一定层度之后又变成了原来的样式，那是因为这个类是处于媒体查询中的！这样是为了更好的在移动设备上体验，Bootstrap本来就是一个响应式框架不是吗？

如果你想更简洁一点还可以对于`label`添加一个`.sr-only`类，把label标签进行隐藏。（注意是隐藏，而不是人为删除，设置label标签有助于屏幕阅读器理解此处的含义）


### 水平表单

Bootstrap框架默认的表单是**垂直显示风格**，除了上面的内联表达之外，很多时候我们需要的是**水平表单风格**。在Bootstrap框架中要实现水平表单效果，必须满足以下两个条件：

1. 在`<form>`元素是使用类名`.form-horizontal`，作用如下：
- 设置表单控件padding和margin值。
- 改变“form-group”的表现形式，类似于栅格系统的“row”。
2. 配合Bootstrap框架的栅格系统。（栅格布局会在以后的章节中详细讲解）
- 例如：使用`<div class="col-sm-6"></div>`将我们的input进行包裹，具体情况到栅格布局的时候再说

可以实现下面的效果，（同样处于媒体查询中）
![水平表单](//ws1.sinaimg.cn/large/82d12951gy1fewhzpjlxdj20e3030t8n.jpg)

## 二. 表单控件

### 输入框input

单行文本框在html编写时，我们都需要设置**type**属性为**text**，在Bootstrap中也必须正确的添加type的类型，因为在这里是使用CSS的属性选择器如：`input[type="text"]`来进行样式设置的！
为了让控件在各种表单风格中样式不出错，需要添加类名“form-control”，如：`<input type="email" class="form-control" placeholder="请输入您的邮箱">`

### 下拉选择框select

Bootstrap框架中的下拉选择框使用和原始的一致，但是Bootstrap框架为这些元素提供统一的样式风格。如：

```html
<form role="form">
  <div class="form-group">
    <select  class="form-control">
      <option>踢足球</option>
      <option>游泳</option>
      <option>慢跑</option>
      <option>跳舞</option>
    </select>
  </div>
</form>
```

想要实现多行选择，只需要在**select**中设置multiple属性的值为multiple。`<select multiple class="form-control">`

需要注意的是，经过测试多行选择是固定高度的（82px），也就是说只有一个选项时，也占据那么高的高度，在选项多时，将出现滚动条

### 文本域textarea

文本域和原始使用方法一样，设置**rows可定义其高度**，设置**cols可以设置其宽度**。但如果textarea元素中添加了类名`form-control`类名，则无需设置cols属性。因为Bootstrap框架中的`form-control`样式的表单控件宽度为100%或auto。
如：`<textarea class="form-control" rows="3"></textarea>`

### 复选框checkbox和单选按钮radio

Bootstrap对于这两个按钮进行了一些优化，要想达到最佳显示效果，有着如下说明：

1. 不管是`checkbox`还是`radio`都使用`label`包起来了。
2. `checkbox`按钮连同`label`标签放置在一个名为`.checkbox`的容器内，`radio`连同`label`标签放置在一个名为`.radio`的容器内。
3. 在Bootstrap框架中，主要借助`.checkbox`和`.radio`样式，来处理复选框、单选按钮与标签的对齐方式。
4. 只需要将`checkbox`换成`checkbox-inline`就可以了，你可以添加在label上也可以添加在外部的容器上。

### 表单控件大小
在Bootstrap中除了使用传统的控制大小（height，padding等等）方式外，还特意定制了两个类名用来控制大小，如下：

1. `input-sm`：让控件比正常大小更小
2. `input-lg`：让控件比正常大小更大

这两个类适用于表单中的**input，textarea和select**控件

### 表单控件状态

#### 焦点状态

焦点状态是通过伪类`:focus`来实现。在Bootstrap框架中表单控件的焦点状态删除了`outline`的默认样式，重新添加阴影效果。.

#### 禁用状态

Bootstrap实现禁用和普通的表单禁用状态的实现方法一样的，就是在相应的表单控件上添加属性`disabled`，只不过Bootstrap做了一些样式风格的处理：

![禁用状态](//ws1.sinaimg.cn/large/82d12951gy1fewi0x6wg8j208r032mwz.jpg)

其次，除了单独给相应的表单控件添加disabled外，还可以直接添加到域中`<fieldset disabled></fieldset>`，在这种情况，整个域中的表单全部都将会被禁用，此外还有一个**小bug**：如果该域中存在`<legend>`(域标题)，在其内的表单控件，虽然有禁用的样式，但是实际上可以进行输入，点击等操作！

#### 验证状态

在前面我们说过，Bootstrap有着大量的对于特定的情景内容的颜色设置，表单当然也不例外！在制作表单时，不免要做表单验证。同样也需要提供验证状态样式，那么Bootstrap框架中就提供了这几种效果：

1. `.has-warning`：警告状态（黄色）
2. `.has-error`：错误状态（红色）
3. `.has-success`：成功状态（绿色）

除此之外，Bootstrap还实现了在不同的状态提示不同的**icon**，如果你想让表单在对应的状态下显示这样的效果，只需要在对应的状态下添加类名`has-feedback`。请注意，此类名要与`has-error`、`has-warning`和`has-success`在一起，代码如下：

```html
<form role="form">
  <div class="form-group has-success has-feedback"><!-- 最后一个class控制图标显示 -->
    <label class="control-label" for="inputSuccess1">成功状态</label>
    <input type="text" class="form-control" id="inputSuccess1" placeholder="成功状态" >
    <span class="glyphicon glyphicon-ok form-control-feedback"></span><!-- 图标显示！选取显示图标 -->
  </div>
  <!-- ...... 还有不同的图标显示例如glyphicon-warning-sign glyphicon-remove等等 -->
</form>
```
在 Bootstrap 的小图标都是使用**@font-face**来制作，只要有一个容器，就可以通过不同的类名来控制显示的图标。具体内容后面再详细介绍。

显示效果如下：

![禁用状态](//ws1.sinaimg.cn/large/82d12951gy1fewi0xhp8wj20d106edfw.jpg)

#### 表单提示信息
在表单验证的过程，未免会要提供不同的提示信息。在Bootstrap框架中也提供了这样的效果。提供了一个`help-block`类，例如：`<span class="help-block">您输入的信息是错误的</span>`只要将其插入到input之后，提示信息将以块状显示，并且显示在控件底部。



## 三. 按钮

众所周知，我们创建的按钮通常通过下面这几种形式：:

- `input[type="submit"]`：提交按钮
- `input[type="button"]`：普通按钮
- `input[type="reset"]`：重置按钮
- `<button></button>`：按钮元素，（默认行为是提交）

**在Bootstrap框架中的按钮都是采用`<button>`来实现。**

### 1. 情景按钮

也正如我们前面所说，Bootstrop对于按钮也做了不同情景下的类，用不同的颜色展示很好的描述了当前的状态。一下图片来自[慕课网](http://www.imooc.com)

![默认状态](//ws1.sinaimg.cn/large/82d12951gy1fewi0x857dj20kx08oq3s.jpg)
![多种状态](//ws1.sinaimg.cn/large/82d12951gy1fewi0xmc7aj20ma0mimzp.jpg)


记住一点！Bootstrap中的按钮，**第一前提是必须添加`btn`这个类**，其他的各种类，都只能添加到其后。所以一个按钮应该是这个样子的：`<button class="btn btn-info" >信息按钮</button> `，若还有其他的样式，往`btn-info`后添加，充分利用css的层叠特性。

### 2. 按钮大小

Bootstrap有着很对相似的类（学习完后总结一下吧颜色，大小等等），比如现在要说的，改变按钮的大小，当然你可以自定义，但是Bootstrap默认为我们提供了一些，添加到`btn`类后就行！

![按钮大小](//ws1.sinaimg.cn/large/82d12951gy1fewi0xbir3j20j70gtmy9.jpg)

### 3. 块状按钮

Bootstrap框架中提供了一个类名`btn-block`。使用这个类名就可以让按钮**充满整个容器**，并且这个按钮不会有任何的padding和margin值。在实际当中，常把这种按钮称为块状按钮。同样添加到`btn`类后即可生效

### 4. 活动与禁用状态

Bootstrap框架针对按钮的状态做了一些特殊处理。主要分为两种：活动状态和禁用状态。

#### 活动状态

Bootstrap按钮的活动状态主要包括按钮的悬浮状态(`:hover`)，点击状态(`:active`)和焦点状态（`:focus`）几种。

通过在源码中我们可以看到，Bootstrap对于每一种风格的按钮都做了单独的定制。需要进行修改的话可以参考源码！

#### 禁用状态

在Bootstrap框架中，要禁用按钮有两种实现方式：

1. 在标签中添加`disabled`属性
2. 在元素标签中添加类名`.disabled`

```html
<a href="http://guowenfh.github.io/" class="btn btn-danger disabled" type="button">添加disabled类</a>
<a href="http://guowenfh.github.io/" class="btn btn-danger " type="button" disabled>添加disabled属性</a>
```

这两个方式除了样式上的改变之外，还存在是否阻止默认行为上的区别。（此处有大坑，暂时不能跳，以后在详细了解吧。不同浏览器，对于实现阻止默认行为的方式不同，IE11：两个方式都阻止默认行为，IE10-通过属性可以阻止，FF、Chrome通过类可以阻止默认行为。。我已经醉了）


从这里我们也可以看到，Bootstrap只需要在制作按钮的标签元素比如`<div>,<span>`等等，上添加类名`btn`就可以为其加上按钮风格，但是，**并不建议这样使用，为了避免浏览器兼容性问题，个人强烈建议使用button或a标签来制作按钮。**


##  四. 图像
在Bootstrap框架中对于图像的样式风格提供以下几种风格：

1. `.img-responsive`：响应式图片，主要针对于响应式设计
2. `.img-rounded`：圆角图片
3. `.img-circle`：圆形图片
4. `.img-thumbnail`：缩略图片，相框效果

直接把类名添加到img标签上就行了！

**注意：**
设置图片大小时，由于样式没有对图片做大小上的样式限制，所以在实际使用的时候，需要通过其他的方式来处理图片大小。比如说控制图片容器大小。（注意不可以通过css样式直接修改img图片的大小，这样操作就不响应了）

### 图标

这里说的图标就是Web制作中常看到的小icon图标，包括250多个来自 Glyphicon Halflings 的字体图标，Bootstrap框架中图标都是**glyphicons.com**这个商业网站提供的，并且**免费授权**给Bootstrap框架使用。

可以在[Glyphicons 字体图标](http://v3.bootcss.com/components/#glyphicons)，看到全部图标的样式，您可以根据你的需求进行设置

在网页中使用图标也非常的简单，在任何**内联元素**上应用所对应的样式即可：

```html
<span class="glyphicon glyphicon-cloud"></span>
<span class="glyphicon glyphicon-chevron-left"></span>
```

这里第一个类是**所有字体图标所必需的**，第二个类用来自定义显示的图标。

从源码中我们可以看到`glyphicon`这个类,最主要的部分有着如下样式设置：

```css
.glyphicon {
    position: relative;
    top: 1px;
    display: inline-block;
    font-family: 'Glyphicons Halflings';
    font-style: normal;
    font-weight: normal;
    line-height: 1;
}
```

从这里，也就不难发现为什么是必须的了，它控制了标签的显示方式，和引入了字体图标库；而第二个类，仅仅是调用对应字体的编码而已

表单的部分呢，学到这里也就基本高一段落了，下面就要开始进行，Bootstrap的核心**栅格系统**的学习了，继续加油！


参考：

- [慕课网：玩转Bootstrap](http://www.imooc.com/learn/141)
- [Bootstrap中文官网：全局 CSS 样式](http://v3.bootcss.com/css/)
