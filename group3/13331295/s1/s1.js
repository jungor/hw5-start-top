// Generated by LiveScript 1.3.1
(function(){
  var Button, Bubble, Aplus, initAll;
  Button = (function(){
    Button.displayName = 'Button';
    var prototype = Button.prototype, constructor = Button;
    Button.allButtons = [];
    Button.disableOtherButton = function(thisButton){
      var i$, ref$, len$, button;
      console.log('disable-other-button');
      for (i$ = 0, len$ = (ref$ = this.allButtons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button !== thisButton && button.state !== 'clicked') {
          button.state = 'disabled';
          button.theButton.removeClass('enabled').addClass('disabled');
        }
      }
    };
    Button.enableOtherButton = function(thisButton){
      var i$, ref$, len$, button;
      console.log('enable-other-button');
      for (i$ = 0, len$ = (ref$ = this.allButtons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button !== thisButton && button.state !== 'clicked') {
          button.state = 'enabled';
          button.theButton.removeClass('disabled').addClass('enabled');
        }
      }
    };
    Button.checkIfAllButtonsClicked = function(){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.allButtons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button.state !== 'clicked') {
          return false;
        }
      }
      console.log('check-if-all-buttons-clicked');
      return true;
    };
    function Button(theButton, bubble){
      var this$ = this;
      this.theButton = theButton;
      this.bubble = bubble;
      console.log('init button');
      this.state = "enabled";
      this.theButton.addClass('enabled');
      this.constructor.allButtons.push(this);
      this.theButton.click(function(){
        if (this$.state === 'enabled') {
          this$.constructor.disableOtherButton(this$);
          this$.state = 'waiting';
          this$.theButton.find('.ran_num').removeClass('hide');
          this$.getNumber();
        }
      });
    }
    prototype.getNumber = function(){
      var this$ = this;
      $.get('/', function(num, state){
        if (this$.state === 'waiting') {
          console.log('get number');
          this$.theButton.find('.ran_num').text(num);
          this$.state = 'clicked';
          this$.theButton.removeClass('enabled');
          this$.theButton.addClass('disabled');
          this$.constructor.enableOtherButton(this$.theButton);
          if (this$.constructor.checkIfAllButtonsClicked()) {
            this$.bubble.enabled();
          }
        }
      });
    };
    prototype.resetTheButton = function(){
      console.log('reset button');
      this.state = 'enabled';
      this.theButton.removeClass('disabled');
      this.theButton.addClass('enabled');
      this.theButton.find('.ran_num').addClass('hide');
      this.theButton.find('.ran_num').text('...');
    };
    return Button;
  }());
  Bubble = (function(){
    Bubble.displayName = 'Bubble';
    var prototype = Bubble.prototype, constructor = Bubble;
    function Bubble(theBubble){
      var this$ = this;
      this.theBubble = theBubble;
      console.log('init bubble');
      this.state = 'disabled';
      this.theBubble.addClass('disabled');
      this.theBubble.click(function(){
        if (this$.state === 'enabled') {
          this$.getSum();
        }
      });
    }
    prototype.enabled = function(){
      console.log('enable bubble');
      this.state = 'enabled';
      this.theBubble.removeClass('disabled');
      this.theBubble.addClass('enable_bubble');
    };
    prototype.getSum = function(){
      var ans, i$, ref$, len$, button, tmp;
      console.log('get-sum');
      ans = 0;
      for (i$ = 0, len$ = (ref$ = Button.allButtons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        tmp = button.theButton.find('.ran_num').text();
        ans += parseInt(tmp);
      }
      this.theBubble.find('#sum').text(ans);
      this.theBubble.addClass('disabled');
      this.state = 'disabled';
    };
    prototype.resetTheBubble = function(){
      console.log('reset-the-bubble');
      this.theBubble.removeClass('enable_bubble');
      this.theBubble.addClass('disabled');
      this.state = 'disabled';
      this.theBubble.find('#sum').text('');
    };
    return Bubble;
  }());
  Aplus = (function(){
    Aplus.displayName = 'Aplus';
    var prototype = Aplus.prototype, constructor = Aplus;
    function Aplus(aplus, bubble){
      var this$ = this;
      this.aplus = aplus;
      this.bubble = bubble;
      console.log('Aplus');
      this.aplus.mouseleave(function(){
        var i$, ref$, len$, button;
        for (i$ = 0, len$ = (ref$ = Button.allButtons).length; i$ < len$; ++i$) {
          button = ref$[i$];
          button.resetTheButton();
        }
        this$.bubble.resetTheBubble();
      });
    }
    return Aplus;
  }());
  initAll = function(){
    var bubble, buttons_, aplus, bigBubble, i$, len$, aplus_;
    console.log('init-all');
    bubble = $('#info-bar');
    buttons_ = $('#control-ring-container .button');
    aplus = $('#bottom-positioner');
    bigBubble = new Bubble($(bubble));
    for (i$ = 0, len$ = buttons_.length; i$ < len$; ++i$) {
      (fn$.call(this, buttons_[i$]));
    }
    aplus_ = new Aplus($(aplus), bigBubble);
    function fn$(button_){
      var thisButton;
      thisButton = new Button($(button_), bigBubble);
    }
  };
  $(function(){
    console.log('init');
    return initAll();
  });
}).call(this);
