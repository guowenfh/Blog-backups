title: ES6 简单特性学习记录
date: 2017-03-01 23:26:07
tags: [ES6,JS]
categories: [JS深度学习]
---

## 变量定义的新方式：`let`/ `const`

**`let` 特性：**
1. 不允许重复声明
2. 没有变量提升（预解析）
3. 块级作用域（一对 `{}` 包括的区域称为一个代码块，`let` 声明的变量只在该代码块起作用）

例子1 ：简单的打印数据

使用 `var`:
```js
for(var i = 0; i<10 ; i++ ){
    setTimeout(()=>console.log(i)) // 执行10次，全都打印 10
}
```

使用 `let`:
```js
for(let i = 0; i<10 ; i++ ){
    setTimeout(()=>console.log(i)) // 执行10次，打印 0 - 9
}
```

之前我们要实现这样的打印，必须使用闭包：
```js
for(var i = 0; i<10;i++){
    (function(j){
        setTimeout(()=>console.log(j)) // 执行10次，打印 0 - 9
    })(i)
}
```

例子二：在网页中常常会有切换 tab ，展示对应的信息的需求，我们使用 `var` 来处理时，常常使用的自定义属性，来保存点击的索引。`btns[i].index=i`。用于找到对应的元素。：

html模板：
```html
<style type="text/css">
    div{display:none}
    .show{display:block;}
    .active{background:red;}
</style>
<button class="active">1</button>
<button>2</button>
<button>3</button>
<div class="show">11111</div>
<div >22223</div>
<div >33333</div>
```
js:

```js
var btns = document.querySelectorAll('button')
var divs = document.querySelectorAll('div')
for (var i=0 ;i<btns.length;i++){
    btns[i].index=i
    btns[i].onclick=function(){
        for(var j=0 ;j<btns.length;j++){
            btns[j].className=''
            divs[j].className=''
        }
        this.className='active'
        divs[this.index].className='show'
    }
}
```
使用 `let`：
```js
var btns = document.querySelectorAll('button')
var divs = document.querySelectorAll('div')
for (let i=0 ;i<btns.length;i++){
    /*可以看到这里少了保存的索引的操作*/
    btns[i].onclick=function(){
        for(let j=0 ;j<btns.length;j++){
            btns[j].className=''
            divs[j].className=''
        }
        this.className='active'
        divs[i].className='show'
    }
}
```

**`const`** 除了具备上述 `let` 的特性外，还有自己的一个特性：**定义之后的值，是固定不变不能被修改的**。

值得注意的是下面这两种情况是不会报错的：
```js
{
    const a = {value:1}
    a.value = 2
    console.log(a) // {value:2}

    const b = [1,2,3]
    b.push(4)
    console.log(b) // [1,2,3,4]
}
```

## 解构赋值

ES6 允许按照一定的模式，从数组和对象中提取值，这样就称为解构

数组：按照对应的顺序解构
```js
{
    var arr = [[1,2,3],[4,5,6],[7,8,9]]
    var [a,b,c] = arr
    // a : [1,2,3]
    // b : [4,5,6]
    // c : [7,8,9]
    // 用法1
    var x = 1;
    var y = 2;
    [y,x] = [x,y]
    console.log(x,y) // 2 1
}
```

对象按照对应的名称一一对应进行解析：
```js
{
    var obj={
        get:function(){
            return 'get'
        },
        value:1,
        data:[1,2,3],
        str:'string'
    }
    var {str,get,data} = obj
    console.log(str) // string
    console.log(get()) //get
    console.log(data) // [1,2,3]
}
```

## 模板字符串

模板字符串 是增强版的字符串，使用反引号（`\``）作为标识 。可以当做普通字符串使用，也可以用来定义多行字符串（会保留换行）。或者在字符串中嵌入变量。

在模板字符串，需要引用变量使用 `${变量名}` 的形式。在 `{}`可以进行运算，也可以引用对象属性。
```js
{
    var name = 'xiaoming'
    var age = 19
    var str = `my name is ${name} ,my age is ${age}`
    console.log(str) //"my name is xiaoming ,my age is 19"
}
```

## 扩展

`Array.from(arrayLike[, mapFn[, thisArg]])` 
- `arrayLike` : 想要转换成真实数组的类数组对象或可遍历对象。
- `mapFn` : 可选参数，如果指定了该参数，则最后生成的数组会经过该函数的加工处理后再返回。
- `thisArg` : 可选参数，执行 mapFn 函数时 this 的值。方法用于将两类对象转为真正的数组：类似数组的对象和可遍历的对象（包括 ES6 新增的数据结构 Set 和 Map ）

```js
{
    // NodeList对象
    let ps = document.querySelectorAll('p');
    Array.from(ps);
    // 将可迭代对象（Set 对象）转换成数组
    Array.from(new Set(["foo", window]));       // ["foo", window]
    // 使用 map 函数转换数组元素
    Array.from([1, 2, 3], x => x + x);      // [2, 4, 6]
    // 将类数组对象（arguments）转换成数组
    (function () {
        var args = Array.from(arguments);
        return args;
    })(1, 2, 3);                            // [1, 2, 3]
}
```

而在这之前，我们要转类数组对象，只能用这样的形式: `[].slice.call(ps)`

当然或许你根本不需要转，因为我们有 `for of` 了,只要有遍历接口的类型，它就可以进行遍历
（`Set`,`String`,`Array`,`NodeList`等等）

```js
{    
    // NodeList对象
    let ps = document.querySelectorAll('p');
    for (let v of ps){
        console.log(v)
    }
    //当然你可能同样需要下标： `arr.keys()`,`arr.values()`,`arr.entries()`
    for (let [i,item] of ps.entries()){
        console.log(i,item)
    }
}
```



`Object.assign()`：拷贝源对象自身的可枚举的属性到目标对象身上

```js
{
    var obj = { a: 1 };
    var copy = Object.assign({}, obj);
    console.log(copy); // { a: 1 }
}
```
值得注意的是， `Object.assign()`执行的是浅拷贝。假如源对象的属性值是一个指向对象的引用，它也只拷贝那个引用值。

```js
{
    let a = { b: {c:4} , d: { e: {f:1}} }
    let g = Object.assign({},a)
    g.d.e = 32 // 设置 g.d.e 为 32
    console.log(g) // {"b":{"c":4},"d":{"e":32}}
    console.log(a) // {"b":{"c":4},"d":{"e":32}}
}
```

如果你需要的不是合并，而只是普通`json`对象的复制，建议使用 `JSON.parse(JSON.stringify(a))`，这样不会有上面的副作用产生。

函数参数默认值。**定义默认值得参数必须是尾参数，因为函数形参定义默认值后该参数可以被忽略**

```js
{
    function fn(a,b=2){
        return {a,b}
    }
    console.info(fn(1)) //{a: 1, b: 2}
}
```


`rest`参数：用于获取获取函数的多余参数。与参数默认值一样，必须为尾参数

```js
{
    function foo(a,b,...args){
        console.info(args)
    }
    foo(1,2,3,4,5,6) // [3, 4, 5, 6]
}
```

扩展运算符`...`：它好比 `rest` 参数的逆运算。可以将一个数组转为用逗号分隔的参数序列。

```js
{
    // 更好的 apply 方法，例如我们在算最大值的时候：
    var arr = [1,2,3,4,5]
    console.info(Math.max.apply(null,arr))
    console.info(Math.max(...arr)) // 使用扩展运算符
    console.info(Math.max(1,2,3,4,5)) // 最终都会被解析成这样

    // 当然还能这样用
    var str = 'string'
    var arr = [...str,4,5] // ["s", "t", "r", "i", "n", "g", 4, 5]

}
```

箭头函数 `Arrow Functions`：箭头函数并不是用来替代现有函数而出现的，并且也无法替代。它是用来作为回调函数使用的，主要是为了简化回调函数的写法。
主要有三个特性：
1. 箭头函数自身没有 `this` 。函数内的 `this` 指向箭头函数 **定义时所在的对象** ，而不是使用时所在的对象。
2. 箭头函数内部，不存在 `arguments` 对象
3. 不可以当作构造函数，不可以使用 `new` 指令。


简单用法，简化回调：

```js
{
    // 我们都知道数组的 sort 并不是根据数值大小来排序的，需要排序时，要通过回调函数的形式来确定排序方式 
    var arr = [7,8,9,10]
    arr.sort() // [10, 7, 8, 9]
    arr.sort(function(a,b){return a-b}) // [7, 8, 9, 10]
    arr.sort((a,b)=> a - b ) // 箭头函数简化。当仅有一条语句时，有一个隐式的 return 
}
```



没有 `arguments`

```js
{
    var foo = (a,b,c)=>{
        console.log(a,b,c)
        console.log(arguments)
    };
    foo(1,2,3)
    // 1 2 3
    // Uncaught ReferenceError: arguments is not defined      
}
```



不要在对象的方法中使用箭头函数：

```js
{
    window.name='window';
    var obj = {
        name:'obj',     
        getName: function(){
            console.log(this.name)
        }
    }
    obj.getName() // obj
    var getName = obj.getName
    getName() // window， this 总是指向调用者
    //-----------------
    var obj = {
        name:'obj',     
        getName: () =>{
            console.log(this.name)
        }
    }
    obj.getName() // window
    /**
        这里由于对象 a，并不能构成一个作用域。所以会再往上达到全       局作用域，所以 this 指向 window..
     */
}
```

