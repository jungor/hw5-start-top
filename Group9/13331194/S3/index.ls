$ ->
  all-buttons-able-to-be-clicked-to-fetch-number !-> robot.next-aim-to-click!
  bubble-able-to-be-clicked-to-get-sum!
  add-resetting-when-leaving-apb!

  robot.initial!

  S1-wait-user-click!
  # S2-robot-click-buttons-from-A-to-E-and-then-click-bubble!
  S3-robot-click-buttons-meanwhile-and-then-click-bubble!

class Button
  @buttons = []

  (@dom, @callback) ->
    @state = 'enabled'
    @index = @@@buttons.length
    @dom.add-class 'enabled'

    @dom.click !~>
      if robot.state is 'running'
        null
      else if @dom.has-class 'enabled'
        @@@disable-other-buttons @

      @wait!
      @button-fetch-number-from-server-and-show @index
      @callback!

    @@@buttons.push @

  @disable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button
      if button.state isnt 'done'
        button.dom[0].children[1].style.visibility = 'collapse' if button.dom[0].children[1].innerHTML is ''
        button.disable!

  @enable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button
      if button.state isnt 'done'
        button.dom[0].children[1].style.visibility = ''
        button.enable!

  @all-buttons-are-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  @reset-all = !-> [button.reset! for button in @buttons]

  button-fetch-number-from-server-and-show: (i)!->
    $.get '/'+i.toString!, (number, result)!~>
      if robot.state isnt 'running'
        @@@enable-other-buttons @
      @done! if @state is 'waiting'
      @button-show-number number

  button-show-number:  (number) !->
    @dom.find '.unread' .text number
    if @@@all-buttons-are-done!
      robot.state = 'waiting'
      set-bubble-able-to-be-clicked!
      $ '#info-bar' .click!

  disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'
  enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'
  wait: !-> @state = 'waiting' ; @dom.remove-class 'enabled' .add-class 'waiting'
  done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'
  reset: !->
    @state = 'enabled'
    @dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @dom.find '.unread' .text ''

all-buttons-able-to-be-clicked-to-fetch-number = (next)!->
  buttons-init next

buttons-init = (next)!->
  buttons = $ '#control-ring .button'
  for bt in buttons
    button = new Button ($ bt), !->
      next?!

bubble-able-to-be-clicked-to-get-sum = !->
  bubble-init!
  bubble = $ '#info-bar'
  bubble.click !~> if bubble.has-class 'enabled'
    bubble.find '.amount' .text get-buttons-sum!
    bubble.remove-class 'enabled' .add-class 'disabled'

get-buttons-sum = !->
  sum = 0
  for button in $ '#control-ring .button'
    sum += parse-int button.children[1].innerHTML.toString!
  return sum

add-resetting-when-leaving-apb = !->
  is-entering-other = false
  $ '#info-bar, #control-ring-container, .apb' .on 'mouseenter' !-> is-entering-other := true
  $ '#info-bar, #control-ring-container' .on 'mouseleave' !-> 
    is-entering-other := false
    set-timeout !-> 
      reset! if not is-entering-other
    , 0

reset = !->
  Button.reset-all!
  bubble-init!
  robot.reset!

set-bubble-able-to-be-clicked = !->
  bubble = $ '#info-bar'
  bubble.remove-class 'disabled' .add-class 'enabled'

bubble-init = !->
  bubble = $ '#info-bar'
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find 'li.amount' .text ''

S1-wait-user-click = !-> console.log 'waiting user to click...'

robot =
  initial: !->
    @state = 'waiting'
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @order = ['A' to 'E']
    @point = 0

  start-click: !-> @state = 'running' ; @next-aim-to-click!

  next-aim-to-click: !->
    if @state isnt 'running'
      null
    else if @point < @buttons.length
      @get-next-button!click!
    # else @state = 'waiting'

  get-next-button: -> 
    @buttons[@point++]

  reset: !-> @point = 0 ; @state = 'waiting'

S2-robot-click-buttons-from-A-to-E-and-then-click-bubble = !->
  $ '#button .apb' .click !-> if robot.state is 'waiting'
    reset!
    robot.start-click!

S3-robot-click-buttons-meanwhile-and-then-click-bubble = !->
  $ '#button .apb' .click !-> if robot.state is 'waiting'
    reset!
    robot.start-click!