class Button
  @buttons = []
  @FAIL-RATE = 0.2
  @disable-other-buttons = (the-button)-> [button.disable! for button in @buttons when button isnt the-button and button.state isnt 'done']
  @enabled-other-buttons = (the-button) -> [button.enable! for button in @buttons when button isnt the-button and button.state isnt 'done']
  @reset-all-buttons =-> [button.reset! for button in @buttons]

  (@dom, @good-massage, @bad-massage, @call-back-func)->
    @state = 'enabled'
    @dom.click ~>
      if @state is 'enabled'
        console.log "button clicked"
        @waiting!
        @@@disable-other-buttons @
        @get-number-and-display!
    @@@buttons.push @

  @all-buttons-done =->
    [return false for button in @buttons when button.state isnt 'done']
    true;

  @enable-bubble =->
    console.log 'bubble enabled'
    $ '#info-bar' .add-class 'enable'

  get-number-and-display :->
    @dom.find '.unread' .text '...'
    $.get '/api/random', (number, result)!~>
      @done!
      if @@@all-buttons-done!
        @@@enable-bubble!
      @display-number number
      calculator.add number
      @success-or-fail number
      @@@enabled-other-buttons @

  display-number : (number) -> @dom.find '.unread' .text number

  success-or-fail : (number) ->
    if is-success = Math.random! > @@@FAIL-RATE
      @call-back-func @good-massage, number
    else @call-back-func @bad-massage, number

  disable: !-> @state = 'disabled'; @dom.remove-class 'enable' .add-class 'disable';console.log 'button.disabled';
  enable: !-> @state = 'enabled'; @dom.remove-class 'disable' .add-class 'enable';console.log 'button.enabled';
  done: !-> @state = 'done'; @dom.remove-class 'waiting' .add-class 'done';console.log 'button.done';
  waiting: !-> @state = 'waiting'; @dom.remove-class 'enable' .add-class 'button.waiting';
  reset: !-> @state = 'enabled'; @dom.remove-class 'disable waiting done' .add-class 'enable';@dom.find '.unread' .text '';console.log 'button.reset'

display-massage =-> $'#info-bar'

init-all-buttons =  (call-back) ->
  console.log "start init"
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '不怪']
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom), good-messages[i], bad-messages[i], (error, number)!->
      if error then display-massage @bad-massage
      else display-massage @good-massage
      call-back?!

init-bubble =->
  bubble = $ '#info-bar'
  bubble.add-class 'disable'
  bubble.click !-> if Button.all-buttons-done! then bubble.find 'span' .text calculator.sum

reset-when-leave-button =->
  is-enter-other = false;
  $ '#at-plus-container' .on 'mouseenter' !-> is-enter-other := true;
  $ '#at-plus-container' .on 'mouseleave' (event)!-> 
    is-enter-other := false;
    set-timeout !-> 
      reset! if not is-enter-other
    , 0

reset =->
  console.log 'reset'
  calculator.sum = 0;
  bubble = $('#info-bar')
  bubble.find 'span' .text ''
  Button.reset-all-buttons!

robot =
  init: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @index = 0
    @order-s = [1 to 5]

  random-order: !-> @order-s.sort ->  0.5 - Math.random!
  display-order: !-> $ '.order' .text @order-s.join ','

  next-click: !->
    if @index is order-s.length then @bubble.click!
    else @buttons[@order-s[@index++]].click!

calculator =
  sum: 0
  add: (number)-> @sum+=parse-int number

$ !->
  init-all-buttons!
  init-bubble!
  reset-when-leave-button!
