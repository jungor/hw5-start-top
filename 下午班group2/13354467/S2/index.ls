robot =
  initial: !->
    @count = 0                         #count记录自动点击时被点击的按钮的数量

    @buttons = $ '#control-ring .button'

    binding-robot-to-apb = !~> $ '#button .apb' .click !~>
      if Button.all-button-enabled!    #所有按钮都未被按，才能执行机器人操作
          @buttons[@count++] .click!
    binding-robot-to-apb!

  click-next-button: !->
    if @count isnt 0                    #只有启动机器人操作时，count才为非零
      if @count is 5
        $ '#info-bar' .text Button.sum
        $ '#info-bar' .css("background-color","gray")
      else
        @buttons[@count++] .click!

  reset: !->
    @count = 0

class Bubble
  ->
    $ '#info-bar' .click !->
      if $ '#info-bar' .css("background-color") is "rgb(0, 0, 255)"
         $ '#info-bar' .text Button.sum 
         $ '#info-bar' .css("background-color","gray")
  @reset = !->
    $ '#info-bar' .text ''
    $ '#info-bar' .css("background-color","gray")

class Button
  @sum = 0

  @buttons = []

  disable: !-> @state = 'disabled' ; $ this.dom .css("background-color","gray")

  enable: !-> @state = 'enabled' ; $ this.dom .css("background-color","blue")

  waiting: !-> @state = 'waiting'; $ this.dom .find '.unread' .css("opacity","0.7"); $ this.dom .find '.unread' .text '...'

  @disable-others = (this-button) !-> 
    for button in @buttons 
      if button isnt this-button and button.state isnt 'done'
        button.disable! 

  @enable-others = (this-button) !-> 
    for button in @buttons 
      if button isnt this-button and button.state isnt 'done'
        button.enable!

  @all-button-enabled = ->
    [return false for button in @buttons when button.state isnt 'enabled']
    true

  @all-button-done = -> 
    [return false for button in @buttons when button.state isnt 'done']
    true

  @reset = !->
    @sum = 0
    for button in @buttons
      button.state = 'enabled'
      button.dom.css("background-color","blue")
      button.dom.find '.unread' .text ''
      button.dom.find '.unread' .css("opacity","0");

  get-number: !-> $.get '/', (number, result)!~>
    if @state is 'waiting'
      @state = 'done'
      @dom .css("background-color","gray")
      @dom.find '.unread' .text number
      @@@enable-others @
      @@@sum += parse-int number
      $ '#info-bar' .css("background-color","blue") if @@@all-button-done!
      robot.click-next-button!

  (@dom) -> 
    @state = 'enabled'
    @dom.click !~> if @state is 'enabled'
      @@@disable-others @
      @waiting!
      @get-number!
    @@@buttons.push @

binding-reset-when-leave-apb = !->
  leave = false
  $ '#button' .on 'mouseenter' !-> leave := true
  $ '#button' .on 'mouseleave' (event)!-> 
    leave := false 
    reset!

reset = !->
  Button.reset!
  Bubble.reset!
  robot.reset!

$ !->
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom)
  bubble = new Bubble()
  robot.initial!
  binding-reset-when-leave-apb! 