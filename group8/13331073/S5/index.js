// Generated by LiveScript 1.3.1
(function(){
  var addClickingToFetchTheNumberToButton, addClickingToCalculateTheSumToBubble, allButtonDone, getRandomNumber, disableAllOtherButtons, showNumberArea, fetchNumber, enableAllOtherButton, resetTheCalculator, resetAllTheButtons, resetTheBubble, robotClick, clickNextButton, bubbleHandler, isFailed, aHandler, bHandler, cHandler, dHandler, eHandler, atPlus, button, number, letter, Info_bar, changeBubbleColorWhileBubbleCanClick, changeButtonsColorToGrayAfterClick, changeButtonsColorToBlueAfterClick, showOrder;
  window.onload = function(){
    addClickingToFetchTheNumberToButton();
    addClickingToCalculateTheSumToBubble();
    robotClick();
    document.getElementById('at_plus').onmouseout = resetTheCalculator;
  };
  addClickingToFetchTheNumberToButton = function(){
    var i$, i;
    resetAllTheButtons();
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      button(i).onclick = fn$;
    }
    function fn$(){
      getRandomNumber(this.number);
    }
  };
  addClickingToCalculateTheSumToBubble = function(){
    document.getElementById('info-bar').onclick = function(){
      var randomNumber, add, i$, i;
      if (!allButtonDone()) {
        return;
      }
      randomNumber = document.getElementsByClassName('number');
      add = 0;
      for (i$ = 0; i$ <= 4; ++i$) {
        i = i$;
        add += parseInt(randomNumber[i].innerHTML);
      }
      Info_bar().innerHTML = add;
      Info_bar().style.backgroundColor = 'gray';
    };
  };
  allButtonDone = function(){
    var i$, i;
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      if (number(i).innerHTML === '...') {
        return false;
      }
    }
    changeBubbleColorWhileBubbleCanClick();
    return true;
  };
  getRandomNumber = function(this_number){
    if (button(this_number).classList.contains('disable') || button(this_number).classList.contains('waiting')) {
      return;
    }
    button(this_number).classList.remove('enable');
    button(this_number).classList.add('disable');
    disableAllOtherButtons(this_number);
    showNumberArea(this_number);
    fetchNumber(this_number, button(this_number).callback);
  };
  disableAllOtherButtons = function(this_number){
    var i$, i;
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      if (i !== this_number) {
        button(i).classList.add('waiting');
        changeButtonsColorToGrayAfterClick(i);
      }
    }
  };
  showNumberArea = function(this_number){
    number(this_number).style.opacity = '1';
  };
  fetchNumber = function(this_number, callback){
    var xmlhttp;
    xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function(){
      if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
        callback(xmlhttp.responseText);
      }
    };
    xmlhttp.open("GET", "/" + this_number, true);
    xmlhttp.send();
  };
  enableAllOtherButton = function(this_number){
    var i$, i;
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      button(i).classList.remove('waiting');
      if (i !== this_number && button(i).classList.contains('enable')) {
        changeButtonsColorToBlueAfterClick(i);
      } else {
        changeButtonsColorToGrayAfterClick(i);
      }
    }
  };
  resetTheCalculator = function(){
    resetAllTheButtons();
    resetTheBubble();
  };
  resetAllTheButtons = function(){
    var i$, i;
    for (i$ = 0; i$ <= 4; ++i$) {
      i = i$;
      button(i).classList.add('enable');
      button(i).classList.remove('disable');
      button(i).classList.remove('waiting');
      changeButtonsColorToBlueAfterClick(i);
      number(i).innerHTML = "...";
      number(i).style.opacity = '0';
    }
  };
  resetTheBubble = function(){
    $("p")[0].innerHTML = "";
    $('#message')[0].innerHTML = "";
    Info_bar().innerHTML = "";
  };
  robotClick = function(){
    atPlus().onclick = function(){
      var order;
      order = [0, 1, 2, 3, 4];
      order.sort(function(){
        if (Math.random() > 0.5) {
          return -1;
        } else {
          return 1;
        }
      });
      showOrder(order);
      clickNextButton(0, order, 0);
    };
  };
  clickNextButton = function(sum, order, position){
    var buttonNumber, additionInNumber, handleResult;
    if (position === 5) {
      bubbleHandler(sum);
      return;
    }
    buttonNumber = order[position];
    if (button(buttonNumber).classList.contains('disable')) {
      additionInNumber = number(buttonNumber).innerHTML;
      clickNextButton(sum + parseInt(additionInNumber, order, position + 1));
    }
    Info_bar().innerHTML = sum;
    handleResult = function(errorInfomation, sum, order, position){
      if (errorInfomation !== null) {
        console.log(errorInfomation);
        clickNextButton(sum, order, position);
      } else {
        clickNextButton(sum, order, position);
      }
    };
    switch (buttonNumber) {
    case 0:
      aHandler(sum, order, position, handleResult);
      break;
    case 1:
      bHandler(sum, order, position, handleResult);
      break;
    case 2:
      cHandler(sum, order, position, handleResult);
      break;
    case 3:
      dHandler(sum, order, position, handleResult);
      break;
    case 4:
      eHandler(sum, order, position, handleResult);
    }
  };
  bubbleHandler = function(sum){
    $('#message')[0].innerHTML = '楼主异步调用战斗力感人，目测不超过: ' + sum;
    Info_bar().innerHTML = sum;
  };
  isFailed = function(){
    return Math.random() < 0.5;
  };
  aHandler = function(sum, order, position, handleResult){
    var isFail;
    if (button(0).classList.contains('disable') || button(0).classList.contains('waiting')) {
      return;
    }
    button(0).classList.remove('enable');
    button(0).classList.add('disable');
    disableAllOtherButtons(0);
    showNumberArea(0);
    isFail = isFailed();
    if (!isFail) {
      $('#message')[0].innerHTML = "这是个天大的秘密";
    } else {
      $('#message')[0].innerHTML = "这不是个天大的秘密";
    }
    fetchNumber(0, function(text){
      enableAllOtherButton(0);
      if (!isFail) {
        number(0).innerHTML = text;
        sum += parseInt(text);
        handleResult(null, sum, order, position + 1);
      } else {
        handleResult('A failed!', sum, order, position + 1);
      }
    });
  };
  bHandler = function(sum, order, position, handleResult){
    var isFail;
    if (button(1).classList.contains('disable') || button(1).classList.contains('waiting')) {
      return;
    }
    button(1).classList.remove('enable');
    button(1).classList.add('disable');
    disableAllOtherButtons(1);
    showNumberArea(1);
    isFail = isFailed();
    if (!isFail) {
      $('#message')[0].innerHTML = "我不知道";
    } else {
      $('#message')[0].innerHTML = "我知道";
    }
    fetchNumber(1, function(text){
      enableAllOtherButton(1);
      if (!isFail) {
        number(1).innerHTML = text;
        sum += parseInt(text);
        handleResult(null, sum, order, position + 1);
      } else {
        handleResult('B failed!', sum, order, position + 1);
      }
    });
  };
  cHandler = function(sum, order, position, handleResult){
    var isFail;
    if (button(2).classList.contains('disable') || button(2).classList.contains('waiting')) {
      return;
    }
    button(2).classList.remove('enable');
    button(2).classList.add('disable');
    disableAllOtherButtons(2);
    showNumberArea(2);
    isFail = isFailed();
    if (!isFail) {
      $('#message')[0].innerHTML = "你不知道";
    } else {
      $('#message')[0].innerHTML = "你知道";
    }
    fetchNumber(2, function(text){
      enableAllOtherButton(2);
      if (!isFail) {
        number(2).innerHTML = text;
        sum += parseInt(text);
        handleResult(null, sum, order, position + 1);
      } else {
        handleResult('C failed!', sum, order, position + 1);
      }
    });
  };
  dHandler = function(sum, order, position, handleResult){
    var isFail;
    if (button(3).classList.contains('disable') || button(3).classList.contains('waiting')) {
      return;
    }
    button(3).classList.remove('enable');
    button(3).classList.add('disable');
    disableAllOtherButtons(3);
    showNumberArea(3);
    isFail = isFailed();
    if (!isFail) {
      $('#message')[0].innerHTML = "他不知道";
    } else {
      $('#message')[0].innerHTML = "他知道";
    }
    fetchNumber(3, function(text){
      enableAllOtherButton(3);
      if (!isFail) {
        number(3).innerHTML = text;
        sum += parseInt(text);
        handleResult(null, sum, order, position + 1);
      } else {
        handleResult('D failed!', sum, order, position + 1);
      }
    });
  };
  eHandler = function(sum, order, position, handleResult){
    var isFail;
    if (button(4).classList.contains('disable') || button(4).classList.contains('waiting')) {
      return;
    }
    button(4).classList.remove('enable');
    button(4).classList.add('disable');
    disableAllOtherButtons(4);
    showNumberArea(4);
    isFail = isFailed();
    if (!isFail) {
      $('#message')[0].innerHTML = "才怪";
    } else {
      $('#message')[0].innerHTML = "才不怪";
    }
    fetchNumber(4, function(text){
      enableAllOtherButton(4);
      if (!isFail) {
        number(4).innerHTML = text;
        sum += parseInt(text);
        handleResult(null, sum, order, position + 1);
      } else {
        handleResult('E failed!', sum, order, position + 1);
      }
    });
  };
  atPlus = function(){
    var atplus;
    return atplus = $('#at_plus')[0];
  };
  button = function(position){
    var buttons;
    buttons = $(".char");
    buttons[position].number = position;
    return buttons[position];
  };
  number = function(position){
    var numbers;
    numbers = $(".number");
    return numbers[position];
  };
  letter = function(position){
    var letters;
    letters = $(".letter");
    return letters[position];
  };
  Info_bar = function(){
    var bars;
    return bars = $('#info-bar')[0];
  };
  changeBubbleColorWhileBubbleCanClick = function(){
    $('#info-bar')[0].style.backgroundColor = 'rgba(48, 63, 159, 1)';
  };
  changeButtonsColorToGrayAfterClick = function(position){
    letter(position).style.backgroundColor = 'gray';
  };
  changeButtonsColorToBlueAfterClick = function(position){
    letter(position).style.backgroundColor = 'rgba(48, 63, 159, 1)';
  };
  showOrder = function(order){
    var E_letter, i$, len$, i;
    E_letter = ["A", "B", "C", "D", "E"];
    $("p")[0].innerHTML = "";
    for (i$ = 0, len$ = order.length; i$ < len$; ++i$) {
      i = order[i$];
      $("p")[0].innerHTML += E_letter[i];
    }
  };
}).call(this);