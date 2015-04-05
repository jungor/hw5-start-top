class Button
    /*构造函数*/
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
    @buttons = []
    @disable-all-other-buttons = (this-button) !->  /*将其他按钮禁用*/
        [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'clicked']
    @enable-all-other-buttons = (this-button) !->  /*将其他按钮激活*/
        [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'clicked']
    @all-button-is-got = ->  /*判断所有按钮是否点击*/
        [return false for button in @buttons when button.state is 'unclicked']
        return true
    @reset-all = !->
        [button.reset! for button in @buttons]
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
    reset: !->
        @state = 'unclicked'
        @dom .remove-class 'disabled' .add-class 'enabled'
        @dom .find '.unread' .text "" .add-class 'hidden'

/*计算总和*/
calculator = 
    Sum: 0
    add: (number) -> @Sum += parse-int number
    reset: !-> @Sum = 0

robot = 
    click-all-button-at-same-time: !->
        Button.click-all-button-at-same-time!

S3-robot = !->
    at-plus = $ '#button .apb'
    at-plus .click !->
        robot.click-all-button-at-same-time!

/*生成button对象*/
click-button-to-get-number = !->
    buttons = $ '#control-ring .button'
    for let dom, i in buttons
        button = new Button ($ dom), (number) !->
            calculator.add number

/*点击info-bar显示总和*/
click-infor-bar-to-show-result = !->
    bubble = $ '#info-bar'
    bubble.add-class 'disabled'
    Button.all-number-is-got-callback = ->
        bubble.remove-class 'disabled' .add-class 'enabled'
    bubble.click !->
        if bubble.has-class 'enabled'
            bubble.remove-class 'enabled' .add-class 'disabled'
            bubble .find '.amount' .text calculator.Sum

/*移开对应区域重置*/
move-out-to-reset = !->
    area = $ '#bottom-positioner'
    area .on 'mouseleave' (event) !->
        Button.reset-all!
        $ '#info-bar' .remove-class 'enabled' .add-class 'disabled'
        $ '#info-bar' .find '.amount' .text ''
        $ '#info-bar' .find '.sequence' .text ''
        calculator.reset!

window.onload = !->
    click-button-to-get-number!
    click-infor-bar-to-show-result!
    move-out-to-reset!
    S3-robot!