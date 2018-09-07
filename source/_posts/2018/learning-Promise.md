title: 学习 Promise，掌握未来世界 JS 异步编程基础
date: 2018-06-04 00:15:37
tags: [异步编程,JS,Promise]
categories: [前端技术,异步编程]

---

> 其实想写 Promise 的使用已经很长时间了。一个是在实际编码的过程中经常用到，一个是确实有时候小伙伴们在使用时也会遇到一些问题。
> Promise 也确实是 ES6 中 对于写 JS 的方式，有着真正最大影响的 API 特性之一。
> 本文是实际使用使用过程中的一个总结
> 看一下文件创建时间 2017-10-09，拖延症真是太可怕了。。。还是得增强执行力啊！不忘初心，加油吧！

## 前言 && 基础概念

Promise 是解决 JS 异步的一种方案，相比传统的回调函数，Promise 能解决多个回调严重嵌套的问题。

Promise 对象代表一个异步操作，有三种状态: `pending、fulfilled 或 rejected` ，状态的转变只能是 `pending -> fulfilled` 或者 `pending -> rejected` ，且**这个过程一旦发生就不可逆转**。

<!-- more -->

> 个人认为讲解 Promise 实际上需要分成两个部分
>
> 1. 对于 Promise 构造函数的使用说明。
> 2. Promise 原型对象上的一些方法。

## Promise 构造函数

ES6 规定，Promise 对象是一个构造函数，用来生成 Promise 实例。

Promise 构造函数接受一个函数作为参数，该函数的两个参数分别是 resolve 和 reject 。它们是两个函数，由 JavaScript 引擎提供，不用自己部署。

resolve 函数的作用是将 Promise 对象的状态从“未完成”变为“成功”（即从 pending 变为 fulfilled ），在异步操作成功时调用，并将异步操作的结果，作为参数传递出去；
reject 函数的作用是，将 Promise 对象的状态从“未完成”变为“失败”（即从 pending 变为 rejected ），在异步操作失败时调用，并将异步操作报出的错误，作为参数传递出去。

下面代码创造了一个 Promise 实例。

```js
function request() {
  return new Promise((resolve, reject) => {
    /* 异步操作成功 */
    setTimeout(() => {
      resolve("success");
    }, 1000);
    // 取消注释这里可以体现，Promise 的状态一旦变更就不会再变化的特性
    // reject('error');
  });
}
```

接收

```js
request()
  .then(result => {
    console.info(result);
  })
  .catch(error => {
    console.info(error);
  });
```

上述 `new Promise()` 之后，除去用 catch 去捕获错误之外，也可以用 `then` 方法指定 `resolve` 和 `reject` 的回调函数
也能达到捕获错误的目的。

```js
request().then(
  result => {
    console.info(result);
  },
  error => {
    console.info(error);
  }
);
```

原型上的方法

### `Promise.prototype.then()`

> p.then(onFulfilled, onRejected);

then 方法 是定义在 `Promise.prototype` 上的方法，如上面的例子一样，有两个参数，`fulfilled` 的回调函数和 `rejected` 的回调函数，第二个参数时可选的。

两个关键点：

1. then 方法的返回值是一个新的 `Promise` 实例，所以对于调用者而言，拿到一个 `Promise` 对象，调用 `then` 后仍然返回一个 `Promise` ，而它的行为与 then 中的回调函数的返回值有关。如下：

- 如果 then 中的回调函数返回一个值，那么 then 返回的 Promise 将会成为接受状态，并且将返回的值作为接受状态的回调函数的参数值。
- 如果 then 中的回调函数抛出一个错误，那么 then 返回的 Promise 将会成为拒绝状态，并且将抛出的错误作为拒绝状态的回调函数的参数值。
- 如果 then 中的回调函数返回一个已经是接受状态的 Promise，那么 then 返回的 Promise 也会成为接受状态，并且将那个 Promise 的接受状态的回调函数的参数值作为该被返回的 Promise 的接受状态回调函数的参数值。
- 如果 then 中的回调函数返回一个已经是拒绝状态的 Promise，那么 then 返回的 Promise 也会成为拒绝状态，并且将那个 Promise 的拒绝状态的回调函数的参数值作为该被返回的 Promise 的拒绝状态回调函数的参数值。
- 如果 then 中的回调函数返回一个未定状态（pending）的 Promise，那么 then 返回 Promise 的状态也是未定的，并且它的终态与那个 Promise 的终态相同；同时，它变为终态时调用的回调函数参数与那个 Promise 变为终态时的回调函数的参数是相同的。

1. 链式调用。把嵌套回调的代码格式转换成一种链式调用的纵向模式。

比如说回调形式: 一个回调地狱的例子

```js
a(a1 => {
  b(a1, b1 => {
    c(b1, c1 => {
      d(c1, d1 => {
        console.log(d1);
      });
    });
  });
});
```

这样的横向扩展可以修改成(a,b,c,d)均为返回 Promise 的函数

```js
a()
  .then(b)
  .then(c)
  .then(d)
  .then(d1 => {
    console.log(d1);
  });
//===== 可能上面的例子并不太好看 ===下面这样更直观
a()
  .then(a1 => b(a1))
  .then(b1 => c(b1))
  .then(c1 => d(c1))
  .then(d1 => {
    console.log(d1);
  });
```

这样的纵向结构，看上去清爽多了。

### `Promise.prototype.catch()`

除了 `then()` ，在 `Promise.prototype` 原型链上的还有 `catch()` 方法，这个是拒绝的情况的处理函数。

其实 它的行为与调用 `Promise.prototype.then(undefined, onRejected)` 相同。 (事实上, calling `obj.catch(onRejected)` 内部 calls `obj.then(undefined, onRejected))`.

```js
// 1.
request().then(
  result => {
    console.info(result);
  },
  error => {
    console.info(error);
  }
);

// 2.
request()
  .then(result => {
    console.info(result);
  })
  .catch(error => {
    console.info(error);
  });
```

如上这个例子：两种方式在使用，与结果基本上是等价的，但是 仍然推荐第二种写法，下面我会给出原因:

1. 在 Promise 链中 `Promise.prototype.then(undefined, onRejected)`，`onRejected` 方法无法捕获当前 Promise 抛出的错误,而后续的 .catch 可以捕获之前的错误。
2. 代码冗余

```js
new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve("reject");
  }, 1000);
})
  .then(
    result => {
      console.log(result + "1");
      throw Error(result + "1"); // 抛出一个错误
    },
    error => {
      console.log(error + ":1"); // 不会走到这里
    }
  )
  .then(
    result => {
      console.log(result + "2");
      return Promise.resolve(result + "2");
    },
    error => {
      console.log(error + ":2");
    }
  );
// reject1, Error: reject1:2
```

如果使用 `.catch` 方法，代码会简化很多，**这样实际上是延长了 Promise 链**

```js
new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve("reject");
  }, 1000);
})
  .then(result => {
    console.log(result + "1");
    throw Error(result + "1"); // 抛出一个错误
  })
  .then(result => {
    console.log(result + "2");
    return Promise.resolve(result + "2");
  })
  .catch(err => {
    console.log(err);
  });
// reject1, Error: reject1:2
```

### `Promise.prototype.finally()`

**暂未完全成为标准的一部分，处于：Stage 4**

`finally()` 方法返回一个 `Promise`，在执行 `then()` 和 `catch()` 后，都会执行`finally`指定的回调函数。（回调函数中无参数，仅仅代表 Promise 的已经结束

等同于使用 `.then` + `.catch` 延长了原有的 Promise 链的效果，避免同样的语句需要在 `then()` 和 `catch()` 中各写一次的情况。

[mdn-Promise-finally](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise/finally)

## Promise 对象上的方法

### `Promise.all()` 用来处理 Promise 的并发

`Promise.all` 会将多个 `Promise` 实例封装成一个新的 `Promise` 实例，新的 promise 的状态取决于多个 `Promise` 实例的状态，只有在全体 `Promise` 都为 `fulfilled` 的情况下，新的实例才会变成 `fulfilled` 状态。；如果参数中 `Promise` 有一个失败（`rejected`），此实例回调失败（`rejecte`），失败原因的是第一个失败 `Promise` 的结果。

举个例子:

```js
Promise.all([
  new Promise(resolve => {
    setTimeout(resolve, 1000, "p1");
  }),
  new Promise(resolve => {
    setTimeout(resolve, 2000, "p2");
  }),
  new Promise(resolve => {
    setTimeout(resolve, 3000, "p3");
  })
])
  .then(result => {
    console.info("then", result);
  })
  .catch(error => {
    console.info("catch", error);
  });
// [p1,p2,p3]

Promise.all([
  new Promise(resolve => {
    setTimeout(resolve, 1000, "p1");
  }),
  new Promise(resolve => {
    setTimeout(resolve, 2000, "p2");
  }),
  Promise.reject("p3 error")
])
  .then(result => {
    console.info("then", result);
  })
  .catch(error => {
    console.info("catch", error);
  });
// p3 error
```

获取 cnode 社区的 精华贴的前十条内容

```js
fetch("https://cnodejs.org/api/v1/topics?tab=good&limit=10")
  .then(res => res.json())
  .then(res => {
    const fetchList = res.data.map(item => {
      return fetch(`https://cnodejs.org/api/v1/topic/${item.id}`)
        .then(res => res.json())
        .then(res => res.data);
    });
    Promise.all(fetchList).then(list => {
      console.log(list);
    });
  });
```

### `Promise.race()` 竞态执行

`Promise.race` 也会将多个 `Promise` 实例封装成一个新的`Promise`实例，只不过新的 `Promise` 的状态取决于最先改变状态的 `Promise` 实例的状态。

在前端最典型的一个用法是为 fetch api 模拟请求超时。

```js
Promise.race([
  fetch("https://cnodejs.org/api/v1/topics?tab=good&limit=10").then(res =>
    res.json()
  ),
  new Promise((resolve, reject) => {
    setTimeout(reject, 1, "error");
  })
])
  .then(result => {
    console.info("then", result);
  })
  .catch(error => {
    console.info("catch", error); // 进入这里
  });
```

上述例子中只要请求 未在 1 毫秒内结束就会进入 `.catch()` 方法中，虽然不能将请求取消，但是超时模拟却成功了

### `Promise.resolve(value)` && `Promise.reject(reason)`

这两个方法都能用来创建并返回一个新的 Promise , 区别是 `Promise.resolve(value)` 携带进新的 Promise 状态是 `fulfilled`。而 `Promise.reject(reason)` 带来的 `rejected`

有的时候可以用来简化一些创建 Promise 的操作如：

```js
const sleep = (time = 0) => new Promise(resolve => setTimeout(resolve, time));
// 这里创建一个 睡眠，并且打印的链
Promise.resolve()
  .then(() => {
    console.log(1);
  })
  .then(() => sleep(1000))
  .then(() => {
    console.log(2);
  })
  .then(() => sleep(2000))
  .then(() => {
    console.log(3);
  });
```

有时也用来 手动改变 Promise 链中的返回状态 ，当然这样实际上和 直接返回一个值，或者是 使用 throw Error 来构造一个错误，并无区别。到底要怎么用 就看个人喜好了

```js
new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve("resolve"); // 1.
  }, 1000);
})
  .then(result => {
    return Promise.reject("reject1"); // 2.
  })
  .then(
    result => {
      return Promise.resolve(result + "2");
    },
    err => {
      return Promise.resolve(err); // 3.
    }
  )
  .then(res => {
    console.log(res); // 4.
  })
  .catch(err => {
    console.log(err + "err");
  });
// reject1
```

## 几个例子

下面来看几个例子:

关于执行顺序，具体可搜索，js 循环

```js
new Promise((resolve, reject) => {
  console.log("step 1");
  resolve();
  console.log("step 2");
}).then(() => {
  console.log("step 3");
});
console.log("step 4");

// step 1, step 2, step 4 , step 3
```

在使用 Promise 构造函数构造 一个 Promise 时，回调函数中的内容就会立即执行，而 `Promise.then` 中的函数是异步执行的。

关于状态不可变更

```js
let start;
const p = new Promise((resolve, reject) => {
  setTimeout(() => {
    start = Date.now();
    console.log("once");
    resolve("success");
  }, 1000);
});
p.then(res => {
  console.log(res, Date.now() - start);
});
p.then(res => {
  console.log(res, Date.now() - start);
});
p.then(res => {
  console.log(res, Date.now() - start);
});
```

`Promise` 构造函数只执行一次，内部状态一旦改变，有了一个值，后续不论调用多少次`then()`都只拿到那么一个结果。

关于好像状态可以变更

```js
const p1 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve("success");
  }, 1000);
});

const p2 = p1.then((resolve, reject) => {
  throw new Error("error");
});

console.log("p1", p1);
console.log("p2", p2);

setTimeout(() => {
  console.log("p1", p1);
  console.log("p2", p2);
}, 2000);
```

观察这一次的打印
第一次打印出两个 `Promise` 的时候都是 `pending` ，因为 p2 是基于 p1 的结果，p1 正在 pending ，立即打印出的时候肯定是 pending ;第二次打印的时候，因为 p1 的状态为 resolved ，p2 为 rejected ，这个并不是已经为 fulfilled 状态改变为 rejected ，而是 p2 是一个新的 Promise 实例，`then()` 返回新的 Promise 实例。

关于透传

```js
Promise.resolve(11)
  .then(1)
  .then(2)
  .then(3)
  .then(res => {
    console.info("res", res);
  });
//   11
```

给 then 方法传递了一个非函数的值，等同于 `then(null)`，会导致穿透的效果，就是直接过掉了这个 then() ，直到符合规范的 then() 为止。

## Promise 的串行调用

使用 Array.reduce 方法串行执行 Promise

```js
const sleep = (time = 0) => new Promise(resolve => setTimeout(resolve, time));
[1000, 2000, 3000, 4000].reduce((Promise, item, index) => {
  return Promise.then(res => {
    console.log(index + 1);
    return sleep(item);
  });
}, Promise.resolve());
// 在分别的等待时间后输出 1，2，3，4
```

这篇文章到这里就基本上结束了，相信 如果能理解上面的内容，并且在实际项目中使用的话。应该会让工作更高效吧，对于新的异步使用应该也会更加的得心应手。Promise 的使用相对简单，可能后续再出一篇如何实现一个 Promise 吧

那些收集的 Promise 的优质文章。

- [ bluebird 是一个拓展 Promise 方法的库，提供了非常多的实用的方法，推荐](http://bluebirdjs.com/docs/getting-started.html)
- [[思维导图] Promise - 《你不知道的 JavaScript》- 中卷 - 第二部分](https://zhuanlan.zhihu.com/p/25266255)
- [[译] 一个简单的 ES6 Promise 指南](https://zhuanlan.zhihu.com/p/37535594)
- [阮一峰-ES6 入门 Promise 对象](http://es6.ruanyifeng.com/#docs/promise)
- [Promise 不够中立](https://juejin.im/post/5abfdfb5f265da237a4d2708)
- [WHY “PROMISES ARE NOT NEUTRAL ENOUGH” IS NOT NEUTRAL ENOUGH](https://zhuanlan.zhihu.com/p/35082528)
- [【译】关于 Promise 的 9 个提示](https://zhuanlan.zhihu.com/p/34093535)
- [Promise 必知必会（十道题）](https://zhuanlan.zhihu.com/p/30797777)
- [Event Loop 必知必会（六道题）](https://www.inoreader.com/article/3a9c6e7ec0b4336e-event-loop)
