$ !->
  Presetting!
  Creat-random-number!

sum = 0
click_num = 0

/*预处理， 创建合法鼠标停留区域， 以及离开区域后的重设*/
Presetting = !->
  a_plus = document.getElementById("button")
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

/* 初始化所有按钮，并为A~E按钮设置申请随机数的操作 */
Creat-random-number = !->
  buttons = document.getElementsByTagName("ul")
  r_numbers = buttons[1].getElementsByTagName("li")
  for i from 0 to 4 by 1
    r_numbers[i].canclick = 1
    r_numbers[i].have_number = 0
  r_sum = buttons[0].getElementsByTagName("li")
  r_sum[0].canclick = 0
  for i from 0 to 4 by 1
    r_numbers[i].style.background = "#0044BB"
    r_numbers[i].onclick = !->
      if @canclick == 1
        click_num++
        @have_number = 1
        r = @getElementsByTagName("span")[0]
        r.style.display="inline"
        number = 0
        r.innerHTML = "..."
        for l from 0 to 4 by 1
          r_numbers[l].style.background = "#666666"
          r_numbers[l].canclick = 0
        Get-num @, r_numbers

/* 核心步骤，申请随机数并填入小气泡 ，实时检测大气泡的激活条件*/
Get-num = (itself, allbuttons)!->
  r = itself.getElementsByTagName("span")[0]
  xmlhttp = null;
  xmlhttp = new XMLHttpRequest();
  if xmlhttp != null
    xmlhttp.open("get", "/", true)
    xmlhttp.send()
    xmlhttp.onreadystatechange = !->
      if xmlhttp.readyState == 4 and xmlhttp.status == 200
        r.innerHTML = xmlhttp.responseText
        sum += parseInt(r.innerHTML)
        for l from 0 to 4 by 1
          if allbuttons[l].have_number == 0
            allbuttons[l].style.background = "#0044BB"
            allbuttons[l].canclick = 1
        if click_num == 5
          buttons = document.getElementsByTagName("ul")
          r_numbers = buttons[0].getElementsByTagName("li")
          r_numbers[0].style.background = "#0044BB"
          r_numbers[0].canclick = 1
          r_numbers[0].onclick = !->
            if r_numbers[0].canclick == 1
              @innerHTML = sum

/* 重置 */
Resetting = !->
  sum := 0
  click_num := 0
  a_plus = document.getElementById("button_hover")
  a_plus.id = "button"
  area_ = document.getElementById("area")
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