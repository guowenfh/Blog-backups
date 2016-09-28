title: eslint 使用实践
date: 2016-09-29 00:32:14
tags: [js,代码风格]
categories: [前端技术]
---
 
本文地址：[http://guowenfh.github.io/2016/08/07/eslint-config-npmbace/](http://guowenfh.github.io/2016/09/29/eslint-config-npmbace/)

> 在上一篇博客[详解 ESLint 规则，规范你的代码](http://guowenfh.github.io/2016/08/07/ESLint-Rules/)中，经过对于 ESLint 规则的学习，当时就决定一定要将 ESLint 使用起来，进行语法校验，来减少我们在程序中可能出现的错误。
但在当时，我们仅仅是把 eslint 的规则过了一遍，并没有把 eslint 的使用过程描述出来，而且要真正的在实际中使用，以及想要在团队中推广开来，需要有一个渐渐的过程，所以反响平平，这篇博客十一个补充，我把一些常见的错误和最佳实践集合到了一起（最最基础的）。为了方便大家使用，还将配置作为一个 npm包 来方便大家使用～顺便也学了一下怎怎么发布
 
### 发布一个 eslint 规则的 npm 包 

1.确保本地已经安装node和npm 

2.申请npm帐号，直接上官网注册一下就好，在输入下面的命令添加把帐号加到本地之前之前，确保你npm的源地址是官方的地址（我把源切成了淘宝结果在发布包的时候发布不了）

```sh
npm adduser   

Username: your name
Password: your password
Email: yourmail@gmail.com
```

3.建立一个存放规则的文件夹，例如我使用的： `eslint-config-3introspection`（npm包的名称只能小写）
按照正常的流程`npm init`初始化项目，我们把规则存在在一个 `eslintrc.js`的文件夹中， 因为我们现在的规则实在是太简单，而且也没考虑要真的做为一个开源的项目来维护，我们在index.js只需要写下一句话`module.exports = require('./eslintrc');`，我们的`package.json`除了name，之外也没做什么修改。。。

（**关于`package.json`的编写，以及一个最基本的npm包的模样长什么样，我这里不说了，网上很多，也比较简单**）

准备工作都做好了就是发布了，很简单的一个命令：出现错误请自行网上查找把。。。

```
npm publish 
```

### 下面简单的说一下使用：

#### 第一步：npm 全局安装 `eslint` 和 `eslint-config-3introspection`

如果你还没全局安装eslint的话，先执行下面的命令全局安装eslint， 如果已经安装了请看下一条

```sh
sudo npm install eslint -g
```

在全局安装定制的 eslint 包

```sh
sudo npm install eslint-config-3introspection -g
```

成功效果如下：
![](http://ww4.sinaimg.cn/large/801b780agw1f89ptaxh5wj20he035aaj.jpg)

依赖信息的错误不用去管，我们只是需要其中的配置文件而已。

（windows的用户有可能出现无法引入eslint无法引用到全局模块的问题，请将 `eslint-config-3introspection`，安装在你的工作区目录，以便不同项目都可以引用到）

#### 第二部：在项目的 **根目录**下 新建一个 `.eslintrc` 文件

在文件内部添加下面这样的字段

```js
{
    "extends": "3introspection"
}
```

这样就将我们定制的规则导入到项目中了。

#### 第三步：检查编辑器是否已经安装 eslint 插件

下面是sublimeText的：

打开`command+shift+p`，打开命令窗口，输入 `pcl` ，回车

![pcl](http://ww1.sinaimg.cn/large/006y8mN6gw1f7aipmz6m4j30m503k0sx.jpg)

再输入 `sublimeLinter`,查看是否如下，不对的话一一安装这两个插件：

![sublimeLinter](http://ww4.sinaimg.cn/large/006y8mN6gw1f7aiqjjsnyj30kv0bdwfh.jpg)

若上面两步成功，重启编辑器，再打开文件，应该就能看到 eslint 规则已经生效了，如下：

![错误](http://ww3.sinaimg.cn/large/006y8mN6gw1f7aiya10dxj30jt083754.jpg)

这样就可以愉快的使用eslint进行语法校验拉😂😂😂

**失败的情况：** 打开`command+shift+p`，打开命令窗口，输入 `sublimeLinter` 找到这一项，回车后,找到 eslint 开启选项，重启编辑器再查看是不是已经好了。
![sublimeLinter](http://ww1.sinaimg.cn/large/006y8mN6gw1f7aizq6abzj30me0dk75y.jpg)

如果规则不不起效果又不知道是什么地方出了问题，参考附录1

### 附录

附录1：vscode
安装
![](http://ww2.sinaimg.cn/large/006y8mN6gw1f7aj4ppwzej30cp0g6dgm.jpg)
.eslintrc将`{"extends": "3introspection"}`，引入，重启，不起效果的话，vscode会有很明显的报错信息
![](http://ww4.sinaimg.cn/large/801b780agw1f89r0bv5zmj210o027aal.jpg)
还是查找路径的问题，最简单的解决办法，在项目执行一次`npm i eslint-config-3introspection`，把配置按照到node_modul
![](http://ww4.sinaimg.cn/large/801b780agw1f89qt0mzskj20pd06qjs9.jpg)
其他编辑器都类似


附录2：说明

1. 在项目目录中 `.eslintrc` 中的配置，会覆盖引入的配置，有兴趣的可以进行更详细的定制。例如加入以下字段，将项目的全局变量都列在这边。

```js
    // 项目中 定义的全局变量
    "globals": {
        "Tatami": true,
        "$": true
    },
```

2. 在你的 JavaScript 文件中，用注释指定全局变量，格式如下：

```js
/* global var1, var2 */ 
```

3. 可以在你的文件中使用以下格式的块注释来临时禁止规则出现警告：(禁用指定规则，空格后接规则名称，多个名称时逗号隔开)
 
```js
/* eslint-disable */

alert('foo');// eslint-disable-line 当前行上禁用所有规则：

/* eslint-enable */

```

4. 快速查看当前模块所有错误，效果如下：

```
eslint 模块名/文件名
```
5. `.eslintignore`,如同`.gitignore`一样忽略对于某些文件，文件夹的检查

![](http://ww2.sinaimg.cn/large/801b780agw1f89rimlemyj211a03p74v.jpg)


附录3:eslinrc.js 配置
```js
module.exports = {
    // 环境定义了预定义的全局变量。更多在官网查看
    'env': {
        'browser': true,
        'node': true,
        'commonjs': true,
        'amd': true,
    },
    // JavaScript 语言选项
    'parserOptions': {
        // ECMAScript 版本
        'ecmaVersion': 6,
        'sourceType': 'script', // module

    },
    /**
     *  "off" 或 0 - 关闭规则
     *  "warn" 或 1 - 开启规则，使用警告级别的错误：warn (不会导致程序退出),
     *  "error" 或 2 - 开启规则，使用错误级别的错误：error (当被触发的时候，程序会退出)
     */
    'rules': {
        // //////////////
        // 可能的错误 //
        // //////////////
        'no-console': 0,
        // 禁止条件表达式中出现赋值操作符
        'no-cond-assign': 2,
        // 禁止在条件中使用常量表达式
        'no-constant-condition': 2,
        // 禁止 function 定义中出现重名参数
        'no-dupe-args': 2,
        // 禁止对象字面量中出现重复的 key
        'no-dupe-keys': 2,
        // 禁止重复的 case 标签
        'no-duplicate-case': 2,
        // 禁止空语句块
        'no-empty': 1,
        // 禁止在正则表达式中使用空字符集 (/^abc[]/)
        'no-empty-character-class': 2,
        // 禁止对 catch 子句的参数重新赋值
        'no-ex-assign': 2,
        // 禁止不必要的布尔转换
        'no-extra-boolean-cast': 1,
        // 禁止对 function 声明重新赋值
        'no-func-assign': 2,
        //  禁止在嵌套的块中出现 function 或 var 声明
        'no-inner-declarations': [2, 'functions'],
        // 禁止 RegExp 构造函数中无效的正则表达式字符串
        'no-invalid-regexp': 2,
        // 禁止在 in 表达式中出现否定的左操作数
        'no-negated-in-lhs': 2,
        // !!!!!!!!!!!禁止出现令人困惑的多行表达式
        'no-unexpected-multiline': 1,
        // 禁止在return、throw、continue 和 break语句之后出现不可达代码
        'no-unreachable': 1,
        // 要求使用 isNaN() 检查 NaN
        'use-isnan': 2,
        // 强制使用有效的 JSDoc 注释
        'valid-jsdoc': [1, { 'requireReturn': false }],
        // 强制 typeof 表达式与有效的字符串进行比较
        // typeof foo === "undefimed" 错误
        'valid-typeof': 2,

        // ////////////
        // 最佳实践 //
        // ////////////

        // 强制把变量的使用限制在其定义的作用域范围内
        'block-scoped-var': 1,
        // 强制所有控制语句使用一致的括号风格
        'curly': [2, 'all'],
        // switch 语句强制 default 分支，也可添加 // no default 注释取消此次警告
        'default-case': 1,
        // 使用 === 替代 == allow-null允许null和undefined==
        'eqeqeq': [1, 'allow-null'],
        // 不允许在 case 子句中使用词法声明
        'no-case-declarations': 2,
        // 禁止除法操作符显式的出现在正则表达式开始的位置
        'no-div-regex': 2,
        // 禁止在没有类型检查操作符的情况下与 null 进行比较
        'no-eq-null': 1,
        // 禁止扩展原生类型
        'no-extend-native': 2,
        // 禁止不必要的 .bind() 调用
        'no-extra-bind': 1,
        // 禁止数字字面量中使用前导和末尾小数点
        'no-floating-decimal': 2,
        // 禁用不必要的嵌套块
        'no-lone-blocks': 1,
        // 禁止在循环中出现 function 声明和表达式
        'no-loop-func': 1,
        // 禁止对原生对象赋值
        'no-native-reassign': 2,
        // 禁止在非赋值或条件语句中使用 new 操作符
        'no-new': 1,
        // 不允许对 function 的参数进行重新赋值
        'no-param-reassign': [1, { 'props': true }],
        // 禁止使用 var 多次声明同一变量
        'no-redeclare': 2,
        // 禁止自我赋值
        'no-self-assign': 2,
        // 禁止自身比较
        'no-self-compare': 2,
        // 禁用一成不变的循环条件
        'no-unmodified-loop-condition': 2,
        // 禁止不必要的 .call() 和 .apply()
        'no-useless-call': 2,
        // 禁止不必要的字符串字面量或模板字面量的连接
        'no-useless-concat': 2,
        // 强制在parseInt()使用基数参数
        'radix': 1,
        // 要求所有的 var 声明出现在它们所在的作用域顶部
        'vars-on-top': 1,
        // 要求 IIFE 使用括号括起来
        'wrap-iife': [2, 'any'],

        // ////////////
        //  变量声明 //
        // ////////////

        // 禁止删除变量
        'no-delete-var': 2,
        // 禁止 var 声明 与外层作用域的变量同名
        'no-shadow': 1,
        // 禁止覆盖受限制的标识符
        'no-shadow-restricted-names': 2,
        // 禁用未声明的变量，除非它们在 /*global */ 注释中被提到
        'no-undef': 2,
        // 禁止将变量初始化为 undefined
        'no-undef-init': 1,
        // 禁止将 undefined 作为标识符
        'no-undefined': 1,
        // 禁止出现未使用过的变量
        'no-unused-vars': [1, { 'vars': 'all', 'args': 'none' }],
        // 不允许在变量定义之前使用它们
        'no-use-before-define': 2,
    },
};
```

