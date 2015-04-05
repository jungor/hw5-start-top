class Button
  @buttons = []
  @FAIL-RATE = 0.2
  @disable-other-buttons = (the-button)-> [button.disable! for button in @buttons when button isnt the-button and button.state isnt 'done']
  @enabled-other-buttons = (the-button) -> [button.enable! for button in @buttons when button isnt the-button and button.state isnt 'done']
  @reset-all-buttons =-> [button.reset! for button in @buttons]
  @click-all =-> [button.dom.click! for button in @buttons]
  
  (@dom, @good-massage, @bad-massage, @call-back-func)->
    @state = 'enabled'
    @dom.click ~>
      if @state is 'enabled'
        console.log "button clicked"
        @waiting!
        @get-number-and-display!
        if robot.all-click-on isnt true then @@@disable-other-buttons @
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
      if @state isnt 'waiting' and @state isnt 'enabled' then return
      if robot.all-click-on is false and @state isnt 'waiting' then return
      @done!
      if @@@all-buttons-done!
        @@@enable-bubble!
      @display-number number
      calculator.add number
      @@@enabled-other-buttons @
      @success-or-fail number

  display-number : (number) -> @dom.find '.unread' .text number

  success-or-fail : (number) ->
    if is-success = Math.random! > @@@FAIL-RATE
      @saying @good-massage;
      @call-back-func error = null, number;
    else @saying @bad-massage;@call-back-func @bad-massage, number;
  
  saying: (message) !-> $ '#doubi' .text message
  disable: !-> @state = 'disabled'; @dom.remove-class 'enable' .add-class 'disable';console.log 'button.disabled';
  enable: !-> @state = 'enabled'; @dom.remove-class 'disable' .add-class 'enable';console.log 'button.enabled';
  done: !-> @state = 'done'; @dom.remove-class 'waiting' .add-class 'done';console.log 'button.done';
  waiting: !-> @state = 'waiting'; @dom.remove-class 'enable' .add-class 'button.waiting';console.log 'button.waiting';
  reset: !-> @state = 'enabled'; @dom.remove-class 'disable waiting done' .add-class 'enable';@dom.find '.unread' .text '';console.log 'button.reset'

display-massage =-> $'#info-bar'

init-all-buttons =  (call-back) ->
  console.log "start init"
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '不怪']
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom), good-messages[i], bad-messages[i], (error, number)!->
      console.log 'call-back'
      if error then display-massage @bad-massage
      else display-massage @good-massage;
      call-back?!

init-bubble =->
  bubble = $ '#info-bar'
  bubble.add-class 'disable'
  bubble.click !->
    if Button.all-buttons-done! 
      bubble.find 'span' .text calculator.sum
      $ '#doubi' .text '楼主blablablabla'

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
  robot.init!
  Button.reset-all-buttons!
  $ '#order' .text ''
  $ '#doubi' .text ''

enable-auto-click =->
  console.log 'enable-auto-click'
  start-button = $('#button .icon')
  start-button.click !-> 
    if (robot.auto-button-state)
      robot.autoOn = true;
      robot.auto-button-state = false;
      robot.click-all!

robot =
  init: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @index = 0
    @order = ['A' to 'E']
    @autoOn = false;
    @auto-button-state = true;
    @all-click-on = false;

  random-order: !-> @order.sort -> 0.5 - Math.random!
  display-order: !-> $ '#order' .text @order

  next-click: !->
    if @autoOn
      if @index is @order.length then @bubble.click!
      else @buttons[@order[@index].char-code-at! - 'A'.char-code-at!].click!;@index++;

  click-all: !->
    @all-click-on = true;Button.click-all!;

calculator =
  sum: 0
  add: (number)-> @sum+=parse-int number

$ !->
  robot.init!
  init-all-buttons !-> if robot.all-click-on then robot.bubble.click!
  init-bubble!
  reset-when-leave-button!
  enable-auto-click!
