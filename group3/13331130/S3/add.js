// Generated by LiveScript 1.3.1
(function(){
  var init, addFetchNumberToAllButtonClick, disableOtherButtons, fetchNumberAndDisplay, calculate, enableOtherButtons, allNumberFetchedCallback, allButtonsWereDone, addResetToApbOnmouseleave, Robot, addAutoSequenceClickToApbClik;
  $(function(){
    init();
    addFetchNumberToAllButtonClick();
    addResetToApbOnmouseleave();
    addAutoSequenceClickToApbClik();
  });
  init = function(){
    var i$, ref$, len$, button;
    for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
      button = ref$[i$];
      $(button).removeClass('disable').addClass('enable').find('.number').removeClass('display').text('...');
      button.state = 'enable';
    }
    $('#result').text('');
    $('.info').removeClass('enable').addClass('disable');
    Robot.initial();
    calculate.reset();
  };
  addFetchNumberToAllButtonClick = function(){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
      (fn$.call(this, ref$[i$]));
    }
    function fn$(button){
      var this$ = this;
      $(button).click(function(){
        if (button.state === 'enable') {
          $(button).find('.number').addClass('display');
          button.cancle = fetchNumberAndDisplay(button);
        }
      });
    }
  };
  disableOtherButtons = function(){
    var i$, ref$, len$, ithButton;
    for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
      ithButton = ref$[i$];
      if (ithButton !== this && ithButton.state !== 'done') {
        $(ithButton).removeClass('enable').addClass('disable');
        ithButton.state = 'disable';
      }
    }
  };
  fetchNumberAndDisplay = function(button){
    return $.get('/' + Math.random(), function(number){
      $(button).find('.number').text(number);
      enableOtherButtons(button);
      calculate.add(number);
      button.state = 'done';
      $(button).addClass('disable').removeClass('enable');
      if (allButtonsWereDone()) {
        allNumberFetchedCallback();
      }
    });
  };
  calculate = {
    sum: 0,
    add: function(number){
      return this.sum += parseInt(number);
    },
    reset: function(){
      this.sum = 0;
    }
  };
  enableOtherButtons = function(thisButton){
    var i$, ref$, len$, ithButton;
    for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
      ithButton = ref$[i$];
      if (ithButton !== thisButton && ithButton.state !== 'done') {
        $(ithButton).removeClass('disable').addClass('enable');
        ithButton.state = 'enable';
      }
    }
    $(button).removeClass('enable').addClass('disable');
    button.state = 'done';
  };
  allNumberFetchedCallback = function(){
    $('.info').removeClass('disable').addClass('enable');
    $('.info').click(function(){
      if ($('.info').hasClass('enable')) {
        $('.info').find('#result').text(calculate.sum);
        $('.info').removeClass('enable').addClass('disable');
      }
    });
    $('.info').click();
  };
  allButtonsWereDone = function(){
    var i$, ref$, len$, button;
    for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
      button = ref$[i$];
      if (button.state !== 'done') {
        return false;
      }
    }
    return true;
  };
  addResetToApbOnmouseleave = function(){
    $('#button').mouseleave(function(){
      var i$, ref$, len$, button, ref1$;
      for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if ((ref1$ = button.cancle) != null) {
          ref1$.abort();
        }
      }
      return init();
    });
  };
  Robot = {
    initial: function(){
      this.buttons = $('.button');
      this.cursor = 0;
    },
    clickAllButtons: function(){
      var i$, ref$, len$, button;
      for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
        button = ref$[i$];
        button.click();
      }
    }
  };
  addAutoSequenceClickToApbClik = function(){
    $('.apb').click(function(){
      var i$, ref$, len$, button, ref1$;
      for (i$ = 0, len$ = (ref$ = $('.button')).length; i$ < len$; ++i$) {
        button = ref$[i$];
        if ((ref1$ = button.cancle) != null) {
          ref1$.abort();
        }
      }
      init();
      Robot.clickAllButtons();
    });
  };
}).call(this);
