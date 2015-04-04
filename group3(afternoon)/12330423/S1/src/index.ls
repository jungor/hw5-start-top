window.onload = ->
  IDS = <[A B C D E]>
  @CLICKED = []
  @NUMBERS = []
  @button = document.getElementById('button')
  @btns = [document.getElementsByClassName(ID)[0] for ID in IDS]

  button.setAttribute('onmouseleave', 'setTimeout("reset()", 1000)');
  for btn in btns
    btn.setAttribute('onclick', 'getRandomNum(this)')


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


disable-other-btn = ->
  for btn in btns when btn not in CLICKED
    disable-btn(btn)


enable-other-btn = ->
  for btn in btns
    if btn not in CLICKED
      btn.setAttribute('onclick', 'getRandomNum(this)')
      btn.style.backgroundColor = \blue
    else
      disable-btn(btn)


disable-btn = (btn) ->
  btn.setAttribute('onclick', '')
  btn.style.backgroundColor = \#666


check-ready = ->
  if NUMBERS.length == 5
    document.getElementById('base').setAttribute('onclick', 'showSum()')


@show-sum = ->
  result = 0
  sumSpan = document.getElementById('sum')
  for item in NUMBERS
    result += item
  sumSpan.innerText = result
  sumSpan.style.opacity = 1
  document.getElementById('base').style.backgroundColor = \#666


@reset = ->
  window.onload()
  enable-other-btn()
  document.getElementById('sum').style.opacity = 0
  document.getElementById('base').style.backgroundColor = \blue
  for btn in btns
    btn.getElementsByClassName('num')[0].style.opacity = 0
    document.getElementById('base').setAttribute('onclick', '')
