(function() {
  var Button, init_for_apb, init_for_buttons, init_for_info, mouse_event, reset, robot;

  Button = (function() {
    Button.buttons = [];

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

    Button.prototype.click_event = function(index) {
      if (this.dom.hasClass('enable') && !this.is_get_num()) {
        this.wait();
        return this.get_and_show(index);
      }
    };

    Button.prototype.get_and_show = function(index) {
      var that;
      that = this;
      return $.get('/' + index, function(number, result) {
        if (that.is_get_num()) {
          that.disable();
          that.show(number);
          if (that.constructor.is_get_all()) {
            return Button.info_event();
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

    Button.info_event = function() {
      $('#info-bar').removeClass('disable').addClass('enable');
      return setTimeout((function() {
        return $('#info-bar').click();
      }), 500);
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

  robot = {
    initial: function() {
      this.buttons = Button.buttons;
      this.info = $('#info-bar');
      return this.current = 0;
    },
    get_next_button: function() {
      return this.buttons[this.current++];
    },
    click_all: function() {
      var button, i, index, len, ref, results;
      ref = this.buttons;
      results = [];
      for (index = i = 0, len = ref.length; i < len; index = ++i) {
        button = ref[index];
        results.push(button.click_event(index));
      }
      return results;
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
        $('.apb').removeClass('enable').addClass('disable');
        return robot.click_all();
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
