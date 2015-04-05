// Generated by LiveScript 1.3.1
(function(){
  var newOrder, robotClickAToE, getOrder, s2Callback, makeAllButtonCanBeClicked, rebornAllButtons, makeButtonDisable, makeButtonEnable, getNumber, waitNumber, getResult;
  window.onload = function(){
    makeAllButtonCanBeClicked();
    $("button").onmouseleave = rebornAllButtons;
    $("icon").addEventListener('click', robotClickAToE);
  };
  newOrder = 1;
  robotClickAToE = function(){
    var order;
    $("icon").removeEventListener('click', robotClickAToE);
    order = getOrder();
    newOrder = order;
    s2Callback(order);
  };
  getOrder = function(){
    var hash, i$, i, str, n, random, order;
    if (newOrder === 1) {
      hash = [];
      for (i$ = 0; i$ < 5; ++i$) {
        i = i$;
        hash[i] = 0;
      }
      str = "";
      n = 0;
      while (n < 5) {
        random = Math.floor(Math.random() * 5);
        if (hash[random] === 0) {
          n++;
          hash[random] = 1;
          str = str + random.toString();
        }
      }
      order = "";
      for (i$ = 0; i$ < 5; ++i$) {
        i = i$;
        if (str[i] === '0') {
          order = order + 'A';
        } else if (str[i] === '1') {
          order = order + 'B';
        } else if (str[i] === '2') {
          order = order + 'C';
        } else if (str[i] === '3') {
          order = order + 'D';
        } else if (str[i] === '4') {
          order = order + 'E';
        }
      }
      $("info").style.fontSize = '32px';
      $("info").innerHTML = order;
    }
    return str;
  };
  s2Callback = function(order){
    var abcde, i$, to$, i, thisbutton;
    if (order !== '1') {
      abcde = $("control-ring").children;
      for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
        i = i$;
        thisbutton = parseInt(order[i]);
        if (abcde[thisbutton].childNodes.length === 1) {
          abcde[thisbutton].click();
          return;
        }
      }
    }
  };
  makeAllButtonCanBeClicked = function(){
    var abcde, i$, to$, i;
    abcde = $("control-ring").children;
    for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
      i = i$;
      abcde[i].addEventListener('click', getNumber);
    }
  };
  rebornAllButtons = function(){
    var abcde, i$, to$, i, bubble;
    abcde = $("control-ring").children;
    for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
      i = i$;
      makeButtonEnable(abcde[i]);
    }
    bubble = $("info");
    bubble.removeEventListener('click', getResult);
    bubble.style.backgroundColor = 'grey';
    bubble.innerHTML = "";
    $("icon").addEventListener('click', robotClickAToE);
    for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
      i = i$;
      abcde[i].style.backgroundColor = 'blue';
    }
    newOrder = 1;
  };
  makeButtonDisable = function(button){
    button.removeEventListener('click', getNumber);
    button.style.backgroundColor = 'grey';
  };
  makeButtonEnable = function(button){
    if (button.childNodes.length === 2) {
      button.removeChild(button.childNodes[1]);
    }
    button.addEventListener('click', getNumber);
    button.style.backgroundColor = 'blue';
  };
  getNumber = function(){
    var rc, abcde, i$, to$, i, thisbutton, xmlhttp;
    rc = document.createElement('span');
    rc.innerText = '...';
    rc.className = 'redcircle';
    rc.style.fontSize = '5px';
    this.appendChild(rc);
    abcde = $("control-ring").children;
    for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
      i = i$;
      if (abcde[i] !== this) {
        makeButtonDisable(abcde[i]);
      }
    }
    thisbutton = this;
    /* sent-request-to-server rc,thisbutton */
    if (window.XMLHttpRequest) {
      xmlhttp = new XMLHttpRequest();
    } else {
      xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
    }
    xmlhttp.onreadystatechange = function(){
      if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
        rc.innerText = xmlhttp.responseText;
        waitNumber(thisbutton, newOrder);
      }
    };
    xmlhttp.open('GET', '/', true);
    xmlhttp.send();
  };
  /*sent-request-to-server = (rc, thisbutton) !->
  	$.get('/', (data, status) !->
  					rc.innerText = xmlhttp.data
  					wait-number thisbutton)*/
  waitNumber = function(thisbutton, order){
    var flag, abcde, i$, to$, i, result;
    flag = 1;
    abcde = $("control-ring").children;
    for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
      i = i$;
      if (abcde[i].childNodes.length === 1) {
        makeButtonEnable(abcde[i]);
        flag = 0;
      }
    }
    makeButtonDisable(thisbutton);
    if (flag === 1) {
      result = $("info");
      getResult(result);
    }
    s2Callback(order);
  };
  getResult = function(bubble){
    var abcde, sum, i$, to$, i;
    abcde = $("control-ring").children;
    sum = 0;
    for (i$ = 0, to$ = abcde.length; i$ < to$; ++i$) {
      i = i$;
      sum = sum + parseInt(abcde[i].lastChild.innerText);
    }
    bubble.innerHTML = sum;
  };
}).call(this);