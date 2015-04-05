// Generated by LiveScript 1.3.1
(function(){
  var addClickingToFetchNumbersToAllButtons, addClickingToCalculateResultToTheBubble, addResettingWhenLeaveApb, clickToFetchNumber, disableOtherButtons, enableOtherButtons, system, robot, robotClickButtonsFromAToEThenClickBubble;
  $(function(){
    system.initial();
    robot.initial();
    addClickingToFetchNumbersToAllButtons(function(){
      robot.clickNext();
    });
    addClickingToCalculateResultToTheBubble();
    addResettingWhenLeaveApb();
    robotClickButtonsFromAToEThenClickBubble();
  });
  addClickingToFetchNumbersToAllButtons = function(next){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
      (fn$.call(this, i$, ref$[i$]));
    }
    function fn$(i, dom){
      $(dom).click(function(){
        clickToFetchNumber($(this), next);
      });
    }
  };
  addClickingToCalculateResultToTheBubble = function(){
    $('#info-bar').click(function(){
      if ($('#info-bar').hasClass("enable")) {
        $('#info-bar').text(system.sum);
        $('#info-bar').removeClass("enable").addClass("disable");
      }
    });
  };
  addResettingWhenLeaveApb = function(){
    $('#button').mouseleave(function(){
      system.reset();
    });
  };
  clickToFetchNumber = function(thisButton, next){
    if (!system.buttons_request[thisButton.attr("title")] && system.getRequestLock()) {
      thisButton.find('.unread').addClass("show").text("...");
      disableOtherButtons(thisButton);
      system.buttons_request[thisButton.attr("title")] = $.get('http://localhost:3000/S2/', function(number, result){
        thisButton.find('.unread').text(number);
        system.sum += parseInt(number);
        enableOtherButtons();
        system.releaseRequestLock();
        if (typeof next == 'function') {
          next();
        }
      });
    }
  };
  disableOtherButtons = function(thisButton){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
      (fn$.call(this, i$, ref$[i$]));
    }
    function fn$(i, dom){
      if ($(dom).attr("title") !== thisButton.attr("title")) {
        $(dom).removeClass('enable').addClass('disable');
      }
    }
  };
  enableOtherButtons = function(){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
      (fn$.call(this, i$, ref$[i$]));
    }
    if (system.allButtonHasFetchedNumber()) {
      $('#info-bar').removeClass("disable").addClass("enable");
    }
    function fn$(i, dom){
      if (!system.buttons_request[$(dom).attr("title")]) {
        $(dom).removeClass('disable').addClass('enable');
      } else {
        $(dom).removeClass('enable').addClass('disable');
      }
    }
  };
  system = {
    initial: function(){
      this.buttons_request = [];
      this.sum = 0;
      this.request_command = false;
    },
    getRequestLock: function(){
      if (this.request_command === false) {
        return this.request_command = true;
      } else {
        return false;
      }
    },
    releaseRequestLock: function(){
      this.request_command = false;
    },
    allButtonHasFetchedNumber: function(){
      var i$, ref$, len$, i;
      for (i$ = 0, len$ = (ref$ = ["A", "B", "C", "D", "E"]).length; i$ < len$; ++i$) {
        i = ref$[i$];
        if (!this.buttons_request[i]) {
          return false;
        }
      }
      return true;
    },
    reset: function(){
      var i$, ref$, len$, i;
      for (i$ = 0, len$ = (ref$ = ["A", "B", "C", "D", "E"]).length; i$ < len$; ++i$) {
        i = ref$[i$];
        if (this.buttons_request[i] && this.buttons_request[i].readyState !== 4) {
          this.buttons_request[i].abort();
        }
        this.buttons_request[i] = undefined;
      }
      for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
        (fn$.call(this, i$, ref$[i$]));
      }
      $('#info-bar').removeClass("enable").addClass('disable').text("");
      this.sum = 0;
      this.request_command = false;
      robot.initial();
      function fn$(i, dom){
        $(dom).find('.unread').removeClass("show").addClass("unshow");
        $(dom).removeClass('disable').addClass('enable');
      }
    }
  };
  robot = {
    initial: function(){
      this.buttons = $('#control-ring .button');
      this.bubble = $('#info-bar');
      this.sequence = ["A", "B", "C", "D", "E"];
      this.cursor = 0;
    },
    shuffleOrder: function(){
      this.sequence.sort(function(){
        return 0.5 - Math.random();
      });
    },
    clickNext: function(){
      if (this.cursor === this.sequence.length) {
        this.bubble.click();
      } else {
        this.getNextButton().click();
      }
    },
    getNextButton: function(){
      var index;
      index = this.sequence[this.cursor++].charCodeAt() - 'A'.charCodeAt();
      return this.buttons[index];
    }
  };
  robotClickButtonsFromAToEThenClickBubble = function(){
    $('#button .apb').click(function(){
      robot.clickNext();
    });
  };
}).call(this);