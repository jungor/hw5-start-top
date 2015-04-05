/*13331236 谭笑 S1*/

$ !->
    initialize-all-buttons!
    lets-see-what-will-happen-when-click-on-the-bubble!
    reset-when-we-leave-the-at-plus-area!


class Button
    (@dom) !->
        @state = 'enabled'
        @the-red-dot = @dom.find '.number'
        @dom.click !~> 
            if @state is 'enabled'
                @@@disable-others @
                @show-red-dot!
                @wait!
                @get-and-show-number!
        @@@buttons.push @

    @buttons = []
    @sum = 0;
    @disable-others = (the-button) !->
        for button in @buttons 
            if button isnt the-button and button.state isnt 'done'
                button.disable!
    @enable-others = (the-button) !->
        for button in @buttons
            if button isnt the-button and button.state isnt 'done'
                button.enable!
    @all-is-done = ->
        [return false for button in @buttons when button.state isnt 'done']
        return true
    @reset-all = !->
        for button in @buttons 
            button.reset!
            @sum = 0
    @get-sum = -> return @sum

    disable: !->
        @state = 'disabled'
        @dom.add-class 'disabled'
        @dom.remove-class 'enabled'
    enable: !->
        @state = 'enabled'
        @dom.add-class 'enabled'
        @dom.remove-class 'disabled'
    wait: !->
        @state = 'waiting'
        @dom.remove-class 'enabled'
        @dom.add-class 'disabled'
        #@@@disable-others @
    done: !-> @state = 'done'
    reset: !->
        @state = 'enabled'
        @dom.remove-class 'disabled done'
        @dom.add-class 'enabled'
        @hide-red-dot-and-clear-the-number!

    show-red-dot: !->
        @the-red-dot = @dom.find '.unread'
        @the-red-dot .css 'visibility','visible'
    get-and-show-number: !->
        $.get '/' (number) !~>
            if @state is 'waiting'
                @the-red-dot .text number
                @@@sum += parse-int number
                @done!
                @check!
                @@@enable-others @
    hide-red-dot-and-clear-the-number: !->
        the-red-dot = @dom.find '.unread'
        the-red-dot .text = '...'
        the-red-dot .css 'visibility','hidden'

    check: !->
        if @@@all-is-done!
            enable-bubble!

initialize-all-buttons = !->
    all-buttons = $ '.button'
    for button in all-buttons
        new-button = new Button $ button

enable-bubble = !->
    bubble = $ '.info'
    bubble.remove-class 'disabled'
    bubble.add-class 'enabled'

disable-bubble = !->
    bubble = $ '.info'
    bubble.remove-class 'enabled'
    bubble.add-class 'disabled'

show-sum = !-> $('#sum').css 'visibility','visible'

hide-sum = !-> $('#sum').css 'visibility','hidden'

lets-see-what-will-happen-when-click-on-the-bubble = !->
    bubble = $ '.info'
    bubble.click !->
        if bubble.find '.enabled'
            show-sum!
            $('#sum').text Button.get-sum!
            disable-bubble!

reset-when-we-leave-the-at-plus-area = !->
    $ '#at-plus-container' .on 'mouseleave' (event)!->
        target = event.relatedTarget ? event.relatedTarget : event.toElement
        while target and target isnt this
            target = target.parentNode
        if target isnt this
            Button.reset-all!
            disable-bubble!
            hide-sum!
        
