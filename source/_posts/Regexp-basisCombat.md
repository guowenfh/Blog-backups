title: 正则表达式-基础实战篇
date: 2015-12-14 11:34:31
tags: [JS,正则表达式]
categories: [前端技术]
---

> 在理论基础篇之后呢,应该就对正则表达式有了一些了解.比如说如何去创建一个正则表达式以及其中的匹配规则等等.那么就开始正则表达式的实战吧!
> 建议把所有的实例在console窗口敲一遍.例子中展现的只是一部分,配合《正则表达式-理论基础篇》[SF地址](http://segmentfault.com/a/1190000003977848)、[原址](//guowenfh.github.io/2015/12/01/Regexp-basis/)使用效果更佳哦!

## 一个手机号码匹配的进化历程
> 实例代码依托于:`RegExpObj.test(String)`，其含义是测试正则表达式与指定字符串是否匹配。成功匹配返回`true`

### 第一阶段-字符直接量:匹配自身
> 先假设一个手机号码为13762571094.

- **最初形态**


```javascript
/13762571094/.test("13783281094");//false
/13762571094/.test("13762571094");//true

/13762571094/.test("ui13762571094dd");//true
//正则表达式在匹配时,只要输出匹配内容就返回true,不考虑前面的ui和后面的dd
//最后这种情况显然不是我们想要的.那么就进入下一阶段的实践吧.
```


### 第二阶段-锚点:指定匹配位置
- `^`匹配起始位置


```javascript
/^http:/.test("http://www.163.com");//true
/^http:/.test("ahttp://www.163.com");//false
/^http:/.test("//www.163.com");//false
```

- `$`匹配结尾位置


```javascript
/.jpg$/.test("1.jpg");//true
/.jpg$/.test("1.jpg png");//false
/.jpg$/.test("1.png");//false
/.jpg$/.test("regexp.png");//false
```

- `\b`:匹配单词边界

```javascript
/\bis\b/.test("this");//false
/\bis\b/.test("that is reg");//true
```

- 在了解锚点之后我们的正则就有了**第一次进化**


```javascript
/^13762571094$/.test("13762571094");//true

/^13762571094$/.test("ui13762571094dd");//false
//此时这个程序就能正确识别头尾的字符了.下面我们看看
/^13762571094$/.test("13712345674");//false
/*在试过了多个号码后发现,这个正则只能识别这个标准的手机号码.
这显然不是我们想要的,而不是识别一个手机号码的格式.
在下一阶段我们将实现一个手机号码的匹配.*/
```

### 第三阶段-字符类:匹配一类字符中的一个
- `[abc]`:a或b或c。`[0-9]`:一个数字
- `[^0-9]`:非数字的一个字符。`[a-z]`:一个字母
- `.`    :任一字符(换行符除外)


```javascript
[0-9]/.test("123")//true
/[0-9]/.test("asd")//false
/[^0-9]/.test("asd")//true
/[a-z]/.test("asd")//true
/./.test("allen")//true
/./.test("12")//true
```

- 了解了字符类后,我们就可以进行**第二次进化(50%)**。此时就能匹配一个手机号码啦！


```javascript
/^1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/.test("13762571094");//true
/^1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/.test("13712345678");//true
//是不是感觉代码太长了呢?[0-9]足足5个字符呢,为了省力,当然不会就这样算了.继续向下看吧

```

#### 元字符-具有特殊意义的字符
> 其实我们已经在前面使用过它啦

- `^`、`$`、`\b`。
- `\d`:`[0-9]`。`\D`:`[^\d]`
- `\s`:空白符。`\S`:`[^\s]`
- `\w`:`[A-Za-z0-9_]`。`\W`:`[^\w]`


```javascript
/\d/.test("123");//true
/\d/.test("1dsf");//true
/\D/.test("1dsf");//true
/\D/.test("123");//false
//自己再多去实验一些例子吧
```

- 了解了元字符后我们就可以进行**第二次进化(100%)**了。


```javascript
/^1\d\d\d\d\d\d\d\d\d\d$/.test("13762571094");//true
/^1\d\d\d\d\d\d\d\d\d\d$/.test("13712345678");//true
/^1\d\d\d\d\d\d\d\d\d\d$/.test("1376257109x");//false
//是不是感觉代码比刚刚短了很多了呢?但这还是不够,什么事情都阻止不了我想偷懒的心,继续学习吧.
```

### 第四阶段-量词:出现的次数

- `{n,m}`:n到m次。`?`：`{0,1}`
- `+`:`{1,}`。`*`:`{0,}`


```javascript
/\d*/.test("abc");//true
/\d+/.test("abc");//false
/\d+/.test("1abc");//true
/^https?:/.test("http://www.163.com");//true
/^https?:/.test("//www.163.com");//true
/^https?:/.test("httpss://www.163.com");//false
```

- 此时我们的匹配手机号码的正则表达式就到了**最后阶段**了


```javascript
/^1\d{10}$/.test("1376257109x");//false
/^1\d{10}$/.test("13762571094");//true
/^1\d{10}$/.test("13712345678");//true
//到这里手机号码就匹配完成了!
```

### 需要注意的点

- 这里匹配的情况是最简单的情况，并没有特别完美，比如限制开头第二位数字的范围：188，158通过，而123,191，不通过等等。
- 可利用多选分支，例如：`/^1[3|5][0-9]{9}$|^18\d{9}$/`。不过现在虚拟运营商的加入，号码段变多了，所以直接用最简单的方法，也没事。

## 邮箱的匹配

`/thi(c|n)k/`===`thi[cn]k`

`\.(png|jpg|jpeg|gif)$`:检测一个文件是不是图片文件.

### 多选分支:网易邮箱的匹配

#### 元字符的问题
`/^http:/\/\/`..`/@163\.com$/`

```javascript
/http:\/\//.test("http://www.163.com");//true
/@163.com$/.test("abc@163.com");//true
/@163.com$/.test("abc@163acom");//true
/@163\.com$/.test("abc@163.com");//true
/@163\.com$/.test("abc@163acom");//false
```
#### 使用多选分支。
```javascript
/(\w+)@(163|126|188)\.com$/.test("guo啊圣诞节了@163acom")//false
/(\w+)@(163|126|188)\.com$/.test("guodong111@163acom")//false
/(\w+)@(163|126|188)\.com$/.test("guodong111@163.com")//true

```
### 分组-邮箱的匹配
这里需要思考几个问题.

1. 在@前能出现哪些东西？这里使用`(\w+\.)*`来匹配出现`.`的情况，表示出现0次或多次因为`.`后不能紧跟@，所以后面紧跟`\w+`匹配普通的字母数字情况。
2. @后出现的邮箱后缀并不固定所以使用`\w+`来匹配。
3. 最后考虑域名结尾的级联情况所以用`(\.\w+)+`


```javascript
/^(\w+\.)*\w+@\w+(\.\w+)+$/.test("guo啊圣诞节了@163acom")//false
/^(\w+\.)*\w+@\w+(\.\w+)+$/.test("guodong111@163acom")//false
/^(\w+\.)*\w+@\w+(\.\w+)+$/.test("guodong111@163.com")//true
/^(\w+\.)*\w+@\w+(\.\w+)+$/.test("guodong111@yea.com.cn")//true
```

## 捕获
- 保存匹配到的字符串,日后再用
- `()`:捕获`/(\w+)@(163|126|188)\.com$/`
- (?:):不捕获`/(\w+)@(?:163|126|188)\.com$/`
- 使用:
 - $1,$2,...
 - api参数或返回值

### 获取匹配的字符串:`String.match(regexp)`

```javascript
var url = 'http://blog.163.com/album?id=1#comment';
var reg = /^(https?:)\/\/([^\/]+)(\/[^\?]*)?(\?[^#]*)?(#.*)?$/;
// var reg = /^(https?:)\/\/([^\/]+)([^\?]*)([^#]*)(.*)$///与上面的正则效果相同.;

var arr = url.match(reg);

//arr[0]为原字符串."http://blog.163.com/album?id=1#comment"
//对应括号所匹配的字符
var protocol= arr[1]//"http:"
var host= arr[2]//"blog.163.com"
var pathname= arr[3]//"/album"
var search= arr[4]//"?id=1"
var hash= arr[5]//"#comment"

```

### 替换一个子串:`str.replace(regexp/substr,replacement)`
- 第二个参数是字符时


```javascript
var str = "the price of tomato is 5, the price of apple is 10."
str.replace(/(\d+)/,"$1.00")
"the price of tomato is 5.00, the price of apple is 10."
//使用全局模式
str.replace(/(\d+)/g,"$1.00")
"the price of tomato is 5.00, the price of apple is 10.00."
```

- 第二个参数是函数时


```javascript
var html = '<label>网址:</label><input placeholder="以http://起始">';
html = html.replace(/[<>]/g, function(m0){
	switch(m0){
		case '<':
			return '&lt;';
		case '>':
			return '&gt;';
	}
});
//处理后输出结果为：
console.log(html);//&lt;label&gt;网址:&lt;/label&gt;&lt;input placeholder="以http://起始"&gt;

```

### 更强大的检索 - `regexpObj.exec(str)`

 - 更详尽的结果:index
 - 过程的状态:lastIndex
 - 一般用不到，就不详细说明了，有兴趣的自己去了解一下。