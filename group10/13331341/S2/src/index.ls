$ ->
  robot.init!
  handle-buttons !-> robot.click-next-button!
  handle-cumulator!
  mouse-leaving-to-reset!
  wait-user-clicking!
  robot-click-from-A-to-E!

class Button
  # constructor of class Button
  (@element, @good-message, @bad-message, @number-fetched-callback)->
    @state = 'enabled'
    @element.add-class 'enabled'
    @name = @element.find '.letter' .text!
    @element.click !~> if @state is 'enabled'
      @element.find '.unread' .add-class 'showunread'
      @@@disable-other-buttons @
      @wait!
      @fetch-and-show-random-number!
    @@@buttons.push @

  @buttons = []

  @disable-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @enable-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @all-buttons-are-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true
  @reset-all-buttons = !-> [button.reset! for button in @buttons]

  disable: !-> @state = 'disabled' ; @element.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @element.remove-class 'disabled' .add-class 'enabled'

  wait: !-> @state = 'waiting' ; @element.remove-class 'enabled' .add-class 'waiting'; @element.find '.unread' .text '...'

  done: !-> @state = 'done' ; @element.remove-class 'waiting' .add-class 'done'

  reset: !-> 
    @state = 'enabled'
    @element.remove-class 'disabled waiting done' 
    @element.add-class 'enabled'
    @element.find '.unread' .text ''
    @element.find '.unread' .remove-class 'showunread'

  display-random-number: (number)!-> @element.find '.unread' .text number

  display-message: !-> console.log "#{@name}说： #{@good-message}"

  check-error: (number)!-> 
    if is-success = Math.random! > 0.3
      @display-message @good-message
      @number-fetched-callback error = null, number
    else
      @number-fetched-callback message: @bad-message, data: number 

  fetch-and-show-random-number: !-> $.get '/api/random', (number, result)!~>
    @done!
    @@@fetch-all-random-numbers-done! if @@@all-buttons-are-done!
    @@@enable-other-buttons @
    @display-random-number number
    @check-error number

#construct of cumulator
cumulator =
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

handle-buttons = (next)-> 
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '不怪不怪']
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom), good-messages[i], bad-messages[i], (error, number)!->
      if error
        console.log "#{button.name}错误消息: #{error.message}"
        number = error.data
      cumulator.add number
      next?!


handle-cumulator = ->
  infobar = $ '#info-bar'
  infobar.add-class 'disabled'
  Button.fetch-all-random-numbers-done = !-> infobar.remove-class 'disabled'; infobar.add-class 'enabled'
  infobar.click !-> if infobar.has-class 'enabled'
    infobar.remove-class 'enabled'
    infobar.add-class 'disabled'
    infobar.find '#sum' .text cumulator.sum

reset-all = !->
  cumulator.reset!
  Button.reset-all-buttons!
  infobar = $ '#info-bar'
  infobar.remove-class 'enabled'
  infobar.add-class 'disabled'
  infobar.find '#sum' .text ''
  robot.init!

mouse-leaving-to-reset = !->
  $ '#button' .on 'mouseleave' (event)!-> 
    set-timeout !-> 
      reset-all!
    , 0

wait-user-clicking = !-> console.log "wait user clicking ..."

robot =
  init: !->
    @infobar = $ '#info-bar'
    @buttons = $ '#control-ring .button'
    @order = ['A' to 'E']
    @count = 0

  click-next-button: !-> if @count is @order.length then @infobar.click! else @get-next-button!click!

  get-next-button: -> 
    i = @order[@count++].char-code-at! - 'A'.char-code-at!
    @buttons[i]

robot-click-from-A-to-E = !-> $ '#button .apb' .click !-> robot.click-next-button!
