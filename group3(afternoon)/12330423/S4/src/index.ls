window.onload = -> reset()

enable-btn = (btn) -> btn.setAttribute('onclick', 'getRandomNum(this)'); btn.style.backgroundColor = \blue
disable-btn = (btn) -> btn.setAttribute('onclick', ''); btn.style.backgroundColor = \#666

check-ready = ->
  if NUMBERS.length != 5 => return false
  $('#info-bar')[0].setAttribute('onclick', 'showSum()')
  if AUTO => show-sum() ; $('#base')[0].setAttribute('onclick', '')

disable-other-btn = -> [disable-btn(btn) for btn in btns when btn not in CLICKED]
enable-other-btn = -> for btn in btns
    if btn not in CLICKED => enable-btn(btn)
    else disable-btn(btn)

@show-sum = ->
  result = 0
  for item in NUMBERS
    result += item
  sumSpan = $('#sum')[0]
  sumSpan.innerText = result
  sumSpan.style.opacity = 1


@get-random-num = (btn, current = 0, order = []) ->
  current++
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
      if AUTO and current < 5
          get-random-num(btns[order[current]], current, order)
      check-ready()


@reset = ->
  @CLICKED = []
  @NUMBERS = []
  @AUTO = false
  @CURRENT = 0
  @button = $('#button')[0]
  @btns = [$('.' ++ ID)[0] for ID in <[A B C D E]>]

  enable-other-btn()
  $('#sum')[0].style.opacity = 0
  $('#order')[0].style.opacity = 0
  button.setAttribute('onmouseleave', 'setTimeout("reset()", 1000)')
  $('#base')[0].setAttribute('onclick', 'randomClick()')

  for btn in btns
    $('#info-bar')[0].setAttribute('onclick', '')
    btn.getElementsByClassName('num')[0].style.opacity = 0


@random-click = ->
  @AUTO = true; @CURRENT = 0; @ORDER = [til 5].sort(shuffle)
  show-order(ORDER)
  get-random-num(btns[ORDER[CURRENT]], CURRENT, ORDER)

shuffle = -> if Math.random() > 0.5 => return -1 else return 1
show-order = (order) ->
  orderString = ''
  for i in order
    orderString += (<[A B C D E]>[i] + ' ')
  $('#order')[0].innerText = (orderString); $('#order')[0].style.opacity = 1
