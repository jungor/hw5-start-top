class Button
    @all-buttons = []

    @disable-other-button = (this-button) !->
        for button in @all-buttons when button isnt this-button and button.state isnt 'clicked'
            button.state = 'disabled'
            button.the-button.remove-class 'enabled' .add-class 'disabled'

    @enable-other-button = (this-button) !->
        for button in @all-buttons when button isnt this-button and button.state isnt 'clicked'
            button.state = 'enabled'
            button.the-button.remove-class 'disabled' .add-class 'enabled'

    @check-if-all-buttons-clicked = ->
        [return false for button in @all-buttons when button.state isnt 'clicked']
        true

    (@the-button, @bubble) ->
        @state = "enabled"
        @the-button.add-class 'enabled'
        @@@all-buttons.push @
        @the-button.click !~> if @state is 'enabled'
            @@@disable-other-button @
            @state = 'waiting'
            @the-button.find '.ran_num' .remove-class 'hide'
            @get-number!
        
    get-number: !-> $.get '/', (num, state) !~> if @state is 'waiting'
        @the-button.find '.ran_num' .text num
        @state = 'clicked'
        @the-button.remove-class 'enabled'
        @the-button.add-class 'disabled'
        @@@enable-other-button @the-button
        @bubble.enabled! if @@@check-if-all-buttons-clicked!

    reset-the-button:  !->
        @state = 'enabled'
        @the-button.remove-class 'disabled'
        @the-button.add-class 'enabled'
        @the-button.find '.ran_num' .add-class 'hide'    
        @the-button.find '.ran_num' .text '...'

class Bubble
    (@the-bubble) ->
        @state = 'disabled'
        @the-bubble.add-class 'disabled'
        @the-bubble.click !~> if @state is 'enabled'
            @get-sum!

    enabled: !->
        @state = 'enabled'
        @the-bubble.remove-class 'disabled'
        @the-bubble.add-class 'enable_bubble'

    get-sum: !->
        ans = 0
        for button in Button.all-buttons
            tmp = button.the-button.find '.ran_num' .text!
            ans += parse-int tmp
        @the-bubble.find '#sum' .text ans
        @the-bubble.add-class 'disabled'
        @state = 'disabled'

    reset-the-bubble: !->
        @the-bubble.remove-class 'enable_bubble'
        @the-bubble.add-class 'disabled'
        @state = 'disabled'
        @the-bubble.find '#sum' .text ''

class Aplus
    (@aplus, @bubble) ->
        @aplus.mouseleave !~>
            for button in Button.all-buttons
                button.reset-the-button!
            @bubble.reset-the-bubble!

init-all = !->
    bubble = $ '#info-bar'
    buttons_ = $ '#control-ring-container .button'
    aplus = $ '#bottom-positioner'
    big-bubble = new Bubble($ bubble)
    for let button_ in buttons_
        this-button = new Button ($ button_), big-bubble
    aplus_ = new Aplus ($ aplus), big-bubble

$ ->
    init-all!
