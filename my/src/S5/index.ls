class Button
  @buttons = []

  @disable-all-other-buttons = (this-button) !->
    [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @enable-all-other-buttons = (this-button) !->
    [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @if-all-button-is-done-enable-the-bubble = !->
    [return false for button in @buttons when button.state isnt 'done']
    $ '#info-bar' .remove-class 'disable' .add-class 'able'

  @reset = !->
    [button.reset! for button in @buttons]

  (@dom, @good-message, @bad-message) !->
    @dom.add-class 'able'
    @red-pot = @dom.find '.unread'
    @state = 'able'
    @ajax = void
    @name = @dom.find 'title' .text!
    @dom.click ~> @when-clicked!
    @@@buttons.push @

  when-clicked: (then-to-do)->
    if @state is 'able'
      @@@disable-all-other-buttons @
      @wait!
      @get-number-and-show then-to-do

  get-number-and-show: (then-to-do)->
    @ajax =  $.get "../#@name", (number, status) !~>
      @done!
      @show-number number
      @@@enable-all-other-buttons @
      @@@if-all-button-is-done-enable-the-bubble!
      if then-to-do
        if Math.random! > 0.5
          @show-massage @good-message, null
        else
          @show-massage @bad-message, true
          @red-pot .text 'x'
        then-to-do!

  show-number: (number) !->
    @red-pot .text number

  show-massage: (massage, error) ->
    $ '.show-message' .text massage
    if error then $ '.show-message' .add-class 'bad' .remove-class 'good' else $ '.show-message' .add-class 'good' .remove-class 'bad'

  enable: !->
    @state = 'able'
    @dom.remove-class 'disable' .add-class 'able'
    @red-pot .remove-class 'wait'

  disable: !->
    @state = 'disable'
    @dom.remove-class 'able' .add-class 'disable'

  wait: !->
    @disable!
    @state = 'wait'
    @red-pot .remove-class 'hide' .add-class 'wait' .text '...'

  done: !->
    @disable!
    @state = 'done'
    @red-pot .remove-class 'hide wait'

  reset: !->
    @state = 'able'
    @dom.remove-class 'disable' .add-class 'able'
    @red-pot .add-class 'unread hide'
    @ajax?.abort!

new-a-Button-for-all-buttons = !->
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这才不是个天大的秘密呢', '我才知道呢', '你才知道呢', '他才知道呢', '才不怪呢，讨厌~']
  [new Button $(button), good-messages[i], bad-messages[i] for let button, i in $ '.button']

add-click-to-calculate-sum-to-bubble = ->
  bubble = $ '#info-bar'
  bubble.click !->
    if bubble.has-class 'able'
      bubble.find '#sum' .text calculate-sum!
      $ '#at-plus-container' .remove-class 'disable' .add-class 'able'
      bubble.remove-class 'able' .add-class 'disable'

calculate-sum = ->
  sum = 0
  [sum += +$ unread .text! for unread in $ '.unread' when !isNaN(+$ unread .text!)]
  sum

add-reset-when-leave = ->
  $ '#at-plus-container' .on 'mouseleave', reset

reset = !->
  $ '#sum' .text ''
  $ '.click-sequ' .text ''
  $ '#info-bar' .remove-class 'able' .add-class 'disable'
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
    $ '#at-plus-container' .remove-class 'disable' .add-class 'able'

  show-order: !->
    $ '.click-sequ' .text @sequence * \,

  shuffle-order: !->
    @sequence.sort -> Math.random! - 0.5

  click-next: !->
    if @cur is @sequence.length
      @bubble.click!
      @cur = 0
      $ '.show-message' .text "楼主异步调用战斗力感人，目测不超过#{$ '#sum' .text!}"
    else @get-next-button!when-clicked !~>
      @click-next!

  get-next-button: ->
    index = @sequence[@cur++].char-code-at! - 'A'.char-code-at!
    @buttons[index]

s5 = !->
  $ '.apb' .on 'click', !->
    unless $ '#at-plus-container' .has-class 'disable'
      reset!
      $ '#at-plus-container' .remove-class 'able' .add-class 'disable' 
      robot.show-order!
      robot.click-next!

$ ->
  new-a-Button-for-all-buttons!
  add-click-to-calculate-sum-to-bubble!
  add-reset-when-leave!
  robot.init!
  s5!
