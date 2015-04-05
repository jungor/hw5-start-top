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
    @all-button-is-got = ->  /*判断其他按钮是否点击*/
        [return false for button in @buttons when button.state is 'unclicked']
        return true
    @reset-all = !->
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
    reset: !->
        @state = 'unclicked'
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
        if @index is @sequence.length then @bubble.click! else @get-next-button!click!
    get-next-button: ->
        index2 = @sequence[@index++].char-code-at! - 'A'.char-code-at!
        @buttons[index2]

S4-robot = !->
    at-plus = $ '#button .apb'
    at-plus .click !->
        robot.disorder-sequence!
        robot.show-sequence!
        robot.click-button-by-sequence!      

/*生成button对象，由于需要自动点击，所以将该函数设计为带有参数的函数，参数为robot的点击函数*/
click-button-to-get-number = (next) ->
    buttons = $ '#control-ring .button'
    for let dom, i in buttons
        button = new Button ($ dom), (number) !->
            calculator.add number
            next!

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
        robot.initial!
        calculator.reset!

window.onload = !->
    click-button-to-get-number !-> robot.click-button-by-sequence!
    click-infor-bar-to-show-result!
    move-out-to-reset!
    robot.initial!
    S4-robot!