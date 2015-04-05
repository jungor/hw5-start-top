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
    @dom.click !~> if @state is 'enable'
      @@@change-all-other-buttons-to 'disable', @
      @change-state 'wait'
      @get-number-and-show!
    @@@buttons.push @

  get-number-and-show: !->
    @ajax =  $.get '../', (number, status) !~>
      @change-state 'done'
      @red-pot .text number
      @@@change-all-other-buttons-to 'enable', @
      @@@if-all-button-is-done-enable-the-bubble!

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

$ ->
  new-a-Button-for-all-buttons!
  add-click-to-calculate-sum-to-bubble!
  add-reset-when-leave!
