$ !->
  activation!
  getNumbers!

getRandomNumber = (circle, flag) ->
  buttons = document.getElementsByTagName("ul")
  lis = buttons[1].getElementsByTagName("li")
  xmlHttpReg = null
  xmlHttpReg = new XMLHttpRequest()
  if xmlHttpReg != null
    xmlHttpReg.open("get", "/", true)
    xmlHttpReg.send()
    xmlHttpReg.onreadystatechange =!->
      if xmlHttpReg.readyState==4 and xmlHttpReg.status == 200
        circle.innerHTML = xmlHttpReg.responseText
        for i from 0 to 4 by 1
          flag[i] = 1
          lis[i].style.backgroundColor = "#234991"

getNumbers =!->
  buttons = document.getElementsByTagName("ul")
  lis = buttons[1].getElementsByTagName("li")
  ans = buttons[0].getElementsByTagName("li")[0]
  flag = []
  isclicked = []
  for i from 0 to 4 by 1
    lis[i].style.backgroundColor = "#234991"
    flag[i] = 1
    isclicked[i] = 0
  for let i from 0 to 4 by 1
    lis[i].onclick =!->
      isclicked[i] = 1
      if flag[i]
        for j from 0 to 4 by 1
          if j != i
            flag[j] = 0
            lis[j].style.backgroundColor = "#7E7E7E"
        circle = this.getElementsByTagName("span")[0]
        circle.style.display = "inline"
        circle.innerHTML = "..."
        getRandomNumber(circle, flag)

  ans.onclick =!->
    sum = 0;
    cansum = 1;
    numbers = [];
    for i from 0 to 4 by 1
      if isclicked[i] == 0
        cansum = 0;
    if cansum
      tbuttons = document.getElementsByTagName("ul");
      tlis = buttons[1].getElementsByTagName("li");
      tsp = [];
      this.style.backgroundColor = "#234991";
      for i from 0 to 4 by 1
        tsp[i] = parseInt(tlis[i].getElementsByTagName("span")[0].innerHTML);
        sum += tsp[i];
      buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML = sum;
      for i from 0 to 4 by 1
        isclicked[i] = 0;

activation =->
  buttons = document.getElementById("button");
  buttons.onmouseover =  !->
    document.getElementById("area").className = "at-plus-container-block";
    this.id = "button_hover";
  area = document.getElementById("area");
  area.onmouseleave = !->
    location.reload();
  area = document.getElementById("area"); 