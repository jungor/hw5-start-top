class Button
    /*构造函数添加了good-messages和bad-messages*/
    (@dom, @good-messages, @bad-messages, @number-got-callback) ->
        @state = 'unclicked'
        @succeed = false
        @dom.add-class 'enabled'
        @name = @dom.text!
        @dom .find '.unread' .add-class 'hidden'
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
        @@@buttons.push @  /*构造时放入buttons数组*/
    @buttons = []
    @fail-rate = 0.2
    @disable-all-other-buttons = (this-button) !-> /*将其他按钮全部禁用*/
        [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'clicked']
    @enable-all-other-buttons = (this-button) !->  /*将其他按钮全部恢复*/
        [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'clicked']
    /*这个函数为S1-S4时所使用的判断是否全部得到数字，但由于这里会处理失败，所以重写了一个判断是否全部处理成功的函数*/
    /*@all-button-is-got = ->
        [return false for button in @buttons when button.state is 'unclicked']
        return true*/
    @all-button-is-succeed = ->
        [return false for button in @buttons when button.succeed is false]
        return true
    @reset-all-buttons = !->
        [button.reset! for button in @buttons]
    wait: !->
        @state = 'clicked'
        @dom .find '.unread' .text "..." .remove-class 'hidden'
    disable: !->
        @state = 'can-not-click'; @dom .remove-class 'enabled' .add-class 'disabled'
    enable: !->
        @state = 'unclicked'; @dom .remove-class 'disabled' .add-class 'enabled'
    show-number: (number) !->
        @dom .add-class 'disabled'
        @dom .find '.unread' .text number
    show-message: !->
        bubble = $ '#info-bar'
        bubble .find '.speaking' .text "#{@name}: #{@good-messages}"
    reset: !->
        @state = 'unclicked'
        @succeed = false
        @dom .remove-class 'disabled' .add-class 'enabled'
        @dom .find '.unread' .text "" .add-class 'hidden'

/*计算总和*/
calculator = 
    Sum: 0
    add: (number) -> @Sum += parse-int number
    reset: !-> @Sum = 0

/*robot机器人, 由于不知道该怎么设计robot，此部分是仿造老师的代码的*/
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
        if @index is @sequence.length
            @bubble.click!
        else
            @get-next-button!click!
    get-next-button: ->
        @buttons[@sequence[@index++].char-code-at! - 'A'.char-code-at!]

S5-robot = !->
    at-plus = $ '#button .apb'
    at-plus .click !->
        robot.disorder-sequence!
        robot.show-sequence!
        robot.click-button-by-sequence!

/*点击生成button对象,由于需要自动点击，所以改为参数为robot的点击函数的函数*/
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

/*点击info-bar显示*/
click-infor-bar-to-show-result = !->
    bubble = $ '#info-bar'
    bubble.add-class 'disabled'
    Button.all-number-is-got-callback = ->
        bubble.remove-class 'disabled' .add-class 'enabled'
    bubble.click !->
        if bubble.has-class 'enabled'
            bubble.remove-class 'enabled' .add-class 'disabled'
            bubble .find '.speaking' .text "楼主异步调用战斗力感人，目测不超过#{calculator.Sum}"
            bubble .find '.amount' .text calculator.Sum

/*移开区域时重置*/
move-out-to-reset = !->
    area = $ '#bottom-positioner'
    area .on 'mouseleave' (event) !->
        Button.reset-all-buttons!
        $ '#info-bar' .remove-class 'enabled' .add-class 'disabled'
        $ '#info-bar' .find '.amount' .text ''
        $ '#info-bar' .find '.sequence' .text ''
        $ '#info-bar' .find '.speaking' .text ''
        robot.initial!
        calculator.reset!

window.onload = !->
    click-button-to-get-number !-> robot.click-button-by-sequence!
    click-infor-bar-to-show-result!
    move-out-to-reset!
    robot.initial!
    S5-robot!