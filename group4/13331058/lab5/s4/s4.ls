$ !->
  Resetting!
  Presetting!

used = [0, 0, 0, 0, 0, 0]
ch = ["S", "A", "B", "C", "D", "E"]
order = [-1, -1, -1, -1, -1]
order_list = ""
interrupt = 0
arise = 0
sum = 0
click_num = 0

data =
  can_start: 1

Get-random-number = (limit) ->
  return Math.round(Math.random() * limit)

Check = ->
  flag = 1
  for i from 1 to 5 by 1
    if used[i] == 0
      flag = 0
  return flag

/* 构造随机序列 */
Random-order = !->
  used := [0, 0, 0, 0, 0, 0]
  order := [-1, -1, -1, -1, -1]
  order_list := ""
  position = 0
  num
  while Check! == 0
    num = (Get-random-number 4) + 1
    if used[num] == 0
      used[num] = 1
      order[position] = num
      position++
  for i from 0 to 4 by 1
    if i < 4
      order_list += ch[order[i]]
      order_list += "+ "
    else
      order_list += ch[order[i]]

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
        interrupt := 0
        Robot!

/* 仿真机器人，依据随机序列， 依次点击小按钮 */
Robot = !->
  buttons = document.getElementsByTagName("ul")
  r_numbers = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    r_numbers[i].canclick = 1
    r_numbers[i].have_number = 0
  r_sum = buttons[0].getElementsByTagName("li")
  r_sum[0].canclick = 0
  r_sum[0].innerHTML = order_list
  r_sum[0].style.fontSize = 100 + "%"
  for i from 0 to 4 by 1
    r_numbers[i].style.background = "#0044BB"
  Get-num r_numbers, click_num

/* 核心步骤，申请随机数并填入小气泡 ，实时检测大气泡的激活条件*/
Get-num = (allbuttons, times)!->
  if times < 5
    arise := 0
    allbuttons[order[times]-1].have_number = 1
    r = allbuttons[order[times]-1].getElementsByTagName("span")[0]
    r.style.display="inline"
    r.innerHTML = "..."
    xmlhttp = null;
    for l from 0 to 4 by 1
      allbuttons[l].style.background = "#666666"
      allbuttons[l].canclick = 0
    times++
    xmlhttp = new XMLHttpRequest();
    if xmlhttp != null
      xmlhttp.open("get", "/", true)
      xmlhttp.send()
      xmlhttp.onreadystatechange = !->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          if interrupt == 1
            arise := 1
            Resetting!
            return
          r.innerHTML = xmlhttp.responseText
          sum += parseInt(r.innerHTML)
          for l from 0 to 4 by 1
            if allbuttons[l].have_number == 0
              allbuttons[l].style.background = "#0044BB"
              allbuttons[l].canclick = 1
          if times == 5
            arise := 1
            buttons = document.getElementsByTagName("ul")
            r_numbers = buttons[0].getElementsByTagName("li")
            r_numbers[0].style.background = "#0044BB"
            r_numbers[0].canclick = 1
            if r_numbers[0].canclick == 1
              r_numbers[0].innerHTML = sum
              r_numbers[0].style.fontSize = 300 + "%"
          Get-num allbuttons, times

/* 重置 */
Resetting = !->
  interrupt := 1
  sum := 0
  click_num := 0
  if arise == 1
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