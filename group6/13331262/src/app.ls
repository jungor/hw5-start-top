class Button
  @FAILURE-RATE = 0.3
  @buttons = []

  # 灭活其它气泡
  @disable-other-buttons = (index)-> [button.disable! for button in @buttons when button isnt index and button.state isnt 'done']

  # 激活其它气泡
  @enable-other-buttons = (index)-> [button.enable! for button in @buttons when button isnt index and button.state isnt 'done']

  # 是否所有气泡都被点击
  @all-button-is-done = ->
    [return false for button in @buttons when button.state isnt 'done']
    true
  # 灭活被点击气泡
  @disabled-index-button = (index)-> [button.disable! for button in @buttons when button is index and button.state is 'done']

  # 重置
  @reset-all = !-> [button.reset! for button in @buttons]

  #button的一些状态
  (@dom, @fetched-callback) !->
    @state = 'enabled'
    @dom.add-class 'enabled'
    @dom.click !~> if @state is 'enabled'
      @@@disable-other-buttons @
      @done!
      @fetch-number-and-show!
    @@@buttons.push @

  # 获取随机数
  fetch-number-and-show: !-> $.get '/api/random', (number, result)!~>
    @@@disable-other-buttons @
    alert 'lalala!'
    # 红色圆圈显示“...”
    @done!

    @show-number number
    @@@disable-index-button @
    @@@enable-other-buttons @
    @add-clicking-to-calculate-result-to-the-bubbles if @@@all-button-is-done!

  

  disable = !-> 
    @state = 'disabled'
    @dom.remove-class 'enabled' 
    @dom.add-class 'disabled'

  enable = !->
    @state = 'enabled'
    @dom.remove-class 'disabled'
    @dom.add-class 'enabled'

  done: !->
    @dom.add-class 'red';
    @dom.find '.red' .text '...'

  show-number: (number)!->
    @dom.find '.red' .text number

  reset: !->
    @state = 'enabled';
    @dom.remove-class 'disabled';
    @dom.add-class 'enabled';
    @dom.remove-class 'red'

  calculator = 
    sum : 0
    add : (number) -> @sum = @sum + parse-int number
    reset : !-> @sum = 0

  add-clicking-to-calculate-result-to-the-bubbles = !->
    for let dom, i in $ '#control-ring .button'
      button = new Button ($ dom), fetched-callback !->
        calculator.add fetched-callback


  add-clicking-to-calculate-result-to-the-bubble = ->
    bubble = $ '#info-bar'
    bubble.add-class 'enabled'
    bubble.click !-> if bubble.has-class 'enabled'
      bubble.find '.amount' .text calculator.sum