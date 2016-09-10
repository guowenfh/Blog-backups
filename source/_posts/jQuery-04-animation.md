title:  jQuery入门笔记之（四）动画效果
date: 2016-01-01 16:29:11
tags: [jQuery]
categories: [jQuery]
---

## jQuery自带动画效果

### 一. 显示、隐藏

jQuery中`.show()`为显示方法，`.hide()`为隐藏方法。
在无参数的时候，只是硬性的显示内容和隐藏内容。就不用代码来演示了，`.hide()`方法其实就是把对象的css设为`display：none`；而`.show()`方法会保留原来的display值，并进行设置。但是在一些场景中会有所改变，在后面进行说明）。
这两个方法都可以带参数。

先来说明第一个参数：

1. 第一种用法是传入数字，为毫秒数，表示动画过渡效果的时间。里面同时富含了匀速变大变小，以及透明度变换。

```html
<button class="show">显示</button>
<button class="hide">隐藏</button>
    <div id="box">块</div>
<script>
    $(".show").click(function() {
        $("#box").show(1000);//显示用了一秒
    });//可以看到很明显的动画过渡效果。
    $(".hide").click(function() {
        $("#box").hide(1000);
    });
</script>
```
2. 第二种用法是传入一个字符串。"slow"、"normal"和"fast"，分别对应600毫秒、400毫秒和200毫秒。在传入空字符串或其他字符串参数时，默认为400毫秒。
3. 传入一个对象，后面的参数就不能填了，都在对象中。这个比较强大，整合了`show()`方法的多种参数实现效果外，还有一些其他的方法，比如可以动画执行中的状态，来执行函数。比较复杂，而且日常使用的话，现在这个就已经够了，在这里并不做讲述，有兴趣的可以自己参考手册。

**特别注意**：在传入了速度之后，内联元素inline，隐藏显示过后会变成内联块，inline-block。假设你给一个内联元素的css中设置了宽高，本来不生效，但是在执行隐藏显示后宽高生效

第二个参数：为可选参数，easing运动方式，这个参数，大部分参数值需要通过插件来使用，以后再来讲解。自带的参数有两个："swing"(缓动)、"linear"(匀速)，不填时，默认为"swing"。（注意这里传入一个错误参数，会报错）

第三个参数：可选，回调函数，第一个动画执行完毕后执行，实现链式动画。
```html
<button class="show">显示</button>
<button class="hide">隐藏</button>
<div class="test">一</div><div class="test">二</div><div class="test">三</div><div class="test">四</div>
<script>
    $('.show').click(function () {//链式动画，递归自调用
     $('.test').first().show('fast', function testShow() {
         $(this).next(".test").show('fast', testShow);
       });//注意next中的限制条件，不然会干扰其他的元素，执行该函数。
    });
    $('.hide').click(function () {
     $('.test').last().hide('fast', function() {
         $(this).prev(".test").hide('fast', arguments.callee);
       });//这里只是展现有arguments.callee这种方式，并不推荐使用，建议使用函数递归自调用
    });
</script>
```

我们在使用`.show()`和`.hide()`的时候，如果需要一个按钮切换操作，需要进行一些条件判
断。而 jQuery 提供给我们一个类似功能的独立方法：`.toggle()`。使用方法一样。

```javascript
$(".toggle").click(function(){
    $("div").toggle("fast");
});
```


### 二. 滑动、卷动
jQuery 提供了一组改变元素高度的方法：`.slideUp()`、`.slideDown()`和`.slideToggle()`。顾名思义，向上收缩(卷动)和向下展开(滑动)。
```javascript
$('.toggle').click(function () {
    $('div').slideToggle();
});
```
注意：滑动、卷动效果和显示、隐藏效果一样，具有相同的参数。不展开讲

### 三. 淡入、淡出
jQuery 提供了一组专门用于透明度变化的方法：`.fadeIn()`和`.fadeOut()`，分别表示淡入、
淡出，当然还有一个自动切换的方法：`.fadeToggle()`。

但是上面三个透明度方法只能是从 0 到 100，或者从 100 到 0，如果我们想设置指定值就没
有办法了。而 jQuery 为了解决这个问题提供了`.fadeTo()`方法，使透明度到达指定值：

```javascript
$(".toggle").click(function() {
    $("#box").fadeToggle('slow');
});
$(".to").click(function() {
    $("#box").fadeTo('slow', 0.3);//表示30，jQuery中使用的是百分比的形式来设置
});
```
注意：最先点击`to`透明度变成0.3，再点击`toggle`，第一次点击隐藏，第二次点击显示透明度为0.3！（回到原有设置）

淡入、淡出和上面的显示、隐藏效果一样，具有相同参数

## 自定义动画
>jQuery提供了上面几种简单常用的固定动画方面我们使用。但有些时候，这些简单动画无法满足我们更加复杂的需求。这个时候，jQuery 提供了一个`.animate()`方法来创建我们的自定义动画，满足更多复杂多变的要求。
> 强烈建议先看我的[《JavaScript完美运动框架的进阶之旅》](http://guowenfh.github.io/2015/12/21/JS-Animated-Frames/)，使用JS基本实现了自定义动画，只不过jQuery的更加全面完善，当然也更加复杂。

必传参数只有一个，对象，实现动画：
```javascript
$("button").click(function() {
    $("#box").animate({
        width: "200px",
        height: "500px"});
});
```
这段代码已经实现了多重动画同步运动的效果，使用键值对的方式，来表明运动动画终点的位置。在实现上下左右移动时，需要结合CSS，把物体属性设置绝对定位！

第二个参数，可选，使用字符串时如同上面一样的3个值表示不同的时间（默认400ms），数字类型时，使用毫秒方式。直接跟在第一个参数之后就好
第三个参数，可选，也和上面一样，easing运动方式，自带的参数有两个："swing"(缓动)、"linear"(匀速)，不填时，默认为"swing"。（注意这里传入一个错误参数，会报错）
第四个参数，可选，回调函数，在动画执行完毕后执行，可实现链式动画。

下面进行一些特殊的说明：

自定义动画中，每次开始运动都必须是初始位置或初始状态，而有时我们想通过当前位置或状态下再进行动画。jQuery 提供了自定义动画的累加、累减功能。
```javascript
$("button").click(function() {
    $("#box").animate({//必须先设置CSS的绝对定位。
        left:"+=100px"
    });
});
```

主要是说一下自定义动画中的链式动画，有两种形式：

1. 在回调函数中再执行一个动画，这个没什么好说的。
2. 通过连缀或顺序来实现链式动画。


通过依次顺序实现链式动画

```javascript
$('button').click(function () {
    $('#box').animate({'left' : '100px'});
    $('#box').animate({'top' : '100px'});
    $('#box').animate({'width' : '300px'});
});
```
**注意：如果不是同一个元素，就会实现同步动画**

通过连缀实现链式动画

```javascript
$('button').click(function () {
    $('#box').animate({'left' : '100px'})
    .animate({'top' : '100px'})
    .animate({'width' : '300px'});
});
```


## 链式动画进阶

之前我们已经可以实现链式动画了，如果是同一个元素，可以依次顺序或连缀调用。如果是不同元素，可以使用回调函数。但有时链式动画太多，回调函数的可读性大大降低。为此，jQuery 提供了一组专门用于链式动画的方法。

`$('#box').slideUp('slow').slideDown('slow').css('background', 'orange');`这段代码中，css方法会在一开始就执行。因为动画方法可以用连缀来实现依次排列，但是css方法不是，会在一开始传入队列之前。如何解决呢？回调函数当然可以实现。
```javascript
$('button').click(function () {
    $('#box').slideUp('slow').slideDown('slow',function (){
        $(this).css('background', 'orange');
    });
});
```

这当然没问题，但是那并不是我们应该做的，因为这样可读性太差了，链式动画一多呢？原本的动画都不清晰了吧？jQuery为我们实现了一个类似回调函数的方法：`.queue()`。jQuery 的`.queue()`的回调函数可以传递一个参数，这个参数是 next 函数，在结尾处调用这个 next()方法即可再连缀执行列队动画。（不这样使用的话，后续动画效果无法实现）

```javascript
$('button').click(function () {//在同一个元素直接这样写就可以了。
    $('#box').slideUp('slow')
                .slideDown('slow')
                .queue(function (next) {
                    $(this).css('background', 'orange');
                    //next();//animate的动画效果不会生效，因为把next()注释掉了。
                })
                .animate({//记得设置绝对定位
                    height: "200px",
                    left: "100px"
                });
});
```

`.queue()`方法还有一个功能，就是可以得到当前链式动画剩余的长度（包括当前的动画）。fx 是默认链条的参数。
```javascript
//把上面的代码的第一个动画改装成如下模样时，会弹出4。
$('#box').slideUp('slow',function  (){
    alert($(this).queue('fx').length);
})
```

jQuery 还提供了一个清理链式动画的功能方法：`.clearQueue()`。把它放入一个链式的回调函数或`.queue()`方法里，就可以把剩下未执行的链条给截断。
```javascript
//清理后续链式调用
$('#box').slideDown('slow', function () {$(this).clearQueue()});
```


## 动画相关方法与全局属性

**停止动画**
有很多时候，我们需要停止正在运行中的动画，jQuery中为此提供了一个`.stop()`方法。
它有三个**可选参数**：
1. queue        类型: String   停止链式动画的名称。（比较少用到，若存在，后两个参数都是指向该链式动画）
2. clearQueue类型: Boolean一个布尔值，指示是否取消后续的链式动画。默认 false.
3. jumpToEnd 类型: Boolean一个布尔值指示是否当前动画立即完成。默认false.

说明：
1. 在无参数，且为链式动画时，调用`.stop()`方法，只是立即停止当前正在进行的动画，后续动画继续执行。
2. 传入一个true时，立即停止动画，并且清空后续所有动画。
3. 传入2个true时，立即停止，并且跳转到当前动画的结束位置，后续动画也不再执行。

代码如下：有兴趣的自行测试
```html
<button class="start">动画</button>
<button class="stop">停止</button>
<div style="position: absolute;height: 50px;width: 50px;background-color: #0B71E6;top:30px">12</div>
<script type="text/javascript">
    $('.start').click(function () {
        $('div').animate({'left' : '300px'}, 1000)
                 .animate({'top' : '300px'}, 1000)
                 .animate({ 'width' : '300px'}, 1000)
                 .animate({'height' : '300px'}, 1000);
    });
    $(".stop").click(function() {
        $("div").stop(true,true);
    });
</script>
```

**延迟动画**
有时在执行动画或链式动画时，需要在运动之前有延迟执行，jQuery 为此提供了`.delay()`方法。参数为延迟时间，单位为毫秒数。这个方法可以在动画之前设置延迟，也可 、以在列队动画中间加上。直接在上面代码任意地方加都可以，比较简单，自行测试吧。



**获取正在进行的动画**
在选择器的那篇文章中中，我们提到过一个过滤器`:animated`，这个过滤器可以判断出当前运动的动画是哪个元素。通过这个特点，我们可以避免由于用户快速在某个元素执行动画时，由于动画积累而导致的动画和用户的行为不一致。

对上面代码进行一些改造,将原div进行复制，添加到其后，给原div添加一个id并且在动画效果中改为该元素运动
```javascript
$('.stop').click(function(){
    $('div:animated').stop().css('background', 'red');
        //可以看到只有运动的div背景变色，而未移动的div不改变背景色。
});
```

**动画全局属性**
jQuery 提供了两种全局设置的属性，分别为：`$.fx.interval`，设置每秒运行的帧数；`$.fx.off`，关闭页面上所有的动画。

`$.fx.interval` 属性可以调整动画每秒的运行帧数，默认为 13 毫秒。数字越小越流畅，但可能影响浏览器性能。
设置运行帧数为 1000 毫秒：`$.fx.interval = 1000; `

设置动画为关闭 true：`$.fx.off = true;`默认为false
