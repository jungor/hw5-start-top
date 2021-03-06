// Generated by LiveScript 1.3.1
(function(){
  var addClickingToFetchNumbersToAllButtons, addClickingToCalculateResultToTheBubble, addResettingWhenLeaveApb, clickToFetchNumber, parallelClickToFetchNumber, disableThisButton, disableOtherButtons, enableOtherButtons, system, robot, robotClickAllButtonsThenClickBubble;
  $(function(){
    system.initial();
    robot.initial();
    addClickingToFetchNumbersToAllButtons();
    addClickingToCalculateResultToTheBubble();
    addResettingWhenLeaveApb();
    robotClickAllButtonsThenClickBubble();
  });
  addClickingToFetchNumbersToAllButtons = function(next){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
      (fn$.call(this, i$, ref$[i$]));
    }
    if (typeof next == 'function') {
      next();
    }
    function fn$(i, dom){
      $(dom).click(function(){
        clickToFetchNumber($(this));
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
  clickToFetchNumber = function(thisButton){
    if (!system.buttons_reques[thisButton.attr("title")] && system.getRequestLock()) {
      thisButton.find('.unread').addClass("show").text("...");
      disableOtherButtons(thisButton);
      system.buttons_reques[thisButton.attr("title")] = $.get('http://localhost:3000/S1/', function(number, result){
        thisButton.find('.unread').text(number);
        system.sum += parseInt(number);
        enableOtherButtons();
        system.releaseRequestLock();
      });
    }
  };
  parallelClickToFetchNumber = function(thisButton){
    if (!system.buttons_reques[thisButton.attr("title")]) {
      thisButton.find('.unread').addClass("show").text("...");
      XMLHttp.sendReq('GET', 'http://localhost:3000/S3/', '', function(number, result){
        thisButton.find('.unread').text(number);
        system.sum += parseInt(number);
        disableThisButton(thisButton);
        system.buttons_reques[thisButton.attr("title")] = true;
        if (system.allButtonHasFetchedNumber()) {
          $('#info-bar').removeClass("disable").addClass("enable").click();
        }
      });
    }
  };
  disableThisButton = function(thisButton){
    thisButton.removeClass('enable').addClass('disable');
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
      if (!system.buttons_reques[$(dom).attr("title")]) {
        $(dom).removeClass('disable').addClass('enable');
      } else {
        $(dom).removeClass('enable').addClass('disable');
      }
    }
  };
  system = {
    initial: function(){
      this.buttons_reques = [];
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
        if (!this.buttons_reques[i]) {
          return false;
        }
      }
      return true;
    },
    reset: function(){
      var i$, ref$, len$, i;
      for (i$ = 0, len$ = (ref$ = ["A", "B", "C", "D", "E"]).length; i$ < len$; ++i$) {
        i = ref$[i$];
        if (this.buttons_reques[i] && this.buttons_reques[i].readyState && this.buttons_reques[i].readyState !== 4) {
          this.buttons_reques[i].abort();
        }
        this.buttons_reques[i] = undefined;
      }
      for (i$ = 0, len$ = (ref$ = $('#control-ring .button')).length; i$ < len$; ++i$) {
        (fn$.call(this, i$, ref$[i$]));
      }
      $('#info-bar').removeClass("enable").addClass('disable').text("");
      this.sum = 0;
      this.request_command = false;
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
    clickAll: function(){
      var i$, ref$, len$, index;
      for (i$ = 0, len$ = (ref$ = (fn$.call(this))).length; i$ < len$; ++i$) {
        index = ref$[i$];
        parallelClickToFetchNumber($(this.buttons[index]));
      }
      function fn$(){
        var i$, to$, results$ = [];
        for (i$ = 0, to$ = this.sequence.length; i$ < to$; ++i$) {
          results$.push(i$);
        }
        return results$;
      }
    },
    getNextButton: function(){
      var index;
      index = this.sequence[this.cursor++].charCodeAt() - 'A'.charCodeAt();
      return this.buttons[index];
    }
  };
  robotClickAllButtonsThenClickBubble = function(){
    $('#button .apb').click(function(){
      robot.clickAll();
    });
  };
}).call(this);
