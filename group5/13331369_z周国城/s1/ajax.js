(function(){
  var Button, addSumToBubble, addClickEventToAllButtons, addTheFetchNumberToSum, addLeaveEventToTheArea, reset, resetForBubble;
  Button = (function(){
    Button.displayName = 'Button';
    var prototype = Button.prototype, constructor = Button;
    Button.failRate = 0.3;
    Button.buttons = [];
    Button.enableOtherButtons = function(myown){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button !== myown && button.state !== "done") {
          button.enable();
        }
      }
    };
    Button.disableOtherButtons = function(myown){
      var i$, ref$, len$, button, results$ = [];
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button !== myown && button.state !== "done") {
          results$.push(button.disable());
        }
      }
      return results$;
    };
    Button.allNumbersGet = function(){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if (button.state !== "done") {
          return false;
        }
      }
      return true;
    };
    Button.resetAllButtons = function(){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = this.buttons).length; i$ < len$; ++i$) {
        button = ref$[i$];
        button.reset();
      }
    };
    function Button(dom, goodMessages, badMessages, numberFetchBack){
      var this$ = this;
      this.dom = dom;
      this.goodMessages = goodMessages;
      this.badMessages = badMessages;
      this.numberFetchBack = numberFetchBack;
      this.name = this.dom.find('.title').text();
      this.state = 'enable';
      this.dom.addClass('enable');
      this.constructor.disableOtherButtons();
      this.dom.click(function(){
        if (this$.state === 'enable') {
          this$.constructor.disableOtherButtons(this$);
          this$.wait();
          this$.dom.find('.unread').text('...');
          this$.fetchNumberAndShow();
        }
      });
      this.constructor.buttons.push(this);
    }
    prototype.wait = function(){
      this.state = "waiting";
      this.dom.removeClass('enable').addClass('waiting');
    };
    prototype.fetchNumberAndShow = function(){
      var this$ = this;
      $.get('/', function(number, result){
        this$.done();
        if (this$.constructor.allNumbersGet()) {
          this$.constructor.bubbleCanClickWhenAllTheNumbersGet();
        }
        this$.constructor.enableOtherButtons(this$);
        this$.dom.find('.unread').text(number);
        this$.successOrFail(number);
      });
    };
    prototype.successOrFail = function(number){
      var isSuccess, error;
      if (isSuccess = Math.random() > this.constructor.failRate) {
        this.showMessage(this.goodMessages);
        this.numberFetchBack(error = null, number);
      } else {
        this.numberFetchBack(this.badMessages, number);
      }
    };
    prototype.done = function(){
      this.state = "done";
      this.dom.removeClass('waiting').addClass('done');
    };
    prototype.enable = function(){
      this.state = "enable";
      this.dom.removeClass('disable').addClass('enable');
    };
    prototype.disable = function(){
      this.state = "disable";
      this.dom.removeClass('enable').addClass('disable');
    };
    prototype.reset = function(){
      this.state = "enable";
      this.dom.removeClass('waiting done disable').addClass('enable');
      this.dom.find('.unread').text('');
    };
    prototype.showMessage = function(){
      console.log("Button " + this.name + " say: " + this.goodMessages);
    };
    return Button;
  }());
  $(function(){
    addClickEventToAllButtons();
    addSumToBubble();
    return addLeaveEventToTheArea();
  });
  addSumToBubble = function(){
    var bubble, this$ = this;
    bubble = $('#info-bar');
    bubble.addClass('disable');
    Button.bubbleCanClickWhenAllTheNumbersGet = function(){
      bubble.removeClass('disable').addClass('enable');
    };
    bubble.click(function(){
      if (bubble.hasClass('enable')) {
        bubble.find('.sum').text(addTheFetchNumberToSum.sum);
      }
    });
  };
  addClickEventToAllButtons = function(){
    var goodMessages, badMessages, i$, len$;
    goodMessages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪'];
    badMessages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪'];
    for (i$ = 0, len$ = $('#button .button').length; i$ < len$; ++i$) {
      (fn$.call(this, i$, $('#button .button')[i$]));
    }
    function fn$(i, dom){
      new Button($(dom), goodMessages[i], badMessages[i], function(error, number){
        if (error) {
          console.log("Error from " + button.name + ", message is: " + error.message);
        }
        return addTheFetchNumberToSum.add(number);
      });
    }
  };
  addTheFetchNumberToSum = {
    sum: 0,
    add: function(number){
      return this.sum += parseInt(number);
    },
    reset: function(){
      this.sum = 0;
    }
  };
  addLeaveEventToTheArea = function(){
    $('.apb').on('transitionend', function(){
      reset();
    });
  };
  reset = function(){
    addTheFetchNumberToSum.reset();
    Button.resetAllButtons();
    resetForBubble();
  };
  resetForBubble = function(){
    var bubble;
    bubble = $('#info-bar');
    bubble.removeClass('enable');
    bubble.addClass('disable');
    bubble.find('.sum').text('');
  };
}).call(this);
