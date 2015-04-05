class Button
  @buttons = []

  @change-all-other-buttons-to = (state, this-button) !->
    [button.change-state state for button in @buttons when button isnt this-button and button.state isnt 'done']

  @if-all-button-is-done-enable-the-bubble = !->
    [return false for button in @buttons when button.state isnt 'done']
    $ '#info-bar' .remove-class 'disable' .add-class 'enable'

  @reset = !->
    [button.reset! for button in @buttons]

  (@dom, @good-message, @bad-message) !->
    @dom.add-class 'enable'
    @state = 'enable'
    @red-pot = @dom.find '.unread'
    @ajax = void
    @name = @dom.find '.title' .text!
    @dom.click ~> @when-clicked!
    @@@buttons.push @

  when-clicked: (then-to-do)->
    if @state is 'enable'
      @@@change-all-other-buttons-to 'disable', @
      @change-state 'wait'
      @get-number-and-show then-to-do

  get-number-and-show: (then-to-do)->
    @ajax =  $.get "../#@name", (number, status) !~>
      @change-state 'done'
      @red-pot .text number
      @@@change-all-other-buttons-to 'enable', @
      @@@if-all-button-is-done-enable-the-bubble!
      if then-to-do
        if Math.random! > 0.5
          @show-massage @good-message, null
        else
          @show-massage @bad-message, true
          @red-pot .text 'x'
        then-to-do!

  show-massage: (massage, error) ->
    $ '.show-message' .text massage
    if error then $ '.show-message' .add-class 'bad' .remove-class 'good' else $ '.show-message' .add-class 'good' .remove-class 'bad'

  change-state: (state) !->
    @state = state
    switch state
      when 'enable'
        @dom.remove-class 'disable' .add-class 'enable'
        @red-pot .remove-class 'wait'
      when 'disable'
        @dom.remove-class 'enable' .add-class 'disable'
      when 'wait'
        @dom.remove-class 'enable' .add-class 'disable'
        @red-pot .remove-class 'hide' .add-class 'wait' .text '...'
      when 'done'
        @dom.remove-class 'enable' .add-class 'disable'
        @red-pot .remove-class 'hide wait'

  reset: !->
    @state = 'enable'
    @dom.remove-class 'disable' .add-class 'enable'
    @red-pot .add-class 'unread hide'
    @ajax?.abort!

new-a-Button-for-all-buttons = !->
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这才不是个天大的秘密呢', '我才知道呢', '你才知道呢', '他才知道呢', '才不怪呢，讨厌~']
  [new Button $(button), good-messages[i], bad-messages[i] for let button, i in $ '.button']

add-click-to-calculate-sum-to-bubble = ->
  bubble = $ '#info-bar'
  bubble.click !->
    if bubble.has-class 'enable'
      bubble.find '#sum' .text calculate-sum!
      $ '#at-plus-container' .remove-class 'disable' .add-class 'enable'
      bubble.remove-class 'enable' .add-class 'disable'

calculate-sum = ->
  sum = 0
  [sum += +$ unread .text! for unread in $ '.unread' when !isNaN(+$ unread .text!)]
  sum

add-reset-when-leave = ->
  $ '#at-plus-container' .on 'mouseleave', reset

reset = !->
  $ '#sum' .text ''
  $ '.click-sequ' .text ''
  $ '#info-bar' .remove-class 'enable' .add-class 'disable'
  $ '.show-message' .text ''
  $ '.show-message' .remove-class! .add-class 'show-message'
  Button.reset!
  robot.init!

robot =
  init: !->
    @buttons = Button.buttons
    @bubble = $ '#info-bar'
    @sequence = ['A' to 'E']
    @shuffle-order!
    @cur = 0
    $ '#at-plus-container' .remove-class 'disable' .add-class 'enable' 

  show-order: !->
    $ '.click-sequ' .text @sequence * \,

  shuffle-order: !->
    @sequence.sort -> Math.random! - 0.5

  click-next: !->
    if @cur is @sequence.length
      @bubble.click!
      @cur = 0
      $ '.show-message' .text "楼主异步调用战斗力感人，目测不超过#{$ '#sum' .text!}"
    else @get-next-button!when-clicked !~> @click-next!

  get-next-button: ->
    index = @sequence[@cur++].char-code-at! - 'A'.char-code-at!
    @buttons[index]

s5 = !->
  $ '.apb' .on 'click', !->
    unless $ '#at-plus-container' .has-class 'disable'
      reset!
      $ '#at-plus-container' .remove-class 'enable' .add-class 'disable' 
      robot.show-order!
      robot.click-next!

$ ->
  new-a-Button-for-all-buttons!
  add-click-to-calculate-sum-to-bubble!
  add-reset-when-leave!
  robot.init!
  s5!
