class Button
  @FAILURE-RATE = 0.3     #变化速度
  @buttons : []

  #让所有按键失灵
  @disable-other-buttons = (current)-> [button.disable! for button in @buttons when button isnt current and button.state isnt 'done']

  #让所有按键激活
  @enable-other-buttons = (current)-> [button.enable! for button in @buttons when button isnt current and button.state isnt 'done']

  #是否所有按键都被按下
  @if-all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true

  #重置所有按键
  @reset-all-buttons = !-> [(button.reset!; button.text-invisible!) for button in @buttons]


  #button的一些状态
  (@dom, @fetched-callback)->
    @state = 'enabled' ; 
    @dom.add-class 'enabled'
    @dom.click !~> if @state is 'enabled'
      @@@disable-other-buttons @
      @text-visible!
      @wait!
      @get-number-and-show!
    @@@buttons.push @

  #拿到随机数并显示
  get-number-and-show: !-> $.get '/api/random', (number, result)!~>
    @done!
    @@@all-fetched-callback! if @@@if-all-button-is-done!
    @@@enable-other-buttons @
    @show-number number
    
  #显示随机数
  show-number: (number)!-> @dom.find '.unread' .text number


  #显示交流信息
  text-visible: !-> 
  @dom.remove-class 'invisible'; 
  @dom.add-class 'visible'

  text-invisible: !-> 
  @dom.remove-class 'visible';
  @dom.add-class 'invisible'

  wait: !-> 
  @state = 'waiting' ; 
  @dom.remove-class 'enabled' .add-class 'waiting'

  show-message: !-> console.log "Button #{@name} say: #{@good-message}"

  disable: !-> 
  @state = 'disabled' ;
  @dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> 
  @state = 'enabled' ; 
  @dom.remove-class 'disabled' .add-class 'enabled'

  done: !-> 
  @state = 'done' ; 
  @dom.remove-class 'waiting' .add-class 'done'

  reset: !-> 
  @state = 'enabled' ; @dom.remove-class 'disabled waiting done' .add-class 'enabled'
  @dom.find '.unread' .text ''

#模拟
calculater =
  sum: 0
  add: (number)-> 
  @sum += parse-int number
  reset: !-> @sum = 0

#重置
reset = !->
  calculater.reset!
  Button.reset-all!
  bubble = $ '#info-bar'
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find '.amount span' .text ''

$ ->
  robot.initial!
  show-messages !-> robot.click-next!
  show-resulet-in-buble!
  reaet-all-buttons!


#不同模式下的点击（包括用户自己点击与随机自动）
  s1-wait-user-clicking!
  s4-show-number-in-random-order!

#显示信息
show-messages = (next)-> 
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪']
  for let dom, i in $ '#control-ring .button'
    button = new Button ($ dom), good-messages[i], bad-messages[i], (error, number)!->
      if error
        console.log "Handle error from #{button.name}, message is: #{error.message}"
        number = error.data
      calculater.add number
      next?!

#显示计算结果的函数
show-resulet-in-buble = ->
  bubble = $ '#info-bar' 
  bubble.add-class 'disabled'
  Button.all-number-fetched-callback = !-> bubble.remove-class 'disabled' .add-class 'enabled'
  bubble.click !-> if bubble.has-class 'enabled'
    bubble.find '.amount' .text calculater.sum

#重置函数
reaet-all-buttons = !->
  is-enter-other = false
  $ '#info-bar, #control-ring' .on 'mouseenter' !-> is-enter-other := true
  $ '#info-bar, #control-ring' .on 'mouseleave' (event)!-> 
    # console.log "is leaving: ", event.target
    is-enter-other := false
    set-timeout !-> 
      reset! if not is-enter-other
    , 0

#等待用户点击
s1-wait-user-clicking = !-> console.log "wait user clicking ..."

#机器人初始化
robot =
  initial: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '#info-bar'
    @sequence = ['A' to 'E']
    @cursor = 0

#随机顺序
  shuffle-order: !-> @sequence.sort -> 0.5 - Math.random!

  click-next: !-> if @cursor is @sequence.length then @bubble.click! else @get-next-button!click!

  get-next-button: -> 
    index = @sequence[@cursor++].char-code-at! - 'A'.char-code-at!
    @buttons[index]

#显示随机顺序
  show-order: !-> @bubble.find '.sequence span' .text @sequence.join ', '

#按随机顺序点击按钮
s4-show-number-in-random-order = !-> $ '#button .apb' .click !->
  robot.shuffle-order!
  robot.show-order!
  robot.click-next!


