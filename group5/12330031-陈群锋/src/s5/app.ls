class Button

  @buttons = []
  @FAILURE-RATE = 0.5

  (@dom, @i, @good-message, @bad-message, @init) ->
    @state = @init
    @name = @dom.find '.title' .text!
    @dom .add-class 'enabled'
    @@@buttons.push @
    @dom.click !~>
      if @state is 'enabled'
        @wait!
        @@@disable-other-bubbles @
        @get-number @

  get-number: !->
    $.get '/api/random', (number, result)!~>
      @done!
      @dom.find '.unread' .html number
      @@@enabled-other-bubbles @
      @@@is-all-small-bubbles-done!
      @success-or-fail number
      Rebort.click-next!


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

  success-or-fail: (number)!-> 
    if is-success = Math.random! > @@@FAILURE-RATE
      @show-message @good-message
    else
      @show-message @bad-message

  show-message: (message) !-> console.log "Button #{@name} say: #{message}"

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
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪']
  for let dom, i in $ '#button .button'
    small-bubble = new Button ($ dom), i, good-messages[i], bad-messages[i], 'enabled'

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
      console.log '楼主异步调用战斗力感人，目测不超过' + result

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
  Rebort.init!
  Button.buttons := []

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

Rebort =
  init : !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @seq = ['A' to 'E']
    @cursor = 0

  new-order: !->
    @seq.sort ->
      0.5 - Math.random!

  click-next: !->
    if @cursor is @seq.length then 
      @bubble.click!
    else
      @get-next-button!click!

  list-order: ->
    seq = @seq.join '-'

    @bubble .find '.sequence' .html seq

  get-next-button: -> 
    index = @seq[@cursor++].char-code-at! - 'A'.char-code-at!
    @buttons[index]

window.onload = !->
  Rebort.init!
  bubble-hover!
  $ '#button .apb' .click ->
    Rebort.new-order!
    Rebort.list-order!
    Rebort.click-next!
    
  
