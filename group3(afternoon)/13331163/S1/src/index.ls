$ ->
  # 对象记录和
  currentSum = new CurrentSum

  add-handler-on-control-ring-buttons currentSum
  add-handler-on-info-button currentSum
  add-reset-function currentSum

CurrentSum = !->
  this.sum = 0

# 给所有的按钮添加处理器
add-handler-on-control-ring-buttons = (currentSum) !->
  for button in $ '.button'
    # 遍历所有按钮并且设置未访问样式
    $(button) .add-class 'unvisit'
    button.status = 'unclick'
    # 给每个按钮正式添加处理器
    add-handler button, currentSum
    # 给每个按钮设置点击时间
    $(button) .click !->
      $(this) .trigger 'handler'

# 给按钮添加处理器
add-handler = (button, currentSum) !->
  $(button) .bind 'handler', ->
    # 如果按钮已经被访问过 则不再访问
    return if this.status is 'clicked' or $(this) .has-class 'visited'

    # 改变状态
    this.status = 'clicked'

    for bt in $ '.button'
      if bt isnt this
        $(bt) .remove-class 'unvisit' .add-class 'visited'

    # 修改右上角红圈的样式
    $(this) .children '.unread' .add-class "visiable" .text '...'

    # 向服务器索取数字
    $.get '/' (data, status) !~>
      # 显示数字
      $(this) .children '.unread' .text data
      # 做和运算
      currentSum.sum += parseInt data
      # 回复所有按钮状态
      for bt in $ '.button'
        if bt.status is 'clicked'
          $(bt) .remove-class 'unvisit' .add-class 'visited'
        else
          $(bt) .remove-class 'visited' .add-class 'unvisit'

      # 检查是否所有的按钮已经被按过
      flag = true
      for bt in $ '.button'
        if $(bt) .has-class 'unvisit'
          flag = false
          break
      # 给大按钮修改为可访问状态
      $ '#info' .remove-class 'visited' .add-class 'unvisit' if flag is true


# 给大按钮添加处理时间
add-handler-on-info-button = (currentSum)!->
  # 给大按钮设置为已访问状态
  info = $ '#info'
  info[0].status = 'unclick'
  info .add-class 'visited'

  # 给大气泡绑定处理器
  info .bind 'handler', ->
    # 若大气泡已点击或者不能访问则返回
    return if this.status is 'clicked' or $(this) .has-class 'visited'
    # 设置大气泡为已点击状态
    this.status = 'clicked'
    $(this) .remove-class 'unvisit' .add-class 'visited' .text currentSum.sum
  # 当大气泡被点击时触发处理时间
  info .click !->
    $(this) .trigger 'handler'

add-reset-function = (currentSum) ->
  $ '#button' .on 'mouseleave', ->
    setTimeout reset currentSum, 0

reset = (currentSum) !->
  # 恢复按钮
  for bt in $ '.button'
    bt.status = 'unclick'
    $(bt) .remove-class 'visited' .add-class 'unvisit'
    $(bt) .children '.unread' .remove-class 'visiable'
  # 恢复大气泡
  $ '#info' .get(0) .status = 'unclick'
  $ '#info' .remove-class 'unvisit' .add-class 'visited' .text " "
  # 恢复和
  currentSum.sum = 0

# jquery ajax清理缓存
$.ajaxSetup cache:false