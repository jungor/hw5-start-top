$ ->
    add-clicking-handler-to-all-buttons !-> Robot.click-at-random-order!
    add-clicking-handler-to-the-bubble!
    add-resetting-when-leave-apb!
    s4-robot-click-in-random!
    #s3-robot-click-in-the-same-time!

s4-robot-click-in-random=!->
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

s3-robot-click-in-the-same-time=!-> 
    $ '#button .apb' .click !-> 
        
        if (Robot.state is 'unclicked')
            Robot.click-at-the-same-time!

class Robot
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @sequence = [0 to 4]
    @char-sequence = ['A' to 'E']
    @cursor = 0
    @state = 'unclicked'

    /* this function is used to start the click in-order as well as the callback function of a click*/
    @click-next= !-> if @cursor is @sequence.length then @bubble.click! else @state='all-clicked';@click-cur-button-and-get-next!click!

    @click-cur-button-and-get-next=!->
        cur = @sequence[@cursor++];
        return @buttons[cur]

    @click-at-the-same-time=!->
        Robot.state = 'all-clicked'
        for dom in $ '#control-ring .button'
            dom.click!

    @click-at-random-order=!->
        if @cursor is @sequence.length
            set-timeout !->
                Robot.bubble.click!
            , 350
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

class Button
    @buttons = []
    @sum = 0;
    @disable-all-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']
    @enable-all-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']
    @all-button-is-done = ->
        [return false for button in @buttons when button.state isnt 'done']
        true
    @get-sum =-> return @sum
    @reset-all = !-> [button.reset! for button in @buttons]

    (@dom, @callback-to-the-next-step) !->
        @state = 'enabled';
        @red-dot = @dom.find \.unread
        @dom.click !~> 
            if @state is 'enabled'
                if (Robot.state isnt 'all-clicked')
                    @@@disable-all-other-buttons @
                @wait!
                @fetch-number-and-show!      
        @@@buttons.push @

    bubble-check:->
        if (@@@all-button-is-done!)
            $ '#info-bar' .add-class 'blue' .remove-class 'grey'
            $ '#info-bar' .click!
            console.log("success")

    fetch-number-and-show: !-> 
        $.get '/?timestamp='+ Math.random!, (number, result)!~>
            if (@state is 'waiting') 
                @red-dot .text number
                if (Robot.state isnt 'all-clicked')
                    @@@enable-all-other-buttons @
                @@@sum+= parse-int number
                @done!
                @bubble-check!
                if (Robot.state is 'ran-clicked')
                    @callback-to-the-next-step!

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
        @@@sum = 0;


add-clicking-handler-to-all-buttons = (next-step)!-> 
    #btns = $ '#control-ring .button'
    for dom in $ '#control-ring .button'
        button = new Button ($ dom), next-step

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
        bubble.text Button.get-sum!
        bubble .remove-class 'blue' .add-class 'grey'