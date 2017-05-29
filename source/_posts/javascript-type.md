title: JavaScript类型识别
date: 2015-11-30 19:50:30
tags: [JS]
categories: [前端技术]
---

## 类型系统

关于 JS 类型的几点说明
- JavaScript 是动态类型 ＋ 弱类型的语言
- JavaScript 的变量。属性在运行期决定类型
- JavaScript 存在隐式类型转换
- JavaScript 有一系列识别类型的反射方法

> javascript 类型系统可以分为标准类型和对象类型，进一步标准类型又可以分为原始类型和引用类型，而对象类型又可以分为内置对象类型、普通对象类型、自定义对象类型。

![JS数据类型](https://ws1.sinaimg.cn/large/82d12951gy1feuqvmu3hgj20ie0dw75f.jpg).

### 类型转化表

|Value|Boolean|Number|String|
|-----|-------|------|------|
|undefined|false|NaN|"undefined"|
|null|false|0|"null"|
|true|true|1|"true"|
|false|false|0|"false"|
|""|false|0|""|
|'123'|true|123|'123'|
|'1a'|true|NaN|'1a'|
|0|false|0|"0"|
|1|true|1|"1"|
|Infinity|true|Infinity|"Infinity"|
|NaN|false|NaN|'NaN'|
|{}|true|NaN|"[object Object]"|

## 类型判断

* `typeof`
* `Object.prototype.toString`
* `constructor`
* `instanceof`

### `typeof`
1. 可以识别标准类型(`null`除外)
2. 不可识别具体的对象类型(`Function`除外)

例:

```javascript
//1. 可以识别标准类型(`null`除外)
typeof(1);//"number"
typeof("");//"string"
typeof(undefined);//"undefined"
typeof(true);//"boolean"
typeof(null);//"object"

//2. 不可识别具体的对象类型(`Function`除外)
typeof([]);//"object"
typeof({});//"object"
typeof(function(){});//"function"
```

### `instanceof`
1. 能够判别内置对象类型
2. 不能判别原始类型
3. 能够判别自定义类型

例:

```javascript
//1. 能够判别内置对象类型
[] instanceof Array;//true
/\d/ instanceof RegExp;//true

//2. 不能判别原始类型
1 instanceof Number;//false
"xiaohong" instanceof String;//false

//3. 能够判别自定义类型
function Point(x, y) {
	this.x = x;
	this.y = y;
}
var c = new Point(2,3);

c instanceof Point;//true
```

### `Object.prototype.toString.call()`方法
1. 可以识别标准类型,及内置对象类型
2. 不能识别自定义类型

例:
```javascript
//1. 可以识别标准类型,及内置对象类型
Object.prototype.toString.call(21);//"[object Number]"
Object.prototype.toString.call([]);//"[object Array]"
Object.prototype.toString.call(/[A-Z]/);//"[object RegExp]"

//2. 不能识别自定义类型
function Point(x, y) {
	this.x = x;
	this.y = y;
}

var c = new Point(2,3);//c instanceof Point;//true
Object.prototype.toString.call(c);//"[object Object]"
```
- 为了方便使用,使用函数封装如下:
```javascript
function typeProto(obj) {
	return Object.prototype.toString.call(obj).slice(8,-1);
}

typeProto("guo");//"String"
typeProto({});//"Object"
```

### `constructor`

> `constructor`指向构造这个对象的构造函数本身..

1. 可识别原始类型
2. 可识别内置对象类型
3. 可识别自定义类型

例:

```javascript
//1. 可识别原始类型
"guo".constructor === String;//true
(1).constructor === Number;//true
true.constructor === Boolean;//true
({}).constructor === Object;//true

//2. 可识别内置对象类型
new Date().constructor === Date;//true
[].constructor === Array;//true

//3. 可识别自定义类型
function People(x, y) {
	this.x = x;
	this.y = y;
}
var c = new People(2,3);
c.constructor===People;//true
```

- 为了方便使用,使用函数封装如下:


```javascript
function getConstructorName(obj){
	return obj && obj.constructor && obj.constructor.toString().match(/function\s*([^(]*)/)[1];
}

getConstructorName(new Date());//"Date"
getConstructorName(null);//null
getConstructorName(12);//"Number"

```

## 类型判断对比表
- 其中红色的单元格表示该判断方式不支持的类型。

![类型判断对比表](https://ws1.sinaimg.cn/large/82d12951gy1feuqvmmxcpj20z80mkwkg.jpg)
