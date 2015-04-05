class Button
  @buttons = []
  @disable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button and button.state isnt \done
      button.disable!
  @enable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button and button.state isnt \done
      button.enable!
  @reset-all = !->
    @index = 0
    for let button in @buttons
      button.reset!

  @all-buttons-clicked = !->
    [return false for button in @buttons when button.state isnt \done]
    return true

  (@dom, @good-message, @i) ->
    @state = 'enable';
    @ballon = @dom.find '.unread'
    @ballon.add-class 'hidden-ballon'
    @dom.add-class 'enable';
    console.log @good-message
    @dom.click !~> if @state is 'enable'
      console.log @good-message
      @clicked!
      @get-number!

    @@@buttons.push @


  get-number: !->
    $.get '/hehe'+@i  , (number, status) !~> if @state is \clicked
      @done!
      @show-number-in-ballon number
      Big-button.count(number)
      if (@@@all-buttons-clicked! is true)
        Big-button.change-big-button-state!
        if At-button.clicked is true
          Big-button.ready!

  enable: !-> 
    @state = "enable"
    @dom.remove-class "disable"
    @dom.add-class "enable"  
  disable: !->
    @state = "disable"
    @dom.remove-class "enable"
    @dom.add-class "disable"

  clicked: !->
    @state = "clicked";
    @ballon.remove-class \hidden-ballon
    @ballon.add-class \waiting-ballon
    @ballon.text \...

  done: !->
    @state = "done"
    @dom.remove-class "enable"
    @dom.add-class "disable"

  reset: !->
    @state = "enable"
    @dom.remove-class 'disable'
    @dom.add-class 'enable'
    @ballon.remove-class @state
    @ballon.add-class 'hidden-ballon'
    @ballon.text ''

  show-number-in-ballon: (number) !->
    @ballon.text number


add-clicking-to-all-buttons = !->
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪']
  for let dom, i in $ '.button'
    button = new Button ($ dom) , good-messages[i] , i

add-clicking-to-big-buttons = !->
  dom = $ '#info-bar'
  big-button = new Big-button ($ dom)

add-clicking-to-at-button = !->
  dom = $ '#icon'
  at-button = new At-button($ dom)


$ !->
  add-clicking-to-all-buttons!
  add-clicking-to-big-buttons!
  add-clicking-to-at-button!
  reset-all-when-leaving!
  reset-all-when-entering!

reset-all-when-leaving = !->
  all = $ '#bottom-positioner'
  all.mouseleave !->
    Big-button.reset-large-button!
    Button.reset-all!
    At-button.at-button-reset!

reset-all-when-entering = !->
  all = $ '#buttom-positoner'
  all.mouseenter !->
    Big-button.reset-large-button!
    Button.reset-all!
    At-button.at-button-reset!

class Big-button
  @number = 0
  @reset-large-button = !->
    @big-button.reset!
  @big-button
  @count = (new-number)!->
    @number += parseInt(new-number)
  @change-big-button-state = !->
    @big-button.enable!

  @ready = !->
    @big-button.dom.click!
  show-number-in-big-button: !->
    @show-number-container.text @@@.number


  (@dom) !->
    @disable!
    @show-number-container = @dom.find 'p'
    @dom.click !~>
      if @state is \enable
        @show-number-in-big-button!
        @disable!
    @@@big-button = @

  disable:!->
    @state = \disable
    @dom.remove-class \enable
    @dom.add-class \disable

  enable:!->
    @state = \enable
    @dom.remove-class \disable
    @dom.add-class \enable

  reset:!->
    @state = \disable
    @dom.remove-class \enable
    @dom.add-class \disable
    @@@number = 0
    @show-number-container.text ""

class At-button
  @button
  @clicked
  @at-button-reset = !-> @button.reset!
  (@dom)->
    button = @dom
    @state = 'enable'
    @initialize!
    @dom.click !~> if @state is \enable
      @@@clicked = true
      @click-all!
      @state = \disable
    @@@button = @

  click-all: !->
    for button in @buttons
      button.click!
    Big-button.ready!
  enable:->
    @state = 'enable'
  disable:->
    @state = 'disable'
  reset:->
    @state = 'enable'
  initialize:->
    @buttons = $ '#control-ring .button'
    @big-button = ($ '#info-bar')
    @index = 0
    @button-size = 5