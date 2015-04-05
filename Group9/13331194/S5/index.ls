$ ->
  all-buttons-able-to-be-clicked-to-fetch-number !-> robot.next-aim-to-click!
  bubble-able-to-be-clicked-to-get-sum!
  add-resetting-when-leaving-apb!

  robot.initial!

  S1-wait-user-click!
  # S2-robot-click-buttons-from-A-to-E-and-then-click-bubble!
  # S4-robot-click-buttons-in-a-random-order-and-then-click-bubble!
  S5-robot-click-buttons-in-a-random-order-and-then-click-bubble-with-possible-to-fail!

class Button
  @buttons = []

  (@dom, @i, @callback) ->
    @name = 'A'+@i
    @state = 'enabled'
    @dom.add-class 'enabled'

    @dom.click !~> if @dom.has-class 'enabled'
      @@@disable-other-buttons @
      @wait!
      @button-fetch-number-from-server-and-show!

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

  button-fetch-number-from-server-and-show: !->
    $.get '/', (number, result)!~>
      @done! if @state is 'waiting'
      set-bubble-able-to-be-clicked! if @@@all-buttons-are-done!
      @@@enable-other-buttons @
      @button-show-number number
      @callback!

  button-show-number:  (number) !-> @dom.find '.unread' .text number

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
  for bt, i in buttons
    button = new Button ($ bt), i, !->
      next?!

bubble-able-to-be-clicked-to-get-sum = !->
  bubble-init!
  bubble = $ '#info-bar'
  bubble.click (currentSum)!~> if bubble.has-class 'enabled'
    bubble-handler currentSum
    # bubble.find '.amount' .text get-buttons-sum!
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
  bubble.find 'li.sequence' .text ''

S1-wait-user-click = !-> console.log 'waiting user to click...'

robot =
  initial: !->
    @state = 'waiting'
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @order = ['A' to 'E']
    @point = 0

  start-click: !->
    @state = 'running'
    # @next-aim-to-click!
    call-handler 0, 0

  get-random-order: !->
    @order.sort -> Math.random! - 0.3

  next-aim-to-click: !->
    if @state isnt 'running'
      null
    else if @point < @order.length
      @get-next-button!click!
    else if @point is @order.length
      @bubble.click!
    else
      @state = 'waiting'

  show-order: !->
    bubble = $ '#info-bar'
    bubble.find 'li.sequence' .text @order.join '->'

  get-next-button: ->
    index = @order[@point++].char-code-at! - 'A'.char-code-at!
    @buttons[index]

  reset: !-> @point = 0 ; @state = 'waiting'

S2-robot-click-buttons-from-A-to-E-and-then-click-bubble = !->
  $ '#button .apb' .click !-> if robot.state is 'waiting'
    reset!
    robot.start-click!

S4-robot-click-buttons-in-a-random-order-and-then-click-bubble = !->
  $ '#button .apb' .click !-> if robot.state is 'waiting'
    reset!
    robot.get-random-order!
    robot.show-order!
    robot.start-click!

S5-robot-click-buttons-in-a-random-order-and-then-click-bubble-with-possible-to-fail = !->
  $ '#button .apb' .click !-> if robot.state is 'waiting'
    reset!
    robot.get-random-order!
    robot.show-order!
    robot.start-click!

check-bubble-able-to-be-clicked = (currentSum)!->
  set-bubble-able-to-be-clicked! if Button.all-buttons-are-done!
  $ '#info-bar' .click currentSum

call-handler = (currentIndex, currentSum) !->
  if currentIndex == robot.order.length
    null
  else if robot.order[currentIndex] == 'A'
    A-handler currentIndex, currentSum
  else if robot.order[currentIndex] == 'B'
    B-handler currentIndex, currentSum
  else if robot.order[currentIndex] == 'C'
    C-handler currentIndex, currentSum
  else if robot.order[currentIndex] == 'D'
    D-handler currentIndex, currentSum
  else if robot.order[currentIndex] == 'E'
    E-handler currentIndex, currentSum

A-handler = (currentIndex, currentSum) !->
  failure-number = 0.3
  try
    if Math.random! < failure-number
      throw {message: '这不是个天大的秘密', currentSum: currentSum}
    else
      $ '#A' .remove-class 'enabled' .add-class 'waiting'
      $.get '/', (number, result) !~>
        set-number 'A', number
        show-message 'A', '这是个天大的秘密'
        call-handler currentIndex+1, parse-int currentSum + parse-int number
        set-timeout check-bubble-able-to-be-clicked currentSum
  catch error
    show-message 'A', error.message
    call-handler currentIndex+1, parse-int currentSum + parse-int error.number
    set-timeout check-bubble-able-to-be-clicked currentSum

B-handler = (currentIndex, currentSum) !->
  failure-number = 0.3
  try
    if Math.random! < failure-number
      throw {message: '我知道', currentSum: currentSum}
    else
      $ '#B' .remove-class 'enabled' .add-class 'waiting'
      $.get '/', (number, result) !~>
        set-number 'B', number
        show-message 'B', '我不知道'
        call-handler currentIndex+1, parse-int currentSum + parse-int number
        set-timeout check-bubble-able-to-be-clicked currentSum
  catch error
    show-message 'B', error.message
    call-handler currentIndex+1, parse-int currentSum + parse-int error.number
    set-timeout check-bubble-able-to-be-clicked currentSum

C-handler = (currentIndex, currentSum) !->
  failure-number = 0.3
  try
    if Math.random! < failure-number
      throw {message: '你知道', currentSum: currentSum}
    else
      $ '#C' .remove-class 'enabled' .add-class 'waiting'
      $.get '/', (number, result) !~>
        set-number 'C', number
        show-message 'C', '你不知道'
        call-handler currentIndex+1, parse-int currentSum + parse-int number
        set-timeout check-bubble-able-to-be-clicked currentSum
  catch error
    show-message 'C', error.message
    call-handler currentIndex+1, parse-int currentSum + parse-int error.number
    set-timeout check-bubble-able-to-be-clicked currentSum

D-handler = (currentIndex, currentSum) !->
  failure-number = 0.3
  try
    if Math.random! < failure-number
      throw {message: '他知道', currentSum: currentSum}
    else
      $ '#D' .remove-class 'enabled' .add-class 'waiting'
      $.get '/', (number, result) !~>
        set-number 'D', number
        show-message 'D', '他不知道'
        call-handler currentIndex+1, parse-int currentSum + parse-int number
        set-timeout check-bubble-able-to-be-clicked currentSum
  catch error
    show-message 'D', error.message
    call-handler currentIndex+1, parse-int currentSum + parse-int error.number
    set-timeout check-bubble-able-to-be-clicked currentSum

E-handler = (currentIndex, currentSum) !->
  failure-number = 0.3
  try
    if Math.random! < failure-number
      throw {message: '不怪', currentSum: currentSum}
    else
      $ '#E' .remove-class 'enabled' .add-class 'waiting'
      $.get '/', (number, result) !~>
        set-number 'E', number
        show-message 'E', '才怪'
        call-handler currentIndex+1, parse-int currentSum + parse-int number
        set-timeout check-bubble-able-to-be-clicked currentSum
  catch error
    show-message 'E', error.message
    call-handler currentIndex+1, parse-int currentSum + parse-int error.number
    set-timeout check-bubble-able-to-be-clicked currentSum

bubble-handler = (currentSum) !->
  failure-number = 0.3
  try
    if Math.random! < failure-number
      throw {message: '楼主异步调用战斗力感人，目测超过'+parse-int currentSum, currentSum: currentSum}
    else
      show-message null, '楼主异步调用战斗力感人，目测不超过'+parse-int currentSum
  catch error
    show-message null, error.message 

set-number = (char, number) !->
  $ '#'+char.toString! .find '.unread' .text number
  $ '#'+char.toString! .remove-class 'disabled enabled waiting' .add-class 'done'

show-message = (char, message) !->
  if char isnt null
    console.log "button " + char + " says: " + message
  bubble = $ '#info-bar'
  bubble.find 'li.amount' .text message