$ ->
    add-clicking-handler-to-all-buttons !-> Robot.click-at-random-order!
    add-clicking-handler-to-the-bubble!
    add-resetting-when-leave-apb!
    s5-robot-click-with-message!

s5-robot-click-with-message=!->
    $ '#button .apb' .click !-> 
        
        if (Robot.state is 'unclicked')
            console.log("enter")
            Robot.shuffle!
            bubble = $ '#info-bar'
            list=[]
            for num in Robot.sequence
                list.push Robot.char-sequence[num]
            list.join ','
            bubble .text list
            Robot.click-at-random-order!

#each "button" has its handler and I need a Robot to call them one by one
class Robot
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @sequence = [0 to 4]
    @char-sequence = ['A' to 'E']
    @cursor = 0
    @state = 'unclicked'
    @sum = 0

    /* this function is used to start the click in-order as well as the callback function of a click*/
    @click-at-random-order=!->
        if @cursor is @sequence.length
            set-timeout !->
                Robot.bubble.click!
                $ ('#message-bar .saying') .text "大气泡：楼主异步调用战斗力感人，目测不超过"+Robot.sum
                $ ('#info-bar') .text Robot.sum
            , 0
        else
            @state='ran-clicked';
            set-timeout  !->
                Robot.click-cur-button-and-get-next-randomly!click!
            , 800

    @shuffle=->
        @sequence.sort -> 0.5 - Math.random!

    @click-cur-button-and-get-next-randomly=!->
        cur-ran = Robot.sequence[Robot.cursor++];
        return Robot.buttons[cur-ran]

    @get-sum=!->
        return Robot.sum


class Button
    @buttons = []
    @disable-unclicked-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']
    @enable-unclicked-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']
    @all-button-is-done = ->
        [return false for button in @buttons when button.state isnt 'done']
        return true
    @reset-all = !-> [button.reset! for button in @buttons]

    (@dom, @good-message, @bad-message, @callback) !->
        @state = 'enabled'
        @current-sum = 0
        @red-dot = @dom.find \.unread
        @dom.click !~> 
            if @state is 'enabled'
                @@@disable-unclicked-buttons @
                @wait!
                @fetch-number-and-show!   
        @@@buttons.push @

    fetch-number-and-show: !-> 
        $.get '/?timestamp='+ Math.random!, (number, result)!~>
            if (@state is 'waiting') 
                @red-dot .text number
                @@@enable-unclicked-buttons @
                @current-sum+= parse-int number
                @done!
                @bubble-check!
                @error-check @current-sum

    error-check:(number)->
        data = Math.random!
        error =  data< 0.3
        if (error)
            @show-message @bad-message
            if (Robot.state is 'ran-clicked')
                @callback true, @current-sum, data
        else 
            @show-message @good-message
            if (Robot.state is 'ran-clicked')
                @callback false, @current-sum, data

    bubble-check:->
        if (@@@all-button-is-done!)
            $ '#info-bar' .add-class 'blue' .remove-class 'grey'
            $ '#info-bar' .click!

    show-message:(message)->
        mes = $ '#message-bar .saying'
        mes .text message

    disable: !-> @state = 'disabled' ; @dom .add-class 'disabled'

    enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled'

    wait: !-> 
        @red-dot .add-class 'appear'
        @state = 'waiting' ; 
        @dom.find '.unread' .text '...'
        @dom .add-class 'disabled'

    done: !-> 
        @state = 'done' 

    reset: !-> 
        @state = 'enabled' ; 
        @dom.remove-class 'disabled'
        @dom.find '.unread' .text '' .remove-class 'appear'
        mes = $ '#message-bar .saying'
        mes .text ''

add-resetting-when-leave-apb = !->
    $ '#bottom-positioner' .on 'mouseleave' (event)!-> 
        Button.reset-all!
        bubble2 = $ '#info-bar'
        bubble2.text ''
        Robot.cursor = 0
        Robot.state='unclicked'

add-clicking-handler-to-the-bubble = !->
    bubble = $ '#info-bar'
    bubble .remove-class 'blue' .add-class 'grey'
    bubble.click !-> if bubble.has-class 'blue'
        bubble .remove-class 'blue' .add-class 'grey'

add-clicking-handler-to-all-buttons= (next-step) !->
    add-clicking-to-a-handler !-> next-step!
    add-clicking-to-b-handler !-> next-step!
    add-clicking-to-c-handler !-> next-step!
    add-clicking-to-d-handler !-> next-step!
    add-clicking-to-e-handler !-> next-step!

add-clicking-to-a-handler= (next-step) !->
    buttons = $ '#control-ring .button'
    good-message = 'A;这是个天大的秘密'
    bad-message = 'A:这不是个天大的秘密'
    a-button = new Button ($ buttons[0]), good-message, bad-message, (error, number, data)!->
        if (error)
            console.log("A:error!")
        else
            console.log("A:ran_success")
        Robot.sum += number
        next-step?!

add-clicking-to-b-handler= (next-step) !->
    buttons = $ '#control-ring .button'
    good-message = 'B :我不知道'
    bad-message = 'B :我知道'
    b-button = new Button ($ buttons[1]), good-message, bad-message, (error, number, data)!->
        if (error)
            console.log("B :error!")
        else
            console.log("B : ran_success")
        Robot.sum += number
        next-step?!

add-clicking-to-c-handler= (next-step) !->
    buttons = $ '#control-ring .button'
    good-message = 'C;你不知道'
    bad-message = 'C:你知道'
    c-button = new Button ($ buttons[2]), good-message, bad-message, (error, number, data)!->
        if (error)
            console.log("C:error!")
        else
            console.log("C:ran_success")
        Robot.sum += number
        next-step?!

add-clicking-to-d-handler= (next-step) !->
    buttons = $ '#control-ring .button'
    good-message = 'D;他不知道'
    bad-message = 'D:他不知道'
    d-button = new Button ($ buttons[3]), good-message, bad-message, (error, number, data)!->
        if (error)
            console.log("D:error!")
        else
            console.log("D:ran_success")
        Robot.sum += number
        next-step?!

add-clicking-to-e-handler= (next-step) !->
    buttons = $ '#control-ring .button'
    good-message = 'E:才怪'
    bad-message = 'E:才不怪'
    e-button = new Button ($ buttons[4]), good-message, bad-message, (error, number, data)!->
        if (error)
            console.log("E:error!")
        else
            console.log("E:ran_success")
        Robot.sum += number
        next-step?!