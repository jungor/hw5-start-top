class Bubble
  @bubble

  @reset-bubble = !-> @bubble.dom.add-class 'banned' ; $ '#result' .text ''

  @enable-bubble = !-> @bubble.dom.remove-class 'banned' ;

  @disable-bubble = !-> @bubble.dom.add-class 'banned';

  (@dom) ->
    @@@bubble = @
    @@@reset-bubble!
    @dom.click !~> if not @dom.has-class 'banned'
      @@@disable-bubble!
      $ '#result' .text calculator.sum

class Button
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

  (@dom) ->
    @enabled!
    @dom.click !~> if @state is 'enabled'
      @@@disabled-all-other-buttons @
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
        @show-number number
        calculator .add number
    @dom.find '.tip' .css 'visibility' 'visible'
    @dom.find '.tip' .text '...'

  enabled: !-> @state = 'enabled' ; @dom.remove-class 'banned'

  disabled: !-> @state = 'disabled' ; @dom.add-class 'banned'

  wait: !-> @state = 'wait' ; @dom.remove-class 'banned'

  done: !-> @state = 'done' ; @dom.add-class 'banned'

calculator = 
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

$ ->
  add-clicking-to-fetch-numbers-to-all-buttons!
  add-clicking-to-calculate-result-to-the-bubble!
  add-reset-when-mouse-leave!

add-clicking-to-fetch-numbers-to-all-buttons = !->
  for let dom in $ '#control-ring .button'
    new Button ($ dom)

add-clicking-to-calculate-result-to-the-bubble = !->
  new Bubble ($ '.info')

add-reset-when-mouse-leave = !->
  $ '#button' .on 'mouseleave' !->
    Button.reset-all-buttons!
    Bubble.reset-bubble!
    calculator.reset!

