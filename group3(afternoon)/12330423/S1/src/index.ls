window.onload = -> reset()

@get-random-num = (btn) ->
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


enable-btn = (btn) -> btn.setAttribute('onclick', 'getRandomNum(this)'); btn.style.backgroundColor = \blue
disable-btn = (btn) -> btn.setAttribute('onclick', ''); btn.style.backgroundColor = \#666

disable-other-btn = -> [disable-btn(btn) for btn in btns when btn not in CLICKED]
enable-other-btn = -> for btn in btns
    if btn not in CLICKED => enable-btn(btn)
    else disable-btn(btn)

check-ready = -> $('#info-bar')[0].setAttribute('onclick', 'showSum()') if NUMBERS.length == 5

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
  enable-other-btn()
  $('#sum')[0].style.opacity = 0
  for btn in btns
    $('#info-bar')[0].setAttribute('onclick', '')
    btn.getElementsByClassName('num')[0].style.opacity = 0
