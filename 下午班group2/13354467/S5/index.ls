robot =
  initial: !->
    @sequence = [0 to 4]
    @count = -1
    @buttons = $ '#control-ring .button'
    binding-robot-to-apb = !~> $ '#button .apb' .click !~>
      if Button.all-button-enabled!
        @shuffle!
        @show-sequence!
        @count = 0
        @click-next-button 0
    binding-robot-to-apb!

  click-next-button: (current-sum)!->
    if @count is 5
      $ '#info-bar' .text current-sum
      $ '#info-bar' .css("background-color","gray")
      $ '#message' .text '楼主异步调用战斗力感人，目测不超过'+current-sum
    else if @count >= 0
      @count++
      if @sequence[@count-1] is 0 
        Button.a-handler current-sum
      else if @sequence[@count-1] is 1 
        Button.b-handler current-sum
      else if @sequence[@count-1] is 2 
        Button.c-handler current-sum
      else if @sequence[@count-1] is 3 
        Button.d-handler current-sum
      else if @sequence[@count-1] is 4 
        Button.e-handler current-sum

  shuffle: !-> @sequence.sort -> 0.5 - Math.random!

  show-sequence: !->
    str = ''
    for i in @sequence
      str += String.fromCharCode(i+65)
    $ '#sequence' .text str

  reset: !->
    @count = -1
    $ '#sequence' .text ''

class Bubble
  ->
    $ '#info-bar' .click !->
      if $ '#info-bar' .css("background-color") is "rgb(0, 0, 255)"
        sum = 0
        for button in $ '#control-ring .button'
          sum += parse-int ($ button .find '.unread' .text!)
        $ '#info-bar' .text  sum
        $ '#info-bar' .css("background-color","gray")
  @reset = !->
    $ '#info-bar' .text ''
    $ '#info-bar' .css("background-color","gray")

class Button
  @buttons = []

  @a-handler = (current-sum)-> 
    if @buttons[0].state is 'enabled'
      @disable-others @buttons[0]
      @buttons[0].waiting!
      if sucess!                                       #正常运行
        $ '#message' .text '这是个天大的秘密'
        @buttons[0].get-number current-sum
      else                                             #异常发生
        $ '#message' .text '这不是个天大的秘密'

  @b-handler = (current-sum)-> 
    if @buttons[1].state is 'enabled'
      @disable-others @buttons[1]
      @buttons[1].waiting!
      if sucess!                                       #正常运行
        $ '#message' .text '我不知道'
        @buttons[1].get-number current-sum
      else                                             #异常发生
        $ '#message' .text '我知道'

  @c-handler = (current-sum)-> 
    if @buttons[2].state is 'enabled'
      @disable-others @buttons[2]
      @buttons[2].waiting!
      if sucess!                                       #正常运行
        $ '#message' .text '你不知道'
        @buttons[2].get-number current-sum
      else                                             #异常发生
        $ '#message' .text '你知道'

  @d-handler = (current-sum)-> 
    if @buttons[3].state is 'enabled'
      @disable-others @buttons[3]
      @buttons[3].waiting!
      if sucess!                                       #正常运行
        $ '#message' .text '他不知道'
        @buttons[3].get-number current-sum
      else                                             #异常发生
        $ '#message' .text '他知道'

  @e-handler = (current-sum)-> 
    if @buttons[4].state is 'enabled'
      @disable-others @buttons[4]
      @buttons[4].waiting!
      if sucess!                                       #正常运行
        $ '#message' .text '才怪'
        @buttons[4].get-number current-sum
      else                                             #异常发生
        $ '#message' .text '没错'

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
      button.dom.find '.unread' .css("opacity","0")
      $ '#message' .text ''

  sucess = -> return Math.random! > 0.2              #模拟异常发生

  get-number: (current-sum, count)!-> $.get '/', (number, result)!~>
    if @state is 'waiting'
      @state = 'done'
      @dom .css("background-color","gray")
      @dom.find '.unread' .text number
      @@@enable-others @
      $ '#info-bar' .css("background-color","blue") if @@@all-button-done!
      robot.click-next-button current-sum+ parse-int number

  (@dom, @success-message, @fail-message) -> 
    @state = 'enabled'
    @dom.click !~> if @state is 'enabled'
      @@@disable-others @
      @waiting!
      if sucess!                                       #正常运行
        $ '#message' .text success-message
        @get-number!
      else                                             #异常发生
        $ '#message' .text fail-message
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
  success-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  error-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '没错']
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom), success-messages[i], error-messages[i]
  bubble = new Bubble()
  robot.initial!
  binding-reset-when-leave-apb! 