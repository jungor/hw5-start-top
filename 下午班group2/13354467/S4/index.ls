robot =
  initial: !->
    @sequence = [0 to 4]                                      #记录操作顺序
    @count = 0
    @buttons = $ '#control-ring .button'
    binding-robot-to-apb = !~> $ '#button .apb' .click !~>
      if Button.all-button-enabled!
        @shuffle!
        @show-sequence!
        @buttons[@sequence[@count++]] .click!
    binding-robot-to-apb!

  click-next-button: !->
    if @count isnt 0
      if @count is 5                                   #当5个按钮都已经被点击，在大气泡显示和
        $ '#info-bar' .text cumulator.sum
        $ '#info-bar' .css("background-color","gray")
      else
        @buttons[@sequence[@count++]] .click!

  shuffle: !-> @sequence.sort -> 0.5 - Math.random!             #打乱顺序

  show-sequence: !->                                            #显示顺序
    str = ''
    for i in @sequence
      str += String.fromCharCode(i+65)                          #将下标转换成字母
    $ '#sequence' .text str

  reset: !->
    @count = 0
    $ '#sequence' .text ''

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

  get-number: !-> $.get '/', (number, result)!~>
    if @state is 'waiting'
      @state = 'done'
      @dom .css("background-color","gray")
      @dom.find '.unread' .text number
      @@@enable-others @
      cumulator.add number
      $ '#info-bar' .css("background-color","blue") if @@@all-button-done!
      robot.click-next-button!

  (@dom) -> 
    @state = 'enabled'
    @dom.click !~> if @state is 'enabled'
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