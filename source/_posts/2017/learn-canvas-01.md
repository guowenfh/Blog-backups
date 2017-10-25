title: 从零学习 canvas (一)
date: 2017-10-24 23:10:49
tags: [canvas]
categories: [前端技术]
---

> 由于上一篇描述的原因。有图像处理的需求，于是我就开始学习 canvas 啦，和以前的一样，这一篇也是一边学一边写，敲出来的。有不正确的地方，欢迎指出。
> canvas 本身的 api 描述是比较简单，但是衍生出来的东西，操作，图像处理，动画，性能，还是非常的多的。所以对于 canvas 的学习不出意外的话，将会是一个系列。这就是第一篇了。下面就开始吧

## 前言

```html
<canvas id="canvas" style="background:blue;">浏览器不支持canvas</canvas>
```

在不支持 canvas 的浏览器中，显示标签中的内容。
绘图区域 默认是 300 x 150。
canvas 中的宽高是实际的宽高，css 中的宽高会等比缩放。
在开始绘图之前需要先，获取绘图环境。

```js
const canvas = document.querySelector('#canvas');
if(canvas.getContext){
    const context = canvas.getContext('2d');
    // .... 绘制
}
```

<!-- more -->

## API

### **绘制方块**

- `fillRect(x, y, width, height)`：绘制矩形，默认黑色
- `strokeRect(x, y, width, height)`：带边框的矩形，默认黑色，默认 1px 。但是显示出来可能有区别
- `clearRect(x, y, width, height)`
清除指定矩形区域，让清除部分完全透明。
```js
{
// 边框实际上被加粗了
context.strokeRect(100,100,50,50);
// 正常边框 1px
context.strokeRect(160.5,160.5,50,50); 
}
```

### **设置绘图样式**

- `fillStyle = color`: 填充颜色（绘制 canvas 是有顺序的）
- `lineWidth = value`:  线宽度，是一个数值
- `strokeStyle = color`:边线颜色

```js
{
context.strokeStyle='rgba(0,0,255,0.5)';
context.lineWidth=5;
// 调整 fillRect／ strokeRect 的顺序将有不一样的表现
context.strokeRect(160.5,160.5,50,50);
context.fillRect(160.5,160.5,50,50);
}
```

### **边界绘制**

- `lineJoin = type`:边界连接点样式
    - miter/默认;round/圆角;bevel/斜角
- `lineCaP = type`:端点样式
    - butt/默认;round/圆角;square/高度多出未为宽一半的值

### **绘制路径**

- `beginPath()`:开始绘制路径
- `closePath()`:结束绘制路径（,不是必需的）
- `moveTo(x,y)`:移动到绘制的点，坐标x以及y
- `lineTo(x,y)`:绘制一条从当前位置到指定x以及y位置的直线。
- `fill()`: 填充
- `stroke()`: 边框


```js
{
context.beginPath();
context.moveTo(100,100);
context.lineTo(150,100);
context.lineTo(100,150);
context.closePath();
// 填充
context.fill();
// 边框
context.stroke();
}
```


### **绘制弧**

- `arc(x, y, radius, startAngle, endAngle, anticlockwise)`:绘制圆
    - x,y 起始坐标点，radius 半径大小。
    - startAngle ，endAngle。 圆弧的起始与结束，x轴方向开始计算，单位以弧度表示。弧度 = 角度 * Math.PI/180
    - anticlockwise 可选的Boolean值 ，如果为 true，逆时针绘制圆弧，反之，顺时针绘制。
- `arcTo(x1, y1, x2, y2, radius)`:根据给定的控制点和半径画一段圆弧，再以直线连接两个控制点.(不建议使用。)
- `quadraticCurveTo(cp1x, cp1y, x, y)`:绘制二次贝塞尔曲线，cp1x,cp1y为一个控制点，x,y为结束点。
- `bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y)`
绘制三次贝塞尔曲线，cp1x,cp1y为控制点一，cp2x,cp2y为控制点二，x,y为结束点


```js
{
context.moveTo(200,200);
context.arc(200,200,150,0,90 * Math.PI / 180, true);
// context.closePath();
context.stroke();

context.moveTo(100,150);
context.arcTo(100,100,200,100,50);
context.stroke();

// 贝塞尔曲线
context.beginPath();
context.moveTo(75,25);
context.quadraticCurveTo(25,25,25,62.5);
context.quadraticCurveTo(25,100,50,100);
context.quadraticCurveTo(50,120,30,125);
context.quadraticCurveTo(60,120,65,100);
context.quadraticCurveTo(125,100,125,62.5);
context.quadraticCurveTo(125,25,75,25);
context.stroke();
}
```

### **状态的保存与恢复**

- `save()`:保存路径
- `restore()`:恢复路径


### **变换**

- `translate(x, y)`:偏移。x 是左右偏移量，y 是上下偏移量，如右图所示。
- `rotate(angle)`: 旋转。旋转的角度(angle)，它是顺时针方向的，以弧度为单位的值。
- `scale(x, y)` :缩放。x,y 分别是横轴和纵轴的缩放因子，它们都必须是正值。值比 1.0 小表示缩小，比 1.0 大则表示放大，值为 1.0 时什么效果都没有。
- `transform(m11, m12, m21, m22, dx, dy)`

```js
context.translate(200,100);
context.rotate(Math.PI / 180 * 30);
context.scale(1.6,1);
context.fillRect(10,10,50,50);
```

## 实例


### 画板

![画板](https://ws2.sinaimg.cn/large/006tNc79gy1fktr36cym6j30l40c0t8y.jpg)

```js
(function(){
    document.body.innerHTML='<canvas id="canvas" width="1000" height="1000">浏览器不支持</canvas>';
    var canvas = document.querySelector('#canvas');
    if(!canvas.getContext) return;
    var context = canvas.getContext('2d');
    function move(ev){
        const left = ev.clientX - canvas.offsetLeft;
        const top = ev.clientY - canvas.offsetTop;
        context.lineTo(left,top);
        context.stroke();
    }
    canvas.addEventListener('mousedown',(ev)=>{
        const left = ev.clientX - canvas.offsetLeft;
        const top = ev.clientY - canvas.offsetTop;
        context.moveTo(left,top);
        document.addEventListener('mousemove',move);
    })
    document.addEventListener('mouseup',()=>{
        document.removeEventListener('mousemove',move);
    })
})();
```

### 旋转的小方块

![旋转的小方块](https://ws4.sinaimg.cn/large/006tNc79gy1fktr2ctu8tj30kw0f8jrk.jpg)

```js
(function(){
    document.body.innerHTML='<canvas id="canvas" width="1000" height="1000">浏览器不支持</canvas>';
    var canvas = document.querySelector('#canvas');
    if(!canvas.getContext) return;
    var context = canvas.getContext('2d');
    let num = 0;
    let num2 = 0;
    let value = 1;
    // context.moveTo(200,200);
    context.translate(200,200);
    function start(){
        num++;
        context.save();
        context.fillStyle="#fff";
        context.fillRect(-200, -200, canvas.width, canvas.height);
        if(num2===100){
            value = -1;
        }else if(num2===0){
            value = 1;
        }
        num2 += value;
        context.scale(num2 / 50,num2 / 50);
        context.rotate(num * Math.PI / 180);
        context.translate(-50,-50);
        context.fillStyle="#000";
        context.fillRect(0,0,100,100);
        context.restore();
        requestAnimationFrame(start);
    }
    start();
})();
```

### 时钟

![](https://ws2.sinaimg.cn/large/006tNc79gy1fktr3jexbaj30ou0kk3z8.jpg)

```js
(function() {
    document.body.innerHTML='<canvas id="canvas" width="1000" height="1000">浏览器不支持</canvas>'
    const canvas = document.querySelector('#canvas');
    if (!canvas.getContext) return;
    let context = canvas.getContext('2d');
    function time() {
        context.clearRect(0, 0, canvas.width, canvas.height);
        let x = 200;
        let y = 200;
        let r = 150;
        // 绘制秒的刻度
        context.lineWidth = 1;
        context.beginPath();
        Array(60).fill(0).forEach((item, index) => {
            context.moveTo(x, y);
            context.arc(x,y,r,6 * index * Math.PI / 180,6 * (index + 1) * Math.PI / 180,false);
        });
        context.closePath();
        context.stroke();
        // 清空中间的部分
        context.fillStyle = '#fff';
        context.beginPath();
        context.moveTo(x, y);
        context.arc(x, y, r * 20 / 21, 0, 360 * Math.PI / 180, false);
        context.closePath();
        context.fill();

        // 绘制分钟刻度
        context.lineWidth = 2;
        context.beginPath();
        Array(12).fill(0).forEach((item, index) => {
            context.moveTo(x, y);
            context.arc(x,y,r,30 * index * Math.PI / 180,30 * (index + 1) * Math.PI / 180,false);
        });
        context.closePath();
        context.stroke();

        context.fillStyle = '#fff';
        context.beginPath();
        context.moveTo(x, y);
        context.arc(x, y, r * 19 / 21, 0, 360 * Math.PI / 180, false);
        context.closePath();
        context.fill();

        // 计算时针，分针，秒针的旋转角度
        var date = new Date();
        var hour = date.getHours();
        var minute = date.getMinutes();
        var second = date.getSeconds();
        var hourValue = (-90 + hour * 30 + minute / 2 + second / 60) * Math.PI / 180;
        var minuteValue = (-90 + minute * 6 + second / 12) * Math.PI / 180;
        var secondValue = (-90 + second * 6) * Math.PI / 180;

        // 小时
        context.lineWidth = 4;
        context.beginPath();
        context.moveTo(x, y);
        context.arc(x, y, r * 8 / 21, hourValue, hourValue, false);
        context.closePath();
        context.stroke();
        // 分
        context.lineWidth = 2;
        context.beginPath();
        context.moveTo(x, y);
        context.arc(x, y, r * 15 / 21, minuteValue, minuteValue, false);
        context.closePath();
        context.stroke();
        // 秒
        context.beginPath();
        context.moveTo(x, y);
        context.arc(x, y, r * 18 / 21, secondValue, secondValue, false);
        context.closePath();
        context.stroke();
        // 重新开始
        setTimeout(time, 1000);
    }
    time();
})();
```

