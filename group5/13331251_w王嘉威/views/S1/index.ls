class Button
    @buttons = []
    @show-sum = !->
        if @bubble.has-class "disable"
            return
        @bubble.remove-class "enable"
        @bubble.add-class "disable" .add-class "show"
        @bubble.find('#sum').text(adder.sum) 
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
        @dom.click !~>
            if @state isnt 'enable'
                return
            @waiting!
            @@@disable-other-buttons @
            @fetch-show-number!
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
    fetch-show-number: !->
        $.get '/', (num)!~>
            if @state isnt 'waiting'
                return
            failed = @random-fail!
            if failed
                @callback @error-message, num
            else
                @callback null, num
                adder.add num
                @show num
            @completed!
            @@@enable-other-buttons @
            if @@@all-button-is-completed!
                @@@bubble.remove-class 'disable'
                @@@bubble.add-class 'enable'
    random-fail: ->
        return Math.random! > 0.5  
    show: (num)->
        @dom.find '.unread' .text num 

$ ->
    Button.bubble = $ '#info-bar'
    add-listener-to-buttons !->
        robot.get-next!
    add-listener-to-bubble!
    init!
    init-by-leaving!

add-listener-to-buttons = (next)!->
    success-messages = ['这是一个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
    error-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪个锤子']
    doms = $ ".button"
    for dom, i in doms
        button = new Button($(dom), success-messages[i], error-messages[i], (err, num)!->
            if err
                console.log 'Error happen:', err
                adder.add num
                @show num
        )

init = !->
    for button in Button.buttons
        button.enable!
    Button.bubble.remove-class "enable" .add-class "disable" .remove-class "show"
    adder.reset!

add-listener-to-bubble = !->
    $ '#info-bar' .addClass 'disable'
    $ '#info-bar' .click !->
        Button.show-sum!

init-by-leaving = !->
    $ '#button' .mouseleave init

adder =
    sum: 0
    add: (number)!->
        @sum += parseInt number
    reset: !->
        @sum = 0

robot =
    buttons = $ ".button"
    bubble = $ '#info-bar'
    order = [0, 1, 2, 3, 4]
    pointer = 0
    get-next = ->
        if pointer < order.length
            @buttons.[pointer].click!
        else
            @bubble.click!
