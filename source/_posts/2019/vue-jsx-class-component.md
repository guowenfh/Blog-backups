title: 在 vue 中使用 jsx 与 class component 的各种姿势
date: 2019-04-28 12:00:00
tags: [react, vue]
categories: [react, vue]
---

> 在之前我们分享过一次 [一个使用 react 的思想去使用 vue 的方式](https://blog.guowenfh.com/2019/04/28/2019/react-development-description-vue/)。
> 随着组内很多时候为了让 view 层更加清晰，和一些复杂的逻辑处理，导致现在 vue 代码中 jsx 的代码越来越多，这里进行一个整理说明

## 如何使用 

先参看腾讯 alloyTeam 这篇文章：

- [用 jsx 写 vue 组件](http://www.alloyteam.com/2017/07/12918/)

里面有提到使用 `babel-plugin-transform-vue-jsx` babel 6 插件来处理 jsx 的编译。

当然可能是官方也知道在一定的场景下 jsx 相对模板是有优势的，于是单独有了这个仓库 对于上面的插件进行了增强。[https://github.com/vuejs/jsx](https://github.com/vuejs/jsx) 在 babel 7+ 情况下可以参考使用

```sh
npm install @vue/babel-preset-jsx @vue/babel-helper-vue-jsx-merge-props
<!--.babelrc-->
{
  "presets": ["@vue/babel-preset-jsx"]
}
```

你可以在 jsx 中使用 v-model 进行双向绑定了！当然这只是一个语法糖。你也可以使用 babel 实现 v-for 。

对于一些简单的情况我们直接使用 jsx 替换 template 都不会有什么问题，但是当我们深入下去，比如要看一些 react 的 特殊模式 比如：`render props` 在 vue 中的使用。那么我们就要对 vue 实例的属性差异进行深入的对比和理解了。（render props 在vue中对应的就是 slotProps.default ）

- [https://cn.vuejs.org/v2/guide/render-function.html](https://cn.vuejs.org/v2/guide/render-function.html)
- [https://www.yuque.com/zeka/vue/vu60wg](https://www.yuque.com/zeka/vue/vu60wg)

## 与组件库结合的问题 

对于 antd-vue 来说，由于 实现的api基本和 react 版本一致，所以调用方式基本和react版本的文档也一致。

```jsx 
import {Input} form 'ant-design-vue'
<Input value={xx} onChange={(e)=>{}}>

//----

const HelloWorld = ({ props }) => <p>hello {props.message}</p>
```

但是也有一些没有那么友好的组件库， 比如 iview ，由于 内部大部分api都使用了 `this.$emit('on-xxEvent')` 的形式，在 template 语法下 `@on-xxEvent="xx"`觉得还好，但是在 jsx 语法下就显得很奇怪了。如下： 

```jsx
<Input value={xx} on-on-Change={(e)=>{}}>
```

在上面我们处理完了直接使用 jsx 的问题。那么我们能不能更像 react 一点呢？

## 单文件组件

这个时候我们可能写的一个 vue 单文件组件是这样的：

VueForm.vue
```vue
<script>
export default {
  name: 'VueForm',
  props: {},
  data() {
    return {}
  },
  render(){
    return (
        <div>
            <input />
        </div>
    )
  }
}
</script>
<style ></style>
```

如何直接使用 .js 或者 jsx 文件？

VueForm.jsx

```jsx
const VueForm = {
  name: 'VueForm',
  props: {},
  data() {
    return {}
  },
  methods:{
  
  },
  render(){
    return (
        <div>
            <input />
        </div>
    )
  }
}
VueForm.install = function(Vue) {
  Vue.component(VueForm.name, VueForm);
};

export default VueForm;
```

还是好麻烦啊，每一个组件都的去定义 install 方法，也得去写 methods 啥的，那么如何 再像一些呢？或者说更简单一些呢？

## class component

vue 官方提供了 [vue-class-component](https://github.com/vuejs/vue-class-component) 模块 结合我们上面聊的，我们可以写出来这样的代码。


```jsx
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({
  props: {
    propMessage: String
  }
})
export default class App extends Vue {
  // initial data
  msg = 123
  // use prop values for initial data
  helloMsg = 'Hello, ' + this.propMessage
  // lifecycle hook
  mounted () {
    this.greet()
  }
  // computed
  get computedMsg () {
    return 'computed ' + this.msg
  }
  // method
  greet () {
    alert('greeting: ' + this.msg)
  }
  render(){
    return (
        <input vModel={this.msg}>
        <p>prop: {this.propMessage}</p>
        <p>msg: {this.msg}</p>
        <p>helloMsg: {this.helloMsg}</p>
        <p>computed msg: {this.computedMsg}</p>
        <button onClick={this.greet}>Greet</button>
    )
  }
}
```

当然仅仅是这样可能还是不够的 。你需要再来一个模块 [vue-property-decorator](https://github.com/kaorun343/vue-property-decorator) 甚至是 [vuex-class](https://github.com/ktsn/vuex-class/)

哈？ 这不是 React + Mobx ？

我们可以看到 vue 的可扩展性是非常强的。恭喜你已经成功进入邪教。23333