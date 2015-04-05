(function() {
  var Button, addEventHandlerToBubble, addEventHandlerToButtons, addResetWhenLeavingApb, countResult, resetBubble, robot, robotClickingHandler;

  Button = (function() {
    Button.prototype.buttons = [];

    Button.prototype.disableButtonsExcept = function(thisButton) {
      var button, i, j, len, ref, results;
      ref = Button.prototype.buttons;
      results = [];
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        button = ref[i];
        if (button !== thisButton && button.disabled !== true) {
          button.disabled = true;
          results.push(button.dom.css('background-color', '#686868'));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Button.prototype.enableButtons = function() {
      var button, j, len, ref, results;
      ref = Button.prototype.buttons;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        if (button.disabled === true && button.dom.find('.unread').css('opacity') === '0') {
          button.disabled = false;
          results.push(button.dom.css('background', 'rgb(48, 63, 159)'));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Button.prototype.ifAllButtonsDoneThenEnableBubble = function() {
      var button, j, len, ref;
      ref = Button.prototype.buttons;
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        if (button.disabled !== true) {
          return;
        }
      }
      $('#info-bar').attr('enabled', 'true');
      return $('#info-bar').css('background-color', 'rgb(48, 63, 159)');
    };

    Button.prototype.resetAllButtons = function() {
      var button, dom, j, len, ref, results;
      ref = Button.prototype.buttons;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        button.disabled = false;
        dom = button.dom;
        dom.css('background-color', 'rgb(48, 63, 159)');
        results.push(dom.find('.unread').css('opacity', '0').text(''));
      }
      return results;
    };

    function Button(dom1, goodMessages1, badMessages1) {
      this.dom = dom1;
      this.goodMessages = goodMessages1;
      this.badMessages = badMessages1;
      this.addClickHandler();
      this.disabled = false;
      Button.prototype.buttons.push(this);
    }

    Button.prototype.addClickHandler = function() {
      return this.dom.click((function(_this) {
        return function() {
          if (_this.disabled) {

          } else {
            _this.dom.find('.unread').css('opacity', '1').text('...');
            Button.prototype.disableButtonsExcept(_this);
            return _this.getRandomNumberAndShow();
          }
        };
      })(this));
    };

    Button.prototype.getRandomNumberAndShow = function() {
      return $.get('/', (function(_this) {
        return function(data) {
          if (_this.disabled === false) {
            if (_this.success()) {
              _this.dom.find('.unread').text(data);
              _this.disabled = true;
              _this.dom.css('background-color', '#686868');
              Button.prototype.enableButtons();
              Button.prototype.ifAllButtonsDoneThenEnableBubble();
              if (robot.state === 'working') {
                return robot.clickNext();
              }
            }
          }
        };
      })(this));
    };

    Button.prototype.success = function() {
      if (Math.random() > 0.3) {
        this.showMessage(true);
        return true;
      } else {
        this.showMessage(false);
        this.getRandomNumberAndShow();
        return false;
      }
    };

    Button.prototype.showMessage = function(good) {
      if (good) {
        return console.log(("Button " + (this.dom.find('.button-id').text()) + " say: ") + this.goodMessages);
      } else {
        return console.log("Handle error from " + (this.dom.find('.button-id').text()) + " , message is: " + this.badMessages);
      }
    };

    return Button;

  })();

  $(function() {
    robot.init();
    addEventHandlerToButtons();
    addEventHandlerToBubble();
    addResetWhenLeavingApb();
    return robotClickingHandler();
  });

  addEventHandlerToButtons = function(next) {
    var badMessages, button, dom, goodMessages, i, j, len, ref, results;
    goodMessages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪'];
    badMessages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪'];
    ref = $('#control-ring li.button');
    results = [];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      dom = ref[i];
      results.push(button = new Button($(dom), goodMessages[i], badMessages[i]));
    }
    return results;
  };

  addEventHandlerToBubble = function() {
    var bubble;
    bubble = $('#info-bar');
    bubble.attr('enabled', 'false');
    return bubble.click(function() {
      if (bubble.attr('enabled') === 'true') {
        bubble.find('span').text(countResult());
        bubble.attr('enabled', 'false');
        return bubble.css('background-color', '#686868');
      }
    });
  };

  countResult = function() {
    var dom, j, len, number, ref, result;
    result = 0;
    ref = $('#control-ring li.button');
    for (j = 0, len = ref.length; j < len; j++) {
      dom = ref[j];
      number = $($(dom).find('span')[1]).text();
      result += parseInt(number);
    }
    return result;
  };

  addResetWhenLeavingApb = function() {
    return $('div#button').on('mouseleave', function() {
      Button.prototype.resetAllButtons();
      resetBubble();
      return robot.reset();
    });
  };

  resetBubble = function() {
    var bubble;
    bubble = $('#info-bar');
    bubble.find('span').text('');
    bubble.attr('enabled', 'false');
    return bubble.css('background-color', '#686868');
  };

  robotClickingHandler = function() {
    return $('.apb').click(function() {
      if (robot.state === 'resting') {
        robot.state = 'working';
        return robot.clickNext();
      }
    });
  };

  robot = {
    init: function() {
      this.buttons = $('#control-ring .button');
      this.order = ['A', 'B', 'C', 'D', 'E'];
      this.currentIndex = 0;
      return this.state = 'resting';
    },
    clickNext: function() {
      if (this.currentIndex === this.order.length) {
        return $('#info-bar').click();
      } else {
        return this.getNextButton().click();
      }
    },
    getNextButton: function() {
      return this.buttons[this.order[this.currentIndex++].charCodeAt() - 'A'.charCodeAt()];
    },
    reset: function() {
      this.state = 'resting';
      return this.currentIndex = 0;
    }
  };

}).call(this);
