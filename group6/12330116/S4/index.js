window.onload = function() {
  var addAll, all, atplus_green, atplus_white, clicked, container, element, elements, i, k, l, len, num, okFunc, sort, startAjax, xmlHttp;
  atplus_white = document.getElementById("atplus_white");
  atplus_green = document.getElementById("atplus_green");
  all = document.getElementById("all");
  container = document.getElementById("container");
  elements = ["A", "B", "C", "D", "E"];
  sort = [0, 1, 2, 3, 4];
  xmlHttp = null;
  num = 0;
  k = 0;
  addAll = 0;
  clicked = [];
  okFunc = function(obj, elements) {
    var div, i, l;
    if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
      addAll += parseInt(xmlHttp.responseText);
      num++;
      div = obj.lastChild;
      div.innerHTML = xmlHttp.responseText;
      obj.style.backgroundColor = "gray";
      obj.canClick = false;
      for (i = l = 0; l <= 4; i = ++l) {
        if (!(!clicked[i])) {
          continue;
        }
        elements[i].canClick = true;
        elements[i].style.backgroundColor = "rgba(48, 63, 159, 1)";
      }
      if (k < 5) {
        elements[sort[k]].click();
      } else if (k === 5) {
        all.click();
      }
      k++;
    }
    return null;
  };
  startAjax = function(obj) {
    if (!!window.ActiveXObject) {
      xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    } else if (!!window.XMLHttpRequest) {
      xmlHttp = new XMLHttpRequest();
    }
    xmlHttp.open("POST", "/", true);
    xmlHttp.onreadystatechange = okFunc.bind(null, obj, elements);
    xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlHttp.send(document);
    return null;
  };
  all.onclick = function() {
    var textNode;
    if (num === 5) {
      textNode = document.createTextNode(addAll);
      document.getElementById('addAll').appendChild(textNode);
      this.onclick = null;
    }
    return null;
  };
  all.onmouseover = function() {
    this.style.cursor = "pointer";
    return null;
  };
  atplus_green.onclick = function() {
    var arr, div, html, i, index, l, len, m, mid, x;
    for (i = l = 0; l <= 10; i = ++l) {
      index = Math.floor(Math.random() * sort.length);
      mid = sort[4];
      sort[4] = sort[index];
      sort[index] = mid;
    }
    arr = ['A', 'B', 'C', 'D', 'E'];
    div = document.createElement('div');
    html = '[ ';
    for (m = 0, len = sort.length; m < len; m++) {
      x = sort[m];
      html = html + arr[x] + ' ';
    }
    html += ']';
    div.innerHTML = html;
    div.style.cssText = "position:absolute;top:-40px;left:25px;width:100px;color:red;background-color:white";
    all.appendChild(div);
    k++;
    elements[sort[0]].click();
    this.onclick = null;
    return null;
  };
  atplus_green.onmouseover = function() {
    this.style.cursor = "pointer";
    return null;
  };
  atplus_white.onmouseover = function() {
    atplus_white.style.opacity = 0;
    atplus_white.style.zIndex = -1000;
    atplus_green.style.cssText = "opacity:1;transform:scale(1.5,1.5);background-color:rgba(48, 63, 159, 1)";
    elements[0].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);transform:translate(-82px,-40px)";
    elements[1].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-100px,0px)";
    elements[2].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-80px,50px)";
    elements[3].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-30px,85px)";
    elements[4].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(30px,80px)";
    all.style.cssText = "opacity:1;background-color:gray;transform:translate(-50px,-80px);width:150px;height:150px;color:white;text-align:center;font-weight:bold";
    return null;
  };
  container.onmouseout = function() {
    return window.location = "";
  };
  for (i = l = 0, len = elements.length; l < len; i = ++l) {
    element = elements[i];
    elements[i] = document.getElementById(element);
    elements[i].canClick = true;
    elements[i].onclick = (function(i, elements) {
      return function() {
        var div, j, m;
        if (!this.canClick) {
          return null;
        }
        for (j = m = 0; m <= 4; j = ++m) {
          if (!(i !== j)) {
            continue;
          }
          elements[j].style.backgroundColor = "gray";
          elements[j].canClick = false;
        }
        div = document.createElement('div');
        div.style.cssText = "position:absolute;right:-5px;top:-5px;width:17px;height:17px;color:white;text-align:center;font-size:12px;z-index:50;background-color:red";
        div.innerHTML = "...";
        clicked[i] = true;
        this.appendChild(div);
        startAjax(this, elements);
        return null;
      };
    })(i, elements);
    elements[i].onmouseover = function() {
      return this.style.cursor = "pointer";
    };
  }
  return null;
};
