class Button
  @FAILURE-RATE = 0.3
  @buttons = []

  @disable-all-other-buttons = (this-button) -> 
    for button in @buttons when button isnt this-button and button.state != 'done'
      button.disable!
  @enable-all-other-buttons = (this-button) ->
    for button in @buttons when button isnt this-button and button.state != 'done'
      button.enable!
  @all-buttons-done = ->
    for button in @buttons
      if button.state != 'done'
        return false
    return true;
  @reset-all = !->
    for button in @buttons
      button.reset!

  (@dom, @bad-message, @good-message)->
    @state = 'enabled' ; @dom.add-class 'enabled'
    @name = @dom.attr 'title'
    @dom.click !~> if @state is 'enabled'
      @dom.find '.num' .css "display" "inline" #test
      @@@disable-all-other-buttons @
      @wait!
      @fetch-number-and-show!
    @@@buttons.push @

  fetch-number-and-show: !->  $.get '/api/random', (number, result)!~>
    @done!
    @@@all-number-fetched-callback! if @@@all-buttons-done!
    @@@enable-all-other-buttons @
    @show-number number
    @success-or-fail!
    cumulator.add number
    robot.click-next!

  success-or-fail: !->
    if is-success = Math.random! > @@@FAILURE-RATE
      console.log "Button #{@name} say: #{@good-message}"
    else
      console.log "Handle error from #{@name}, message is: #{@bad-message}"

  show-number: (num) !-> @dom.find '.num' .text num

  disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'

  enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'

  wait: !-> @state = 'waiting' ; @dom.remove-class 'enabled' .add-class 'waiting'

  done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'

  reset: !-> 
    @state = 'enabled' 
    @dom.remove-class 'disabled waiting done' .add-class 'enabled'
    @dom.find '.num' .text ''
    @dom.find '.num' .css 'display' 'none'


robot =
  initial: !->
    @buttons = $ '#control-ring .button'
    @bubble = $ '.info'
    @sequence = ['A' to 'E']
    @count = 0

  random-sequence: !->
    @buttons.sort -> 0.5 - Math.random!

  click-next: !->
    if @count == @sequence.length then @bubble.click! else @get-next-button!.click!
    @count++;

  get-next-button: ->
    @buttons[@count]

cumulator =
  sum: 0
  add: (number)-> @sum += parse-int number
  reset: !-> @sum = 0


$ -> #dom加载ready之后才执行
  robot.initial! #如果不加这么一个函数的话，robot在dom加载之前就生成，buttons并没有找到
  add-click-to-fetch-numbers-to-all-buttons! #这里不一样
  add-click-to-calcu-sum-to-the-bubble!
  add-click-to-icon!
  add-reset-when-leave-apb!

add-click-to-fetch-numbers-to-all-buttons = ->
  good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪']
  for let dom,i in $ '#control-ring .button'
    button = new Button ($ dom), good-messages[i], bad-messages[i]

add-click-to-calcu-sum-to-the-bubble = ->
  bubble = $ '.info' 
  bubble.add-class 'disabled'
  Button.all-number-fetched-callback = !-> bubble.remove-class 'disabled' .add-class 'enabled'
  bubble.click !-> if bubble.has-class 'enabled'
    bubble.find '.sum' .text cumulator.sum

add-reset-when-leave-apb = !->
  $ '#at-plus-container' .on 'mouseleave' !-> 
      reset!

add-click-to-icon = !->
  icon = $ '.icon' 
  icon.click !-> 
    robot.random-sequence!
    robot.click-next!

reset = !->
  cumulator.reset!
  Button.reset-all!
  bubble = $ '.info'
  bubble.remove-class 'enabled' .add-class 'disabled'
  bubble.find '.sum' .text ''
  robot.count=0
