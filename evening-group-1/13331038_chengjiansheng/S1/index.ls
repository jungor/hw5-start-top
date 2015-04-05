$ ->
    add-clicking-handler-to-all-buttons!
    add-clicking-handler-to-the-bubble!
    add-resetting-when-leave-apb!

#there is three states enabled->waiting->done  with different css classes
#button class is make those "button" added click attributes
class Button

    (@dom) !->
        @state = 'enabled';
        @red-dot = @dom.find \.unread
        @dom.click !~> if @state is 'enabled'
            @@@disable-all-other-buttons @
            @wait!
            @fetch-number-and-show!      
        @@@buttons.push @

    # seems like static vars and methods
    @buttons = []
    @sum = 0;

    @disable-all-other-buttons = (this-button)->
        for button in @buttons
            if (button isnt this-button and button.state isnt 'done')
                button.disable!

    @enable-all-other-buttons = (this-button)-> 
        for button in @buttons
            if (button isnt this-button and button.state isnt 'done')
                button.enable!

    @all-button-is-done = ->
        [return false for button in @buttons when button.state isnt 'done']
        return true

    @get-sum =-> return @sum

    @reset-all = !-> [button.reset! for button in @buttons]

    #prototype methods
    bubble-check:->
        if (@@@all-button-is-done!)
            $ '#info-bar' .add-class 'blue' .remove-class 'grey'

    fetch-number-and-show: !-> 
        $.get '/', (number, result)!~>
            if (@state is 'waiting') 
                @red-dot .text number
                @@@enable-all-other-buttons @
                @@@sum+= parse-int number
                @done!
                @bubble-check!

    disable: !-> 
        @state = 'disabled'
        @dom .add-class 'disabled'

    enable: !->
        @state = 'enabled' 
        @dom.remove-class 'disabled'

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

#class Btn definition  finished
add-clicking-handler-to-all-buttons = !-> 
    #btns = $ '#control-ring .button'
    for dom in $ '#control-ring .button'
        button = new Button ($ dom)

add-resetting-when-leave-apb = !->
    $ '#bottom-positioner' .on 'mouseleave' (event)!-> 
        #mistake !!!!
        #button = new Button ($ '#control-ring .button'[0])
        #button.reset-all!
        Button.reset-all!
        bubble2 = $ '#info-bar'
        bubble2.text ''

add-clicking-handler-to-the-bubble = !->
    bubble = $ '#info-bar'
    bubble .remove-class 'blue' .add-class 'grey'
    bubble.click !-> 
        if bubble.has-class 'blue'
            bubble.text Button.get-sum!
            bubble .remove-class 'blue' .add-class 'grey'