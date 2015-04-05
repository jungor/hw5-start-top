window.onload = !->
  activation!
  getNumbers!

pan = 0;
count = 0;
answ = 0;
isclicking = [];
isclicked = [];
for i from 0 to 4 by 1
  isclicked[i] = 0;
  isclicking[i] = 0;

getRandomNumber = (circle, anynum) !->
  if count != 5
    buttons = document.getElementsByTagName("ul");
    lis = buttons[1].getElementsByTagName("li");
    xmlHttpReg = null;
    circle[anynum[count]].style.display = "inline";
    circle[anynum[count]].innerHTML = "...";
    xmlHttpReg = new XMLHttpRequest();
    if xmlHttpReg != null
      xmlHttpReg.open("get", "/", true);
      xmlHttpReg.send();
      xmlHttpReg.onreadystatechange = !->
        if xmlHttpReg.readyState==4 and xmlHttpReg.status == 200
          for i from 0 to 4 by 1
            if i == anynum[count+1]
              lis[i].style.backgroundColor = "#234991";
            else
              lis[i].style.backgroundColor = "#7E7E7E"
          circle[anynum[count]].innerHTML=(xmlHttpReg.responseText);
          answ += parseInt(circle[anynum[count]].innerHTML);
          count++;
          getRandomNumber(circle, anynum);
  if count == 5
    buttons = document.getElementsByTagName("ul");
    buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML += answ;


getNumbers = !->
  buttons = document.getElementsByTagName("ul");
  lis = buttons[1].getElementsByTagName("li");
  ans = buttons[0].getElementsByTagName("li")[0];
  atplus = document.getElementById("button");
  anynum = [];
  sum = 0;
  atplus.onclick = !->
    for i from 0 to 4 by 1
      lis[i].style.backgroundColor = "#234991";
    circle = [];
    for i from 0 to 4 by 1
      circle[i] = lis[i].getElementsByTagName("span")[0];
      anynum[i] = i;
    anynum = anynum.sort(randomsort);
    alpha = changeToAlpha(anynum);
    buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML = alpha+'\n'+'Answer:';
    getRandomNumber(circle, anynum);


activation =->
  buttons = document.getElementById("button");
  buttons.onmouseover =  !->
    document.getElementById("area").className = "at-plus-container-block";
    this.id = "button_hover";
  area = document.getElementById("area");
  area.onmouseleave = !->
    location.reload();
  area = document.getElementById("area"); 

randomsort = (a, b) !->
  ter = Math.random!
  if ter >= 0.5
    return -1
  else
    return 1

changeToAlpha = (array) !->
  alpha = "";
  for i from 0 to array.length-1 by 1
    if array[i] == 0
      alpha += "A";
    else if array[i] == 1
      alpha += "B";
    else if array[i] == 2
      alpha += "C";
    else if array[i] == 3
      alpha += "D";
    else if array[i] == 4
      alpha += "E";
  return alpha;
