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
    (@dom, @callback) ->
        @state = 'enabled' # 状态...
        @request # 用以存放 $.get 对象
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
            @callback number # 将值存到calculator当中
            @@@enable-other-buttons @
            @show-number number

    show-number: (number) !->
        @dom.find '.unread' .text number

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

# 类似window.onload ...
$ ->
    add-click-to-get-number-with-ajax-to-all-numbers!
    add-click-to-calculate-sum-of-all-buttons-and-show!
    add-reset-to-leave-at-plus-area!

    s1-waiting-user-click!

add-click-to-get-number-with-ajax-to-all-numbers = ->
    for btn in $ '#control-ring .button'
        # 为什么$(btn)？因为jQuery的get方法只有jQuery对象能用，所以加$
        button = new Button $(btn), (number)!->
            calcuator.add number

add-click-to-calculate-sum-of-all-buttons-and-show = ->
    big-bubble = $ '#info-bar'
    big-bubble.add-class 'disabled'
    big-bubble.click !-> if big-bubble.has-class 'enabled'
        big-bubble.find '.info' .text calcuator.sum
        big-bubble.add-class 'disabled'

add-reset-to-leave-at-plus-area = !->
    $ '#at-plus-container' .on 'mouseleave' !->
            reset!

reset = !->
    big-bubble = $ '#info-bar'
    calcuator.reset!
    Button.reset-all-buttons!
    big-bubble.remove-class 'enabled' .add-class 'disabled'
    big-bubble.find '.info' .text ''

s1-waiting-user-click = !->
    console.log "wait user click..."
