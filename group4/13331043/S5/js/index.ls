# @   this
# @@  constructor
# @@@ this.constructor

# 定义按钮类
class Button
    # 存放所有的button
    @buttons = []

    # 类方法
    @disable-other-buttons = (current-button) ->
        # for循环就得有个 [] 
        [button.disable! for button in @buttons when button isnt current-button and button.state isnt 'done']

    # 类方法
    @enable-other-buttons = (current-button) ->
        [button.enable! for button in @buttons when button isnt current-button and button.state isnt 'done' ]

    # 类方法
    @all-button-got-number = ->
        [return false for button in @buttons when button.state isnt 'done']
        $ '#info-bar' .remove-class 'disabled' .add-class 'enabled'
        return true

    # 类方法，用以reset~
    @reset-all-buttons = ->
        [button.reset! for button in @buttons]

    # 构造子
    (@dom, @good-msg, @bad-msg, @callback) ->
        @state = 'enabled' # 状态...
        @request # 用以存放 $.get 对象
        @name = @dom .text!
        # bound methods, which have their definition of `this` bound to the instance
        @dom.click !~> if @state is 'enabled'
            # ! 在箭头前表示没有返回值
            # ! 在定义了的函数后代表执行
            @@@disable-other-buttons @ # 传入当前button
            @wait! # wait with "..."
            @get-number-and-show! # 显示拿到的数
        @@@buttons.push @ # 把当前button push到@buttons数组

    # 以下是实例方法
    get-number-and-show: !->
        # 如果这里写 !-> this是Object
        # 变成!~>的话，在这行增加 var this$ = this
        # random: 分开url地址，方便拿数...
        @request = $.get '/'+Math.random!, (number) !~>
            # 拿到数后回调
            @done!
            @@@all-button-got-number!
            @@@enable-other-buttons @
            @show-number number
            @exception-handler number # 产不产生异常呢？0.0

    show-number: (number) !->
        @dom.find '.unread' .text number

    show-message: !->
        $ '#message' .text "#{@name}: #{@good-msg}"

    exception-handler: (number) !->
        if Math.random! > 0.5
            @show-message!
            @callback error = null, number
        else
            @callback message: @bad-msg, data: number # 传了一个对象进去 error:{message, data}

    disable: !->
        @state = 'disabled'
        @dom.remove-class 'enabled' .add-class 'disabled'

    enable: !->
        @state = 'enabled'
        @dom.remove-class 'disabled' .add-class 'enabled'

    wait: !->
        @state = 'wait'
        @dom.remove-class 'disabled' .add-class 'wait'
        @dom.find '.unread' .text "..."

    done: !->
        @state = 'done'
        @dom.remove-class 'wait' .add-class 'done'

    reset: !->
        @state = 'enabled'
        @request.abort! if @request # 停止正在送数的ajax请求
        @dom.remove-class 'disabled wait done' .add-class 'enabled'
        @dom.find '.unread' .text ''

# 加加加~
calcuator = 
    sum: 0
    add: (number)->
        @sum += parse-int number
    reset: !->
        @sum = 0

robot = 
    init: !->
        @buttons = $ '#control-ring .button'
        @big-bubble = $ '#info-bar'
        @sequence = ['A' to 'E']
        @current = 0
    shuffle-order: !->
        @sequence.sort -> if Math.random! > 0.5 then -1 else 1
    show-order: !->
        order = ''
        [order += i for i in @sequence]
        @big-bubble.find '.info' .text order
    click-next: !->
        if @current is @sequence.length then @big-bubble.click! else
            @get-next-button! .click!
    get-next-button: ->
        next = @sequence[@current].char-code-at! - 'A'.char-code-at!
        @current++
        return @buttons[next]
    click-all: !->
        [(button.click!; Button.enable-other-buttons button; @current++) for button in @buttons]
        @click-next!

reset = !->
    big-bubble = $ '#info-bar'
    calcuator.reset!
    robot.init!
    Button.reset-all-buttons!
    big-bubble.remove-class 'enabled' .add-class 'disabled'
    big-bubble.find '.info' .text ''
    $ '#message' .text ''

# 类似window.onload ...
$ ->
    add-click-to-get-number-with-ajax-to-all-numbers!
    add-click-to-calculate-sum-of-all-buttons-and-show!
    add-reset-to-leave-at-plus-area!

    s1-waiting-user-click!
    s5-independent-behavior!

add-click-to-get-number-with-ajax-to-all-numbers = ->
    good-msg = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
    bad-msg = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪个鬼']
    # let 实现闭包...因为在回调那儿用到了button.name~
    for let btn, i in $ '#control-ring .button'
        # 为什么$(btn)？因为jQuery的get方法只有jQuery对象能用，所以加$
        button = new Button $(btn), good-msg[i], bad-msg[i], (error, number)!->
            if error
                $ '#message' .text "Error! #{button.name}: #{error.message}"
                number = error.data
            calcuator.add number
            if robot.current isnt 0 then robot.click-next!

add-click-to-calculate-sum-of-all-buttons-and-show = ->
    big-bubble = $ '#info-bar'
    big-bubble.add-class 'disabled'
    big-bubble.click !-> if big-bubble.has-class 'enabled'
        big-bubble.find '.info' .text calcuator.sum
        big-bubble.add-class 'disabled'
        $ '#message' .text "楼主异步调用战斗力感人，目测不超过"+calcuator.sum


add-reset-to-leave-at-plus-area = !->
    $ '#at-plus-container' .on 'mouseleave' !->
            reset!

s1-waiting-user-click = !->
    console.log "wait user click..."

s5-independent-behavior = ->
    robot.init!
    $ '#button .apb' .click !->
        robot.shuffle-order!
        robot.show-order!
        robot.click-next!
