title: CSS3选择器详解
date: 2016-01-08 22:38:19
tags: [css]
categories: [前端技术]
---

## 1.常用选择器
1.1标签选择器
```css
p{ }/*选择标签名为p的元素*/
```
1.2类选择器
```css
.box{ }/*选择class名为box的元素*/
```
1.3ID选择器
```css
#pid{ }/*选择id名为pid的元素*/
```
1.4通配符选择器
```css
*{ }/*选择页面中所有的元素*/
```

1.5选择器前缀
```css
div.bd{}/*选中class名为bd且标签为div的元素*/
```
1.6属性选择器
```css
[disabled]{}/*选择带有属性disabled的所有元素*/
[type=button]{}/*选择type属性为button的所有元素*/
[class~=sports]{}/*选择class属性包含sports所有元素*/
[lang|=en]{  }/*选择以lang属性以"en"开头以及以"-"分隔的所有元素*/
a[href^="#"]{ }/*选择href属性以"#"开头的a元素*/
[href$="pdf"]{  }/*选择href属性以"pdf"结尾的元素*/
[href*="lady.163.com"]{}/*选择href属性中包含"lady.163.com"的元素*/
```
## 2.伪类选择器
2.1链接伪类
```css
/*前两个只可用于描元素（链接）*/
a:link {color:#FF0000;}     /* 未被访问的链接 */
a:visited {color:#00FF00;}  /* 已被访问的链接 */
/*后两个可以用于其它元素*/
a:hover {color:#FF00FF;}    /* 鼠标指针移动到链接上 */
a:active {color:#0000FF;}   /* 正在被点击的链接 */
```
链接在进行设置时：`a:hover` 必须位于 `a:link` 和 `a:visited` 之后, `a:active` 必须位于 `a:hover` 之后。


2.2动态伪类
```css
input:focus{}/*设置input元素获得焦点后的样式*/
input:enabled{}/*元素可用的状态*/
input:disabled{}/*元素不可用的状态，属性选择器[disabled]的简写*/
input:checked{}/*单选框或者复选框选择的样式*/
```

2.3树形图上的伪类
html结构如下：

```html
<ul>
    <li>1</li>
    <li>2</li>
    <li><a href="#">3</a></li>
    <li>4</li>
    <p>5</p>
</ul>
```
选择符：
```css
ul:first-child{}/*选择第一个ul下第一个标签（css2定义，支持ie7）在处理margin时很有用*/

/*以下全是CSS3新增的伪类*/
ul:last-child{}/*选择最后一个li标签*/
ul:nth-child(n){}/*选择()内的表达式如：[2n+1]，或者数字所代表的li标签*/
ul:nth-last-child(n)/*同上，反向选择*/
ul:only-child{}/*选择ul只有一个子元素的项，这里会选中第三个li下的a标签*/
ul:first-of-type{}/*选择第一个该类型的标签，会选择第一个li和p*/
ul:last-of-type{}/*选择最后一个该类型的标签，会选择第四个li和p*/
ul:nth-last-of-type(2n){  }/*倒数的选择(.)内的表达式[2n]，或数字所代表的该类型标签。选择第一个和第三个li标签*/
ul:only-of-type{}/*选择ul下中只有一个该类型的项，会选中a标签和p标签*/
:root{}/*选择文档的根元素*/
ul:not(li){}/*选择不含有li标签的元素，这里会选中a标签和p元素*/
ul:empty{}/*匹配ul下没有任何子元素（包括text节点）的元素，这里匹配不到，把p标签中的5删除，可匹配成功*/
E:target{}/*匹配相关URL（锚点）指向的元素。*/
```

## 3.伪元素选择器
```css
::first-letter{}/*选择第一个字母*/
::first-line{}/*选择第一行*/
::before{content:"before";}/*在某个元素之前插入一些内容*/
::after{content:"after";}/*在某个元素后插入一些内容*/
::selection{}/*设置于被用户选中时的样式*/
::placeholder{}/*设置对象文字占位符的样式*/
```
## 4.组合选择器
4.1后代选择器
```css
.main h2{  }/*选择class名为mian元素内的所有h2标签*/
```

4.2子选择器
```css
.main>h2{  }/*选择class名为mian元素内的直接关联与父元素的h2标签*/
```
4.3相连选择器
```css
h2~p{}/*只要P标签前有h2标签便选择*/
```

4.4兄弟选择器
```css
h2~p{}/*选择h2标签后出现的所有p标签*/
```
4.4选择器分组
```css
h1,h2,h3{backgound-color:#ddd;}/*同时设置h1,h2,h3标签,使用","分隔*/
```
## 5.继承
```css
body{font-family:"Microsoft Yahei";}/*设置页面中所有的字体为微软雅黑*/
```
* 继承属性
 * color
 * font
 * text-align
 * list-style
 * ...
* 非继承属性
 * background
 * border
 * position
 * ...

## 6.CSS优先级
* 计算方法
 * a = 行内样式
 * b = ID选择器的数量
 * c = 类/伪类和属性选择器的数量
 * d = 标签选择器和伪元素选择器数量

> value = a*1000 + b*100 + c*10 +d

`!important`强行提升优先级
