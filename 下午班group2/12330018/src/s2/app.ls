$ !->
  initial!
  a-pluss-event!
  lis = get-my-list!
  add-event lis
  s2-click-buttons!

get-my-list = ->
  $ '#control-ring .button'

# 初始化
initial = !->
  list = get-my-list!
  for let i in list
    temp = $ i
    temp.attr "flag",true
    allow-li temp
    temp.find ".unread" .hide!

# 当鼠标离开a+
a-pluss-event = !->
  is-enter-other = false
  $ '#info-bar, #control-ring' .on 'mouseenter' !-> is-enter-other := true
  $ '#info-bar, #control-ring' .on 'mouseleave' (event)!-> 
    # console.log "is leaving: ", event.target
    is-enter-other := false
    set-timeout !-> 
      if not is-enter-other
        initial!
        $ '#info-bar' .find '.amount' .text ''
        forbid-bubble!
    , 0

# 给button添加click函数，并发送ajax
add-event = (list)!-> for let i in list
  temp = $ i
  temp.on 'click' !->
    click-event i,-1

click-event =(ob,index=-1) !->
  temp = $ ob
  # 判断button是否是可点击状态
  list = get-my-list!
  if(temp.has-class "enabled")
    before-click list,temp
    temp.attr "flag",false
    send-ajax temp,index
    
send-ajax = (temp,index)->
  list = get-my-list
  $.get '/api/random', (number, result) !->
    temp.find '.unread' .text number
    allow-other-lis list temp
    big-is-ready!
    if index isnt -1
      click-by-order ++index

# 点击button之前，灭活button，等待服务器反应
before-click = (list,curr) !->
  curr.find ".unread" .text '...'
  curr.find ".unread" .show!
  forbid-other-lis list,curr

# 灭活其他li，使它不可点击
forbid-other-lis= (list,curr=null) !->
  for let i in list
    temp = $ i
    forbid-li temp
  allow-li curr

# 激活其他li 使得其可以被点击,灭活当前的button
allow-other-lis = (list,curr=null) !->
  for let i in list
    temp = $ i
    f = i.getAttribute "flag" 
    if f ~= "true"
      allow-li temp
  if curr isnt null
    forbid-li curr

# 激活某个li ,disabled = false 表示可点击
allow-li = (button) !->
  button.remove-class 'disabled' .add-class 'enabled'

# 灭活某个li，disabled = true 表示不可点击
forbid-li = (button) !->
  button.remove-class 'enabled' .add-class 'disabled'

# 判断大气泡是否可以激活。
big-is-ready = !->
  flag = true
  list = get-my-list!
  for let i in list
    temp = $ i
    if temp.has-class "enabled"
      flag := false
  if flag
    $ '#info-bar' .remove-class 'disabled' .add-class 'enabled'
    bubble-triggered! # 在这里调用，在这之前加了enabled

# bubble被触发，添加点击函数
bubble-triggered = !->
  $ '#info-bar' .on 'click' !->
    if $ '#info-bar' .has-class 'enabled'
      sum = 0
      list = get-my-list!
      for let i in list
        it = $ i
        a = it.find '.unread' .get(0).innerText
        sum += parse-int (a)
      $ '#info-bar' .find '.amount' .text sum
      set-timeout 'forbid-bubble()',1000


# 禁止bubble点击
forbid-bubble = !->
  bubble = $ '#info-bar'
  bubble.remove-class 'enabled' .add-class 'disabled'

#s2的代码
s2-click-buttons = !->
  $ '#button .apb' .on 'click' !->
    list = get-my-list!
    click-by-order 0
click-by-order = (i) !->
  list =get-my-list!
  if(i>=list.length)
    $ '#info-bar' .click!
    return
  click-event list[i],i