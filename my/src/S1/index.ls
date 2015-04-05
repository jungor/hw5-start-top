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

  (@dom) !->
    @dom.add-class 'able'
    @state = 'able'
    @ajax = void
    @name = @dom.find '.title' .text!
    @dom.click !~> if @state is 'able'
      @@@disable-all-other-buttons @
      @wait!
      @get-number-and-show!
    @@@buttons.push @

  get-number-and-show: !->
    @ajax =  $.get '../', (number, status) !~>
      @done!
      @show-number number
      @@@enable-all-other-buttons @
      @@@if-all-button-is-done-enable-the-bubble!

  show-number: (number) !->
    @dom.find '.unread' .text number

  enable: !->
    @state = 'able'
    @dom.remove-class 'disable' .add-class 'able'
    @dom.find '.unread' .remove-class 'wait'

  disable: !->
    @state = 'disable'
    @dom.remove-class 'able' .add-class 'disable'

  wait: !->
    @disable!
    @state = 'wait'
    @dom.find '.unread' .remove-class 'hide' .add-class 'wait' .text '...'

  done: !->
    @disable!
    @state = 'done'
    @dom.find '.unread' .remove-class 'hide wait'

  reset: !->
    @state = 'able'
    @dom.remove-class 'disable' .add-class 'able'
    @dom.find '.unread' .add-class 'unread hide'
    @ajax?.abort!

new-a-Button-for-all-buttons = !->
  [new Button $ button for button in $ '.button']

add-click-to-calculate-sum-to-bubble = ->
  bubble = $ '#info-bar'
  bubble.click !->
    if bubble.has-class 'able'
      bubble.find '#sum' .text calculate-sum!

calculate-sum = ->
  sum = 0
  [sum += +$ unread .text! for unread in $ '.unread']
  sum

add-reset-when-leave = ->
  $ '#at-plus-container' .on 'mouseleave', reset

reset = !->
  $ '#sum'.text = ''
  $ '#info-bar' .remove-class 'able' .add-class 'disable'
  Button.reset!

$ ->
  new-a-Button-for-all-buttons!
  add-click-to-calculate-sum-to-bubble!
  add-reset-when-leave!
