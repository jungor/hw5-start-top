class Bubble
  ->
    $ '#info-bar' .click !->
      if $ '#info-bar' .css("background-color") is "rgb(0, 0, 255)"  #如果气泡为蓝色，说明为可用状态
         $ '#info-bar' .text Button.sum 
         $ '#info-bar' .css("background-color","gray")
  @reset = !->
    $ '#info-bar' .text ''
    $ '#info-bar' .css("background-color","gray")

class Button
  @sum = 0                                         #记录数字的和

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

  @all-button-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  @reset = !->
    for button in @buttons
      button.state = 'enabled'
      button.dom.css("background-color","blue")
      button.dom.find '.unread' .text ''
      button.dom.find '.unread' .css("opacity","0");   #隐藏右上角红色的小圆圈
    @sum = 0

  get-number: !-> $.get '/', (number)!~>
    if @state is 'waiting'
      @state = 'done'
      @dom .css("background-color","gray")
      @@@enable-others @
      @dom.find '.unread' .text number
      @@@sum += parse-int number
      $ '#info-bar' .css("background-color","blue") if @@@all-button-done!

  (@dom) -> 
    @state = 'enabled'
    @dom.click !~> if @state is 'enabled'
      @@@disable-others @
      @waiting!
      @get-number!
    @@@buttons.push @

reset = !->
  Button.reset!
  Bubble.reset!

$ !->
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom)
  bubble = new Bubble()

  binding-reset-when-leave-apb = !->                        #离开区域清零
  leave = false
  $ '#button' .on 'mouseenter' !-> leave := true            #全局变量
  $ '#button' .on 'mouseleave' (event)!-> 
    leave := false
    reset!

  binding-reset-when-leave-apb! 