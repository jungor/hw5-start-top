(function() {
  var Button, cumulate, init_for_apb, init_for_buttons, init_for_info, mouse_event, reset, robot;

  Button = (function() {
    Button.buttons = [];

    Button.good_messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪'];

    Button.bad_messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪'];

    function Button(dom1) {
      var that;
      this.dom = dom1;
      this.reset;
      that = this;
      this.dom.click(function() {
        return that.click_event();
      });
      this.constructor.buttons.push(this);
    }

    Button.prototype.click_event = function(click_finish_next) {
      if (this.dom.hasClass('enable') && !this.is_get_num()) {
        this.constructor.disable_other_buttons(this);
        this.wait();
        return this.get_and_show(click_finish_next);
      }
    };

    Button.prototype.get_and_show = function(event_finish_next, currentSum, fail) {
      var that;
      that = this;
      return $.get('/', function(number, result) {
        if (that.is_get_num()) {
          that.disable();
          that.constructor.enable_other_buttons(that);
          if (fail === void 0) {
            that.show(number);
            if (that.constructor.is_get_all()) {
              that.constructor.info_event();
            }
            cumulate.add(number);
            return typeof event_finish_next === "function" ? event_finish_next(currentSum + parseInt(number)) : void 0;
          } else {
            return typeof event_finish_next === "function" ? event_finish_next(currentSum) : void 0;
          }
        }
      });
    };

    Button.prototype.disable = function() {
      return this.dom.removeClass('enable').addClass('disable');
    };

    Button.prototype.enable = function() {
      return this.dom.removeClass('disable').addClass('enable');
    };

    Button.prototype.is_get_num = function() {
      return this.dom.find('.unread').css("display") !== 'none';
    };

    Button.prototype.wait = function() {
      return this.dom.find('.unread').css("display", "block");
    };

    Button.prototype.hide = function() {
      this.dom.find('.unread').css("display", "none");
      return this.dom.find('.unread').text('...');
    };

    Button.prototype.show = function(number) {
      return this.dom.find('.unread').text(number);
    };

    Button.prototype.reset = function() {
      this.enable();
      return this.hide();
    };

    Button.S5_button_event = function(number, event_finish_next, currentSum) {
      switch (number) {
        case 0:
          return Button.a_handler(event_finish_next, currentSum);
        case 1:
          return Button.b_handler(event_finish_next, currentSum);
        case 2:
          return Button.c_handler(event_finish_next, currentSum);
        case 3:
          return Button.d_handler(event_finish_next, currentSum);
        case 4:
          return Button.e_handler(event_finish_next, currentSum);
      }
    };

    Button.a_handler = function(event_finish_next, currentSum) {
      var button, error;
      try {
        button = Button.buttons[0];
        button.wait();
        Button.disable_other_buttons(button);
        if (Button.is_fail()) {
          throw {
            message: Button.bad_messages[0],
            currentSum: currentSum
          };
        }
        button.get_and_show(event_finish_next, currentSum);
        return Button.show_message(Button.good_messages[0]);
      } catch (_error) {
        error = _error;
        button.get_and_show(event_finish_next, currentSum, true);
        console.log("Error occurs in a_handler while the current sum is :" + error['currentSum']);
        console.log(error['message']);
        return Button.show_message(error['message']);
      }
    };

    Button.b_handler = function(event_finish_next, currentSum) {
      var button, error;
      try {
        button = Button.buttons[1];
        button.wait();
        Button.disable_other_buttons(button);
        if (Button.is_fail()) {
          throw {
            message: Button.bad_messages[1],
            currentSum: currentSum
          };
        }
        button.get_and_show(event_finish_next, currentSum);
        return Button.show_message(Button.good_messages[1]);
      } catch (_error) {
        error = _error;
        button.get_and_show(event_finish_next, currentSum, true);
        console.log("Error occurs in b_handler while the current sum is :" + error['currentSum']);
        console.log(error['message']);
        return Button.show_message(error['message']);
      }
    };

    Button.c_handler = function(event_finish_next, currentSum) {
      var button, error;
      try {
        button = Button.buttons[2];
        button.wait();
        Button.disable_other_buttons(button);
        if (Button.is_fail()) {
          throw {
            message: Button.bad_messages[2],
            currentSum: currentSum
          };
        }
        button.get_and_show(event_finish_next, currentSum);
        return Button.show_message(Button.good_messages[2]);
      } catch (_error) {
        error = _error;
        button.get_and_show(event_finish_next, currentSum, true);
        console.log("Error occurs in c_handler while the current sum is :" + error['currentSum']);
        console.log(error['message']);
        return Button.show_message(error['message']);
      }
    };

    Button.d_handler = function(event_finish_next, currentSum) {
      var button, error;
      try {
        button = Button.buttons[3];
        button.wait();
        Button.disable_other_buttons(button);
        if (Button.is_fail()) {
          throw {
            message: Button.bad_messages[3],
            currentSum: currentSum
          };
        }
        button.get_and_show(event_finish_next, currentSum);
        return Button.show_message(Button.good_messages[3]);
      } catch (_error) {
        error = _error;
        button.get_and_show(event_finish_next, currentSum, true);
        console.log("Error occurs in d_handler while the current sum is :" + error['currentSum']);
        console.log(error['message']);
        return Button.show_message(error['message']);
      }
    };

    Button.e_handler = function(event_finish_next, currentSum) {
      var button, error;
      try {
        button = Button.buttons[4];
        button.wait();
        Button.disable_other_buttons(button);
        if (Button.is_fail()) {
          throw {
            message: Button.bad_messages[4],
            currentSum: currentSum
          };
        }
        button.get_and_show(event_finish_next, currentSum);
        return Button.show_message(Button.good_messages[4]);
      } catch (_error) {
        error = _error;
        button.get_and_show(event_finish_next, currentSum, true);
        console.log("Error occurs in e_handler while the current sum is :" + error['currentSum']);
        console.log(error['message']);
        return Button.show_message(error['message']);
      }
    };

    Button.bubble_Handler = function() {
      $('.apb').removeClass('disable').addClass('enable');
      Button.info_event();
      return setTimeout((function() {
        $('.mysum').text(cumulate.sum);
        Button.show_message("楼主异步调用战斗力感人，目测不超过" + cumulate.sum);
        return $('#info-bar').removeClass('enable').addClass('disable');
      }), 500);
    };

    Button.info_event = function() {
      return $('#info-bar').removeClass('disable').addClass('enable');
    };

    Button.is_fail = function() {
      return Math.random() > 0.4;
    };

    Button.show_message = function(message) {
      return $('#message').text(message);
    };

    Button.get_sum = function() {
      var button, i, len, ref, sum;
      sum = 0;
      ref = this.buttons;
      for (i = 0, len = ref.length; i < len; i++) {
        button = ref[i];
        sum += parseInt(button.dom.find('.unread').text());
      }
      return sum;
    };

    Button.reset_all = function() {
      var button, i, len, ref, results;
      ref = this.buttons;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        button = ref[i];
        results.push(button.reset());
      }
      return results;
    };

    Button.enable_other_buttons = function(this_button) {
      var button, i, len, ref, results;
      ref = this.buttons;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        button = ref[i];
        if (button !== this_button && !button.is_get_num()) {
          results.push(button.enable());
        }
      }
      return results;
    };

    Button.disable_other_buttons = function(this_button) {
      var button, i, len, ref, results;
      ref = this.buttons;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        button = ref[i];
        if (button !== this_button && !button.is_get_num()) {
          results.push(button.disable());
        }
      }
      return results;
    };

    Button.is_get_all = function() {
      var button, i, len, ref;
      ref = this.buttons;
      for (i = 0, len = ref.length; i < len; i++) {
        button = ref[i];
        if (button.dom.find('.unread').text() === '...') {
          return false;
        }
      }
      return true;
    };

    return Button;

  })();

  cumulate = {
    sum: 0,
    add: function(number) {
      return this.sum += parseInt(number);
    },
    reset: function() {
      return this.sum = 0;
    }
  };

  robot = {
    initial: function() {
      this.buttons = Button.buttons;
      this.info = $('#info-bar');
      this.current = 0;
      this.order = [0, 1, 2, 3, 4];
      return this.order_char = ['A', 'B', 'C', 'D', 'E'];
    },
    get_next_button: function() {
      return this.buttons[this.order[this.current++]];
    },
    click_next: function(currentSum) {
      if (robot.current >= robot.buttons.length) {
        return Button.bubble_Handler();
      } else {
        return Button.S5_button_event(robot.order[robot.current++], robot.click_next, currentSum);
      }
    },
    make_order: function() {
      return this.order.sort(function() {
        return Math.random() - 0.5;
      });
    },
    show_order: function() {
      var str;
      str = this.order_char[this.order[0]] + '、' + this.order_char[this.order[1]] + '、' + this.order_char[this.order[2]] + '、' + this.order_char[this.order[3]] + '、' + this.order_char[this.order[4]];
      return $('#order').text(str);
    }
  };

  init_for_buttons = function() {
    var button, dom, i, len, ref, results;
    ref = $('.button');
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      dom = ref[i];
      results.push(button = new Button($(dom)));
    }
    return results;
  };

  init_for_info = function() {
    var info;
    info = $('#info-bar');
    info.addClass('disable');
    return info.click(function() {
      if (info.hasClass('enable')) {
        info.find('.mysum').text(Button.get_sum());
        info.removeClass('enable');
        info.addClass('disable');
        return $('.apb').removeClass('disable').addClass('enable');
      }
    });
  };

  reset = function() {
    var info;
    $('#order').text('');
    $('#message').text('');
    cumulate.reset();
    Button.reset_all();
    info = $('#info-bar');
    info.removeClass('enable').addClass('disable');
    info.find('.mysum').text('');
    return $('.apb').removeClass('disable').addClass('enable');
  };

  mouse_event = function() {
    return $('.apb')[0].addEventListener('transitionend', reset, false);
  };

  init_for_apb = function() {
    return $('.apb').click(function() {
      if ($('.apb').hasClass('enable')) {
        reset();
        robot.current = 0;
        robot.make_order();
        robot.show_order();
        $('.apb').removeClass('enable').addClass('disable');
        return robot.click_next(cumulate.sum);
      }
    });
  };

  $(function() {
    init_for_buttons();
    init_for_info();
    robot.initial();
    init_for_apb();
    reset();
    return mouse_event();
  });

}).call(this);
