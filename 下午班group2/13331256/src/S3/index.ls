class Button
  @buttons = []

  @change-all-other-buttons-to = (state, this-button) !->
    [button.change-state state for button in @buttons when button isnt this-button and button.state isnt 'done']

  @if-all-button-is-done-enable-the-bubble = !->
    [return false for button in @buttons when button.state isnt 'done']
    $ '#info-bar' .remove-class 'disable' .add-class 'enable'

  @reset = !->
    [button.reset! for button in @buttons]

  (@dom) !->
    @dom.add-class 'enable'
    @state = 'enable'
    @red-pot = @dom.find '.unread'
    @ajax = void
    @name = @dom.find '.title' .text!
    @dom.click ~> @when-clicked!
    @@@buttons.push @

  when-clicked: (then-to-do)->
    if @state is 'enable' or then-to-do isnt void
      @@@change-all-other-buttons-to 'disable', @
      @change-state 'wait'
      @get-number-and-show then-to-do

  get-number-and-show: (then-to-do)->
    @ajax =  $.get "../#{Math.random!}", (number, status) !~>
      @change-state 'done'
      @red-pot .text number
      @@@change-all-other-buttons-to 'enable', @
      @@@if-all-button-is-done-enable-the-bubble!
      then-to-do?!

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
  [new Button $ button for button in $ '.button']

add-click-to-calculate-sum-to-bubble = ->
  bubble = $ '#info-bar'
  bubble.click !->
    if bubble.has-class 'enable'
      bubble.find '#sum' .text calculate-sum!
      $ '#at-plus-container' .remove-class 'disable' .add-class 'enable'
      bubble.remove-class 'enable' .add-class 'disable'

calculate-sum = ->
  sum = 0
  [sum += +$ unread .text! for unread in $ '.unread']
  sum

add-reset-when-leave = ->
  $ '#at-plus-container' .on 'mouseleave', reset

reset = !->
  $ '#sum' .text ''
  $ '#info-bar' .remove-class 'enable' .add-class 'disable'
  Button.reset!
  robot.init!

robot =
  init: !->
    @buttons = Button.buttons
    @bubble = $ '#info-bar'
    @sequence = ['A' to 'E']
    @cur = 0
    $ '#at-plus-container' .remove-class 'disable' .add-class 'enable' 

  shuffle-order: !->
    @sequence.sort Math.random! - 0.5

  click-next: !->
    if @cur is @sequence.length
      @bubble.click!
      @cur = 0
    else @get-next-button!when-clicked !~> @click-bubble!

  click-bubble: !->
    @bubble.click! if @bubble.has-class 'enable'

  get-next-button: ->
    index = @sequence[@cur++].char-code-at! - 'A'.char-code-at!
    @buttons[index]

s3 = !->
  $ '.apb' .on 'click', !->
    unless $ '#at-plus-container' .has-class 'disable'
      reset!
      $ '#at-plus-container' .remove-class 'enable' .add-class 'disable' 
      [robot.click-next! for til robot.sequence.length]

$ ->
  new-a-Button-for-all-buttons!
  add-click-to-calculate-sum-to-bubble!
  add-reset-when-leave!
  robot.init!
  s3!
