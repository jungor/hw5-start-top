$ ->
  # 对象记录和
  currentSum = new CurrentSum

  add-handler-on-control-ring-buttons currentSum
  add-handler-on-info-button currentSum
  add-reset-function currentSum
  add-robot-button currentSum

CurrentSum = !->
  this.sum = 0

# 给所有的按钮添加处理器
add-handler-on-control-ring-buttons = (currentSum) !->
  message = <[ A:这是个天大的秘密 B:我不知道 C:你不知道 D:他不知道 E:才怪 ]>
  reverse-message = <[ A:这不是个天大的秘密 B:我知道 C:你知道 D:他知道 E:才不怪 ]>
  for button, index in $ '.button'
    # 遍历所有按钮并且设置未访问样式
    $(button) .add-class 'unvisit'
    button.status = 'unclick'
    button.message = message[index]
    button.reverse-message = reverse-message[index]
    # 给每个按钮正式添加处理器
    add-handler button, currentSum
    # 给每个按钮设置点击时间
    $(button) .click (event) !->
      event.stopPropagation!
      $(this) .trigger 'handler'

# 给按钮添加处理器
add-handler = (button, currentSum) !->
  $(button) .bind 'handler', (event) ->
    # 如果按钮已经被访问过 则不再访问
    event.stopPropagation!
    return if this.status is 'clicked' or $(this) .has-class 'visited'
    # 改变状态
    this.status = 'clicked'
    # 在信息栏显示信息
    show-message this, true

    # 随机数模拟异常
    try
      if Math.random! > 0.4
        $ (this) .remove-class 'unvisit' .add-class 'visited'
        throw "#{this.reverse-message};#{currentSum.sum}"
    catch err
      throw err

    # 修改右上角红圈的样式
    $(this) .children '.unread' .add-class "visiable" .text '...'
    # 向服务器索取数字
    $.get '/', (data, status) !~>
      return if this.status is 'unclick'
      # 显示数字
      $(this) .children '.unread' .text data
      # 做和运算
      currentSum.sum += parseInt data
      # 到一个数字灭一个按钮
      $(this) .remove-class 'unvisit' .add-class 'visited' if this.status is 'clicked'

      # 检查是否所有的按钮已经被按过
      flag = true
      for bt in $ '.button'
        if $(bt) .has-class 'unvisit'
          flag = false
          break
      # 给大按钮修改为可访问状态
      $ '#info' .remove-class 'visited' .add-class 'unvisit' .trigger 'handler' if flag is true
      # 触发下一个按钮
      try
        if this.next-button is undefined
          $ '#info' .trigger 'handler'
        else if this.next-button isnt false
          $ 'li'+":nth-child(#{this.next-button})" .trigger 'handler'
      catch err
        $ '#message-box' .text ((err.split ';')[0])

# 给大按钮添加处理时间
add-handler-on-info-button = (currentSum) !->
  message = "楼主异步调用战斗力感人，目测不超过"
  # 给大按钮设置为已访问状态
  info = $ '#info'
  info[0].status = 'unclick'
  info[0].message = message
  info .add-class 'visited'

  # 给大气泡绑定处理器
  info .bind 'handler', (event) ->
    # 若大气泡已点击或者不能访问则返回
    event.stopPropagation!
    return if this.status is 'clicked' or $(this) .has-class 'visited'
    # 设置大气泡为已点击状态
    this.status = 'clicked'

    # 显示大气泡的信息
    show-info-message this, currentSum.sum, true
    $(this) .remove-class 'unvisit' .add-class 'visited' .text currentSum.sum

  # 当大气泡被点击时触发处理时间
  info .click (event) ->
    event.stopPropagation!
    $(this) .trigger 'handler'

add-reset-function = (currentSum) !->
  $ '#button' .on 'mouseleave', !->
    setTimeout reset currentSum, 0

reset = (currentSum) !->
  # 恢复按钮
  for bt in $ '.button'
    bt.status = 'unclick'
    bt.next-button = false
    $(bt) .remove-class 'visited' .add-class 'unvisit'
    $(bt) .children '.unread' .remove-class 'visiable'
  # 恢复大气泡
  $ '#info' .get(0) .status = 'unclick'
  $ '#info' .remove-class 'unvisit' .add-class 'visited' .text " "
  # 恢复和
  currentSum.sum = 0
  # 恢复 @+ 按钮
  $ '#button' .get(0) .status = "unclick"
  # 清空显示排序的信息
  $ '#sort' .text " "
  # 清空信息栏
  $ '#message-box' .text " "

add-robot-button = (currentSum) !->
  # 设置'@+'按钮初始状态
  $ '#button' .get(0) .status = 'unclick'
  # 给 '@+' 按钮绑定处理器
  $ '#button' .bind 'handler', (event) ->
    event.stopPropagation!
    return if this.status is 'clicked'
    reset currentSum
    this.status = 'clicked'
    # 获取一组顺序
    sequence = [ 1 til 6 by 1 ]
    sequence = random-sequence sequence
    show-sequence sequence
    # 给每一个按钮设置下一按钮
    for i from 0 til 4 by 1
      $ 'li'+":nth-child(#{sequence[i]})" .get(0) .next-button = sequence[i+1]
    $ 'li' + ":nth-child(#{sequence[4]})" .get(0) .next-button = undefined
    # 开始按下第一个按钮
    currentSum.sum = 0

    try
      $ 'li'+":nth-child(#{sequence[0]})" .trigger 'handler'
    catch err
      $ '#message-box' .text ((err.split ';')[0])


  # '@+' 按钮点击触发处理器
  $ '#button' .click (event) !->
    event.stopPropagation!
    $ (this) .trigger 'handler'

# jquery ajax清理缓存
$.ajaxSetup cache:false

# 轻量级随机排序算法
random-sequence = (sequence) ->
  sequence.sort (a, b)->
    if Math.random! > 0.2
      return 1
    else
      return -1
  return sequence

# 显示排序信息
show-sequence = (sequence) !->
  content = new Array!
  for x in sequence
    content.push String.fromCharCode (x+64)
  $ '#sort' .text content.join ' '

# 显示按钮信息
show-message = (who, flag) !->
  if flag is true
    $ '#message-box' .text who.message
  else
    $ '#message-box' .text who.reverse-message

# 显示大气泡信息
show-info-message = (who, sum, flag) !->
  if flag is true
    $ '#message-box' .text (who.message+sum)
  else
    $ '#message-box' .text (who.reverse-message+sum)