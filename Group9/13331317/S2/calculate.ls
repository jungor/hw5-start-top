window.onload =!->
  activation!
  getNumbers!

pan = 0
count = 0
answ = 0
isclicking = []
isclicked = []
for i from 0 to 4 by 1
  isclicked[i] = 0
  isclicking[i] = 0

getRandomNumber = (circle) !->
  if count != 5
    buttons = document.getElementsByTagName("ul");
    lis = buttons[1].getElementsByTagName("li");
    xmlHttpReg = null;
    circle[count].style.display = "inline";
    circle[count].innerHTML = "...";
    xmlHttpReg = new XMLHttpRequest();
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true);
      xmlHttpReg.send();
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState==4 and xmlHttpReg.status == 200
          for i from 0 to 4 by 1
            if i = (count+1)
              lis[i].style.backgroundColor = "#234991"
            else
              lis[i].style.backgroundColor = "#7E7E7E"
        circle[count].innerHTML=(xmlHttpReg.responseText);
        answ += parseInt(circle[count].innerHTML);
        count++;
        getRandomNumber circle
  if count == 5
    buttons = document.getElementsByTagName("ul")
    buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML = answ;

getNumbers = !->
  buttons = document.getElementsByTagName("ul")
  lis = buttons[1].getElementsByTagName("li")
  ans = buttons[0].getElementsByTagName("li")[0]
  atplus = document.getElementById("button")
  flag = []
  sum = 0
  atplus.onclick = !->
    for i from 0 to 4 by 1
      lis[i].style.backgroundColor = "#234991"
      flag[i] = 1
    circle = []
    for i from 0 to 4 by 1
      circle[i] = lis[i].getElementsByTagName("span")[0]
    getRandomNumber circle


activation =->
  buttons = document.getElementById("button");
  buttons.onmouseover =  !->
    document.getElementById("area").className = "at-plus-container-block";
    this.id = "button_hover";
  area = document.getElementById("area");
  area.onmouseleave = !->
    location.reload();
  area = document.getElementById("area"); 