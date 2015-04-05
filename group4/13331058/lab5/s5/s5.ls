$ !->
  Resetting!
  Presetting!

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

/* 构造随机序列 */
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

/*预处理， 创建合法鼠标停留区域， 以及离开区域后的重设*/
Presetting = !->
  a_plus = document.getElementById("button")
  buttons = document.getElementsByTagName("ul")
  r_numbers = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    r_numbers[i].style.background = "#0044BB"
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
        if x >= areax2 || x < areax1 || y < areay1 || y >= areay2 then Resetting!
    click_area_ = document.getElementById("click_area")
    click_area_.onclick = !->
      if data.can_start == 1
        Random-order!
        data.can_start = 0
        data.interrupt := 0
        Robot!

/* 一个控制使用哪一个按钮函数的控制函数 */
click_next = !->
  if data.order[data.click_num]-1 == 0
    aHandler!
  if data.order[data.click_num]-1 == 1
    bHandler!
  if data.order[data.click_num]-1 == 2
    cHandler!
  if data.order[data.click_num]-1 == 3
    dHandler!
  if data.order[data.click_num]-1 == 4
    eHandler!

/* 一个判断是否产生异常错误随机函数 , 异常率大概为 40% */
check-if-success = ->
  num = (Get-random-number 9) + 1
  if num > 4
    return 1
  else
    return 0

/* 大气泡控制器 */
bubbleHandler = !->
  buttons = document.getElementsByTagName("ul")
  ring_numbers = buttons[0].getElementsByTagName("li")
  ring_numbers[0].style.background = "#0044BB"
  ring_numbers[0].canclick = 1
  if ring_numbers[0].canclick == 1
    ring_numbers[0].innerHTML = data.sum
    ring_numbers[0].style.fontSize = 300 + "%"


/* 5个按钮的控制函数 */
aHandler = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    r_numbers = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    r_numbers[0].have_number = 1
    r = r_numbers[0].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlhttp = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[0]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[0]
    for l from 0 to 4 by 1
      r_numbers[l].style.background = "#666666"
      r_numbers[l].canclick = 0
    xmlhttp = new XMLHttpRequest()
    if xmlhttp != null
      xmlhttp.open("get", "/", true)
      xmlhttp.send()
      xmlhttp.onreadystatechange = !->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          if data.interrupt == 1
            data.arise := 1
            Resetting!
            return
          if can == 1
            r.innerHTML = xmlhttp.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if r_numbers[l].have_number == 0
                r_numbers[l].style.background = "#0044BB"
                r_numbers[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubbleHandler!
            data.click_num++
            click_next!
          else
            aHandler!

bHandler = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    r_numbers = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    r_numbers[1].have_number = 1
    r = r_numbers[1].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlhttp = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[1]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[1]
    for l from 0 to 4 by 1
      r_numbers[l].style.background = "#666666"
      r_numbers[l].canclick = 0
    xmlhttp = new XMLHttpRequest()
    if xmlhttp != null
      xmlhttp.open("get", "/", true)
      xmlhttp.send()
      xmlhttp.onreadystatechange = !->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          if data.interrupt == 1
            data.arise := 1
            Resetting!
            return
          if can == 1
            r.innerHTML = xmlhttp.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if r_numbers[l].have_number == 0
                r_numbers[l].style.background = "#0044BB"
                r_numbers[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubbleHandler!
            data.click_num++
            click_next!
          else
            bHandler!

cHandler = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    r_numbers = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    r_numbers[2].have_number = 1
    r = r_numbers[2].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlhttp = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[2]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[2]
    for l from 0 to 4 by 1
      r_numbers[l].style.background = "#666666"
      r_numbers[l].canclick = 0
    xmlhttp = new XMLHttpRequest()
    if xmlhttp != null
      xmlhttp.open("get", "/", true)
      xmlhttp.send()
      xmlhttp.onreadystatechange = !->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          if data.interrupt == 1
            data.arise := 1
            Resetting!
            return
          if can == 1
            r.innerHTML = xmlhttp.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if r_numbers[l].have_number == 0
                r_numbers[l].style.background = "#0044BB"
                r_numbers[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubbleHandler!
            data.click_num++
            click_next!
          else
            cHandler!

dHandler = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    r_numbers = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    r_numbers[3].have_number = 1
    r = r_numbers[3].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlhttp = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[3]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[3]
    for l from 0 to 4 by 1
      r_numbers[l].style.background = "#666666"
      r_numbers[l].canclick = 0
    xmlhttp = new XMLHttpRequest()
    if xmlhttp != null
      xmlhttp.open("get", "/", true)
      xmlhttp.send()
      xmlhttp.onreadystatechange = !->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          if data.interrupt == 1
            data.arise := 1
            Resetting!
            return
          if can == 1
            r.innerHTML = xmlhttp.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if r_numbers[l].have_number == 0
                r_numbers[l].style.background = "#0044BB"
                r_numbers[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubbleHandler!
            data.click_num++
            click_next!
          else
            dHandler!

eHandler = !->
  if data.click_num < 5
    buttons = document.getElementsByTagName("ul")
    r_numbers = buttons[1].getElementsByTagName("li")
    ring_numbers = buttons[0].getElementsByTagName("li")
    data.arise := 0
    r_numbers[4].have_number = 1
    r = r_numbers[4].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlhttp = null
    can = check-if-success!
    if can == 1
      ring_numbers[0].innerHTML = data.good_mes[4]
    else
      ring_numbers[0].innerHTML = "error: " + data.bad_mes[4]
    for l from 0 to 4 by 1
      r_numbers[l].style.background = "#666666"
      r_numbers[l].canclick = 0
    xmlhttp = new XMLHttpRequest()
    if xmlhttp != null
      xmlhttp.open("get", "/", true)
      xmlhttp.send()
      xmlhttp.onreadystatechange = !->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          if data.interrupt == 1
            data.arise := 1
            Resetting!
            return
          if can == 1
            r.innerHTML = xmlhttp.responseText
            data.sum += parseInt(r.innerHTML)
            for l from 0 to 4 by 1
              if r_numbers[l].have_number == 0
                r_numbers[l].style.background = "#0044BB"
                r_numbers[l].canclick = 1
            if data.click_num == 4
              data.arise := 1
              bubbleHandler!
            data.click_num++
            click_next!
          else
            eHandler!

/* 仿真机器人，依据随机序列， 依次点击小按钮 */
Robot = !->
  buttons = document.getElementsByTagName("ul")
  r_numbers = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    r_numbers[i].canclick = 1
    r_numbers[i].have_number = 0
  r_sum = buttons[0].getElementsByTagName("li")
  r_sum[0].canclick = 0
  r_sum[0].style.fontSize = 100 + "%"
  for i from 0 to 4 by 1
    r_numbers[i].style.background = "#0044BB"
  click_next!

/* 重置 */
Resetting = !->
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
  r_numbers = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    r_numbers[i].canclick = 1
    r_numbers[i].have_number = 0
    r_numbers[i].style.background = "#0044BB"
    r = r_numbers[i].getElementsByTagName("span")[0]
    r.style.display="none"
  r_numbers = buttons[0].getElementsByTagName("li")
  r_numbers[0].style.background = "#666666"
  r_numbers[0].innerHTML = ""
  r_numbers[0].canclick = 0