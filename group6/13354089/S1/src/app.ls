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
  reset: !-> 
  @sum = 0

reset = !->
  calculater.reset!
  Button.reset-all-buttons!
  bubble = $ '#info-bar'
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find '.amount span' .text ''

$ ->
  set-click-event!
  show-sum-in-buble!
  reset-all-buttons!


set-click-event = !->
  for dom in $ '#control-ring .button'
    button = new Button ($ dom), -> calculater.add number

show-sum-in-buble = !->
  bubble = $ '#info-bar' 
  Button.all-fetched-callback = !-> bubble.remove-class 'disabled' .add-class 'enabled'
  bubble.click !-> if bubble.has-class 'enabled'
    bubble.find '.amount' .text caculator.sum

reset-all-buttons = !->
  $ '#at-plus-container' .mouseleave = !-> reset!
