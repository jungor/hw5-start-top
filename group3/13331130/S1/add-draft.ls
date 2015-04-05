class Button
  @buttons = []

  @disable-all-other-buttons = (this-button) -> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']
  @enable-all-other-buttons = (this-button) -> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']
  @reset-all = !-> for let buutton in @buttons
    button.reset!
  @all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  (@dom) ->
    @state = 'enable'
    @dom.add-class 'enable'
    @dom.click !~> if @state is 'enable'
      @@@disable-all-other-buttons @
      @wait!
      @fetch-number-and-show!
    @@@buttons.push @

  fetch-number-and-show: !-> $.get '/', (number, result) !~>
    @done!
    @@@all-number-fetched-callback! if @@@all-button-is-done!
    @@@enable-all-other-buttons @
    @show-number number
    cmulattor.add number

  show-number: (number) -> @dom.find '.number' .text number

  disable: !-> @state = 'disable' ; @dom.remove-class 'enable' .add-class 'disable'
  enable: !-> @state = 'enable' ; @dom.remove-class 'disable' .add-class 'enable'
  wait: !-> @state = 'waitting' ; @dom.remove-class 'enable' .add-class 'waitting'
  done: !-> @state = 'done' ; @dom.remove-class 'waitting' .add-class 'done'

  reseet: !->
    @state = 'enable' ; @dom.remove-class 'disable waitting done' .add-class 'enable'
    @dom.find 'number' .text '...'

cmulattor = 
  sum: 0
  add: (number) -> @sum += +number
  reset: !-> @sum = 0

$ ->
  add-click-to-get-number-to-all-buttons!
  add-click-to-get-calculate-to-bubble!
  add-mouseleave-to-apb!

add-click-to-get-number-to-all-buttons = ->
  for dom in $ '.button'
    button = new Button($ dom)

add-click-to-get-calculate-to-bubble = ->
  bubble = $ ".info"
  bubble.add-class 'disable'
  Button.all-number-fetched-callback = !-> bubble.remove-class 'disable' .add-class 'enable'
  bubble.click !-> if bubble.has-class 'enable'
    bubble.find '#result' .text cmulattor.sum

reset = !->
  cmulattor.reset!
  Button.reset-all!
  $ '.info' .remove-class 'enable' .add-class 'disable'

add-mouseleave-to-apb = ->
  $ '.apb' .onmouseleave =  !~>
    reset!
