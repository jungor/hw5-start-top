// Generated by LiveScript 1.3.1
(function(){
  var enableBtn, disableBtn, checkReady, disableOtherBtn, enableOtherBtn;
  window.onload = function(){
    return reset();
  };
  enableBtn = function(btn){
    btn.setAttribute('onclick', 'getRandomNum(this)');
    return btn.style.backgroundColor = 'blue';
  };
  disableBtn = function(btn){
    btn.setAttribute('onclick', '');
    return btn.style.backgroundColor = '#666';
  };
  checkReady = function(){
    if (NUMBERS.length !== 5) {
      return;
    }
    $('#info-bar')[0].setAttribute('onclick', 'showSum()');
    if (AUTO) {
      return showSum();
    }
  };
  disableOtherBtn = function(){
    var i$, ref$, len$, btn, results$ = [];
    for (i$ = 0, len$ = (ref$ = btns).length; i$ < len$; ++i$) {
      btn = ref$[i$];
      if (!in$(btn, CLICKED)) {
        results$.push(disableBtn(btn));
      }
    }
    return results$;
  };
  enableOtherBtn = function(){
    var i$, ref$, len$, btn, results$ = [];
    for (i$ = 0, len$ = (ref$ = btns).length; i$ < len$; ++i$) {
      btn = ref$[i$];
      if (!in$(btn, CLICKED)) {
        results$.push(enableBtn(btn));
      } else {
        results$.push(disableBtn(btn));
      }
    }
    return results$;
  };
  this.showSum = function(){
    var result, i$, ref$, len$, item, sumSpan;
    result = 0;
    for (i$ = 0, len$ = (ref$ = NUMBERS).length; i$ < len$; ++i$) {
      item = ref$[i$];
      result += item;
    }
    sumSpan = $('#sum')[0];
    sumSpan.innerText = result;
    sumSpan.style.opacity = 1;
    return $('#base')[0].setAttribute('onclick', '');
  };
  this.getRandomNum = function(btn){
    var num, req;
    this.CLICKED = this.CLICKED.concat([btn]);
    num = btn.getElementsByClassName('num')[0];
    num.innerText = '...';
    num.style.opacity = 1;
    btn.setAttribute('onclick', '');
    disableOtherBtn();
    req = new XMLHttpRequest();
    req.open('GET', '../getRandomNum' + Math.random(), true);
    req.send();
    return req.onreadystatechange = function(){
      if (req.readyState === 4 && req.status === 200) {
        window.NUMBERS = window.NUMBERS.concat([Number(req.response)]);
        num.innerText = req.response;
        enableOtherBtn();
        return checkReady();
      }
    };
  };
  this.reset = function(){
    var res$, i$, ref$, len$, ID, btn, results$ = [];
    this.CLICKED = [];
    this.NUMBERS = [];
    this.AUTO = false;
    this.button = $('#button')[0];
    res$ = [];
    for (i$ = 0, len$ = (ref$ = ['A', 'B', 'C', 'D', 'E']).length; i$ < len$; ++i$) {
      ID = ref$[i$];
      res$.push($('.'.concat(ID))[0]);
    }
    this.btns = res$;
    enableOtherBtn();
    $('#sum')[0].style.opacity = 0;
    button.setAttribute('onmouseleave', 'setTimeout("reset()", 1000)');
    $('#base')[0].setAttribute('onclick', 'clickAll()');
    for (i$ = 0, len$ = (ref$ = btns).length; i$ < len$; ++i$) {
      btn = ref$[i$];
      $('#info-bar')[0].setAttribute('onclick', '');
      results$.push(btn.getElementsByClassName('num')[0].style.opacity = 0);
    }
    return results$;
  };
  this.clickAll = function(){
    var i$, ref$, len$, btn;
    this.AUTO = true;
    disableOtherBtn();
    for (i$ = 0, len$ = (ref$ = btns).length; i$ < len$; ++i$) {
      btn = ref$[i$];
      getRandomNum(btn);
    }
    return $('#base')[0].setAttribute('onclick', '');
  };
  function in$(x, xs){
    var i = -1, l = xs.length >>> 0;
    while (++i < l) if (x === xs[i]) return true;
    return false;
  }
}).call(this);
