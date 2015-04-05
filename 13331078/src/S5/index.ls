class Bubble
  @bubble

  @reset-bubble = !-> @bubble.dom.add-class 'banned' ; $ '#result' .text 0 ; $ '#order' .text '' ; $ '#msg' .text ''

  @enable-bubble = !-> @bubble.dom.remove-class 'banned' ;

  @disable-bubble = !-> @bubble.dom.add-class 'banned';

  (@dom) ->
    @@@bubble = @
    @@@reset-bubble!
    @dom.click !~> if not @dom.has-class 'banned'
      @@@disable-bubble!
      $ '#msg' .css 'color' '#43f974'
      $ '#msg' .text '楼主异步调用战斗力感人，目测不超过'
      $ '#result' .text calculator.sum

class Button
  @failure-rate = 0.3

  @buttons = []

  @enable-all-other-buttons = (this-button)!->
    [button.enabled! for button in @buttons when button isnt this-button and button.state is 'disabled']

  @disabled-all-other-buttons = (this-button)!->
    [button.disabled! for button in @buttons when button isnt this-button and button.state is 'enabled']

  @all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done'] 
    true

  @reset-all-buttons = ->
    [button.reset! for button in @buttons]

  (@dom, @good-message, @bad-message, @callback-info) ->
    @enabled!
    @dom.click !~> if @state is 'enabled'
      @@@disabled-all-other-buttons @
      apb.disabled!
      @wait!
      @fetch-number-and-show!
    @@@buttons.push @

  reset: !->
    @enabled!
    @dom.find '.tip' .text ''
    @dom.find '.tip' .css 'visibility' 'hidden'

  show-number: (number)!-> @dom.find '.tip' .text number

  fetch-number-and-show: !-> 
    $.get '/api/random', (number, result)!~>
      if @state is 'wait'
        @done!
        Bubble.enable-bubble! if @@@all-button-is-done!
        @@@enable-all-other-buttons @
        @success-or-fail number
        apb.enabled!
        if apb.state is 'banned'
          @callback-info ''
    @dom.find '.tip' .css 'visibility' 'visible'
    @dom.find '.tip' .text '...'

  success-or-fail: (number)->
    if @@@failure-rate < Math.random!
      @show-number number
      calculator .add number
      $ '#result' .text calculator.sum
      $ '#msg' .css 'color' '#43f974'
      $ '#msg' .text @good-message
    else
      $ '#msg' .css 'color' 'red'
      $ '#msg' .text @bad-message

  enabled: !-> @state = 'enabled' ; @dom.remove-class 'banned'

  disabled: !-> @state = 'disabled' ; @dom.add-class 'banned'

  wait: !-> @state = 'wait' ; @dom.remove-class 'banned'

  done: !-> @state = 'done' ; @dom.add-class 'banned'

apb =
  enabled: -> if @state is not 'banned' then @state = 'enabled'

  disabled: ->if @state is not 'banned' then @state = 'disabled'

  banned: -> @state = 'banned'

  reset: -> @state = 'enabled'

  click: -> if @state is 'enabled'
    @banned!
    robot.shuffle!
    robot.show-sequence!
    robot.click-next-button!

calculator = 
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

robot =
  init: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '.info'
    @sequence = ['A' to 'E']
    @cursor = 0
    apb.reset!

  shuffle: !-> @sequence .sort -> 0.5 - Math.random!

  show-sequence: !-> $ '#order' .text @sequence.join ','

  click-next-button: !-> if @bubble-is-able-to-click! then @bubble.click! else @get-next-button!click!

  bubble-is-able-to-click: -> @cursor is @sequence.length

  get-next-button: ->
    if @bubble-is-able-to-click!
      return @bubble
    else
      index = @sequence[@cursor++].char-code-at! - 'A'.char-code-at!
      button = @buttons[index]
      if $ button .has-class 'banned'
        return @get-next-button!
      else
        return button

  reset: -> @cursor = 0; apb.reset!

$ ->
  robot.init!
  add-clicking-to-fetch-numbers-to-all-buttons !-> robot.click-next-button!
  add-clicking-to-calculate-result-to-the-bubble!
  add-reset-when-mouse-leave!

add-clicking-to-fetch-numbers-to-all-buttons = (next)!->
  $ '.icon' .click !-> apb.click!
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '不怪']
  for let dom, i in $ '#control-ring .button'
    new Button ($ dom), good-messages[i], bad-messages[i], (callback-info) !->
      console.log(callback-info)
      next!

add-clicking-to-calculate-result-to-the-bubble = !->
  new Bubble ($ '.info')

add-reset-when-mouse-leave = !->
  $ '#button' .on 'mouseleave' !->
    Button.reset-all-buttons!
    Bubble.reset-bubble!
    calculator.reset!
    robot.reset!
