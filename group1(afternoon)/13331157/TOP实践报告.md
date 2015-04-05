<p>
&nbsp;&nbsp;&nbsp;&nbsp;刚开始的时候，对于 Thinking Oriented Programming， 对于老师所说的 "What you code is what you think" <br />
是否真的能够实现，还是有疑惑的。只有动手实践，才能真正有所体验和感悟。<br />
</p>
####    1. 工具的重要性
<p>
&nbsp;&nbsp;&nbsp;&nbsp;好的编程工具应该是让我们从复杂繁琐的语法约束中解脱出来，从而只关注方法的实现本身；好的任务运行工具同 <br />
样也应该让我们从繁琐的项目管理，代码编译等工作中解脱出来，我们要做的，应该只是coding, debug,至于不断的刷 <br />
新重启，应该让工具自动帮我们完成开始的时候，总是会想：“真的有变得简单吗？学习LiveScript感觉是学习一门新 <br />
的语言，怎么注释，怎么定义函数，for循环怎么写......GruntJs的配置怎么这么麻烦，一直无法运行......但是我们 <br />
所说的难，也就止于此了。真正熟练起来后，会发现使用这些带来更多的是好处。<br />
</p>
####    2. 自顶向下，逐步求精
<p>
&nbsp;&nbsp;&nbsp;&nbsp;现在回头看自己写lab4的时候，发现其实自己当时的思维是混乱的，处于一种“写一小点调试一小点”，“这样不 <br />
行再试试那样”的状态。“自顶向下”的编程方式能够让自己的思维更加清晰，也使得自己的代码更加易读。 <br />
</p>

```livescript
buttons = $ '.button'
for let item, i in buttons
    item.status = -1                        # status代表按钮的状态, -1 表示按钮为经过点击, 
                                            # 0 表示按钮已点击且正在取数, 1 表示按钮取数完成
    item.onclick =!-> click-on-button item  # 为每个按钮添加 click-on-button 事件

click-on-button = (button)->
    if button.status == 1    # 如果按钮状态为已经完成了点击, 再次点击无效
       return
    if a-button-is-waiting!  # 如果按钮中有正在取数的按钮, 点击无效
        return
    set-status-as-waiting button    # 将按钮状态设置为 waiting
    set-other-as-disable button     # 将其他按钮灭活
    $.get 'http://localhost:3000', (number)!~>
        if button.status === 0
            set-status-as-done button        # 将按钮状态设置为 done
            show-the-number button,number    # 显示获取的数字
            set-other-as-enable button       # 将其他按钮激活
            if all-buttons-done!
                make-bubble-enable!          # 将 bubble(大气泡)激活
```
<p>
&nbsp;&nbsp;&nbsp;&nbsp;上面是点击button的事件代码，当点击发生时，先判断button能否被点击，能够点击，就将按钮的状态设置  <br />
为waiting，将其他按钮的状态设置为disable，然后发送ajax请求，在获取到返回后，将button状态设置为done，<br />
显示number，将其他按钮设置为enable就可以了。至于set-status-as-done, set-other-as-disable这些函数的  <br />
实现，可以先不必管，放在之后实现。这样进行层层分解，到最后会发现一个复杂的任务已经被分解为一些简单  <br />
的小任务，这些小任务的实现已经相当简单了，例如make-bubble-enable的实现：<br />
</p>
```livescript
make-bubble-enable =->          # 将bubble激活
    $ '.info' .remove-class 'disable'
    $ '.info' .add-class 'enable'
```
####    3.怎么想就怎么写？
<p>
&nbsp;&nbsp;&nbsp;&nbsp;个人认为，老师所说的"What you code is what you think", 是建立在对项目有良好的整体认知的前提上 <br />
的。如果在编写程序的过程中没有一个清晰一致的思路，代码在越写越多的同时，也会越来越混乱，在将个功  <br />
能模块进行组合的时候也会令自己陷入痛苦的debug中。因此，在写代码的过程中需要保持清醒，有一个清晰明 <br />
确的思路。
</p>
