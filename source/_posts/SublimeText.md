title: 一个前端程序猿的Sublime Text3的自我修养
date: 2015-12-26 15:26:17
tags: [Sublime Text,开发工具]
categories: [前端技术]
---

**详细设置 && 20+插件**

> 本文章会在本人有插件或者设置更新时，进行不定时更新
>
> 2015-12-31更新：NO. 21 侧边栏同步编辑窗口底色插件。
> 2016-04-06更新：代码片段：`better-completions`；主题：`Material`,`Seti_UI`；代码格式化：`HTML-CSS-JS Prettify`；vue语法高亮：`Vue Syntax Highlight`；`Terminal`与`MarkdownEditing`个性化定制
> GitSavvy 、
> 2016-07-03更新：自定义代码片段；`livereload`：保存自动刷新浏览器；`WakaTime`:记录你的编程时间



**为什么要选择Sublime Text3？**

- Sublime Text3 自动保存，打开图片
- 跨平台启动快!!!!多行游标，太好用。
- 插件，简直选不过来。
- 代码片段
- VIM兼容模式


## 菜单栏基础功能介绍

![菜单栏介绍](https://ws1.sinaimg.cn/large/82d12951gy1fewiqk6y6pj20hi07qaae.jpg)

1. `File`：文档相关，新建文件,打开文件或文件夹等。
2. `Edit`：文件编辑相关，复制，剪切等（CVS大法好）。除此之外还有一些强大的功能。
3. `Selection`：选择相关，帮助选择代码。
4. `Find`：查找替换相关。这个和其它编辑器区别好像不大。
 - `Ctrl+F`查找、`Ctrl+H`替换等。
5. `View`：对Sublime_Text编辑器本身的一些配置。
 - `SideBar`:开启侧边栏`Ctrl+k,b`
 - `Show console`：打开控制台窗口，安装package control需要使用.
6. `Goto`：快捷导航：下面介绍。Goto Anything
7. `tools`:工具，一些命令。
 - `new Snippet`：自定义代码片段，保存到user下
8. `Project`: 项目相关，用的少。
9. `Preferences`：对于sublime_text进行一些个性化定值。
10. `Help`：如同名字。注册在这里

### 快捷键
- `line`相关：
 - `Ctrl+Shift+D`：复制当前行
 - `Ctrl+Shift+K`：删除当前行
 - `Ctrl+j` 合并一行
 - `Ctrl+Enter`：在当前行下添加新行。After
 - `Ctrl+Shift+Enter`：在当前行上添加新行。Before
 - `Ctrl+Shift+上、下`：移动当前行
- `Comment`注释：
 - `Ctrl+/`：行注释。
 - `Ctrl+Shift+/`：块注释
- `Ctrl+Shift+P`：调用命令面板，快速查找，例如：改变语法模式等。
  - 模糊匹配，可以减少对快捷键的记忆。
- **`Shift+Alt+1，2，3，4，5`：开启对应数字的多栏编辑**


#### `Ctrl+P`：Goto Anything
 - `Ctrl+P`: 查找项目中的文件：
  - 直接输入名称：在不同文件中切换，**支持级联的目录模式**
  - `:`：+ 行号：`Ctrl+G` 定位到具体的行。
  - `@`：+ 符号：`Ctrl+R`定位到具体的符号，例如：JS函数名，CSS选择器名。
  - `#`：+ 关键字：`Ctrl+;`匹配到具体的匹配的关键字。主要是模糊匹配。


#### 多行游标
 - `Ctrl+D`：选中当前光标所在位置的**单词**。连续使用时，进行多光标选择，选中下一个同名单词。
 - `Ctrl+K`：配合`Ctrl+D`可以**跳过**下一个同名单词。
 - `Ctrl+L`：选择当前光标所在位置的**行**。连续使用时，继续选中下一行。
 - `Ctrl+Shift+L`：在多行选中后，在所有选中的行后产生游标。
 - `Alt+F3`：选中文档中所有的同名单词。
 - `Shift+鼠标右键`：向下拖动，产生多个光标。

### 设置

使用 `View`-->`Show console`，快捷键： Ctrl+\` 调出console面板输入`sublime.log_commands(True)`，可以得到当前使用的命令面板进行设置的值。方便进行快捷键的绑定。

下面这些都可以通过命令面板快捷查找

- `Settings-User`：个人对于sublime_text的定制。使用JSON格式，会直接覆盖掉`Settings-Default`默认设置中的内容。

```javascript
// User/Preferences.sublime-settings
//我觉得自带字体挺好的。
{
    "color_scheme": "Packages/Material Theme/schemes/Material-Theme-Darker.tmTheme",//主题，
    "theme": "Material-Theme-Darker.sublime-theme",//侧边栏样式，需要安装该主题才可以使用
    "draw_minimap_border": true, // 右侧缩略图边框
    "font_face": "Monaco",//字体
    "font_size": 10, // 字体大小
    "highlight_line": true, // 当前行标亮
    "save_on_focus_lost": true, // 当前行标亮
    "theme": "Spacegray Eighties.sublime-theme", //主题相关
    "word_separators": "./\\()\"':,.;<>~!@#$%^&*|+=[]{}`~?", // 双击选中中划线
    "word_wrap": true, //自动换行
    "trim_trailing_white_space_on_save": true, //自动移除行尾多余空格
    "ensure_newline_at_eof_on_save": true, //文件末尾自动保留一个空行
    "disable_tab_abbreviations": true, //禁用 Emmet 的 tab 键功能（请使用 ctrl+e）
    "translate_tabs_to_spaces": true, //把代码 tab 对齐转换为空格对齐
    "tab_size": 4, //空格数
    "fade_fold_buttons": false, //显示代码块的倒三角
    "bold_folder_labels": true, //侧边栏文件夹加粗
    "auto_find_in_selection": true //开启选中范围内搜索
}
```

- `key - Bindings-User`：个人对于快捷键的设置。同样会覆盖默认的设置。例如：


```javascript
//自动改变缩进格式
    {
        "keys": ["shift+tab"], "command": "reindent","args":{"single_line":false}
    }
```

### 构建系统实现快捷调用浏览器

> 构建系统可以让您通过外部程序来运行文件，并可以在Sublime Text查看输出。

`tools`:工具下的`Build System`选择新建一个选项后(`Build System`-->`New Build System`)，进行如下设置（注意后缀），保存到user目录下：

```javascript
//这样设置。。地址是你的浏览器位置
{
  "cmd" :["C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe","$file"],
  "selector":["text.html"]
}
```

之后再进入刚刚的的地方，选择第一个`Automatic`，修改内容后按`Ctrl+B`，可以看到自动调用`chrome`并且是修改后的内容。在`sublime Text`的`console`中可以看到输出的信息。更多功能请查看[这里](http://docs.sublimetext.info/en/latest/file_processing/build_systems.html)

上面是一些基础功能的介绍

2016-07-03 更新：**自定义sublime代码片段**

我们在开发中有很多代码是需要重复编写的，每一次都去复制粘贴显然是一件效率极其低下的事情，sublime的自定义代码片段功能就很好的解决了这个问题。下面就来看一下如何在sublime中自定义代码片段

首先在菜单栏选择：Tools ->developer -> New Snippet可以看到新建一个`xml`类型的描述文件，如下：

```xml
<snippet>
    <content><![CDATA[
Hello, ${1:this} is a ${2:snippet}.
]]></content>
    <!-- Optional: Set a tabTrigger to define how to trigger the snippet -->
    <!-- <tabTrigger>hello</tabTrigger> -->
    <!-- Optional: Set a scope to limit where the snippet will trigger -->
    <!-- <scope>source.python</scope> -->
</snippet>
```


注释已经非常详细了，`content` 里面就是代码模版：`${序号：默认值}` ，序号相同的地方光标会同时停在那可以多处同时编辑。序号大小就是 `tabindex`。在实际使用代码的时候，可以使用 `tab` 切换光标位置。

以hexo新建一篇博客头部为例：

```xml
<snippet>
    <content>
        <![CDATA[
title: ${1:标题}
date: ${2:2015-12-26 15:26:17}
tags: [${3:标签}]
categories: [${4:分类}]
]]>
    </content>
    <!-- 可选：快捷键，利用Tab自动补全代码的功能 -->
    <tabTrigger>hexoH</tabTrigger>
    <!-- 可选：使用范围，不填写代表对所有文件有效。附：source.css和test.html分别对应不同文件。 -->
    <!-- <scope>source.md</scope> -->
    <!-- 可选：在snippet菜单中的显示说明（支持中文）。如果不定义，菜单则显示当前文件的文件名。 -->
    <description>hexo博客头部生成</description>
</snippet>
```
设置完毕，最后还差一步，要想代码片段生效，还必须保存到`sublime的文件目录\Data\Packages\User`，文件名任意，但文件后缀必须为`.sublime-snippet`。

现在输入`hexoH`试试，你想要的代码片段是不是已经有了呢？


## 插件的安装与使用

### 安装`package control`。
这里我使用的是`sublimeText 3`，2 的话上官网查询代码。
首先打开`package control`的[官方网站](https://packagecontrol.io/installation)。
复制下面这一段代码:

```
import urllib.request,os,hashlib; h = '2915d1851351e5ee549c20394736b442' + '8bc59f460fa1548d1514676163dafc88'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```

在上面说的`View`-->`Show console`,快捷键： Ctrl+\` 打开控制台窗口，粘贴上面的代码，回车，然后就是等待安装了，需要一定的时间。安装完成后重启 。

使用`Ctrl+Shift+P`,打开控制面板，输入`PC`，效果如下：说明安装成功了。

![package control](https://ws1.sinaimg.cn/large/82d12951gy1fewiql1jepj20c50arwf8.jpg)


### 安装主题

- 按照上面的步骤，打开图片中的安装插件就行了，其实默认配色真的挺好看的
- 推荐在安装前，先去[官方网站查看样式](https://packagecontrol.io)。的样式，以及设置方法,说明文档。一般安装成功后，会自动弹出。
- 以`Theme - Spacegray`为例：


![Theme - Spacegray](https://ws1.sinaimg.cn/large/82d12951gy1fewitm4cmpj20cb09dgm8.jpg)
先使用`Ctrl+Shift+P` 输入PCI，回车选择 `Install Package` 。需要等待一会加载时间，输入`Theme-Spacegray`。其实不输入完也会模糊匹配出来的。
- 回车等待安装就好，成功后会弹出一个使用设置的页面，把其中的如下代码拷贝到`Settings-User`，保存，你会发现，默认的主题已经变成了刚刚我们查看过的主题了。

```javascript
"color_scheme": "Packages/Theme - Spacegray/base16-eighties.dark.tmTheme",
"theme": "Spacegray Eighties.sublime-theme"
```
当然，你也可以通过菜单栏，进行主题的选择。会有相同的效果。它会自动在`Settings-User`进行设置。

**2016-04-6 更新**

安利两款主题：

两款主题都有侧边栏图标显示：我在这里说不清到底谁好谁差，全凭个人的喜好吧！

1. Material：

![Theme_Material](https://ws1.sinaimg.cn/large/82d12951gy1fewiqlbwh4j210o0u20ty.jpg)

2. Seti_UI：

![Theme_Seti_UI](https://ws1.sinaimg.cn/large/82d12951gy1fewiql87qij21ao0r93ze.jpg)

安装方法还是和上面一样，最好是根据它的`README`描述来进行设置。

## 个人常用插件及使用方法：

### NO.1 `AdvancedNewFile`：快速新建文件。

- 假设有文件夹`file`。我们正在输入代码，又想在新的子目录下新建html文件的话用传统方式得很多步，新建目录，新建文件，保存等等等。
- 但是有了该插件之后，事情就变得简单了许多，只需要按下`Ctrl+Shift+N`，输入文件夹以及文件名，你就会看到如下效果:（回车，你会发现已经子目录下的文件已经新建完成了！）


![AdvancedNewFile](https://ws1.sinaimg.cn/large/82d12951gy1fewiqk9cn6j20aq023jrn.jpg)


### NO.2 `Nettuts+ Fetch`：管理类库。

安装成功后输入`Ctrl+Shift+P`打开命令面板，输入`Fetch`，可以看到以下：


![Nettuts+ Fetch](https://ws1.sinaimg.cn/large/82d12951gy1fewiqk901oj209s03ydfw.jpg)
选择`file`可以看到设置的文件。选择下载
配合刚刚上面的插件使用，简直完美..


### NO.3 `Sidebar Enhancements`：增强侧边栏。
必装插件，无比强大，就不过多介绍了。可以在浏览器中打开，还可以配置不同文件的打开方式。
单单下面这一个功能就必须安装了！快捷在不同浏览器打开：

配置设置：

```js
[
    {
        "keys": ["f1"],
        "command": "side_bar_files_open_with",
        "args": {
            "paths": [],
            "application": "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",//你的浏览器路径
            "extensions": ".*" //匹配任何文件类型
        }
    },
    {//firefox
        "keys": ["f2"],
        "command": "side_bar_files_open_with",
        "args": {
            "paths": [],
            "application": "D:\\浏览器\\火狐\\firefox.exe",
            "extensions": ".*"
        }
    },
    { //ie
        "keys": ["f3"],
        "command": "side_bar_files_open_with",
        "args": {
            "paths": [],
            "application": "C:\\Program Files\\Internet Explorer\\iexplore.exe",
            "extensions": ".*"
        }
    }
]
```

- 可选`SyncedSideBar`：每次打开文件，侧边栏都会同步显示该文件所在目录树中的位置




### NO.4 `Doc​Blockr`：代码块注释。

可以快速的对函数进行注释。保持代码规范。支持多种语言。（个人觉得`brackets`的这个插件比`Sublime Text`做得好多了。）

- `/*`:回车创建一个代码块注释
- `/**`:回车在自动查找函数中的形参等等。

它会生成 `JSDoc` 格式的注释。如果你从没有使用过类似的工具，`DocBlockr` 会让你觉得以前没有它是如何写代码的。帮助你创造你的代码注释，通过解析功能，参数，变量，并且自动添加基本项目。

### NO.5 `SublimeLinter-jshint`:语法校验

- 需先安装`SublimeLinter`。
- 需先安装`Node.JS`及`npm`。
- 在cmd输入 `npm install -g jshint`，等待安装成功就好了。


安装成功后，重启就可以测试代码的风格了。
当然还可以自定义校验规则，在该目录下使用`Ctrl+Shift+N`创建文件`.jshintrc`，在其中使用JSON格式配置校验风格。

例如：

```javascript
//建议使用===，不使用时会有提示。
{
  "eqeqeq":true
}
```

并且在左下角会有错误提示。需要注意的是内容有更改时，才会立即生效。
详细自定义规则：[自定义Hint校验](http://jshint.com/docs/options/)


### NO.6 `Git` :版本控制

可视化的操作：帮助你与你的Git repo协议进行交互。它支持很多命令像`init`,` push`, `pull`, `branch`, `stash`,等等。了解更多关于你在`Sublime Text`里面究竟能使用哪些Git功能，以提高您的工作流程。
[使用参考](https://scotch.io/tutorials/using-git-inside-of-sublime-text-to-improve-workflow)

- `GitGutter`:
Sublime Text 有了 Git 插件之后，GitGutter 更好的帮助开发者查看文件之前的改动和差异，提升开发效率。（其实我是冲着这个来的）


### NO.7 `Emmet`：不解释。

中文文档：[地址](https://yanxyz.github.io/emmet-docs/css-abbreviations/vendor-prefixes/)

[前端开发必备！Emmet使用手册](http://www.w3cplus.com/tools/emmet-cheat-sheet.html)

### ~~NO.8 `JsFormat`：代码格式化~~ 使用 **HTML-CSS-JS Prettify**，下面介绍：

- JsFormat 基于 `JS Beautifier`，可以帮助你自动格式化` JavaScript `和 JSON。这对于阅读代码是非常有用的。
- 快捷键：`Ctrl + Alt + f` 或者，你也可以使用菜单栏。
- 可定制喜欢的格式：在 SublimeText 3 中 Preferences -> Package Settings -> JsFormat -> Settings - Default 可以调整这些配置。


### NO.9 `jQuery`：jQuery的API代码片段

我知道目前在很多地方 `jQuery `看似已经落伍了，但是如果你不是建立一个交互性很强的网站或者你只是想在已有应用上添加功能，它仍然是非常有用的。

比如，输入` $.a`就可以让我选择`$.ajax()`，然后自动扩展成以下代码：
```javascript
$.ajax({
  url: '/path/to/file',
  type: 'default GET (Other values: POST)',
  dataType: 'default: Intelligent Guess (Other values: xml, json, script, or html)',
  data: {param1: 'value1'},
})
.done(function() {
  console.log("success");
})
.fail(function() {
  console.log("error");
})
.always(function() {
  console.log("complete");
});
```

### NO.10 `BracketHighlighter`:符号高亮
该插件提供行数列高亮的各种配对的语法符号，显示在行号上。效果如下：

![BracketHighlighter](https://ws1.sinaimg.cn/large/82d12951gy1fewiqkjlk4j20dy09hdga.jpg)

配置方法参考[sublime text3下BracketHighlighter的配置方法](http://www.cnblogs.com/liu-l/p/3866458.html)

### NO.11 `JavaScript Next`：完美支持ECMAScript 6

- JavaScript Next 提供了比默认JavaScript Package更好的语法高亮，而且他完美支持ECMAScript 6。
- 建议**完全使用** JavaScript Next代替JavaScript Package。


### NO.12 `CSS3`:CSS3语法高亮

- 默认安装的Sublime Text对CSS3的支持让人抓狂，帧动画？别开玩笑了你只会看到一片白色的纯文本一样的代码。
- 事实上不光CSS3，我建议用CSS3 Package完全替代原来的CSS Package来完成语法高亮。把原来的禁用了吧


### NO.13 `Color Highlighter` ：CSS颜色高亮

- 这个插件我等了很久了（在使用breakets的时候发现 的，好用到爆），我最早用Sublime Text写CSS时候就在想“这堆颜色码谁知道是什么颜色”。。
- 还是brackets的牛逼
- Color Highlighter这个插件会检测CSS文件中的颜色码，不论是Hex码或者RGB码都能很好的显示。
- Color Highlighter能够设置成用背景色或者边框提示颜色，我一般在Settings里做这样的设置：


```javascript
{
  "ha_style": "filled",
  "icons": false
}
```

效果如下：


![Color Highlighter](https://ws1.sinaimg.cn/large/82d12951gy1fewiqkkc1ij20bj049aaw.jpg)

### NO.14`Colorpicker`：使用一个取色器改变颜色

使用方法: `ctrl + shift + c`，快捷键有冲突，需修改。可以通过`ctrl+shift+p`：搜索`Colorpicker`调用

![Colorpicker](https://ws1.sinaimg.cn/large/82d12951gy1fewiqkqweij20ht0aywf1.jpg)


### NO.15 `Markdown Editing` 和 `Markdown Preview`，实现预览MD

- 当在 Sublime Text 中编写 markdown 文件时，在浏览器中打开全是乱码，因为还没有将 markdown 文件解析成相应的 HTML.
- 这两个插件的功能就是可以用浏览器浏览 Sublime Text 中编写的 markdown文件。
- 配置：

打开 Preferences->Package Settings->Markdown Preview->Setting User 将下面这句话粘贴进去。

```javascript
{
    // "浏览markdown的浏览器的路径"
    "browser" : "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
}
//打开Preferences->Key Binding User，添加下面一句话。
{
    "keys": ["f6"], "command": "markdown_preview", "args": {"target": "browser", "parser":"markdown"}
},
//keys的值是以上面浏览器预览markdown文件。
```

直接按`F6`就可以打开浏览器预览`markdown`，并且它们的安装还会让编写`markdown`时支持一些快捷键。

不进行这些配置的话，因为我们在前面 **构建系统** 使用了一些操作，按`ctrl+b`,就会在当前文件目录下，创建一个同名的`html`文件。

选中该`htnl`文件，再次按`ctrl+b`可以达到同样的预览效果，不过还是F6简单不是吗？

**2016-04-06 更新**

我知道你们都忍不了那默认的白色背景，丑爆了好吗？ 现在我们找到
`preference`-->`package Settings`-->`MarkdownEditing`-->`Markdown GFM Settings-users`，把下面这个复制进去：

```js
{
    "color_scheme": "Packages/Material Theme/schemes/Material-Theme-Darker.tmTheme",
}
```
然后你就会发现世界又回到了春天-。-（这里使用的我上面介绍的`Material`）,更多的设置就举一反三啦！

### NO.16 `AutoFileName`：文件路径自动提示

这个直接安装就可以用了，挺方便的。


### NO.17 `Terminal`：在Sublime Text直接打开命令行

**2016-04-06 更新**

默认快捷键 `Ctrl+Shift+T`。

在`windows`下默认会打开`Windows PowerShell`，那界面简直丑到不行好吗！！

根据上面的经验同样找到`preference`-->`package Settings`-->`Terminal`-->`Terminal Settings-users`：进行下面的设置：

```javascript
{
    "terminal": "C:\\WINDOWS\\system32\\cmd.exe",
    //"terminal": "C:\\Program Files\\cmder\\Cmder.exe",
    "parameters": ["/START", "%CWD%"]
}
```

然后人生就焕发了第二春 -。-（强烈建议大家去搜索使用被我注释掉的**`Cmder`**，这才是一个`shell`的样子嘛！）

### NO.18 `CSScomb` : CSS属性排序

- 使用参考:[点击查看](http://yunkus.com/article/ziyuan/331.html)
- [CSS属性排序 CSScomb 插件配置参数大全](http://yunkus.com/article/ziyuan/333.html)

### NO.19 `JavaScript Completions`和`Java​Script & Node​JS Snippets`。输入提示，代码补全

- 看个人喜好咯，不用代码补全，可以锻炼英语！！

### NO.20 `SyncedSidebarBg`:自动同步侧边栏底色为编辑窗口底色。

有人反映说安装主题后侧边栏颜色不更改，其实有两个方法，一个在`\Data\Packages\主题`修改主题配置。

比较麻烦，就不说了，直接安装这个插件就好了，记得重启刷新。

**2016-04-06 更新**

### NO.21 `HTML-CSS-JS Prettify`: HTML-CSS-JavaScript 代码格式化

其实有了这个代码格式化插件，就可以删除上面的代码格式化插件了。因为功能确实强大！

- [官网插件配置](https://packagecontrol.io/packages/HTML-CSS-JS%20Prettify)
- [FED社区：sublime text 3 插件：HTML-CSS-JS Prettify](http://frontenddev.org/article/sublime-does-text-three-plug-ins-html-and-css-js-prettify.html)

其实我把官网的配置趴下来之后就改了两个地方：

- `"selector_separator_newline": false`： 不需要每个CSS选择器单独占一行
- `"allowed_file_extensions": ["..这是老的，新增在-->","vue"],`：将`vue`的组件当成`html`来进行格式化
- 默认快捷键：`Ctrl+Shift+H`

更多的个性化定制大家自己去实现吧！

### NO.22 `better-completions`: 涵盖了`html`, `jquery`，`javascript`，`Bootstrap`的代码片段。

- [官网详细配置](https://packagecontrol.io/packages/Better%20Completion);

官网介绍的很详细。
这个插件要是包含的类型多，当然在每一种语言上的匹配肯定是不如上面介绍。不过为了少按几个插件，还是用了它，把上面的几个代码片段插件删了。
不过它也是支持加载自定义代码片段的，如果有需要的话，那就自己编写吧^_^。

### NO.23 `liveReload`：文件保存浏览器即时刷新！
> 该插件在window下，有很多问题会导致不能使用，mac下可以正常使用

- 需安装对应的chrome插件：[chrome商店下载](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)，完成后需勾选允许访问文件网址
- 为了避免每一次启动实时刷新在sulime里面启动一遍插件，可在插件设置中增加如下字段：

```javascript
{
    "enabled_plugins": [
        "SimpleReloadPlugin",
        "SimpleRefresh"
    ]
}
```
这时就只需要在浏览器端点一下小圆圈就好了


### 其他：

- `SideBar Folders`：更好的管理侧边栏文件夹
- `IMESupport` ：输入法不跟随时安装
- `FileHeader` ：自动更新保存时间，文件模板
- `Quote​HTML` ：把HTML拼接成js插入字符串，字符串拼接的痛
- `CSS Format` ：CSS格式化
- `AutoPrefixer` ：浏览器私有属性前缀补全 (Node.js依赖)
- `ConvertToUTF8`：GBK编码兼容
- `Vue Syntax Highlight`：`vue`文件的语法高亮
- `WakaTime`：记录你的编程时间
- `rem-unit`：px单位自动转rem，移动端开发必备



> 参考如下：
- 慕课网视频：[前端开发工具技巧介绍—Sublime篇](http://www.imooc.com/learn/40)
- 慕课网视频：[快乐的sublime编辑器](http://www.imooc.com/learn/333)
- Sublime Text手冊：[点击查看](http://docs.sublimetext.tw/)
- Github资源合集[jikeytang/sublime-text](https://github.com/jikeytang/sublime-text)
- 知乎Sublime Text专题[点击查看](https://www.zhihu.com/topic/19668076)
