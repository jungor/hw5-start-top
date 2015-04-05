(function() {
  var Button, init_for_buttons, init_for_info, moust_event, reset;

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

    Button.prototype.click_event = function() {
      if (this.dom.hasClass('enable') && !this.is_get_num()) {
        this.constructor.disable_other_buttons(this);
        this.wait();
        return this.get_and_show();
      }
    };

    Button.prototype.get_and_show = function() {
      var that;
      that = this;
      return $.get('/', function(number, result) {
        if (that.is_get_num()) {
          that.disable();
          that.show(number);
          that.constructor.enable_other_buttons(that);
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
      return $('#info-bar').removeClass('disable').addClass('enable');
    };

    Button.get_sum = function() {
      var button, j, len, ref, sum;
      sum = 0;
      ref = this.buttons;
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        sum += parseInt(button.dom.find('.unread').text());
      }
      return sum;
    };

    Button.reset_all = function() {
      var button, j, len, ref, results;
      ref = this.buttons;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        results.push(button.reset());
      }
      return results;
    };

    Button.enable_other_buttons = function(this_button) {
      var button, j, len, ref, results;
      ref = this.buttons;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        if (button !== this_button && !button.is_get_num()) {
          results.push(button.enable());
        }
      }
      return results;
    };

    Button.disable_other_buttons = function(this_button) {
      var button, j, len, ref, results;
      ref = this.buttons;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        if (button !== this_button && !button.is_get_num()) {
          results.push(button.disable());
        }
      }
      return results;
    };

    Button.is_get_all = function() {
      var button, j, len, ref;
      ref = this.buttons;
      for (j = 0, len = ref.length; j < len; j++) {
        button = ref[j];
        if (button.dom.find('.unread').text() === '...') {
          return false;
        }
      }
      return true;
    };

    return Button;

  })();

  init_for_buttons = function() {
    var button, dom, i, j, len, ref, results;
    ref = $('.button');
    results = [];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
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
        return info.addClass('disable');
      }
    });
  };

  reset = function() {
    var info;
    Button.reset_all();
    info = $('#info-bar');
    info.removeClass('enable').addClass('disable');
    return info.find('.mysum').text('');
  };

  moust_event = function() {
    return $('.apb')[0].addEventListener('transitionend', reset, false);
  };

  $(function() {
    init_for_buttons();
    init_for_info();
    reset();
    return moust_event();
  });

}).call(this);
