var AddClearEvent, AddClickEventToApb, Button, DisableButton, EnableButton, GetAllButton, ShowMessageOnBubble, aHandler, bHandler, bubbleHandler, cHandler, dHandler, disableBubble, eHandler, enableBubble, init, reset, resetBubble, resetButton, resetRobot, robot;

$(document).ready(function() {
  return init();
});

Button = (function() {
  var FAILRATE;

  FAILRATE = 1;

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
      if (_this.reddot.innerHTML === '...' || dom.hasClass('disable')) {
        return;
      }
      _this.reddot.hidden = false;
      _this.reddot.innerHTML = '...';
      otherButtons = GetOtherButtons();
      for (_i = 0, _len = otherButtons.length; _i < _len; _i++) {
        i = otherButtons[_i];
        DisableButton(i);
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
      return $.get('/api/random', function(number, result) {
        if (!isvalid()) {
          return;
        }
        DisableButton(dom);
        dom.children()[0].innerHTML = number;
        EnableUnclickButton();
        CheckAllButtonClick();
        return SuccessOrFail(number);
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
    SuccessOrFail = function(number) {
      if (Math.floor(Math.random() * 10) > FAILRATE) {
        ShowMessage();
        _this.numberFetchhCallBack(null, number);
      } else {
        _this.numberFetchhCallBack(_this.badMessages, number);
      }
    };
    ShowMessage = function() {
      console.log("Button " + _this.name + " say: " + _this.goodMessages);
      return ShowMessageOnBubble(_this.goodMessages);
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
  resetRobot();
  return $('#info-bar span')[1].innerHTML = '';
};

AddClearEvent = function() {
  $('#at-plus-container').mouseleave(function() {
    return reset();
  });
  return $('#at-plus-container').mouseenter(function() {
    return reset();
  });
};

ShowMessageOnBubble = function(msg) {
  return $('#info-bar span')[0].innerHTML = msg;
};

init = function() {
  aHandler.create();
  bHandler.create();
  cHandler.create();
  dHandler.create();
  eHandler.create();
  bubbleHandler.create();
  robot.create();
  AddClearEvent();
  AddClickEventToApb();
  return reset();
};

bubbleHandler = {
  create: function() {
    var _this = this;
    this.bubble = $('#info-bar');
    this.bubbletext = $('#info-bar span')[0];
    return this.bubble.click(function() {
      var i, normalclicksum, _i, _len, _ref;
      if ($('#info-bar').hasClass('disable')) {
        return;
      }
      if (!robot.running) {
        normalclicksum = 0;
        _ref = GetAllButton();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          normalclicksum += parseInt(i.children[0].innerHTML);
        }
        $('#info-bar span')[0].innerHTML = normalclicksum;
      }
      if (robot.running) {
        ShowMessageOnBubble('楼主异步调用战斗力感人，目测不超过' + _this.currentSum);
      }
      return disableBubble();
    });
  },
  click: function(currentSum) {
    this.currentSum = currentSum;
    return this.bubble.click();
  }
};

aHandler = {
  create: function() {
    var _this = this;
    this.button = $('.mask');
    return new Button(this.button, '这是个天大的秘密', '这不是个天大的秘密', function(error, number) {
      if (error) {
        console.log("Handle error from A, message is: " + error);
      }
      _this.currentSum += parseInt(number);
      if (robot.running) {
        return robot.ClickNext(_this.currentSum);
      }
    });
  },
  click: function(currentSum) {
    this.currentSum = currentSum;
    return this.button.click();
  }
};

bHandler = {
  create: function() {
    var _this = this;
    this.button = $('.history');
    return new Button(this.button, '我不知道', '我知道', function(error, number) {
      if (error) {
        console.log("Handle error from B, message is: " + error);
      }
      _this.currentSum += parseInt(number);
      if (robot.running) {
        return robot.ClickNext(_this.currentSum);
      }
    });
  },
  click: function(currentSum) {
    this.currentSum = currentSum;
    return this.button.click();
  }
};

cHandler = {
  create: function() {
    var _this = this;
    this.button = $('.message');
    return new Button(this.button, '你不知道', '你知道', function(error, number) {
      if (error) {
        console.log("Handle error from C, message is: " + error);
      }
      _this.currentSum += parseInt(number);
      if (robot.running) {
        return robot.ClickNext(_this.currentSum);
      }
    });
  },
  click: function(currentSum) {
    this.currentSum = currentSum;
    return this.button.click();
  }
};

dHandler = {
  create: function() {
    var _this = this;
    this.button = $('.setting');
    return new Button(this.button, '他不知道', '他知道', function(error, number) {
      if (error) {
        console.log("Handle error from D, message is: " + error);
      }
      _this.currentSum += parseInt(number);
      if (robot.running) {
        return robot.ClickNext(_this.currentSum);
      }
    });
  },
  click: function(currentSum) {
    this.currentSum = currentSum;
    return this.button.click();
  }
};

eHandler = {
  create: function() {
    var _this = this;
    this.button = $('.sign');
    return new Button(this.button, '才怪', '才不怪', function(error, number) {
      if (error) {
        console.log("Handle error from E, message is: " + error);
      }
      _this.currentSum += parseInt(number);
      if (robot.running) {
        return robot.ClickNext(_this.currentSum);
      }
    });
  },
  click: function(currentSum) {
    this.currentSum = currentSum;
    return this.button.click();
  }
};

resetRobot = function() {
  robot.sequence = ['A', 'B', 'C', 'D', 'E'];
  robot.cursor = 0;
  return robot.running = false;
};

robot = {
  create: function() {
    this.buttons = [aHandler, bHandler, cHandler, dHandler, eHandler];
    this.bubble = bubbleHandler;
    this.sequence = ['A', 'B', 'C', 'D', 'E'];
    this.cursor = 0;
    return this.running = false;
  },
  ClickNext: function(currentSum) {
    this.currentSum = currentSum;
    if (!this.running) {
      return;
    }
    if (this.cursor === this.sequence.length) {
      this.bubble.click(this.currentSum);
      this.cursor = 0;
      this.running = false;
      return;
    }
    if ($(this.buttons[this.sequence[this.cursor].charCodeAt() - 'A'.charCodeAt()]).hasClass("disable")) {
      this.cursor++;
      return this.ClickNext(this.currentSum);
    } else {
      return this.GetNextButton().click(this.currentSum);
    }
  },
  GetNextButton: function() {
    return this.buttons[this.sequence[this.cursor++].charCodeAt() - 'A'.charCodeAt()];
  },
  ShuffleOrder: function() {
    return this.sequence.sort(function() {
      return 0.5 - Math.random();
    });
  },
  ShowOrder: function() {
    return ShowMessageOnBubble(this.sequence.join(', '));
  }
};

AddClickEventToApb = function() {
  return $('#button .apb').click(function() {
    if (robot.running === true) {
      return;
    }
    robot.ShuffleOrder();
    robot.ShowOrder();
    robot.running = true;
    return robot.ClickNext(0);
  });
};
