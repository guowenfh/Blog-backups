title: 从一个简单的实例看 JavaScript 的异步编程进化历
date: 2018-09-03 14:32:24
tags: [异步编程,JS,Promise,async,generator]
categories: [前端技术,异步编程]

---

![回调地狱](https://ws4.sinaimg.cn/large/0069RVTdgy1fuwvkqjzvdj30k00bnmym.jpg)

> 很久没有进行过创作了，也感觉到了自己的不足。这一篇文章是对于 JavaScript 异步编程的一个 整理
> 希望自己更多的成为一个创造者，而不是只会看，会用，还需要深入理解到原理吧。

例子如下：

> 我们有 A, B, C, D 四个请求获取数据的函数（函数自己实现），
> C 依赖 B 的结果，D 依赖 ABC 的结果，最终输出 D 的结果。

<!-- more -->

### 版本一

```js
// 伪代码
function A(callbak) {
  ajax(url, function(res) {
    callbak(res);
  });
}
function B(callbak) {
  ajax(url, function(res) {
    callbak(res);
  });
}
function C(data, callback) {
  ajax(url, data, function(res) {
    callbak(res);
  });
}
function D(data1, data2, data3, callback) {
  ajax(url, { data1, data2, data3 }, function(res) {
    callbak(res);
  });
}

A(function(resa) {
  B(function(resb) {
    C(resb, function(resc) {
      D(resa, resb, resc, function(resd) {
        console.log("this is D result:", resd);
      });
    });
  });
});
```

emm...代码还是能运行，但是写法丑陋，回调地狱，如果还有请求依赖，得继续回调嵌套
性能太差，没有考虑 A 和 B 实际上是可以并发的。

### 例子二

函数基础实现如同例子一，但是考虑 A,B 可以并发的。

```js
// 伪代码
let resa = null;
let timer = null;

A(res => {
  resa = res;
});

B(resb => {
  C(resb, resc => {
    timer = setInterval(() => {
      if (resa) {
        D(resa, resb, resc, resd => {
          console.log("this is D result:", resd);
          timer && clearInterval(timer);
        });
      }
    }, 100);
  });
});
```

考虑了 A,B 的并发，使用 setInterval 轮询实现，并不一定实时。性能太差。

### 例子三

```js
// 伪代码
let count = 2;
let resa = null;
let resb = null;
let resc = null;
function done() {
  count--;
  if (count === 0) {
    D(resa, resb, resc, resd => {
      console.log("this is D result:", resd);
    });
  }
}

A(res => {
  resa = res;
  done();
});
B(datab => {
  C(datab, datac => {
    resb = datab;
    resc = datac;
    done();
  });
});
```

使用 计数器实现。性能没什么问题，但是 封装太差，写法恶心。

### 例子四

```js
// 实现并发
function parallel(tasks, callback) {
  let count = tasks.length;
  let all = [];
  tasks.forEach((fn, index) => {
    fn(res => {
      all[index] = res;
      count--;
      if (count === 0) {
        callback(all);
      }
    });
  });
}
// 实现串行
function waterfall(tasks, callback) {
  let count = tasks.length;
  function loop(...args) {
    let task = tasks.shift();
    task.apply(
      null,
      args.concat([
        (...res) => {
          count--;
          if (count === 0) {
            return callback(res);
          }
          loop(...res);
        }
      ])
    );
  }
  loop();
}
function A(cb = () => {}) {
  setTimeout(() => {
    cb("a");
  }, 2000);
}
function B(cb = () => {}) {
  setTimeout(() => {
    cb("b");
  }, 1000);
}
function C(datab, cb = () => {}) {
  setTimeout(() => {
    cb(datab, "c");
  }, 1000);
}
function D(data, datab, datac, cb = () => {}) {
  cb("d");
}
parallel(
  [
    A,
    cb => {
      waterfall([B, C], (datab, datac) => {
        cb(datab, datac);
      });
    }
  ],
  data => {
    const [resa, [resb, resc]] = data;
    D(resa, resb, resc, resd => {
      console.log("this is D result:", resd);
    });
  }
);
```

模仿 async.js 提炼出来了 waterfall，parallel，两个流程控制函数。还不错。
但是写法还是麻烦，对于 A,B,C 的实现有要求。得自己考虑好每一次 callback 的值。

**async.js** 是我认为在目前 JavaScript callback 的终极解决方案了（没用过 fib.js..

推荐查看 [github async.js](https://github.com/caolan/async) 源码。

waterfall 可以考虑使用函数式的形式实现：

```js
function pipe(...fnList) {
  return function(...args) {
    const fn = fnList.reduceRight(function(a, b) {
      return function(...subArgs) {
        return b.apply(this, [].concat(subArgs, a));
      };
    });
    return fn.apply(this, args);
  };
}
```

### 例子五

```js
function A() {
  return fetch("http://google.com");
}
function B() {}
function C() {}
function D() {}

Promise.all[(A(), B().then(b => C(b)))]
  .then(([resa,{resb,resc}) => {
    return D(resa,resb,resc);
  })
  .then(resd => {
    console.log("this is D result:", resd);
  });
```

使用 Promise 来代替 之前的 callback。好评。
用 Promise.all 来控制并发，使用 .then 串行请求，整体看起来非常舒服了，脱离了回调地狱。

### 例子六

```js
function A(cb) {
  setTimeout(() => {
    cb("a");
  }, 2000);
}
function B(cb) {
  setTimeout(() => {
    cb("b");
  }, 1000);
}
function C(datab, cb) {
  setTimeout(() => {
    cb("c");
  }, 1000);
}
function D(dataa, datab, datac, cb) {
  setTimeout(() => {
    cb("d");
  }, 1000);
}
function thunk(fn) {
  return function(...args) {
    return function(callback) {
      fn.call(this, ...args, callback);
    };
  };
}
function scheduler(fn) {
  var gen = fn();

  function next(data) {
    var result = gen.next(data);
    if (result.done) return;
    // 如果没结束就继续执行
    result.value(next);
  }

  next();
}

// generator 实际代码
function* generatorTask() {
  const resa = yield thunk(A)();
  const resb = yield thunk(B)();
  const resc = yield thunk(C)(resb);
  const resd = yield thunk(D)(resa, resb, resc);
  console.log("this is D result:", resd);
  return null;
}

scheduler(generatorTask);
```

使用 generator + callback 来控制流程顺序，还是同步写法，看起来还是挺牛逼的。
但是 generator 不会自动执行，需要自己手动写一个执行器，并且依赖于 thunk 函数。麻烦！
等等。。又全变成了串行？垃圾

### 例子七

```js
function A() {
  return new Promise(r =>
    setTimeout(() => {
      r("a");
    }, 2000)
  );
}
function B() {
  return new Promise(r =>
    setTimeout(() => {
      r("b");
    }, 1000)
  );
}
function C(datab) {
  return new Promise(r =>
    setTimeout(() => {
      r("c");
    }, 1000)
  );
}
function D(dataa, datab, datac) {
  return new Promise(r =>
    setTimeout(() => {
      r("d");
    }, 1000)
  );
}
function scheduler(fn) {
  var gen = fn();

  function next(data) {
    var result = gen.next(data);
    if (result.done) return;
    // 如果没结束就继续执行
    result.value.then(next);
  }

  next();
}

// generator 实际代码
function* generatorTask() {
  const [resa, { resb, resc }] = yield Promise.all([
    A(),
    B().then(resb => C(resb).then(resc => ({ resb, resc })))
  ]);
  const resd = yield D(resa, resb, resc);
  console.log("this is D result:", resa, resb, resc, resd);
  return resd;
}

scheduler(generatorTask);
```

抛弃了 thunk 函数，修改了一下 A，B，C，D。的实现以及 generator 执行函数 scheduler。 结合了 Promise 重新实现了并发和串行。
再等等？？好麻烦啊。。然后并发好像和 generator 没什么关系吧。果然还是 Promise 大法好。

关于 generator 的自动执行建议直接看 [github tj/co](https://github.com/tj/co) 的源码。

### 例子八

```js
function A() {
  return fetch("http://google.com");
}
// ...B,C,D
async function asyncTask() {
  const resa = await A();
  const resb = await B();
  const resc = await C(resb);
  const resd = await D(resa, resb, resc);
  return resd;
}

asyncTask().then(resd => {
  console.log("this is D result:", resd);
});
```

使用 Promise 结合 async/await 的形式 ，看起来非常简洁。也不用自己写执行器了，舒服。
但是和上面有几个版本出现了一样的问题，没有考虑并发的情况，导致性能下降。

### 例子九，终极方案？

```js
// ...B,C,D
async function asyncBC() {
  const resb = await B();
  const resc = await c(resb);
  return { resb, resc };
}
async function asyncTask() {
  // const [resa,{resb,resc}] = await Promise.all([A(), B().then(resb=>C(resb)]);
  const [resa, { resb, resc }] = await Promise.all([A(), asyncBC()]);
  const resd = await D(resa, resb, resc);
  return resd;
}
asyncTask().then(resd => {
  console.log("this is D result:", resd);
});
```

使用 Promise.all 结合 async/await 的形式，考虑了并发和串行，写法简洁。
应该算是目前的终极方案了。 async/await 作为 generator 语法糖还是非常的甜的。

### 例子十 使用 RxJs

```js
import { defer, forkJoin } from "rxjs";
import { mergeMap, map } from "rxjs/operators";

function A() {
  return fetch("https://cnodejs.org/api/v1/topics").then(res => res.json());
}
function B() {
  return fetch("https://cnodejs.org/api/v1/topics").then(res => res.json());
}
function C() {
  return fetch("https://cnodejs.org/api/v1/topics").then(res => res.json());
}
function D(...args) {
  return fetch("https://cnodejs.org/api/v1/topics")
    .then(res => res.json())
    .then(res => [...args, res]);
}
// A, B, C, D 函数必须返回 Promise
// 使用 defer 产生一个 Observable
const A$ = defer(() => A());
// pipe 类型 Promise 链中 的 then
const BC$ = defer(() => B()).pipe(
  // mergeMap 映射成 promise 并发出结果
  mergeMap(resB => {
    // 使用 map 产生新值
    return defer(() => C(resB)).pipe(map(resC => [resB, resC]));
  })
);

// forkJoin 类似 Promise.all 并发执行多个 Observable
forkJoin(A$, BC$)
  .pipe(mergeMap(([resa, [resb, resc]]) => D(resa, resb, resc)))
  .subscribe(resd => {
    console.log("this is D result:", resd); // <------- fnD 返回的结果
  });
```

使用 rxjs 来构建流式的请求过程。结构还是非常清晰的，但是相对繁琐，概念也比 原生的 Promise 和 await 要多

不过 rxjs 操作符巨多，掌握之后，可以做更多的事情

---

结语：

从上面几个例子我们可以窥探到 JavaScript 对于异步编程体验的一个非常大的进步。

但是同时我们其实可以看到不论是 generator 还是 async/await。其实更多的是基于 Promise 之上的一些语法简化。
没有从 callback 过渡到 Promise 的时候那种真正心灵上的愉悦。

> 感谢 @墨水 之前在内部分享提供的 demo 版本。
