window.onload = -> reset()

enable-btn = (btn) -> btn.setAttribute('onclick', 'getRandomNum(this)'); btn.style.backgroundColor = \blue
disable-btn = (btn) -> btn.setAttribute('onclick', ''); btn.style.backgroundColor = \#666

check-ready = ->
  if NUMBERS.length != 5 => return false
  $('#info-bar')[0].setAttribute('onclick', 'showSum()')
  if AUTO => show-sum()

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
      console.log(AUTO)
      if AUTO
        for btn_ in btns
          if btn_ not in CLICKED
            get-random-num(btn_)
            break
      check-ready()


@reset = ->
  @CLICKED = []
  @NUMBERS = []
  @AUTO = false
  @button = $('#button')[0]
  @btns = [$('.' ++ ID)[0] for ID in <[A B C D E]>]

  enable-other-btn()
  $('#sum')[0].style.opacity = 0
  button.setAttribute('onmouseleave', 'setTimeout("reset()", 1000)')
  $('#base')[0].setAttribute('onclick', 'clickOneByOne()')

  for btn in btns
    $('#info-bar')[0].setAttribute('onclick', '')
    btn.getElementsByClassName('num')[0].style.opacity = 0


@click-one-by-one = -> @AUTO = true; get-random-num(btns[0])
