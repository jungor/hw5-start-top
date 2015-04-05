class Button
  @buttons = []

  (@dom, @i, @init) ->
    @state = @init
    @dom .add-class 'enabled'
    @@@buttons.push @
    @dom.click !~>
      if @state is 'enabled'
        @wait!
        @@@disable-other-bubbles @
        @@@get-number @

  @get-number = (button) !~>
    $.get '/api/random', (number, result)!~>
      button.done!
      button.dom.find '.unread' .html number
      @enabled-other-bubbles @
      @is-all-small-bubbles-done!


  @disable-other-bubbles = (button) !~>
    for dom in @buttons
      if button isnt dom and dom.state isnt 'done'
        dom.disabled!
  
  @enabled-other-bubbles = (button) !~>
    for dom in @buttons
      if button isnt dom and dom.state isnt 'done'
        dom.enabled!
  
  @is-all-small-bubbles-done = !~>
    count = 0
    for dom in @buttons
      if dom.state isnt 'done'
        count := 1
    if count is 0
      big-bubble = $ '#info-bar'
      big-bubble.remove-class 'disabled'
      big-bubble.add-class 'enabled'


  wait : !~>
    @state = 'waiting'
    @dom.remove-class 'enabled'
    @dom.add-class 'waiting'
  disabled : !~>
    @state = 'disabled'
    @dom.remove-class 'enabled'
    @dom.add-class 'disabled'
  enabled : !~>
    @state = 'enabled'
    @dom.remove-class 'disabled'
    @dom.add-class 'enabled'
  done : !~>
    @state = 'done'
    @dom.remove-class 'waiting'
    @dom.add-class 'done'

add-click-to-small-bubbles = ->
  for let dom, i in $ '#button .button'
    small-bubble = new Button ($ dom), i, 'enabled'

add-click-to-big-bubble = ->
  big-bubble = $ '#info-bar'
  big-bubble.add-class 'disabled'
  big-bubble.state = 'enabled'
  big-bubble.click !~>
    if big-bubble.has-class 'enabled'
      result = 0
      for i in Button.buttons
        result += i.dom.find '.unread' .html! * 1
      big-bubble.find '.amount' .html(result)
      big-bubble.remove-class 'enabled'
      big-bubble.add-class 'disabled'

reset = ~>
  for i in Button.buttons
    i.dom.find '.unread' .html('')
    if i.dom.has-class 'enabled'
      i.dom.remove-class 'enabled'
    if i.dom.has-class 'disabled'
      i.dom.remove-class 'disabled'
    if i.dom.has-class 'waiting'
      i.dom.remove-class 'waiting'
    if i.dom.has-class 'done'
      i.dom.remove-class 'done'
  big-bubble = $ '#info-bar'
  big-bubble.find '.amount' .html('')
  big-bubble.find '.sequence' .html('')
  if big-bubble.has-class 'enabled'
    big-bubble.remove-class 'enabled'
  if big-bubble.has-class 'disabled'
    big-bubble.remove-class 'disabled'
    

bubble-hover = ->
  is-over = false
  $ '#button' .on 'mouseenter' !->
    is-over := true
    add-click-to-small-bubbles!
    add-click-to-big-bubble!
    
  $ '#button' .on 'mouseleave' !->
    is-over := false
    set-timeout !->
      if not is-over
        reset!
    , 0

window.onload = !->
  bubble-hover!
