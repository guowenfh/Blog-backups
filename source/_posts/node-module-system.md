title: Node.js 模块系统
date: 2016-10-15 11:18:41
tags: [nodejs]
categories: [node]
---

> 什么是模块?

- 在 node 中，文件和模块是一一对应的，也就是一个文件就是一个模块
- 每个模块都有自己的作用域
- 我们使用 var 来申明的一个变量，他并不是全局的，而是属于当前模块下

## 模块的加载与使用

### 模块的引入

在 node 中,我们使用 `require('模块')` 的形式将一个模块引入到我们的当前的文件中来。关于 `require` 路径的写法也有如下几种:

- 模块路径可以是一个以 `/` 开头，表示一个 **绝对路径**
- 模块路径以 `./` 开头，表示当前目录出发的 **相对路径**
- 模块路径如果没有以 `/` 或者 `./` 开头，那么这个模块要么是 **核心模块** 要么是通过 **npm** 安装在 node_modules 文件夹下的。

看到上面的不同路径写法, 我们就想起来在 web 中引入当前文件夹中的文件时是不需要加上`./`的, 但在 node 中使用 `./` 或 `/` 开头的路径和不使用时,有着很大的差别。

### 模块的加载机制

1. 首先按照加载的模块的文件名称进行查找
2. 如果没有找到，则会在模块文件名称后加上 `.js` 的后缀，进行查找
3. 如果还没有找到，则会在文件名称后加上 `.json` 的后缀，进行查找
4. 如果还没有，则会在文件名称后加上 `.node` 的后缀，进行查找
5. 最终未找到，抛出异常

### 模块数据的使用

与浏览器中不同 , 在 node 中，每一个模块都有自己的作用域，在模块中使用 var 申明的变量的作用域范围是在该模块内，而不是 node 全局的。
但是你忘记了使用 var 进行变量声明,恭喜你这时和浏览器中忘记使用的效果是一致的。该变量也将挂在全局对象上。
只不过在 `node`中，全局对象是`global`，而不是浏览器中的`window`

下面看一个简单的例子:

我们从两个文件 `a.js` 和 `b.js` 就可以简单的看到 node 的声明变量的作用域。

a.js:
```js
var a = '这是a声明的变量';
console.log('这是a.js模块');
```
b.js:
```js
require('./2.js');
console.log('bbbb');
console.log(a);
console.log(global.a);
```
`node b.js` 输出结果:
```js
这是2.js模块
bbbb
console.log(a); //ReferenceError: a is not defined
```
至于去掉 var 之后会是怎么样,大家自己试试吧 ^ ^

## 暴露模块API
> module、module.exports、exports

如同上面代码中所展示的，在 nodejs 中不能直接去拿到另一个模块中的变量函数等等。要让模块暴露一个API成为 `require`调用的返回值，我们就需要通过 `module.exports` 或者 `exports` 对外提供模块内部变量的访问。

默认情况下，每个模块都会暴露处一个空对象，如果你想要在该对象上添加属性，那么简单的使用 `exports` 即可。

看这个例子：

module_a.js:
```js
console.log(exports === module.exports)
exports.name = 'module_a.js'
exports.data = 'this is module_a.js data'
exports.getDate = function() {
    return new Date();
}
```

module_b.js:
```js
var a = require('./module_a.js')
console.log(a.name)
console.log(a.data)
console.log(a.getDate())
```

`node module_b.js`输出:
```sh
true
module_a.js
this is module_a.js data
Thu Sep 22 2016 22:23:59 GMT+0800 (CST)
```
可以看到这里实际上在模块内部 `exports` 就是对于`module.exports`的引用，并且在使用`require`引入模块之后，a 是一个对象。可见外部模块通过 `require(模块)` 方法加载模块，该函数返回的就是被加载模块的 `module.exports` 对象

如果这样在 `module.exports` 对象上一个一个添加属性还满足不了你的需求，你还可以将 `module.exports` 彻底重写。我们将上面的两个文件改写：

module_a.js:
```js
module.exports = function(text) {
    console.log('printf: ' + text);
}
```

module_b.js:
```js
var a = require('./module_a.js')
a('ok');
```
`node module_b.js`输出:`printf: ok`

这样有一个需要注意的地方是：直接覆盖 `exports` 或者 `module.exports`让模块导出一个值，这样做会破坏 `exports` 和  `module.exports` 的引用关系。

这是对于 node 的模块系统的学习，理解有限，如果有错误之处，请指出，谢谢！

本文地址：[//guowenfh.github.io/2016/10/15/node-module-system/](//guowenfh.github.io/2016/10/15/node-module-system/)
