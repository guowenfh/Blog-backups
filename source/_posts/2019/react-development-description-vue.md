title: 一个使用 react 的思想去使用 vue 的方式
date: 2019-04-28 12:00:00
tags: [react, vue]
categories: [react, vue]
---

> 有一个 react 开发者 问我 vue 如何上手开发？然后我是这么和他描述的。。
> 用 react 的思想 去考虑 vue 要怎么写。
> 本文很水。而且将来感觉一定会被打脸，期待那一天到来。

其实也就几块

1. 你可以把 template 就看成 react 的 render 就是写法有一些不一样，看一下 vue 的指令就可以了，当然也可以直接用 render function
2. data 的话 和 react 的 state 也没什么区别 , 只不过赋值方式变成了 this.setState({text:'state'})  this.text = 'state' （vue 有一个坑，数组里面 data: [{a:1}]  使用 this.data[0].b = 1 => data":[{a:1,b:1}] 新增了一个b字段 这样是不会刷新页面的。react 不会有这个问题（至于怎么刷新，这个就先你自己去看文档把哈哈哈（底层实现不考虑
3. methods 对应的就是 react 中 class componnet 中 直接写上去的方法  onMenuClick = () => {} 这种 （vue里面不需要箭头函数
4. 事件监听的话 @click="onMenuClick" 和 react 中的  onClick={this.onMenuClick} 也没什么区别
5. 生命周期 mounted 和 react 中的 componentDidMount 也基本一致（周期里面就这个最重要了 当然还有 wtach需要看一下
6. computed 正确的使用方式，其实就是一个纯函数，在里面写有副作用的内容，对可维护性是一个灾难（自动计算，实际上不用也没关系 （react里面就没有
7. 其他的 就是 props components 这两个了，用法是一样的，但是得手动声明一下，按照文档来就可以
8. 路由，vue 的路由其实更好理解，react-route@4 + react-route-config 使用上基本也一致。 只不过 router-view 换成了 renderRoutes
9. 剩下的部分 其实就照着文档看看就行拉 https://cn.vuejs.org/v2/api/#components

然后在组内问了一下大家的看法

Q：感觉写vue和react的思维方式不太一样?
A：大的说的话，一个是函数式，一个是响应式。

Q：vue比较符合常人的思维，比较好上手。同时意味着，不如react的方法抽象。watch就很有意思。
A：watch 是一个双刃剑吧。确实很方便...不过也容易写出来不易读或者性能很差的代码。

Q：React 的生命周期component WillReceiveProps可以拿到nextProps 这样的参数，父组件参数改变时，子组件方便监听并特殊处理。vue 中通过computed 监听数据变化并处理，感觉怪怪的
A：其实 componentWillReceiveProps 即将被废弃了。。。不过这个需求确实是有的 ，也就是父组件和 子组件其实都有一份state，并且父组件的状态更改会影响 子组件的state 更改的情况。 vue里面应该这个用 watch 会比较多，结合上面，其实 还是建议 computed 使用 纯函数，如果是纯函数的话，那么就不能去改子组件的 state 了 （state 改成 data 也是一样。

Q：Vue 通过 getter/setter 以及一些函数的劫持，能精确知道数据变化，不需要特别的优化就能达到的性能
React 默认是通过比较引用的方式进行的，如果不优化（PureComponent/shouldComponentUpdate）可能导致大量不必要的VDOM的重新渲染
A：嗯...有点偏题。 一个新人学 vue 进来应该不会考虑这个？不过基本没错

Q：computed是实现y = f（x） ，因变量只能通过这个函数得到才能用 computed吧，否则应该是有问题的。
A：虽然是这么说，但是你看了主站的代码就知道，这个其实不是一个强绑定。主站里面 computed 里面做有副作用的事情，也有好多- -，不是一个好的实践。（我上面说的是建议只当成纯函数来用