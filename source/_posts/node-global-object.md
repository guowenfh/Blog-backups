title: process 对象与 Buffer 类
date: 2016-10-15 11:40:29
tags: [nodejs]
categories: [node]
---

>在上一篇博客中，我们一起对于 node 的模块机制有了一点点的了解，当时我们就知道了在 node 中的全局对象是 `global` 而不是浏览器中的 `window` 它们有一部分属性方法是相同的，
比如：`clearInterval` / `clearTimeout` / `setInterval` / `setTimeout` / `console`。他们的用法和在浏览器中的用法是一样的，接下来我们就来看看那些在 node 中所特有全局属性和方法。

我们先来稍微跑个题，看看与上一个篇博客的中介绍的 模块系统相关 的两个属性，还是可以模块的路径有关：

- `__filename` : 返回 **当前模块文件**解析后的绝对路径
- `__dirname` : 返回 **当前模块文件所在目录** 解析后的绝对路径

**注意：它们可以直接使用，但是实际上并非全局的，而是在模块作用域下的**

直接在文件内输入，运行即可输出：
```js
console.log(__filename);
console.log(__dirname);
```

## `process` 对象

### `process` 对象的属性和方法

process对象是一个全局对象，可以在任何地方都能访问到他，通过这个对象提供的属性和方法，使我们可以对当前运行的程序的进程进行访问和控制

- `process.argv` :一个包含命令行参数的数组。第一个元素会是 'node'， 第二个元素将是 .Js 文件的名称。接下来的元素依次是命令行传入的参数。
- `process.execPath` : 开启当前进程的绝对路径
- `process.env`  : 返回用户环境信息的对象
- `process.version`  : 返回node版本信息
- `process.versions`  : 返回node以及node依赖包版本信息
- `process.pid`  : 当前进程的pid
- `process.title`  : 当前进程的显示名称(Getter/Setter)
- `process.arch`  : 返回当前CPU处理器架构 arm/ia32/x64
- `process.platform`  : 返回当前操作系统平台
- `process.cwd()` :  返回当前进程的工作目录
- `process.chdir(directory)` :  改变进程的当前进程的工作目录，若操作失败则抛出异常。
- `process.memoryUsage()` : 返回node进程的内存使用情况，单位是byte
- `process.exit(code)` : 退出
- `process.kill(pid)` :  向进程发送信息
- 标准输入/输出流（IO）：stdin 和stdout提供了操作输入数据和输出数据的方法，我们也通常称为IO操作
    - `stdin`：标准输入http://baike.baidu.com/view/632680.htm
    - `stdout`标准输出http://baike.baidu.com/view/632676.htm

这里主要是对于标准输入/输出流（IO）的理解，放上一个中文维基百科的解释：[标准输入/输出流](https://zh.wikipedia.org/wiki/%E6%A8%99%E6%BA%96%E4%B8%B2%E6%B5%81)，在这里关于 `stdout`就简单举例 `console.log`实现：
```js
console.log = function(d) {
  process.stdout.write(d + '\n');
};
```

再看一个`stdin`的简单示例：

```js
process.stdout.write('请输入内容：');
//默认情况下，输入流是关闭的，要监听处理输入流数据，首先要开启输入流
process.stdin.resume();
//用于监听用户的输入数据12
process.stdin.on('data', function(chunk) {
     console.log('用户输入了：' + chunk);
});
```
在 `shell` 执行该文件后，输入内容并回车，会把你输入的内容打印出来


## Buffer 类

什么 buffer 类？

> Buffer 类是一个全局变量类型，用于操作二进制数据流的类。我们在操作文件或者网络数据的时候，其实操作的就是二进制数据流，Buffer 类就是 Node 为了我们更好的操 作二进制数据而创建的类

- `new Buffer(size)`: Number 类型 配一个新的 buffer 大小是 `size` 的8位字节.
- `new Buffer(array)`: Array 类型分配一个新的 buffer 使用一个8位字节 `array` 数组.
- `new Buffer(str, [encoding])`:分配一个新的 buffer ，其中包含着给定的 `str` 字符串. `encoding` 编码方式默认是：`'utf8'`.
    - `str` : String类型 - 需要存入buffer的string字符串.
    - `encoding` : String类型 - 使用什么编码方式，参数可选.
    
### Buffer 方法学习

1. `buf.length`:这个buffer的bytes大小。注意这未必是这buffer里面内容的大小。length 的依据是buffer对象所分配的内存数值，它不会随着这个buffer对象内容的改变而改变。
2. `buf.write(string, [offset], [length], [encoding])` : 根据参数 offset 偏移量和指定的encoding编码方式，length 长度是将要写入的字符串的bytes大小，将参数 string 数据写入buffer。
    - `string` : String类型 - 将要被写入 buffer 的数据
    - `offset` : Number类型, 可选参数, 默认: 0
    - `length` : Number类型, 可选参数, 默认: buffer.length - offset
    - `encoding` : String类型, 可选参数, 默认: 'utf8'
    
```js
var str = 'buffer';
console.log(new Buffer(str));
var buf = new Buffer(6);
buf.write(str,1,3);
console.log(buf);
// <Buffer 62 75 66 66 65 72>
// <Buffer 62 62 75 66 01 00>
```
这里我们指定了 offset 和 length ，分别为1和3，所以可以看到两次在输出时，62，75，66，这部分是相同的，并且第二次输出它的位置偏移了1个位置。

3. `buf.toString([encoding], [start], [end])`：根据 encoding参数（默认是'utf8'）返回一个解码的 string 类型。还会根据传入的参数 start (默认是0)和 end (默认是 buffer.length)作为取值范围。
    - `encoding`: String类型, 可选参数, 默认: 'utf8'
    - `start`: Number类型, 可选参数, 默认: 0
    - `end`: Number类型, 可选参数, 默认: buffer.length


```js
var str1 = 'buffer';
var bf1  = new Buffer(str1);
console.log(bf1.toString());
console.log(bf1.toString('utf8',1,4));

var str2 = '二进制';
var bf2  = new Buffer(str2);
console.log(bf2);
console.log(bf2.toString('utf8',1));

// buffer
// uff
// <Buffer e4 ba 8c e8 bf 9b e5 88 b6>
// ��进制
```
在这里通过例子和输出，就可以发现 `toString()` 方法看到在截取时 **取左不取右**，所以第一例子输出了 `uff`，
第二例子则可以说明，中文使用3个字节来存储，所以在偏移量为一时读取到的 `ba 8c`被输出为乱码，当偏移量为3时，正常。

4. `buf.toJSON()`：返回一个 JSON表示的Buffer实例。JSON.stringify 将会默认调用来字符串序列化这个Buffer实例。如：`{ type: 'Buffer', data: [ 98, 117, 102, 102, 101, 114 ] }`
5. `buf.slice([start], [end])`:返回一个新的buffer，这个 buffer 将会和老的 buffer 引用相同的内存地址，只是偏移和裁剪了索引，方法类似于数组。 负的索引是从 buffer 尾部开始计算的。
6. `buf.copy(targetBuffer, [targetStart], [sourceStart], [sourceEnd])`:进行 buffer 的拷贝，源和目标可以是重叠的。 targetStart 目标开始偏移 和sourceStart源开始偏移 默认都是 0. sourceEnd 源结束位置偏移默认是源的长度  buffer.length.
如果传递的值是undefined/NaN 或者是 out of bounds 超越边界的，就将设置为他们的默认值。（译者：这个默认值下面有的例子有说明）
    - `targetBuffer`: Buffer 类型对象 - 将要进行拷贝的Buffer
    - `targetStart`: Number类型, 可选参数, 默认: 0
    - `sourceStart`: Number类型, 可选参数, 默认: 0
    - `sourceEnd`: Number类型, 可选参数, 默认: buffer.length
    
### 类/静态方法

1. `Buffer.isEncoding(encoding)`:用来测试给定的编码字符串,如果给定的编码 encoding 是有效的，返回 true，否则返回 false :`Buffer.isEncoding('utf8')`
2. `Buffer.isBuffer(obj)`:测试这个 obj 是否是一个 Buffer.
3. `Buffer.byteLength(string, [encoding])`:将会返回这个字符串真实 byte 长度。 encoding 编码默认是： 'utf8'. 这个和 String.prototype.length 是不一样的，因为那个方法返回这个字符串中有几个字符的数量。
4. `Buffer.concat(list, [totalLength])`: 返回一个保存着将传入 buffer 数组中所有 buffer 对象拼接在一起的 buffer 对象。其实就是将数组中所有的 buffer 实例通过复制拼接在一起
    - `list `: {Array}数组类型，Buffer 数组，用于被连接。
    - `totalLength `: {Number}类型 上述 Buffer 数组的所有Buffer的总大小。（数组里 Buffer 实例的大小总和）
    
这里我们再回头来看看，在上半部分中的介绍`process` 对象，说的标准输入输出流的时候，我们有这样一个例子：

```js
process.stdout.write('请输入内容：');
//默认情况下，输入流是关闭的，要监听处理输入流数据，首先要开启输入流
process.stdin.resume();
//用于监听用户的输入数据12
process.stdin.on('data', function(chunk) {
     console.log('用户输入了：' + chunk);
});
```

我们运行这一段代码，在命令行中输入：process，可以看到有下面这样的结果：
```
请输入内容：process
用户输入了：process
```

在这里看来，我们接收到的用户输入 `chunk` ，就是一个字符串，实际上它是一个buffer对象，我们重写 `porcess.stdin` 方法，
```js
process.stdin.on('data', function(chunk) {
     console.log(chunk);
});
```
输入同样的内容打印出来的是 `<Buffer 70 72 6f 63 65 73 73 0a>` ,可以知道在标准输入输出流中，实际上也是进行二进制的数据传输。
在第一个示例中 `console.log('用户输入了：' + chunk);` 因为 `chunk`与字符串相链接，所以 它实际上自动调用了 `toString()` 方法。

这是对于 process 对象与 Buffer 类的简单学习，理解较为粗浅，如有错误之处请指出，谢谢！

本文地址:[https://guowenfh.github.io/2016/10/15/node-global-object/](https://guowenfh.github.io/2016/10/15/node-global-object/)
