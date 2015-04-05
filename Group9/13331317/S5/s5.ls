$ !->
  reset!
  preset!

data =
  good_mes: ["这是个天大的秘密", "我不知道", "你不知道", "他不知道", "才怪"]
  bad_mes: ["这不是个天大的秘密", "我知道", "你知道", "他知道", "才不怪"]
  arise: 0
  used: [0, 0, 0, 0, 0, 0]
  order: [-1, -1, -1, -1, -1]
  can_start: 1
  interrupt: 0
  sum: 0
  click_num: 0

Get-random-number = (limit) ->
  return Math.round(Math.random() * limit)

Check = ->
  flag = 1
  for i from 1 to 5 by 1
    if data.used[i] == 0
      flag = 0
  return flag


Random-order = !->
  data.used := [0, 0, 0, 0, 0, 0]
  data.order := [-1, -1, -1, -1, -1]
  data.order_list := ""
  position = 0
  num
  while Check! == 0
    num = (Get-random-number 4) + 1
    if data.used[num] == 0
      data.used[num] = 1
      data.order[position] = num
      position++

preset = !->
  a_plus = document.getElementById("button")
  buttons = document.getElementsByTagName("ul")
  randomNum = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    randomNum[i].style.background = "#0044BB"
  a_plus.onmouseover = !->
    @id = "button_hover"
    area_ = document.getElementsByTagName("div")[0]
    area_.onmouseover = !->
      @id = "area"
      this.onmouseout = !->
        x = event.clientX
        y = event.clientY
        areax1 = this.offsetLeft
        areax2 = this.offsetLeft + 350
        areay1 = this.offsetTop
        areay2 = this.offsetTop + 350
        if x >= areax2 || x < areax1 || y < areay1 || y >= areay2 then reset!
    click_area_ = document.getElementById("click_area")
    click_area_.onclick = !->
      if data.can_start == 1
        Random-order!
        data.can_start = 0
        data.interrupt := 0
        jiqiren!


nextClicking = !->
  if data.order[data.click_num]-1 == 0
    fuca!
  if data.order[data.click_num]-1 == 1
    fucb!
  if data.order[data.click_num]-1 == 2
    fucc!
  if data.order[data.click_num]-1 == 3
    fucd!
  if data.order[data.click_num]-1 == 4
    fuce!


check-if-success = ->
  num = (Get-random-number 9) + 1
  if num > 4
    return 1
  else
    return 0


bubblfuce = !->
  buttons = document.getElementsByTagName("ul")
  ring_numbers = buttons[0].getElementsByTagName("li")
  ring_numbers[0].style.background = "#0044BB"
  ring_numbers[0].canclick = 1
  if ring_numbers[0].canclick == 1
    ring_numbers[0].innerHTML = data.sum
    ring_numbers[0].style.fontSize = 300 + "%"



fuca = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    randomNum = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    randomNum[0].have_number = 1
    r = randomNum[0].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlHttpReg = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[0]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[0]
    for l from 0 to 4 by 1
      randomNum[l].style.background = "#666666"
      randomNum[l].canclick = 0
    xmlHttpReg = new xmlHttpRegRequest()
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true)
      xmlHttpReg.send()
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState == 4 and xmlHttpReg.status == 200
          if data.interrupt == 1
            data.arise := 1
            reset!
            return
          if can == 1
            r.innerHTML = xmlHttpReg.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if randomNum[l].have_number == 0
                randomNum[l].style.background = "#0044BB"
                randomNum[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubblfuce!
            data.click_num++
            nextClicking!
          else
            fuca!

fucb = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    randomNum = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    randomNum[1].have_number = 1
    r = randomNum[1].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlHttpReg = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[1]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[1]
    for l from 0 to 4 by 1
      randomNum[l].style.background = "#666666"
      randomNum[l].canclick = 0
    xmlHttpReg = new xmlHttpRegRequest()
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true)
      xmlHttpReg.send()
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState == 4 and xmlHttpReg.status == 200
          if data.interrupt == 1
            data.arise := 1
            reset!
            return
          if can == 1
            r.innerHTML = xmlHttpReg.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if randomNum[l].have_number == 0
                randomNum[l].style.background = "#0044BB"
                randomNum[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubblfuce!
            data.click_num++
            nextClicking!
          else
            fucb!

fucc = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    randomNum = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    randomNum[2].have_number = 1
    r = randomNum[2].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlHttpReg = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[2]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[2]
    for l from 0 to 4 by 1
      randomNum[l].style.background = "#666666"
      randomNum[l].canclick = 0
    xmlHttpReg = new xmlHttpRegRequest()
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true)
      xmlHttpReg.send()
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState == 4 and xmlHttpReg.status == 200
          if data.interrupt == 1
            data.arise := 1
            reset!
            return
          if can == 1
            r.innerHTML = xmlHttpReg.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if randomNum[l].have_number == 0
                randomNum[l].style.background = "#0044BB"
                randomNum[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubblfuce!
            data.click_num++
            nextClicking!
          else
            fucc!

fucd = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    randomNum = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    randomNum[3].have_number = 1
    r = randomNum[3].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlHttpReg = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[3]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[3]
    for l from 0 to 4 by 1
      randomNum[l].style.background = "#666666"
      randomNum[l].canclick = 0
    xmlHttpReg = new xmlHttpRegRequest()
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true)
      xmlHttpReg.send()
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState == 4 and xmlHttpReg.status == 200
          if data.interrupt == 1
            data.arise := 1
            reset!
            return
          if can == 1
            r.innerHTML = xmlHttpReg.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if randomNum[l].have_number == 0
                randomNum[l].style.background = "#0044BB"
                randomNum[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubblfuce!
            data.click_num++
            nextClicking!
          else
            fucd!

fuce = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    randomNum = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    randomNum[4].have_number = 1
    r = randomNum[4].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlHttpReg = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[4]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[4]
    for l from 0 to 4 by 1
      randomNum[l].style.background = "#666666"
      randomNum[l].canclick = 0
    xmlHttpReg = new xmlHttpRegRequest()
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true)
      xmlHttpReg.send()
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState == 4 and xmlHttpReg.status == 200
          if data.interrupt == 1
            data.arise := 1
            reset!
            return
          if can == 1
            r.innerHTML = xmlHttpReg.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if randomNum[l].have_number == 0
                randomNum[l].style.background = "#0044BB"
                randomNum[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubblfuce!
            data.click_num++
            nextClicking!
          else
            fuce!


jiqiren = !->
  buttons = document.getElementsByTagName("ul")
  randomNum = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    randomNum[i].canclick = 1
    randomNum[i].have_number = 0
  r_sum = buttons[0].getElementsByTagName("li")
  r_sum[0].canclick = 0
  r_sum[0].style.fontSize = 100 + "%"
  for i from 0 to 4 by 1
    randomNum[i].style.background = "#0044BB"
  nextClicking!


reset = !->
  data.interrupt := 1
  data.sum := 0
  data.click_num := 0
  if data.arise == 1
    data.can_start = 1
  a_plus = document.getElementsByTagName("div")[2]
  a_plus.id = "button"
  area_ = document.getElementsByTagName("div")[0]
  area_.id = "at-plus-container"
  buttons = document.getElementsByTagName("ul")
  randomNum = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    randomNum[i].canclick = 1
    randomNum[i].have_number = 0
    randomNum[i].style.background = "#0044BB"
    r = randomNum[i].getElementsByTagName("span")[0]
    r.style.display="none"
  randomNum = buttons[0].getElementsByTagName("li")
  randomNum[0].style.background = "#666666"
  randomNum[0].innerHTML = ""
  randomNum[0].canclick = 0