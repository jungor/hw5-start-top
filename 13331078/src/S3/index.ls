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

  (@dom, @callback-info) ->
    @enabled!
    @dom.click !~> if @state is 'enabled'
      #@@@disabled-all-other-buttons @
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
    $.get '/api/random' + Math.random(), (number, result)!~>
      if @state is 'wait'
        @done!
        Bubble.enable-bubble! if @@@all-button-is-done!
        @@@enable-all-other-buttons @
        @show-number number
        calculator .add number
        apb.enabled!
        if apb.state is 'banned'
          @callback-info 'success'
    @dom.find '.tip' .css 'visibility' 'visible'
    @dom.find '.tip' .text '...'

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
    robot.click-all-buttons-at-once!

calculator = 
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

robot =
  init: ->
    @buttons = $ '#control-ring .button'
    @bubble = $ '.info'
    @sequence = ['A' to 'E']
    @cursor = 0

  click-all-buttons-at-once: !->
    for button in @buttons
      button.click!

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

  reset: -> @cursor = 0;

$ ->
  robot.init!
  apb.reset!
  add-clicking-to-fetch-numbers-to-all-buttons !-> robot.click-next-button!
  add-clicking-to-calculate-result-to-the-bubble!
  add-reset-when-mouse-leave!

add-clicking-to-fetch-numbers-to-all-buttons = (next)!->
  $ '.icon' .click !-> apb.click!
  for let dom in $ '#control-ring .button'
    new Button ($ dom), (callback-info) !->
      console.log(callback-info)
      next!

add-clicking-to-calculate-result-to-the-bubble = !->
  new Bubble ($ '.info')

add-reset-when-mouse-leave = !->
  $ '#button' .on 'mouseleave' !->
    Button.reset-all-buttons!
    Bubble.reset-bubble!
    calculator.reset!
    apb.reset!
    robot.reset!
