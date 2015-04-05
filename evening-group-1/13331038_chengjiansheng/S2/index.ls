$ ->
    add-clicking-handler-to-all-buttons !-> Robot.click-next!
    add-clicking-handler-to-the-bubble!
    add-resetting-when-leave-apb!
    s2-robot-click-in-order!

s2-robot-click-in-order=!-> 
    $ '#button .apb' .click !->     
        if (Robot.state is 'unclicked')
            Robot.click-next!

#Robot is only an instance! no prototype methods
class Robot
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @sequence = [0 to 4]
    @char-sequence = ['A' to 'E']
    @cursor = 0
    @state = 'unclicked'

    /* this function is used to start the click in-order as well as the callback function of a click*/
    @click-next= !-> 
        if @cursor is @sequence.length
            set-timeout !->
                Robot.bubble.click!
            , 350
        else 
            Robot.state='clicked'
            set-timeout !->
                Robot.click-cur-button-and-get-next!click!
            , 400

    @click-cur-button-and-get-next=!->
        cur = @sequence[@cursor++];
        return @buttons[cur]

class Button
    # "static methods"are as same as S1, so write in simple ways
    @buttons = []
    @sum = 0;
    @disable-all-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']
    @enable-all-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']
    @all-button-is-done = ->
        [return false for button in @buttons when button.state isnt 'done']
        return true
    @get-sum =-> return @sum
    @reset-all = !-> [button.reset! for button in @buttons]
    #finished

    (@dom, @callback-to-the-next-step) !->
        @state = 'enabled';
        @red-dot = @dom.find \.unread
        @dom.click !~> if @state is 'enabled'
            @@@disable-all-other-buttons @
            @wait!
            @fetch-number-and-show!      
        @@@buttons.push @

    bubble-check:->
        if (@@@all-button-is-done!)
            $ '#info-bar' .add-class 'blue' .remove-class 'grey'

    fetch-number-and-show: !-> $.get '/', (number, result)!~>
        if (@state is 'waiting') 
            @red-dot .text number
            @@@enable-all-other-buttons @
            @@@sum+= parse-int number
            @done!
            @bubble-check!
        if (Robot.state is 'clicked')
            @callback-to-the-next-step!

    disable: !-> @state = 'disabled' ; @dom .add-class 'disabled'

    enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled'

    wait: !-> 
        @red-dot .add-class 'appear'
        @state = 'waiting' ; 
        @dom.find '.unread' .text '...'

    done: !-> 
        @dom .add-class 'disabled'
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
        $ '#info-bar' .text ''
        #bubble2.text ''
        Robot.cursor = 0
        Robot.state='unclicked'

add-clicking-handler-to-the-bubble = !->
    bubble = $ '#info-bar'
    bubble .remove-class 'blue' .add-class 'grey'
    bubble.click !-> 
        if bubble.has-class 'blue'
            bubble.text Button.get-sum!
            bubble .remove-class 'blue' .add-class 'grey'