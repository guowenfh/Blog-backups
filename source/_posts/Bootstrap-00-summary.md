title: Bootstrap入门笔记之（零）简介
date: 2016-01-17 17:26:06
tags: [Bootstrap]
categories: [Bootstrap]
---

### 什么是Bootstrap？

1. Bootstrap 是由Twitter推出的一个用于快速开发 Web 应用程序和网站的前端框架。
2. 基于html5、css3的bootstrap，具有下面这些诱人特性：
（1）移动设备优先；
（2）漂亮的设计；
（3）友好的学习曲线；
（4）卓越的兼容性；
（5）响应式设计；
（6）12列响应式栅格结构；
（7）样式向导文档。

3.  自定义JQuery插件，完整的类库，基于Less、Sass等

### Bootstrap下载

可以在其[中文官网](http://v3.bootcss.com/getting-started/#download)中下载，可以很明显的看到一个大大的下载按钮，此外还可以通过CDN，git命令，以及npm等等方式进行下载。

如果您恰好看了我写的[sublime Text](http://guowenfh.github.io/2015/12/26/SublimeText/)的博客的话，肯定知道我们是可以直接通过插件进行安装的。只需要在`ctrl`+`shift`+`P`时,输入`fecth:manage`，进行如下设置：

```javascript
"packages":
    {
        "Bootstrap": "//github.com/twbs/bootstrap/releases/download/v3.3.6/bootstrap-3.3.6-dist.zip"
    }
```
之后就可以直接通过sublime Text进行下载了，还是刚刚的步骤，但是这一次输入的是`fetch:package`。找到`Bootstrap`，如果下载成功在您的文件夹中应该可以看到主要包括三个文件夹`css`，`fonts`和`js`，如下：

![下载文件夹](//ws1.sinaimg.cn/large/82d12951gy1fewhun5wsfj20fk0b90tc.jpg)

可以看到除去字体文件夹外的其他文件夹中每一分文件都有两个不同的版本，一个完整版的文件，方便查看源码如：`bootstrap.js`和一个用于实际生产情况的压缩文件如`bottstrap.min.js`；

在字体文件中可以看到有很多文件，但是它的功能很简单，就是是用来制作**icon图标**的文件，使用了CSS3的@font-face技术。

在实际情况中，如果你还想使用更多的图标，还可以在[Iconfont-阿里巴巴矢量图标库](http://www.iconfont.cn/)，自行查找设置。

### Bootstrap标准模板

```html
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <!-- 在IE运行最新的渲染模式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- 初始化移动浏览显示 -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>Bootstrap 标准模板</title>

    <!-- 1. 加载Bootstrap层叠样式表 -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- 你自己自定义的样式文件 -->
    <link href="css/your-style.css" rel="stylesheet">
    <!-- 以下两个插件用于在IE8以及以下版本浏览器支持HTML5元素和媒体查询，如果不需要用可以移除 -->
    <!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

  </head>
  <body>
    <h1>hello,world</h1>
    <!-- 2. 如果要使用Bootstrap的js插件，必须加载jquery库，且必须在bootstrap库之前 -->
    <script src="js/jquery-min-1.11.3.js"></script>
    <!-- 3. 包括所有bootstrap的js插件或者可以根据需要使用的js插件调用-->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
```

### 全局样式
Bootstrap框架的核心是轻量的CSS基础代码库，他并没有一味的重置样式，而是注重各浏览器基础表现，降低开发难度。
为了增强跨浏览器表现的一致性，Bootstrap使用了 [Normalize.css](http://necolas.github.io/normalize.css/)。但没有一味全部使用该重置样式，而是在此基础之上进行了一些改良，让其更加符合Bootstrap的设计思想。
Bootstrap保留和坚持部分浏览器的基础样式，解决部分潜在的问题，提升一些细节的体验，在排版、链接样式设置了基本的全局样式。具体说明如下：

- 移除body的margin声明
- 设置body的背景色为白色
- 为排版设置了基本的字体、字号和行高
- 设置全局链接颜色，且当链接处于悬浮`:hover`状态时才会显示下划线样式


Bootstrap简介部分到此就结束了，在Bootstrap的[中文官网](http://v3.bootcss.com/)中，有着层次清晰且详细的说明文档，下面就和我一起走进Bootstrap的世界吧！

