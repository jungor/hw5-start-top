class Button
    (@dom$, @good-message, @bad-message, @do-something-after-get-number) ->
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

    @FAILURE-RATE = 0.3
    @buttons = []

    @disable-other-buttons = (this-button) ->
        [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

    @enable-other-buttons = (this-button) ->
        [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

    @all-button-is-done = !->
        [return false for button in @buttons when button.state isnt 'done']
        return true

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

    abort-request: !->
        @request.abort! if @request
        @request = null

    say-good-message: !->
        console.log "Button #{@name} says #{@good-message}."

    say-bad-message: !->
        console.log "Button #{@name} has error and she says #{@bad-message}"

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

    reset: -> @disable! ; @clear-sum!

    display-sum: ->
        $ '#sum' .html @sum
        console.log "楼主异步调用战斗力感人, 目测不超过#{@sum}"

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

$ !-> 
    bubble = new Bubble $ '.info'
    add-clicking-to-get-numbers-for-all-buttons bubble
    reset bubble, Button.buttons
    $ '#at-plus-container' .mouseleave !-> reset bubble, Button.buttons
        

reset = (bubble, buttons) !->
    [button.reset! for button in buttons]
    bubble.reset!

add-clicking-to-get-numbers-for-all-buttons = (bubble) ->
    good-messages = ["这是个天大的秘密", "我不知道", "你不知道", "他不知道", "才怪"]
    bad-messages = ["这不是个天大的秘密", "我知道", "你知道", "他知道", "才不怪"]
    buttons = $ '#control-ring .button'
    for let dom, i in buttons
        button = new Button ($ dom), good-messages[i], bad-messages[i], (number) !->
            bubble.add-to-sum parse-int number
            bubble.enable! if Button.all-button-is-done!
