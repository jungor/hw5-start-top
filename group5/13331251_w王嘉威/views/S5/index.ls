class Button
    @buttons = []
    @show-sum = (sum)!->
        if @bubble.has-class "disable"
            return
        @bubble.remove-class "enable"
        @bubble.add-class "disable" .add-class "show"
        @bubble.find('#sum').text(sum)
        alert("楼主异步调用战斗力感人，目测不超过" + sum)
    @enable-other-buttons = (except-button)!->
        for button in @buttons
            if button isnt except-button && button.dom.has-class "disable"
                button.enable!
    @disable-other-buttons = (except-button)!->
        for button in @buttons
            if button isnt except-button && button.dom.has-class "enable"
                button.disable!
    @all-button-is-completed = ->
        for button in @buttons
            if button.state isnt 'completed'
                return false
        return true
    (@dom, @success-message, @error-message, @callback)!->
        @state = 'enable'
        @dom.add-class 'enable'
        @handler = (sum)!->
            if @state isnt 'enable'
                return
            @waiting!
            @@@disable-other-buttons @
            @fetch-show-number sum
        @dom .click !~>
            @handler
        @@@buttons.push @
        @dom.add-class 'enable'
    enable: ->
        @state = 'enable'
        @dom.remove-class 'disable' .remove-class 'completed' .remove-class 'waiting'
        @dom.add-class 'enable'
    waiting: ->
        @state = 'waiting'
        @dom.remove-class 'enable'
        @dom.add-class 'waiting'
        @dom.find '.unread' .text "..."
    disable: ->
        @state = 'disable'
        @dom.remove-class 'enable'
        @dom.add-class 'disable'
    completed: ->
        @state = 'completed'
        @dom.remove-class 'waiting'
        @dom.add-class 'completed'
    fetch-show-number: (sum)!->
        @sum = sum
        $.get '/', (num)!~>
            if @state isnt 'waiting'
                    return
            failed = @random-fail!
            @completed!
            @@@enable-other-buttons @
            if @@@all-button-is-completed!
                @@@bubble.remove-class 'disable'
                @@@bubble.add-class 'enable'
            if failed
                alert(@error-message)
                @callback @error-message, num, @sum
            else
                alert(@success-message)
                @sum = parseInt(@sum) + parseInt(num)
                @callback null, num, @sum
                @show num
    random-fail: ->
        return Math.random! > 0.5  
    show: (num)->
        @dom.find '.unread' .text num 

robot =
    order: [0, 1, 2, 3, 4]
    pointer: -1
    S5-poccess: !->
        $ '.apb' .click !~>
            if $ '.apb' .has-class 'unclickable'
                return
            $ '.apb' .remove-class 'clickable' .add-class 'unclickable'
            @get-next 0
    get-next: (sum)!->
        if @pointer + 1 < @order.length
            Button.buttons[@order[++@pointer]] .handler sum
        else
            Button.show-sum sum

$ ->
    robot.buttons = $ '.button'
    robot.bubble = $ '#info-bar'
    Button.bubble = $ '#info-bar'
    add-listener-to-buttons (sum)!->
        robot.get-next sum
    add-listener-to-bubble!
    init!
    init-by-leaving!
    robot.S5-poccess!

add-listener-to-buttons = (next)!->
    success-messages = ['这是一个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
    error-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪个锤子']
    doms = $ ".button"
    for dom, i in doms
        button = new Button($(dom), success-messages[i], error-messages[i], (err, num, sum)!->
            if err
                console.log 'Error happen:', err
                sum = parseInt(sum) + parseInt num
                @show num
            next sum
        )

init = !->
    for button in Button.buttons
        button.enable!
    Button.bubble.remove-class "enable" .add-class "disable" .remove-class "show"
    $ '.apb' .remove-class 'unclickable' .add-class 'clickable'
    robot.pointer = -1

add-listener-to-bubble = !->
    $ '#info-bar' .addClass 'disable'
    $ '#info-bar' .click !->
        Button.show-sum!

init-by-leaving = !->
    $ '#button' .mouseleave init

