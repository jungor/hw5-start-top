var AddClearEvent, AddClickEventToApb, AddClickEventToBubble, AddClickEventToButton, Button, DisableButton, EnableButton, GetAllButton, disableBubble, enableBubble, reset, resetBubble, resetButton, resetRobot, robot;

$(document).ready(function() {
  robot.create();
  reset();
  AddClickEventToButton(robot);
  AddClickEventToButton();
  AddClickEventToBubble();
  AddClearEvent();
  return AddClickEventToApb();
});

Button = (function() {
  var FAILRATE;

  FAILRATE = 0;

  function Button(dom, goodMessages, badMessages, numberFetchhCallBack) {
    var CheckAllButtonClick, EnableUnclickButton, GetNumberAndShow, GetOtherButtons, ShowMessage, SuccessOrFail, isvalid,
      _this = this;
    this.goodMessages = goodMessages;
    this.badMessages = badMessages;
    this.numberFetchhCallBack = numberFetchhCallBack;
    this.name = dom[0].title;
    this.reddot = dom.children()[0];
    dom.click(function() {
      var i, otherButtons, _i, _len;
      if (robot.running && _this.reddot.innerHTML === "") {
        EnableButton(dom);
      }
      if (_this.reddot.innerHTML === '...' || dom.hasClass('disable')) {
        return;
      }
      _this.reddot.hidden = false;
      _this.reddot.innerHTML = '...';
      otherButtons = GetOtherButtons();
      if (!robot.running) {
        for (_i = 0, _len = otherButtons.length; _i < _len; _i++) {
          i = otherButtons[_i];
          DisableButton(i);
        }
      }
      GetNumberAndShow();
      return console.log("Click on ", _this.name);
    });
    GetOtherButtons = function() {
      var buttons, i, otherButtons, _i, _len;
      otherButtons = [];
      buttons = GetAllButton();
      for (_i = 0, _len = buttons.length; _i < _len; _i++) {
        i = buttons[_i];
        [i !== dom[0] ? otherButtons.push(i) : void 0];
      }
      return otherButtons;
    };
    GetNumberAndShow = function() {
      return $.get('/api/random/' + _this.name, function(number, result) {
        if (!isvalid()) {
          return;
        }
        DisableButton(dom);
        dom.children()[0].innerHTML = number;
        if (!robot.running) {
          EnableUnclickButton();
        }
        CheckAllButtonClick();
        return SuccessOrFail();
      });
    };
    isvalid = function() {
      if (dom.children()[0].innerHTML !== '...' || dom.hasClass('disable')) {
        return false;
      }
      return true;
    };
    EnableUnclickButton = function() {
      var buttons, i, _i, _len, _results;
      buttons = GetAllButton();
      _results = [];
      for (_i = 0, _len = buttons.length; _i < _len; _i++) {
        i = buttons[_i];
        _results.push([i.children[0].innerHTML === "" ? EnableButton(i) : void 0]);
      }
      return _results;
    };
    CheckAllButtonClick = function() {
      var buttons, check, i, _i, _len;
      buttons = GetAllButton();
      check = true;
      for (_i = 0, _len = buttons.length; _i < _len; _i++) {
        i = buttons[_i];
        [$(i).hasClass('enable') ? check = false : void 0];
      }
      if (check) {
        return enableBubble();
      }
    };
    SuccessOrFail = function() {
      if (Math.floor(Math.random() * 10) > FAILRATE) {
        ShowMessage();
        _this.numberFetchhCallBack(null, _this.name);
      } else {
        _this.numberFetchhCallBack(_this.badMessages, _this.name);
      }
    };
    ShowMessage = function() {
      return console.log("Button " + _this.name + " say: " + _this.goodMessages);
    };
  }

  return Button;

})();

DisableButton = function(button) {
  $(button).removeClass("enable");
  return $(button).addClass("disable");
};

EnableButton = function(button) {
  $(button).removeClass("disable");
  return $(button).addClass("enable");
};

GetAllButton = function() {
  return $('.button');
};

enableBubble = function() {
  $('#info-bar').removeClass('disable');
  return $('#info-bar').addClass('enable');
};

disableBubble = function() {
  $('#info-bar').removeClass('enable');
  return $('#info-bar').addClass('disable');
};

resetBubble = function() {
  disableBubble();
  return $('#info-bar span')[0].innerHTML = "";
};

resetButton = function() {
  var buttons, i, _i, _j, _len, _len1, _ref, _results;
  _ref = $('.button span');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    [i.hidden = true, i.innerHTML = ""];
  }
  buttons = GetAllButton();
  _results = [];
  for (_j = 0, _len1 = buttons.length; _j < _len1; _j++) {
    i = buttons[_j];
    _results.push(EnableButton(i));
  }
  return _results;
};

reset = function() {
  resetButton();
  resetBubble();
  return resetRobot();
};

AddClearEvent = function() {
  $('#at-plus-container').mouseleave(function() {
    return reset();
  });
  return $('#at-plus-container').mouseenter(function() {
    return reset();
  });
};

AddClickEventToBubble = function() {
  var Calculate, bubble, bubbletext;
  bubble = $('#info-bar');
  bubbletext = $('#info-bar span')[0];
  Calculate = function() {
    var buttons, i, sum, _i, _len;
    buttons = GetAllButton();
    sum = 0;
    for (_i = 0, _len = buttons.length; _i < _len; _i++) {
      i = buttons[_i];
      sum += parseInt(i.children[0].innerHTML);
    }
    return sum;
  };
  return bubble.click(function() {
    if (bubble.hasClass('disable')) {
      return;
    }
    bubbletext.innerHTML = Calculate();
    return disableBubble();
  });
};

AddClickEventToButton = function(robot) {
  var badMessages, button, buttons, goodMessages, i, tem, _i, _len, _results;
  buttons = GetAllButton();
  goodMessages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪'];
  badMessages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪'];
  _results = [];
  for (i = _i = 0, _len = buttons.length; _i < _len; i = ++_i) {
    button = buttons[i];
    _results.push(tem = new Button($(button), goodMessages[i], badMessages[i], function(error, name) {
      if (error) {
        console.log("Handle error from " + name + ", message is: " + error);
      }
      if (robot) {
        return robot.ClickBubble();
      }
    }));
  }
  return _results;
};

resetRobot = function() {
  robot.sequence = ['A', 'B', 'C', 'D', 'E'];
  robot.cursor = 0;
  return robot.running = false;
};

robot = {
  create: function() {
    this.buttons = $('#control-ring .button');
    this.bubble = $('#info-bar');
    this.sequence = ['A', 'B', 'C', 'D', 'E'];
    this.cursor = 0;
    return this.running = false;
  },
  ClickBubble: function() {
    if (!this.running) {
      return;
    }
    this.bubble.click();
    if ($('#info-bar span')[0].innerHTML !== "") {
      this.cursor = 0;
      return this.running = false;
    }
  },
  ClickAll: function() {
    var i, _i, _len, _ref, _results;
    _ref = this.buttons;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(i.click());
    }
    return _results;
  }
};

AddClickEventToApb = function() {
  return $('#button .apb').click(function() {
    robot.running = true;
    return robot.ClickAll();
  });
};
