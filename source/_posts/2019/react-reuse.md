title: 从一个简单功能的实现，谈谈 react 中的逻辑复用进化过程
date: 2019-09-17 21:36:00
tags: [react]
categories: [react,前端技术]
---

> 需求：我们现在有一个获取验证码的按钮，需要在点击后禁用，并且在按钮上显示倒计时60秒才可以进行第二次点击。
> 本篇文章通过对这个需求的八种实现方式来讨论在  react 中的逻辑复用的进化过程

![](https://tva1.sinaimg.cn/large/006y8mN6ly1g72u9uxyqyj30k00zl0u8.jpg)

代码例子放在了 codesandbox 上。

[![Edit react-loading-button](https://codesandbox.io/static/img/play-codesandbox.svg)](https://codesandbox.io/s/kind-herschel-l4f9h?fontsize=14)

### 方案一 使用 setInterval

```jsx
import React from 'react'

export default class LoadingButtonInterval extends React.Component {
  state = {
    loading: false,
    btnText: '获取验证码',
    totalSecond: 10
  }
  timer = null
  componentWillUnmount() {
    this.clear()
  }
  clear = () => {
    clearInterval(this.timer)

    this.setState({
      loading: false,
      totalSecond: 10
    })
  }
  setTime = () => {
    this.timer = setInterval(() => {
      const { totalSecond } = this.state
      if (totalSecond <= 0) {
        this.clear()
        return
      }
      this.setState(() => ({
        totalSecond: totalSecond - 1
      }))
    }, 1000)
  }
  onFetch = () => {
    this.setState(() => ({ loading: true }))
    const { totalSecond } = this.state
    this.setState(() => ({
      totalSecond: totalSecond - 1
    }))
    this.setTime()
  }
  render() {
    const { loading, btnText, totalSecond } = this.state
    return (
      <button disabled={loading} onClick={this.onFetch}>
        {!loading ? btnText : `请等待${totalSecond}秒..`}
      </button>
    )
  }
}


```

### 方案二 使用 setTimeout

```jsx
import React from 'react'

export default class LoadingButton extends React.Component {
  state = {
    loading: false,
    btnText: '获取验证码',
    totalSecond: 60
  }
  timer = null

  componentWillUnmount() {
    this.clear()
  }
  clear = () => {
    clearTimeout(this.timer)

    this.setState({
      loading: false,
      totalSecond: 60
    })
  }
  setTime = () => {
    const { totalSecond } = this.state
    if (totalSecond <= 0) {
      this.clear()
      return
    }
    this.setState({
      totalSecond: totalSecond - 1
    })
    this.timer = setTimeout(() => {
      this.setTime()
    }, 1000)
  }
  onFetch = () => {
    this.setState(() => ({ loading: true }))
    this.setTime()
  }
  render() {
    const { loading, btnText, totalSecond } = this.state
    return (
      <button disabled={loading} onClick={this.onFetch}>
        {!loading ? btnText : `请等待${totalSecond}秒..`}
      </button>
    )
  }
}
```

我们可能很快就写出来两个这样的组件。使用 setTimeout 还是 setInterval 区别不是特别大。 但是我会更推荐 setTimeout 因为 万物皆递归（逃）

不过，又有更高的要求了。可以看到刚刚我们的获取验证码。如果说再有一个页面有相同的需求，只能将组件完全再拷贝一遍。这肯定不合适嘛。

那咋办嘛？

### 方案三 参数提取到 Props 1

```jsx
import React from "react";
class LoadingButtonProps extends React.Component {
  constructor(props) {
    super(props);
    this.initState = {
      loading: false,
      btnText: this.props.btnText || "获取验证码",
      totalSecond: this.props.totalSecond || 60
    };
    this.state = { ...this.initState };
  }
  timer = null;
  componentWillUnmount() {
    this.clear();
  }
  clear = () => {
    clearTimeout(this.timer);
    this.setState({
      ...this.initState
    });
  };
  setTime = () => {
    const { totalSecond } = this.state;
    if (totalSecond <= 0) {
      this.clear();
      return;
    }
    this.setState({
      totalSecond: totalSecond - 1
    });
    this.timer = setTimeout(() => {
      this.setTime();
    }, 1000);
  };
  onFetch = () => {
    const { loading } = this.state;
    if (loading) return;
    this.setState(() => ({ loading: true }));
    this.setTime();
  };
  render() {
    const { loading, btnText, totalSecond } = this.state;
    return (
      <button disabled={loading} onClick={this.onFetch}>
        {!loading ? btnText : `请等待${totalSecond}秒..`}
      </button>
    );
  }
}

class LoadingButtonProps1 extends React.Component {
  render() {
    return <LoadingButtonProps btnText={"获取验证码1"} totalSecond={10} />;
  }
}
class LoadingButtonProps2 extends React.Component {
  render() {
    return <LoadingButtonProps btnText={"获取验证码2"} totalSecond={20} />;
  }
}

export default () => (
  <div>
    <LoadingButtonProps1 />
    <LoadingButtonProps2 />
  </div>
);

```

对于上面的需求，不就是复用嘛，看我 props 提取到公共父组件一把梭搞定！
想想好像还挺美的。。

结果这时候需求变更来了：

第一点：两个地方获取验证码的api不一样。第二点：我需要在获取验证码之前做一些别的事情

挠了挠头，那咋办嘛？

### 方案四 参数提取到 Props 2

```jsx
import React from 'react'

class LoadingButtonProps extends React.Component {
  // static defaultProps = {
  //   loading: false,
  //   btnText: '获取验证码',
  //   totalSecond: 10,
  //   onStart: () => {},
  //   onTimeChange: () => {},
  //   onReset: () => {}
  // }
  timer = null
  componentWillUnmount() {
    this.clear()
  }
  clear = () => {
    clearTimeout(this.timer)
    this.props.onReset()
  }
  setTime = () => {
    const { totalSecond } = this.props
    console.error(totalSecond)
    if (this.props.totalSecond <= 0) {
      this.clear()
      return
    }
    this.props.onTimeChange()
    this.timer = setTimeout(() => {
      this.setTime()
    }, 1000)
  }
  onFetch = () => {
    if (this.loading) return
    this.setTime()
    this.props.onStart()
  }
  render() {
    return <div onClick={this.onFetch}>{this.props.children}</div>
  }
}

class LoadingButtonProps1 extends React.Component {
  totalSecond = 10
  state = {
    loading: false,
    btnText: '获取验证码1',
    totalSecond: this.totalSecond
  }
  onTimeChange = () => {
    const { totalSecond } = this.state
    this.setState(() => ({ totalSecond: totalSecond - 1 }))
  }
  onReset = () => {
    this.setState({
      loading: false,
      totalSecond: this.totalSecond
    })
  }
  onStart = () => {
    this.setState(() => ({ loading: true }))
  }
  render() {
    const { loading, btnText, totalSecond } = this.state
    return (
      <LoadingButtonProps
        loading={loading}
        totalSecond={totalSecond}
        onStart={this.onStart}
        onTimeChange={this.onTimeChange}
        onReset={this.onReset}
      >
        <button disabled={loading}>
          {!loading ? btnText : `请等待${totalSecond}秒..`}
        </button>
      </LoadingButtonProps>
    )
  }
}
class LoadingButtonProps2 extends React.Component {
  totalSecond = 15
  state = {
    loading: false,
    btnText: '获取验证码2',
    totalSecond: this.totalSecond
  }
  onTimeChange = () => {
    const { totalSecond } = this.state
    this.setState(() => ({ totalSecond: totalSecond - 1 }))
  }
  onReset = () => {
    this.setState({
      loading: false,
      totalSecond: this.totalSecond
    })
  }
  onStart = () => {
    this.setState(() => ({ loading: true }))
  }
  render() {
    const { loading, btnText, totalSecond } = this.state
    return (
      <LoadingButtonProps
        loading={loading}
        totalSecond={totalSecond}
        onStart={this.onStart}
        onTimeChange={this.onTimeChange}
        onReset={this.onReset}
      >
        <button disabled={loading}>
          {!loading ? btnText : `请等待${totalSecond}秒..`}
        </button>
      </LoadingButtonProps>
    )
  }
}
export default () => (
  <div>
    <LoadingButtonProps1 />
    <LoadingButtonProps2 />
  </div>
)

```

嗯？等等。。所以说这样的操作只共用了时间递归减少的部分吧？好像重复代码有点多哇，感觉和老版本也没什么太大的区别嘛。

那咋办嘛？

### 方案五 试试 Hoc

```jsx
import React from 'react'

function loadingButtonHoc(WrappedComponent, initState) {
  return class extends React.Component {
    constructor(props) {
      super(props)
      this.initState = initState || {
        loading: false,
        btnText: '获取验证码',
        totalSecond: 60
      }
      this.state = { ...this.initState }
    }
    timer = null

    componentWillUnmount() {
      this.clear()
    }
    clear = () => {
      clearTimeout(this.timer)

      this.setState({
        ...this.initState
      })
    }
    setTime = () => {
      const { totalSecond } = this.state
      if (totalSecond <= 0) {
        this.clear()
        return
      }
      this.setState({
        totalSecond: totalSecond - 1
      })
      this.timer = setTimeout(() => {
        this.setTime()
      }, 1000)
    }
    onFetch = () => {
      const { loading } = this.state
      if (loading) return
      this.setState(() => ({ loading: true }))
      this.setTime()
    }
    render() {
      const { loading, btnText, totalSecond } = this.state
      return (
        <WrappedComponent
          {...this.props}
          onClick={this.onFetch}
          loading={loading}
          btnText={btnText}
          totalSecond={totalSecond}
        />
      )
    }
  }
}
class LoadingButtonHocComponent extends React.Component {
  render() {
    const { loading, btnText, totalSecond, onClick } = this.props
    return (
      <button disabled={loading} onClick={onClick}>
        {!loading ? btnText : `请等待${totalSecond}秒..`}
      </button>
    )
  }
}
const LoadingButtonHocComponent1 = loadingButtonHoc(LoadingButtonHocComponent, {
  loading: false,
  btnText: '获取验证码Hoc1',
  totalSecond: 20
})
const LoadingButtonHocComponent2 = loadingButtonHoc(LoadingButtonHocComponent, {
  loading: false,
  btnText: '获取验证码Hoc2',
  totalSecond: 12
})
export default () => (
  <div>
    <LoadingButtonHocComponent1 />
    <LoadingButtonHocComponent2 />
  </div>
)

```

我们使用 高阶组件再次重写了整个逻辑。好像基本上需求都满足了？

### 方案六 renderProps

```jsx

import React from 'react'
class LoadingButtonRenderProps extends React.Component {
  constructor(props) {
    super(props)
    this.initState = {
      loading: false,
      btnText: this.props.btnText || '获取验证码',
      totalSecond: this.props.totalSecond || 60
    }
    this.state = { ...this.initState }
  }
  timer = null

  componentWillUnmount() {
    this.clear()
  }
  clear = () => {
    clearTimeout(this.timer)

    this.setState({
      ...this.initState
    })
  }
  setTime = () => {
    const { totalSecond } = this.state
    if (totalSecond <= 0) {
      this.clear()
      return
    }
    this.setState({
      totalSecond: totalSecond - 1
    })
    this.timer = setTimeout(() => {
      this.setTime()
    }, 1000)
  }
  onFetch = () => {
    const { loading } = this.state
    if (loading) return
    this.setState(() => ({ loading: true }))
    this.setTime()
  }
  render() {
    const { loading, btnText, totalSecond } = this.state
    return this.props.children({
      onClick: this.onFetch,
      loading: loading,
      btnText: btnText,
      totalSecond: totalSecond
    })
  }
}
class LoadingButtonRenderProps1 extends React.Component {
  render() {
    return (
      <LoadingButtonRenderProps btnText={'获取验证码RP1'} totalSecond={15}>
        {({ loading, btnText, totalSecond, onClick }) => (
          <button disabled={loading} onClick={onClick}>
            {!loading ? btnText : `请等待${totalSecond}秒..`}
          </button>
        )}
      </LoadingButtonRenderProps>
    )
  }
}
class LoadingButtonRenderProps2 extends React.Component {
  render() {
    return (
      <LoadingButtonRenderProps btnText={'获取验证码RP1'} totalSecond={8}>
        {({ loading, btnText, totalSecond, onClick }) => (
          <button disabled={loading} onClick={onClick}>
            {!loading ? btnText : `请等待${totalSecond}秒..`}
          </button>
        )}
      </LoadingButtonRenderProps>
    )
  }
}

export default () => (
  <div>
    <LoadingButtonRenderProps1 />
    <LoadingButtonRenderProps2 />
  </div>
)
```

嘿嘿，我们使用了 render Props 重写了在 Hoc 上实现的功能。个人角度看，其实比Hoc 会简洁也优雅很多！


### 方案七 React Hooks


```jsx
import React, { useState, useEffect, useRef, useCallback } from 'react'
function LoadingButtonHooks(props) {
  const timeRef = useRef(null)
  const [loading, setLoading] = useState(props.loading)
  const [btnText, setBtnText] = useState(props.btnText)
  const [totalSecond, setTotalSecond] = useState(props.totalSecond)
  const countRef = useRef(totalSecond)
  const clear = useCallback(() => {
    clearTimeout(timeRef.current)
    setLoading(false)
    setTotalSecond(props.totalSecond)
    countRef.current = props.totalSecond
  })
  const setTime = useCallback(() => {
    if (countRef.current <= 0) {
      clear()
      return
    }
    countRef.current = countRef.current - 1
    setTotalSecond(countRef.current)

    timeRef.current = setTimeout(() => {
      setTime()
    }, 1000)
  })
  const onStart = useCallback(() => {
    if (loading) return
    countRef.current = totalSecond
    setLoading(true)
    setTime()
  })

  useEffect(() => {
    return () => {
      clearTimeout(timeRef.current)
    }
  }, [])
  return (
    <button disabled={loading} onClick={onStart}>
      {!loading ? btnText : `请等待${totalSecond}秒..`}
    </button>
  )
}
LoadingButtonHooks.defaultProps = {
  loading: false,
  btnText: '获取验证码',
  totalSecond: 10
}
export default () => (
  <div>
    <LoadingButtonHooks
      loading={false}
      btnText={'获取验证码hooks1'}
      totalSecond={10}
    />
    <LoadingButtonHooks
      loading={false}
      btnText={'获取验证码hooks2'}
      totalSecond={11}
    />
  </div>
)
```

我们使用 hooks 重写了整个程序， 它让我们把ui和状态更明确的区分开，也去解决了一些 renderProps 在多层嵌套时的jsx 嵌套地狱问题， 当然个人感觉在这个例子上好像 Hooks 与 renderProps 版本是差别不大的。

### 方案八 uesHooks

```jsx
import React, { useState, useEffect, useRef, useCallback } from 'react'
function useLoadingTimer(initState) {
  const timeRef = useRef(null)
  const [loading, setLoading] = useState(initState.loading)
  const [btnText, setBtnText] = useState(initState.btnText)
  const [totalSecond, setTotalSecond] = useState(initState.totalSecond)
  const countRef = useRef(totalSecond)
  const clear = useCallback(() => {
    clearTimeout(timeRef.current)
    setLoading(false)
    setTotalSecond(initState.totalSecond)
    countRef.current = initState.totalSecond
  })
  const setTime = useCallback(() => {
    if (countRef.current <= 0) {
      clear()
      return
    }
    countRef.current = countRef.current - 1
    setTotalSecond(countRef.current)

    timeRef.current = setTimeout(() => {
      setTime()
    }, 1000)
  })
  const onStart = useCallback(() => {
    if (loading) return
    countRef.current = totalSecond
    setLoading(true)
    setTime()
  })

  useEffect(() => {
    return () => {
      clearTimeout(timeRef.current)
    }
  }, [])
  return {
    onStart,
    loading,
    totalSecond,
    btnText
  }
}
const LoadingButtonHooks1 = () => {
  const { onStart, loading, totalSecond, btnText } = useLoadingTimer({
    loading: false,
    btnText: '获取验证码UseHooks1',
    totalSecond: 10
  })
  return (
    <button disabled={loading} onClick={onStart}>
      {!loading ? btnText : `请等待${totalSecond}秒..`}
    </button>
  )
}
const LoadingButtonHooks2 = () => {
  const { onStart, loading, totalSecond, btnText } = useLoadingTimer({
    loading: false,
    btnText: '获取验证码UseHooks2',
    totalSecond: 10
  })
  return (
    <button disabled={loading} onClick={onStart}>
      {!loading ? btnText : `请等待${totalSecond}秒..`}
    </button>
  )
}
export default () => (
  <div>
    <LoadingButtonHooks1 />
    <LoadingButtonHooks2 />
  </div>
)

```
当然，更解耦的做法是，把 hooks 完全独立的提取出来成 useHooks ，最后我们再编写组件去组合 uesHooks。


在上述的例子中我们在 react 中用了 8 种 不同的方案，去描述了同一个功能的编写过程。有一点 “回” 字的多种写法的意味。不过他也代表着 react 社区在选择实现上的思想的变化过程，我觉得谈不上某一个方案，一定就完全比另外一个好。社区也有比如 HOC vs renderProps 的很多讨论。

仅以此希望大家能够辩证的去看这个过程，也希望能够在大家编写 React 组件时带来更多的新思路。



参考链接：

- [React 中文官网 Hook 简介](https://zh-hans.reactjs.org/docs/hooks-intro.html)