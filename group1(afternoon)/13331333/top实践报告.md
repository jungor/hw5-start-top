这次实验要求使用的是top的思想，所以我在开始写代码之前仔细研究过了老师在课堂上展示的代码和细心回想老师上课时的步骤。
刚开始的时候可以说是遇到了很大的麻烦，因为完全不理解livescript的语法，然后自己又想办法去搜资料，最后才大概把这个实验弄了个明白。

首先，我的脑海中出现了老师刚开始所说的3个函数，
click-button-to-get-number
click-infor-bar-to-show-result
move-out-to-reset
这三个函数就囊括了这次实验所需要的操作，由于需要用面向对象的思想来考虑问题，
所以自然会想到需要Button类来封装Button。
而像我之前写的函数，其实就不能算上是面向对象的思想，我是用几个函数来进行操作，虽然结果能够实现出来，但是维护性和可读性却不是很高，而用Button来封装就提高了可读性和维护性。

class Button
    (@dom, @number-got-callback)

这是我一开始想到的构造函数，首先需要自己的一个dom来代表自己的button，而number-got-callback函数则是发送ajax请求后需要执行的回调函数。
然后就开始完善这个构造函数，最后结果得到下面：

(@dom, @number-got-callback) ->
        @state = 'unclicked'
        @dom.add-class 'enabled'
        @dom .find '.unread' .add-class 'hidden'
        @dom.click !~>
            if @dom .has-class 'enabled' and @state is 'unclicked'
                @@@disable-all-other-buttons @
                @wait!
                $.get '/random', (number) !~>
                    @show-number number
                    @@@enable-all-other-buttons @
                    @@@all-number-is-got-callback! if @@@all-button-is-got!
                    @number-got-callback number
        @@@buttons.push @

由于按钮只有点击和不点击两种情况，所以设置状态为"unclicked"和"clicked"。
接下来是对button和unread的设置，由于刚开始unread不可见，所以添加了hidden类名。
点击函数则是发送ajax请求，然后经过一番设置和判断，最后调用number-got-callback回调函数。
由于设置属性等的函数都较为简单，这里不对其进行解释。

和老师一样，我采用了calculator来记录数字的和的结果。
calculator = 
    Sum: 0
    add: (number) -> @Sum += parse-int number
    reset: !-> @Sum = 0

这是生成button对象和回调函数的调用部分：
click-button-to-get-number = !->
    buttons = $ '#control-ring .button'
    for let dom, i in buttons
        button = new Button ($ dom), (number) !->
            calculator.add number

S1和S3的回调函数由于只需将结果加起来，所以该函数不需要参数。

click-button-to-get-number = (next) ->
    buttons = $ '#control-ring .button'
    for let dom, i in buttons
        button = new Button ($ dom), (number) !->
            calculator.add number
            next!

S2和S4的回调函数由于需要在回调的时候执行下一次点击，所以给该函数带上参数，参数则为robot的点击函数。

这里是点击info-bar显示数据的函数：

click-infor-bar-to-show-result = !->
    bubble = $ '#info-bar'
    bubble.add-class 'disabled'
    Button.all-number-is-got-callback = ->
        bubble.remove-class 'disabled' .add-class 'enabled'
    bubble.click !->
        if bubble.has-class 'enabled'
            bubble.remove-class 'enabled' .add-class 'disabled'
            bubble .find '.amount' .text calculator.Sum

这里使用到Button.all-number-is-got-callback的回调函数，需要在每一次ajax请求返回后判断一下是否调用。

move-out-to-reset = !->
    area = $ '#bottom-positioner'
    area .on 'mouseleave' (event) !->
        Button.reset-all!
        $ '#info-bar' .remove-class 'enabled' .add-class 'disabled'
        $ '#info-bar' .find '.amount' .text ''
        $ '#info-bar' .find '.sequence' .text ''
        calculator.reset!

重置部分判断采用的的是一个#bottom-positioner的范围（比#button的范围要大许多），由于我的css的地方写的并不是很好，判断变化的部分采用的是#button:hover的方式，所以在鼠标移到两个按钮之间的时候图标也会缩回（这个部分不属于#button），所以只能采用这种亡羊补牢的方式来看的合理一些。
PS：需要测试重置的时候可以把鼠标移得相对远一点，否则可能会出现不能成功重置的问题。

robot = 
    initial: ->
        @sequence = ['A' to 'E']
        @index = 0
        @buttons = $ '#control-ring .button'
        @bubble = $ '#info-bar'
    disorder-sequence: !->
        @sequence .sort -> Math.random! > 0.5
    show-sequence: !->
        $ '#info-bar' .find '.sequence' .text @sequence.join ', '
    click-button-by-sequence: !->
        if @index is @sequence.length then @bubble.click! else @get-next-button!click!
    get-next-button: ->
        index2 = @sequence[@index++].char-code-at! - 'A'.char-code-at!
        @buttons[index2]

robot机器人部分在看了老师的代码和我自己思考了很久以后，我仍然没有能够想出好的设计方案，不知道从TOP的思想来看的话应该从哪方面着手去思考，自己也写失败过很多次，最后实在没有办法才采用了和老师相类似的方法，如果没有老师的这段代码，我大概是不能写出robot机器人的代码的。

对于S3的机器人代码部分，再次使用之前的button的click函数我认为是不能实现的，因为点击函数发送ajax请求的url都是相同的，所以会出现排队的情况，所以我自己写了一个函数来同时发送ajax请求。
代码如下：
@click-all-button-at-same-time = !->  /*由于S3的要求为同时点击，如果使用click函数的话是做不到的，所以声明了一个函数*/
    index = 0
    bubble = $ '#info-bar'
    for let i from 0 to @buttons.length-1
        @buttons[i].wait!
        $.get '/random'+i, (number) !~>  /*使用不同的url来访问server*/
            @buttons[i].show-number number
            calculator.add parse-int number
            index += 1
            if index is 5
                bubble.add-class 'enabled'
                bubble.click!

对于S5异常处理的部分，我将Button的构造函数进行的修改，把good-messages和bad-messages加上，这样就能在生成对象的时候把message的信息同时保存到button内。

click函数也需要进行修改，随机产生异常情况。

@dom.click !~>  /*点击请求*/
    if @dom .has-class 'enabled' and @state is 'unclicked'
        @@@disable-all-other-buttons @
        @wait!
        $.get '/', (number) !~>
            if Math.random! > @@@fail-rate  /*随机处理失败*/
                @show-number number
                @@@enable-all-other-buttons @
                @show-message!
                @succeed = true
                @@@all-number-is-got-callback! if @@@all-button-is-succeed!  /*判断是否激活info-bar的函数*/
                @number-got-callback error = null, number /*成功时error为null*/
            else
                @number-got-callback message: @bad-messages, data: number /*失败时返回一个error对象*/


click-button-to-get-number = (next) ->
    good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
    bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪']
    buttons = $ '#control-ring .button'
    for let dom, i in buttons
        button = new Button ($ dom), good-messages[i], bad-messages[i], (error, number) !->
            if error  /*若出现处理异常，显示出异常*/
                bubble = $ '#info-bar'
                bubble .find '.speaking' .text "来自#{button.name}的处理错误, 错误信息为: #{error.message}"
                number = error.data
            else   /*不出现处理异常，则正常进行*/
                calculator.add number
                next!

在点击的时候，若出现异常的情况，则会中断这个点击事件，让整个robot停下来

这次的实验我使用了TOP的思想，由于可能是研究老师的代码比较久，所以整个思路有点像老师的代码，这个地方不是很好。
然后通过这次实验，我也了解TOP思想变成的好处，首先是可读性高，其次是维护起来相对简单很多，其他的几个小题都是在S1的基础上修改一下就大概能达成了，而我之前没有使用TOP思想编程的时候为了修改则是花了很大功夫，所以说TOP编程时很有好处的。

尝试的部分大概就是我花了很多时间去搞懂@@@和@的区别，可能是之前的那个实施理解的不是很透彻，所以花了比较多的功夫来弄这个，当时还有几十调试了很多bug，然后再进行修改。