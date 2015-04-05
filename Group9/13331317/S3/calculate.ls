window.onload = !->
  activation!
  getNumbers!

pan = 0;
count = 0;
answ = 0;

getRandomNumber = (circle, flag, i) !->
  buttons = document.getElementsByTagName("ul");
  lis = buttons[1].getElementsByTagName("li");
  xmlHttpReg = null;
  xmlHttpReg = new XMLHttpRequest();
  if xmlHttpReg != null
    xmlHttpReg.open("get", "/"+String(i), true);
    xmlHttpReg.send();
    xmlHttpReg.onreadystatechange = !->
      if xmlHttpReg.readyState==4 and xmlHttpReg.status == 200
        circle.innerHTML=(xmlHttpReg.responseText);
        for i from 0 to 4 by 1
          lis[i].style.backgroundColor = "#234991";
        count := count + 1;
        answ := answ + parseInt(circle.innerHTML);
        if count == 5
          buttons = document.getElementsByTagName("ul");
          buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML = answ;


getNumbers = !->
  buttons = document.getElementsByTagName("ul");
  lis = buttons[1].getElementsByTagName("li");
  ans = buttons[0].getElementsByTagName("li")[0];
  atplus = document.getElementById("button");
  flag = [];
  isclicked = [];
  sum = 0;
  atplus.onclick = !->
    for i from 0 to 4 by 1
      lis[i].style.backgroundColor = "#234991"
      flag[i] = 1;
    for i from 0 to 4 by 1
      circle = lis[i].getElementsByTagName("span")[0];
      circle.style.display = "inline";
      circle.innerHTML = "...";
      getRandomNumber(circle, flag, i);


activation =->
  buttons = document.getElementById("button");
  buttons.onmouseover =  !->
    document.getElementById("area").className = "at-plus-container-block";
    this.id = "button_hover";
  area = document.getElementById("area");
  area.onmouseleave = !->
    location.reload();
  area = document.getElementById("area"); 
