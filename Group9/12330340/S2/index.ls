class Button
  @buttons = []

  @enable-others = (this-button) !-> [button.enable! for button in @buttons when button isnt this-button and button.state is 'disable']

  @disable-others = (this-button) !-> [button.disable! for button in @buttons when button isnt this-button and button.state is 'enable']

  @reset-all = !-> [button.reset! for button in @buttons]

  @all-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  (@dom) ->
    @state = 'enable'; @dom.add-class 'enable'
    @dom.click !~> if @state == 'enable'
      @@@disable-others @
      @wait!
      @dom.find '.unread' .css('visibility', 'visible')
      @fetch-and-show!
    @@@buttons.push @

  fetch-and-show: !~>
    number = '...'
    @show-number number
    @ajax = $.ajax !-> method : 'GET', url: 'http://localhost:3000/' 
    @ajax.done (msg) !~> number = msg; @show-number number; @done!; calculator.add number; @@@enable-others @; bubble-click!; if robot.current != 0 then robot.click-button!

  enable: !-> @state = 'enable'; @dom.remove-class 'disable' .add-class 'enable'

  disable: !-> @state = 'disable'; @dom.remove-class 'enable' .add-class 'disable'

  wait: !-> @state = 'wating'; @dom.add-class 'waiting'

  done: !-> @state = 'done'; @dom.add-class 'done'

  show-number: (number) !-> @dom.find '.num' .text number
  
  reset: !->
    @state = 'enable'; @dom.remove-class 'disable waiting done' .add-class 'enable'
    @dom.find '.unread' .css('visibility', 'hidden')
    @dom.find '.num' .text('')

calculator = 
  sum: 0
  add: (number) !-> @sum += parse-int number
  reset: !-> @sum = 0

$ window .load ->
  initial-button!
  robot.initial!
  initial-at!
  when-leaving!

initial-button = !->
  for let dom in $ '.button'
    button = new Button ($ dom)

robot = 
  initial: !->
    @buttons = $ '.button'
    @current = 0
    @sequence = ['0' to '4']

  click-button: !->
    if @current is @sequence.length then $ '#info-bar' .click!
    else 
      @get-next-button!click 'robot'

  get-next-button: ->
    @buttons[@current++]

  reset: !->
    @current = 0

initial-at = !->
  $ '.apb' .click !->
    reset-all-element!
    robot.click-button!

bubble-click = !->
  bubble = $ '#info-bar'
  if !Button.all-done!
    bubble.add-class 'disable'
    bubble.off 'click'
  else
    bubble.remove-class 'disable' .add-class 'enable'
    bubble.on 'click', !->
      bubble.text(calculator.sum)
      bubble.add-class 'done'

when-leaving = !->
  leave = false
  $ '.apb' .mouseover !->
    if leave
      initial-button!
      leave = false
  $ '.apb' .mouseout !->
    leave = true
    reset-all-element!

reset-all-element = !->
  Button.reset-all!
  calculator.reset!
  robot.reset!
  $ '#info-bar' .text('')
  if ($ '#info-bar' .has-class 'enable')
    $ '#info-bar' .remove-class 'enable'
  if ($ '#info-bar' .has-class 'done')
    $ '#info-bar' .remove-class 'done'
  if (!$ '#info-bar' .has-class 'disable')
    $ '#info-bar' .add-class 'disable'
  $ '#info-bar' .off 'click'