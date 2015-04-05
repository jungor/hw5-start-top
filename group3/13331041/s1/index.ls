class Button
  @buttons = []
  @disable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button and button.state isnt \done
      button.disable!
  @enable-other-buttons = (this-button)->
    for button in @buttons when button isnt this-button and button.state isnt \done
      button.enable!
  @reset-all = !->
    for let button in @buttons
      button.reset!

  @all-buttons-clicked = !->
    [return false for button in @buttons when button.state isnt \done]
    return true
        # body...

  (@dom)->
    @state = 'enable';
    @ballon = @dom.find '.unread'
    @ballon.add-class 'hidden-ballon'
    @dom.add-class 'enable';
    @dom.click !~> if @state is 'enable'
      @@@disable-other-buttons @
      @clicked!
      @get-number!

    @@@buttons.push @


  get-number: !->
    $.get '/hehe' (number, status) !~> if @state is \clicked
      @@@enable-other-buttons @
      @done!
      @show-number-in-ballon number
      Big-button.count(number)
      if (@@@all-buttons-clicked! is true)
        Big-button.change-big-button-state!

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
  for let dom in $ '.button'
    button = new Button ($ dom)

add-clicking-to-big-buttons = !->
  dom = $ '#info-bar'
  big-button = new Big-button ($ dom)

$ !->
  add-clicking-to-all-buttons!
  add-clicking-to-big-buttons!
  reset-all-when-leaving!
  reset-all-when-entering!

reset-all-when-leaving = !->
  all = $ '#bottom-positioner'
  all.mouseleave !->
    Big-button.reset-large-button!
    Button.reset-all!

reset-all-when-entering = !->
  all = $ '#buttom-positoner'
  all.mouseenter !->
    Big-button.reset-large-button!
    Button.reset-all!

class Big-button
  @number = 0
  @reset-large-button = !->
    @big-button.reset!
  @big-button
  @count = (new-number)!->
    @number += parseInt(new-number)
  @change-big-button-state = !->
    @big-button.enable!
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
