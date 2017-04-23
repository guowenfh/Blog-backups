title: node 文件系统
date: 2016-10-15 12:12:48
tags: [nodejs]
categories: [node]
---

> 该模块是核心模块，需要使用 require 导入后使用

### 底层方法

1. `fs.open(path, flags, [mode], callback)`:异步版的文件读取
    - `path`: 要打开的文件的路径
    - `flags`: 打开文件的方式 读/写，12种不同方式？
    - `mode`: 设置文件的模式 前提是这个文件是已存在的，读/写/执行  4/2/1
    - `callback`: 回调
        - `err` : 文件打开失败的错误保存在err里面，如果成功err为null
        - `fd` : 被打开文件的标识，和定时器
2. `fs.openSync(path, flags, [mode])`:fs.open() 的同步版，返回值为 `fd`
3. `fs.read(fd, buffer, offset, length, position, callback)`:从指定的文档标识符 `fd` 读取文件数据。
    - `fd`: 通过open方法成功打开一个文件返回的编号
    - `buffer`: buffer对象, 缓冲区，数据将会写入这里。
    - `offset`: 新的内容添加到buffer中的起始位置,向缓冲区 buffer 写入的偏移量。
    - `length`： 添加到buffer中内容的长度
    - `position`：读取的文件中的起始位置,为null，将会从文件当前的位置读取数据。
    - `callback`: 回调
        - `err`:错误
        - `bytesRead`:buffer的长度，读取的字节
        - `buffer`: buffer对象
4. `fs.readSync(fd, buffer, offset, length, position)`:fs.read()的同步版，返回 `bytesRead`
5. `fs.write(fd, buffer, offset, length[, position], callback)`:通过文件标识fd，向指定的文件中写入buffer通过文件标识fd，向指定的文件中写入buffer.
    /`fs.write(fd, data[, position[, encoding]], callback)`:通过指定的fd把data写入到文档中.
    - `fd`: 打开的文件标识
    - `buffer` : 要写入的数据
    - `offset` : buffer对象中要写入的数据的起始位置
    - `length` : 要写入的buffer数据的长度
    - `data`: 如果data不是buffer对象的实例则会把值强制转化成一个字符串。
    - `position`: 是参考当前文档光标的位置，然后从该处写入数据。
    - `encoding`: 是预期得到一个字符串编码
    - `callback`:回调函数 (err, written, string)
6. `fs.writeSync(fd, buffer, offset, length[, position])`/`fs.writeSync(fd, data[, position[, encoding]])`
7. `fs.close(fd, callback)`:关闭一个打开的文件
8. `fs.closeSync(fd)`: fs.close() 的同步版本

### 更易用的方法

1. `fs.writeFlie(filename, data, [options], callback)`:
异步的将数据写入一个文件,如果文件不存在则新建, 如果文件原先存在，会被替换。
    - `filename` : 文件路径，
    - `data` : data 可以是一个string，也可以是一个原生buffer。
    - `options` : 选项
        - `encoding` :文件编码default = 'utf8'
        - `mode` : default = 438 (aka 0666 in Octal)
        - `flag` : default = 'a'
    - `callback` : 回调函数
2. `fs.writeFileSync(filename, data, [options])`：fs.writeFile的同步版本。
3. `fs.appendFile(filename, data, [options], callback)`：异步的将数据添加到一个文件的尾部，如果文件不存在，会创建一个新的文件。
    - `filename` : 文件路径，
    - `data` : data 可以是一个string，也可以是一个原生buffer。
    - `options` : 选项
        - `encoding` :文件编码default = 'utf8'
        - `mode` : default = 438 (aka 0666 in Octal)
        - `flag` : default = 'a'
    - `callback` : 回调函数
4. `fs.appendFileSync(filename, data, [options])`:fs.appendFile的同步版本。
5. `fs.exists(path, callback)`:检查指定路径的文件或者目录是否存在。
    - `path`:路径
    - `callback`: callback 传入的参数指明存在 (true) 或者不存在 (false).
6. `fs.existsSync(path)`:fs.exists 函数的同步版。
7. `fs.readFile(filename, [options], callback)`:异步读取一个文件的全部内容
    - `filename`:文件路径
    - `options`:
        - `encoding`:  default = null,如果未指定编码方式，原生buffer就会被返回。
        - `flag`: default = 'r'
    - `callback` :(err, data), data 就是文件的内容
8. `fs.readFileSync(filename, [options])`:fs.readFile的同步版本。 返回文件名为 filename 的文件内容。
9. `fs.unlink(path, callback)`:删除一个文件,回调函数（callback）只接受一个参数：可能出现的异常信息.
10. `fs.unlinkSync(path):fs.unlink()`: 的同步版本
11. `fs.rename(oldPath, newPath, callback)`:异步版本的重命名函数.完成时的回调函数(callback)只接受一个参数:可能出现的异常信息.
12. `fs.renameSync(oldPath, newPath)`:fs.rename() 的同步版本
13. `fs.stat(path, callback)`:读取文件的状态信息,callback,接收两个参数： (err, stats) ，其中 stats 是一个 fs.Stats 对象。
14. `fs.statSync(path, callback)`:fs.stat() 的同步版本,返回一个 fs.Stats 实例。
15. `fs.watch(filename, [options], [callback])`:观察指定路径的改变，filename 路径可以是文件或者目录。
    回调函数得到两个参数 (event, filename)。其中 event 是 'rename'（重命名）或者 'change'（改变），而 filename 则是触发事件的文件名。

### 文件夹处理

1. `fs.mkdir(path, [mode], callback)` :创建文件夹，回调函数只接受一个参数：可能出现的异常信息。－－－》`fs.mkdirSync(path, [mode])`同步版
2. `fs.rmkdir(path, callback)`:删除文件夹，回调函数只接受一个参数：可能出现的异常信息。－－－》`fs.rmdirSync(path)`同步版
3. `fs.readdir(path, callback)`:读取 path 路径所在文件夹的内容。
    回调函数 (callback) 接受两个参数 (err, files) 其中 files 是一个存储目录中所包含的文件名称的数组，数组中不包括 '.' 和 '..'
4. `fs.readdirSync(path)`:同步版的 readdir(). 返回文件名数组，其中不包括 '.' 和 '..' 目录.

这是对于 node 的文件系统 的学习，仅仅过了一遍api，了解了一下处理流程，理解有限，如果有错误之处，请指出，谢谢！

本文地址：[//guowenfh.github.io/2016/10/15/node-file-system/](//guowenfh.github.io/2016/10/15/node-file-system/)
