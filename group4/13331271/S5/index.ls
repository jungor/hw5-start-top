class Button
    (@dom$, @good-message, @bad-message, @do-something-after-get-number, @robot) ->
        @enable!
        @name = @dom$.attr 'title'
        @request = null
        @@@buttons.push @
        @dom$.click !~> 
            if @state is 'enable'
                @show-badge!
                @wait!
                @@@disable-other-buttons @
                @request = $.get '/api/random', (number) !~>
                    @done!
                    @@@enable-other-buttons @
                    @show-number-on-badge number
                    @make-it-error number
                    @do-something-after-get-number number
                    @robot.click-next-button @robot.current-sum + parse-int number if @robot.state is 'on'  #传递current-sum
            else if @state is 'done'
                @robot.click-next-button @robot.current-sum if @robot.state is 'on'

    @FAILURE-RATE = 0.3
    @buttons = []

    @disable-other-buttons = (this-button) ->
        [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

    @enable-other-buttons = (this-button) ->
        [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

    @all-button-is-done = !->
        [return false for button in @buttons when button.state isnt 'done']
        return true

    # 至少有一个按钮没有被禁用
    @some-button-is-enable = !->
        [return true for button in @buttons when button.state is 'enable']
        return false

    reset: !->
        @enable!
        badge = @dom$.find '.unread'
        badge.text '...'
        badge.hide!
        @abort-request!

    enable: !->
        @dom$.remove-class 'disable'
        @dom$.add-class 'enable'
        @state = 'enable'

    disable: !->
        @dom$.remove-class 'enable'
        @dom$.add-class 'disable'
        @state = 'disable'

    done: !->
        @dom$.remove-class 'enable'
        @dom$.add-class 'disable'
        @state = 'done'

    wait: !->
        @state = 'waiting'

    show-badge: !->
        @dom$.find '.unread' .show!

    show-number-on-badge: (number) !->
        @dom$.find '.unread' .text number

    # 离开环形菜单后立刻中断请求
    abort-request: !->
        @request.abort! if @request
        @request = null

    say-good-message: !->
        console.log "Button #{@name} says #{@good-message}."
        $ '#saying' .html "#{@good-message}"

    say-bad-message: !->
        console.log "Button #{@name} has error and she says #{@bad-message}"
        $ '#saying' .html ""

    make-it-error: (number) !->
        if Math.random! > @@@FAILURE-RATE then @say-good-message! else @say-bad-message!

class Bubble
    (@dom$) ->
        @sum = 0
        @disable!
        @dom$ .click !~>
            if @dom$ .has-class 'enable'
                @display-sum!
                @disable!

    reset: -> @disable! ; @clear-sum! ; $ '#saying' .html ''

    display-sum: ->
        $ '#sum' .html @sum
        console.log "楼主异步调用战斗力感人, 目测不超过#{@sum}"
        $ '#saying' .html "楼主异步调用战斗力感人, 目测不超过#{@sum}"

    disable: ->
        @dom$ .remove-class 'enable'
        @dom$ .add-class 'disable'

    enable: ->
        @dom$ .remove-class 'disable'
        @dom$ .add-class 'enable'

    add-to-sum: (number)-> @sum += number

    clear-sum: -> 
        @sum = 0
        $ '#sum' .html ''

Robot = ->
    init: !->
        @current-index = 0
        @sequence = @get-sequence!
        @bubble = $ '.info'
        @state = 'off'
        @current-sum = 0  # 累计和
        $ '#seq' .html ''

    get-sequence: ->
        ['A' to 'E'].sort -> Math.random! - 0.5

    get-next-button: ->
        if @current-index < @sequence.length
            index = @sequence[@current-index++].char-code-at! - 'A'.char-code-at!
            @handlers[index] 
        else @bubble

    click-next-button: (new-sum) !->
        @current-sum = new-sum
        console.log "楼主战斗力正在不断上升，当前的战斗力为#{@current-sum}"
        @get-next-button! .click!

    show-sequence: !->
        $ '#seq' .html @sequence.join '-'

    import-handlers: (handlers) !->
        @handlers = handlers
        [handler.init! for handler in @handlers]

s5-robot-start-click = (robot) !->
    if robot.state is 'off' and Button.some-button-is-enable!
        robot.state = 'on' 
        robot.show-sequence!
        robot.click-next-button robot.current-sum, 0

$ !-> 
    bubble = new Bubble $ '.info'
    robot = Robot!
    handlers = create-a-to-e-handler bubble, robot
    robot.import-handlers handlers 
    reset bubble, handlers, robot
    $ '#at-plus-container' .mouseleave !-> reset bubble, Button.buttons, robot
    
    do
        <- $ '.apb' .click
        s5-robot-start-click robot

reset = (bubble, handlers, robot) !->
    [handler.reset! for handler in handlers]
    bubble.reset!
    robot.init!

create-a-to-e-handler = (bubble, robot) ->
    calculate-sum = (number, sum) !~>
                        bubble.add-to-sum parse-int number
                        bubble.enable! if Button.all-button-is-done!
    aHandler = 
        init: !->
            @button = new Button ($ '.A'), '这是个天大的秘密', '这不是个天大的秘密', calculate-sum, robot

        click: !-> $ '.A' .click!

        reset: !-> @button.reset!


    bHandler = 
        init: !->
            @button = new Button ($ '.B'), '我不知道', '我知道', calculate-sum, robot

        click: !-> $ '.B' .click!

        reset: !-> @button.reset!

    cHandler = 
        init: !->
            @button = new Button ($ '.C'), '你不知道', '你知道', calculate-sum, robot

        click: !-> $ '.C' .click!

        reset: !-> @button.reset!

    dHandler = 
        init: !->
            @button = new Button ($ '.D'), '他不知道', '他知道', calculate-sum, robot

        click: !-> $ '.D' .click!

        reset: !-> @button.reset!

    eHandler = 
        init: !->
            @button = new Button ($ '.E'), '才怪', '才不怪', calculate-sum, robot

        click: !-> $ '.E' .click!

        reset: !-> @button.reset!

    return [aHandler, bHandler, cHandler, dHandler, eHandler]

