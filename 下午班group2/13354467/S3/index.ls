robot =
  initial: !->
    @auto = 0;                                      #标记当前为机器人操作状态

    @buttons = $ '#control-ring .button'

    binding-robot-to-apb = !~> $ '#button .apb' .click !~>
      if Button.all-button-enabled! and @auto is 0
          @auto = 1;
          [button.click! for button in @buttons]
    binding-robot-to-apb!

  reset: !->
    @auto = 0

class Bubble
  ->
    $ '#info-bar' .click !->
      if $ '#info-bar' .css("background-color") is "rgb(0, 0, 255)"
         $ '#info-bar' .text cumulator.sum 
         $ '#info-bar' .css("background-color","gray")
  @reset = !->
    $ '#info-bar' .text ''
    $ '#info-bar' .css("background-color","gray")

class Button
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
    for button in @buttons
      button.state = 'enabled'
      button.dom.css("background-color","blue")
      button.dom.find '.unread' .text ''
      button.dom.find '.unread' .css("opacity","0");

  get-number: !-> $.get '/?randomNum='+Math.random(), (number, result)!~>  #url不同，实现并发处理
    if @state is 'waiting'
      @state = 'done'
      @dom .css("background-color","gray")
      @dom.find '.unread' .text number
      if robot.auto is 0
        @@@enable-others @
      cumulator.add number
      if @@@all-button-done!
        if robot.auto
          $ '#info-bar' .text cumulator.sum
        else
          $ '#info-bar' .css("background-color","blue") 


  (@dom) -> 
    @state = 'enabled'
    @dom.click !~> if @state is 'enabled' or robot.auto   #机器人操作状态，允许同时点击
      if robot.auto is 0
        @@@disable-others @
      @waiting!
      @get-number!
    @@@buttons.push @

cumulator = 
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0

binding-reset-when-leave-apb = !->
  leave = false
  $ '#button' .on 'mouseenter' !-> leave := true
  $ '#button' .on 'mouseleave' (event)!-> 
    leave := false
    reset!

reset = !->
  Button.reset!
  cumulator.reset!
  Bubble.reset!
  robot.reset!

$ !->
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom)
  bubble = new Bubble()
  robot.initial!
  binding-reset-when-leave-apb! 