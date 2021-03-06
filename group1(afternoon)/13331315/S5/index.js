// Generated by LiveScript 1.3.1
(function(){
  var autoRobot, getrandom, roundFinger, enableAtPlus, clearAll, boomAddClick, liAddClick, liGetNumber, disableOtherLi, callback, nextClick, enableBoomClick, enableOtherLi, liRobot, callbackRobot, failToRespond, aHandler, bHandler, cHandler, dHandler, eHandler, bubbleHandler;
  window.onload = function(){
    boomAddClick();
    liAddClick();
    clearAll();
    autoRobot();
  };
  autoRobot = function(){
    var atplus;
    atplus = document.getElementsByClassName("apb");
    atplus[0].onclick = function(){
      if (atplus[0].success !== "after") {
        enableAtPlus();
        roundFinger();
      }
    };
  };
  getrandom = function(){
    var initial, result, i$, i, j;
    initial = new Array;
    result = new Array;
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      initial[i] = i;
    }
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      j = Math.floor(Math.random() * 5);
      while (initial[j] === null) {
        j = Math.floor(Math.random() * 5);
      }
      result[i] = initial[j];
      initial[j] = null;
    }
    return result;
  };
  roundFinger = function(){
    var randomnum_, show, string, i$, len$, item, msg, lis, to$, i;
    randomnum_ = new Array;
    randomnum_ = getrandom();
    show = document.getElementsByClassName("data");
    string = "";
    for (i$ = 0, len$ = randomnum_.length; i$ < len$; ++i$) {
      item = randomnum_[i$];
      string += String.fromCharCode(65 + item);
    }
    msg = document.getElementById("msg");
    string += '\n';
    msg.innerHTML = string;
    lis = document.getElementsByTagName("li");
    for (i$ = 0, to$ = lis.length - 2; i$ <= to$; ++i$) {
      i = i$;
      lis[randomnum_[i]].nextid = randomnum_[i + 1];
    }
    lis[randomnum_[4]].nextid = -1;
    lis[randomnum_[0]].clickbyrobot = "true";
    lis[randomnum_[0]].success = "after";
    if (randomnum_[0] === 0) {
      aHandler(0, lis[0]);
    } else if (randomnum_[0] === 1) {
      bHandler(0, lis[1]);
    } else if (randomnum_[0] === 2) {
      cHandler(0, lis[2]);
    } else if (randomnum_[0] === 3) {
      dHandler(0, lis[3]);
    } else if (randomnum_[0] === 4) {
      eHandler(0, lis[4]);
    }
  };
  enableAtPlus = function(){
    var atplus;
    atplus = document.getElementsByClassName("apb");
    atplus[0].success = "after";
    atplus[0].style.backgroundColor = "gray";
  };
  clearAll = function(){
    document.getElementById('at-plus-container').onmouseleave = function(){
      location.reload();
    };
  };
  boomAddClick = function(){
    var icon_, unread_, sum;
    icon_ = document.getElementById("info-bar");
    unread_ = document.getElementsByClassName("unread");
    sum = 0;
    icon_.onclick = function(){
      var i$, ref$, len$, item, show;
      if (enableBoomClick()) {
        for (i$ = 0, len$ = (ref$ = unread_).length; i$ < len$; ++i$) {
          item = ref$[i$];
          sum += Number(item.innerHTML);
        }
        show = document.getElementsByClassName("data");
        show[0].innerHTML = String(sum);
        icon_.style.backgroundColor = "gray";
      }
    };
  };
  liAddClick = function(){
    var lis, i$, to$, i, item;
    lis = document.getElementsByTagName("li");
    for (i$ = 0, to$ = lis.length - 1; i$ <= to$; ++i$) {
      i = i$;
      item = lis[i];
      item.id = i;
      item.onclick = fn$;
    }
    function fn$(){
      enableAtPlus();
      if (this.success !== "after" && this.success !== "false") {
        this.success = "after";
        liGetNumber(this, this.id);
      }
    }
  };
  liGetNumber = function(li, i){
    var span, xmlHttp;
    disableOtherLi();
    span = li.getElementsByTagName("span");
    span[0].innerHTML = "...";
    span[0].style.display = "block";
    xmlHttp = new XMLHttpRequest();
    xmlHttp.open("get", "/", true);
    if (xmlHttp !== null) {
      xmlHttp.send(null);
      return xmlHttp.onreadystatechange = function(){
        if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
          return callback(xmlHttp.responseText, li);
        }
      };
    }
  };
  disableOtherLi = function(){
    var lis, i$, len$, item;
    lis = document.getElementsByTagName("li");
    for (i$ = 0, len$ = lis.length; i$ < len$; ++i$) {
      item = lis[i$];
      if (item.success !== "after" && item.success !== "false") {
        item.style.backgroundColor = "gray";
        item.success = "false";
      }
    }
  };
  callback = function(text, li){
    var span;
    span = li.getElementsByTagName("span");
    span[0].innerHTML = String(text);
    li.style.backgroundColor = "gray";
    enableOtherLi();
    enableBoomClick();
    if (li.clickbyrobot === "true") {
      return nextClick(li);
    }
  };
  nextClick = function(li){
    var lis, i, unread_, sum, i$, len$, item, show, icon_;
    lis = document.getElementsByTagName("li");
    i = Number(li.nextid);
    if (i >= 0) {
      lis[i].clickbyrobot = "true";
      lis[i].success = "after";
      return liGetNumber(lis[i], i);
    } else {
      unread_ = document.getElementsByClassName("unread");
      sum = 0;
      for (i$ = 0, len$ = unread_.length; i$ < len$; ++i$) {
        item = unread_[i$];
        sum += Number(item.innerHTML);
      }
      show = document.getElementsByClassName("data");
      show[0].innerHTML = String(sum);
      icon_ = document.getElementById("info-bar");
      return icon_.style.backgroundColor = "gray";
    }
  };
  enableBoomClick = function(){
    var unreads, success, i$, len$, item, icon_;
    unreads = document.getElementsByClassName("unread");
    success = true;
    for (i$ = 0, len$ = unreads.length; i$ < len$; ++i$) {
      item = unreads[i$];
      if (item.innerHTML === "") {
        success = false;
      }
    }
    if (success === true) {
      icon_ = document.getElementById("info-bar");
      icon_.style.backgroundColor = "#21479D";
      return true;
    } else {
      return false;
    }
  };
  enableOtherLi = function(){
    var lis, i$, len$, item;
    lis = document.getElementsByTagName("li");
    for (i$ = 0, len$ = lis.length; i$ < len$; ++i$) {
      item = lis[i$];
      if (item.success !== "after") {
        item.success = "true";
        item.style.backgroundColor = "#21479D";
      }
    }
  };
  liRobot = function(li, success, currentsum){
    var span, xmlHttp;
    li.success = "false";
    disableOtherLi();
    span = li.getElementsByTagName("span");
    span[0].innerHTML = "...";
    span[0].style.display = "block";
    xmlHttp = new XMLHttpRequest();
    xmlHttp.open("get", "/", true);
    if (xmlHttp !== null) {
      xmlHttp.send(null);
      return xmlHttp.onreadystatechange = function(){
        if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
          return callbackRobot(xmlHttp.responseText, li, success, currentsum);
        }
      };
    }
  };
  callbackRobot = function(text, li, success, currentSum){
    var span, next, lis;
    span = li.getElementsByTagName("span");
    if (success === true) {
      span[0].innerHTML = String(text);
      currentSum += Number(text);
    }
    li.style.backgroundColor = "gray";
    enableOtherLi();
    enableBoomClick();
    next = Number(li.nextid);
    lis = document.getElementsByTagName("li");
    switch (next) {
    case 0:
      return aHandler(currentSum, lis[next]);
    case 1:
      return bHandler(currentSum, lis[next]);
    case 2:
      return cHandler(currentSum, lis[next]);
    case 3:
      return dHandler(currentSum, lis[next]);
    case 4:
      return eHandler(currentSum, lis[next]);
    case -1:
      return bubbleHandler(currentSum);
    }
  };
  failToRespond = function(){
    return Math.random() > 0.5;
  };
  aHandler = function(currentsum, li){
    var word, success;
    word = document.getElementById("word");
    success = failToRespond();
    if (success) {
      word.innerHTML = "这是个天大的秘密";
    } else {
      word.innerHTML = "这不是个天大的秘密";
    }
    return liRobot(li, success, currentsum);
  };
  bHandler = function(currentsum, li){
    var word, success;
    word = document.getElementById("word");
    success = failToRespond();
    if (success) {
      word.innerHTML = "我不知道";
    } else {
      word.innerHTML = "我知道";
    }
    return liRobot(li, success, currentsum);
  };
  cHandler = function(currentsum, li){
    var word, success;
    word = document.getElementById("word");
    success = failToRespond();
    if (success) {
      word.innerHTML = "你不知道";
    } else {
      word.innerHTML = "你知道";
    }
    return liRobot(li, success, currentsum);
  };
  dHandler = function(currentsum, li){
    var word, success;
    word = document.getElementById("word");
    success = failToRespond();
    if (success) {
      word.innerHTML = "他不知道";
    } else {
      word.innerHTML = "他知道";
    }
    return liRobot(li, success, currentsum);
  };
  eHandler = function(currentsum, li){
    var word, success;
    word = document.getElementById("word");
    success = failToRespond();
    if (success) {
      word.innerHTML = "才怪";
    } else {
      word.innerHTML = "不怪";
    }
    return liRobot(li, success, currentsum);
  };
  bubbleHandler = function(currentsum){
    var word, show, icon_;
    word = document.getElementById("word");
    word.innerHTML = "楼主异步调用战斗力感人，目测不超过" + currentsum;
    show = document.getElementsByClassName("data");
    show.innerHTML = String(currentsum);
    icon_ = document.getElementById("info-bar");
    return icon_.style.backgroundColor = "gray";
  };
}).call(this);
