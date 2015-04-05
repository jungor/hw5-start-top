class Button
  @FAILURE-RATE = 0.3
  @buttons = []

  @disable-all-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @enable-all-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

  @all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  (@dom, @number-fetched-callback)->
    @state = 'enabled' ; @dom.add-class 'enabled'
    @name = @dom.find '.title' .text!
    @dom.click !~> if @state is 'enabled'
      @@@disable-all-other-buttons @
      @fetch-number-and-show!
    @@@buttons.push @

  fetch-number-and-show: !-> $.get '/api/random', (number, result)!~>
    @done!
    @@@all-number-fetched-callback! if @@@all-button-is-done!
    @@@enable-all-other-buttons @
    @show-number number

  show-number: (number)!-> @dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'

  done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'



mycalculate =
  sum: 0
  add: (number)->@sum += parse-int number

$ ->
  auto.initial!
  buttonClick !-> auto.click-next!
  getSum!


buttonClick = (next)-> 
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom), (error, number)!->
      if error
        number = error.data
      cumulator.add number
      next?!


getSum = ->
  bubble = $ '#info-bar' 
  bubble.add-class 'disabled'
  Button.all-number-fetched-callback = !-> bubble.remove-class 'disabled' .add-class 'enabled'
  bubble.click !-> if bubble.has-class 'enabled'
    bubble.find '.amount' .text mycalculate.sum


auto =
  initial: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @sequence = ['A' to 'E']
    @cursor = 0




