(function() {
  var Button, addEventHandlerToBubble, addEventHandlerToButtons, addResetWhenLeavingApb, addRobotClickingHandler, countResult, resetBubble, robot;

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
      $('#info-bar').css('background-color', 'rgb(48, 63, 159)');
      if (robot.running) {
        return $('#info-bar').click();
      }
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

    Button.prototype.allButtonsSendARequest = function() {
      var button, j, len, ref, results;
      ref = Button.prototype.buttons;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        button.dom.find('.unread').css('opacity', '1').text('...');
        button.disabled = false;
        results.push(button.getRandomNumberAndShow());
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
      return $.ajax({
        url: '/?random=' + Math.random(),
        success: (function(_this) {
          return function(data) {
            if (_this.disabled === false) {
              _this.dom.find('.unread').text(data);
              _this.disabled = true;
              _this.dom.css('background-color', '#686868');
              Button.prototype.enableButtons();
              return Button.prototype.ifAllButtonsDoneThenEnableBubble();
            }
          };
        })(this)
      });
    };

    return Button;

  })();

  $(function() {
    addEventHandlerToButtons();
    addEventHandlerToBubble();
    addResetWhenLeavingApb();
    return addRobotClickingHandler();
  });

  addEventHandlerToButtons = function() {
    var badMessages, button, dom, goodMessages, i, j, len, ref, results;
    goodMessages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪'];
    badMessages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪'];
    ref = $('#control-ring li.button');
    results = [];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      dom = ref[i];
      results.push(button = new Button($(dom, goodMessages[i], badMessages[i])));
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
      return robot.running = false;
    });
  };

  resetBubble = function() {
    var bubble;
    bubble = $('#info-bar');
    bubble.find('span').text('');
    bubble.attr('enabled', 'false');
    return bubble.css('background-color', '#686868');
  };

  addRobotClickingHandler = function() {
    return $('.apb').click(function() {
      if (robot.running !== true) {
        robot.running = true;
        return Button.prototype.allButtonsSendARequest();
      }
    });
  };

  robot = {
    running: false
  };

}).call(this);
