class button
    @state = \idle
    (@sbutton, @callback) !->
        @set-state \clickable
        $ @reddot = @sbutton.find \.unread
        @add-listener!
    add-listener: !->
        ($ @sbutton).on 'click', (e) !~>
            if @get-state! is \clickable and @@state isnt \busy
                @set-state \waiting
                @@state = \busy
                @jqXHR = $.get '/?timestamp='+new Date!getTime! .done (+data) !~>
                    @reddot.text data
                    @set-state \finished
                    @@state = \idle
                    @callback data
    get-number: -> +@reddot.text!
    get-state: -> @state
    set-state: (state) ->
        @state = state
        if @state is \clickable
            @sbutton .remove-class \disabled
            $ @reddot .remove-class \visible
        else if @state is \waiting
            @sbutton.add-class \disabled
            @reddot.text \... .add-class \visible
        else
            @sbutton.add-class \disabled
            @reddot.add-class \visible
    reset: !->
        @set-state \clickable
        @jqXHR?.abort!
        @@state = \idle

class bubble
    (@lbutton, @sum, @callback) !->
        @set-state \disabled
        @add-listener!
    add-listener: !->
        @lbutton.on 'click' !~>
        if @get-state! is \ready
            @callback @lbutton
            @set-state \summed
            @lbutton.text @sum
    get-state: ->
        @state
    set-state: (state) !->
        | state is \init => @lbutton.text '' .add-class \disabled
        | state is \ready => @lbutton.remove-class \disabled
        | otherwise => @lbutton.add-class \disabled
        @state = state
    reset: !->
        @set-state \init

class ringmenu
    (@parts) ->
        @sum = 0
        @buttons = []
        func = &1
        @bubble = new bubble ($ @parts.lbutton, @sum), (lbutton) !~>
            lbutton.text @sum
        for item in @parts.sbuttons
            @buttons.push new button ($ item), (number) !~>
                @sum += number
                console.log(@sum);
                if @check-able-to-sum!
                    @bubble.set-state \ready
                    parts.lbutton.text @sum
                    @bubble.set-state \summed
                func?!
        @container = @parts.container
        @add-listener!
    add-listener: !->
        that = this
        ($ @container).on \mouseleave, (e) !->
            that.resetall!
    resetall: !->
        for item in @buttons then item.reset!
        @bubble.reset!
        @sum = 0
    check-able-to-sum: ->
        for item in @buttons
            if item.get-state! is \clickable then return false
        true
<-! $
parts = 
    lbutton: ($ '#info-bar div'),
    sbuttons: ($ '#control-ring li'),
    container: ($ '#at-plus-container')
rm = new ringmenu parts