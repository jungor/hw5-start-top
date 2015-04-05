window.onload = -> reset()

enable-random-click = -> $('#base')[0].setAttribute('onclick', 'randomClick()')
disable-random-click = -> $('#base')[0].setAttribute('onclick', '')
disable-info-bar = -> $('#info-bar')[0].setAttribute('onclick', '')

enable-btn = (btn) -> btn.setAttribute('onclick', 'getRandomNum(this)'); btn.style.backgroundColor = \blue
disable-btn = (btn) -> btn.setAttribute('onclick', ''); btn.style.backgroundColor = \#666

disable-other-btn = -> [disable-btn(btn) for btn in btns when btn not in CLICKED]
enable-other-btn = -> for btn in btns
    if btn not in CLICKED => enable-btn(btn)
    else disable-btn(btn)

/ 人工交互时调用 /
@get-random-num = (btn) ->
  disable-random-click()
  @CLICKED ++= [btn]
  num = btn.getElementsByClassName('num')[0]
  num.innerText = '...'
  num.style.opacity = 1
  btn.setAttribute('onclick', '')
  disable-other-btn()

  req = new XMLHttpRequest();
  req.open('GET', '../getRandomNum', true)
  req.send()
  req.onreadystatechange = ->
    if (req.readyState == 4 && req.status == 200)
      window.NUMBERS ++= [Number(req.response)]
      num.innerText = req.response
      enable-other-btn()
      check-ready()

check-ready = -> $('#info-bar')[0].setAttribute('onclick', 'showSum()') if NUMBERS.length == 5; if NUMBERS.length == 5 => return true
error-occur = -> return Math.random() > 0.5
shuffle = -> if Math.random() > 0.5 then return 1 else return -1
show-order = (order) -> $('#order')[0].innerText = order.join(' '); $('#order')[0].style.opacity = 1


@random-click = ->
  disable-random-click()
  disable-info-bar()
  order = ['A' to 'E'].sort(shuffle)
  show-order(order)
  index = 0
  currentSum = 0
  switch-handler(order, index, currentSum)

switch-handler = (order, index, currentSum) ->
  switch order[index]
  | 'A' => aHandler(order, index, currentSum)
  | 'B' => bHandler(order, index, currentSum)
  | 'C' => cHandler(order, index, currentSum)
  | 'D' => dHandler(order, index, currentSum)
  | 'E' => eHandler(order, index, currentSum)

aHandler = (order, index, currentSum) ->
  if error-occur()
    show-message('这不是个天大的秘密')
  btn = $('.' + order[index])[0]
  set-btn-wait(btn, order, index, currentSum)


bHandler = (order, index, currentSum) ->
  if error-occur
    show-message('我知道')
  btn = $('.' + order[index])[0]
  set-btn-wait(btn, order, index, currentSum)

cHandler = (order, index, currentSum) ->
  if error-occur
    show-message('你知道')
  btn = $('.' + order[index])[0]
  set-btn-wait(btn, order, index, currentSum)

dHandler = (order, index, currentSum) ->
  if error-occur
    show-message('他知道')
  btn = $('.' + order[index])[0]
  set-btn-wait(btn, order, index, currentSum)

eHandler = (order, index, currentSum) ->
  if error-occur
    show-message('才不怪')
  btn = $('.' + order[index])[0]
  set-btn-wait(btn, order, index, currentSum)

bigHandler = (currentSum) -> show-message('楼主异步调用战斗力感人，目测不超过' + currentSum)

set-btn-wait = (btn, order, index, currentSum) ->
  @CLICKED ++= [btn]
  num = btn.getElementsByClassName('num')[0]
  num.innerText = '...'
  num.style.opacity = 1
  btn.setAttribute('onclick', '')
  disable-other-btn()

  req = new XMLHttpRequest();
  req.open('GET', '../getRandomNum', true)
  req.send()
  req.onreadystatechange = ->
    if (req.readyState == 4 && req.status == 200)
      switch order[index]
      | 'A' => show-message('这是个天大的秘密')
      | 'B' => show-message('我不知道')
      | 'C' => show-message('你不知道')
      | 'D' => show-message('他不知道')
      | 'E' => show-message('才怪')
      window.NUMBERS ++= [Number(req.response)]
      num.innerText = req.response
      index++
      currentSum += Number(req.response)
      switch-handler(order, index, currentSum)
      enable-other-btn()
      if check-ready() => showSum(); bigHandler(currentSum)

@show-sum = ->
  result = 0
  for item in NUMBERS
    result += item
  sumSpan = $('#sum')[0]
  sumSpan.innerText = result
  sumSpan.style.opacity = 1


@reset = ->
  @CLICKED = []
  @NUMBERS = []
  @button = $('#button')[0]
  @btns = [$('.' ++ ID)[0] for ID in <[A B C D E]>]
  button.setAttribute('onmouseleave', 'setTimeout("reset()", 1000)')
  $('#order')[0].style.opacity = 0
  show-message('')
  enable-other-btn()
  enable-random-click()
  $('#sum')[0].style.opacity = 0
  for btn in btns
    $('#info-bar')[0].setAttribute('onclick', '')
    btn.getElementsByClassName('num')[0].style.opacity = 0

show-message = (message) -> $('#message')[0].innerText = message;
