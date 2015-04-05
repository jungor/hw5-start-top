$ ->
  all-buttons-able-to-be-clicked-to-fetch-number!
  bubble-able-to-be-clicked-to-get-sum!
  add-resetting-when-leaving-apb!

  S1-wait-user-click!

class Button
  @buttons = []

  (@dom) ->
    @state = 'enabled'
    @dom.add-class 'enabled'

    @dom.click !~> if @dom.has-class 'enabled'
      @@@disable-other-buttons @
      @wait!
      @button-fetch-number-from-server-and-show!

    @@@buttons.push @

  @disable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button
      if button.state isnt 'done'
        button.dom[0].children[1].style.visibility = 'collapse' if button.dom[0].children[1].innerHTML is ''
        button.disable!

  @enable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button
      if button.state isnt 'done'
        button.dom[0].children[1].style.visibility = ''
        button.enable!

  @all-buttons-are-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  @reset-all = !-> [button.reset! for button in @buttons]

  button-fetch-number-from-server-and-show: !->
    $.get '/', (number, result)!~>
      @done! if @state is 'waiting'
      set-bubble-able-to-be-clicked! if @@@all-buttons-are-done!
      @@@enable-other-buttons @
      @button-show-number number

  button-show-number:  (number) !-> @dom.find '.unread' .text number

  disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'
  enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'
  wait: !-> @state = 'waiting' ; @dom.remove-class 'enabled' .add-class 'waiting'
  done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'
  reset: !->
    @state = 'enabled'
    @dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @dom.find '.unread' .text ''

all-buttons-able-to-be-clicked-to-fetch-number = !->
  buttons-init!

buttons-init = !->
  buttons = $ '#control-ring .button'
  for bt in buttons
    button = new Button ($ bt)

bubble-able-to-be-clicked-to-get-sum = !->
  bubble-init!
  bubble = $ '#info-bar'
  bubble.click !~> if bubble.has-class 'enabled'
    bubble.find '.amount' .text get-buttons-sum!
    bubble.remove-class 'enabled' .add-class 'disabled'

get-buttons-sum = !->
  sum = 0
  for button in $ '#control-ring .button'
    sum += parse-int button.children[1].innerHTML.toString!
  return sum

add-resetting-when-leaving-apb = !->
  is-entering-other = false
  $ '#info-bar, #control-ring-container, .apb' .on 'mouseenter' !-> is-entering-other := true
  $ '#info-bar, #control-ring-container' .on 'mouseleave' !-> 
    is-entering-other := false
    set-timeout !-> 
      reset! if not is-entering-other
    , 0

reset = !->
  Button.reset-all!
  bubble-init!

set-bubble-able-to-be-clicked = !->
  bubble = $ '#info-bar'
  bubble.remove-class 'disabled' .add-class 'enabled'

bubble-init = !->
  bubble = $ '#info-bar'
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find 'li.amount' .text ''

S1-wait-user-click = !-> console.log 'waiting user to click...'