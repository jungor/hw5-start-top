// Generated by LiveScript 1.3.1
(function(){
  var autoRobot, roundFinger, enableAtPlus, clearAll, boomAddClick, liAddClick, liGetNumber, disableOtherLi, callback, nextClick, enableBoomClick, enableOtherLi;
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
  roundFinger = function(){
    var lis;
    lis = document.getElementsByTagName("li");
    lis[0].clickbyrobot = "true";
    lis[0].success = "after";
    liGetNumber(lis[0]);
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
    i = Number(li.id) + 1;
    if (i < 5) {
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
}).call(this);
