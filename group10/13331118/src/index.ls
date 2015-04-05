class Button

  (@$btn, @normal-msg, @err-msg, @err-handler) ->
    @$red-cc = @$btn.find '.adder'
    @reset-myself!
    @@@btns.push @
    @$btn.add-class 'enable' .on 'click', @get-num-and-show

  @FAIL_RATE = 0.7
  @btns = []
  @reset-all-btns = !->
    [b.reset-myself! for b in @btns]
  @is-all-btns-got-num = ->
    for b in @btns when b.num is -1
      return false
    true
  @shuffle-all-btns = !->
    @btns.sort -> Math.random! > 0.5

  name: ~> @$btn.text![0]
  reset-myself: !~>
    @enable-myself!
    @num = -1
    @ajax?.abort!
    @$red-cc.remove-class 'show' .text '...'
    @next = null
  enable-myself: ~>
    @$btn.add-class 'enable' .remove-class 'disable'
  disable-myself: ~>
    @$btn.remove-class 'enable' .add-class 'disable'
  enable-other-btns: ~>
    [b.enable-myself! for b in @@@btns when b.num is -1]
  disable-other-btns: ~>
    [b.disable-myself! for b in @@@btns when b isnt @]
  get-num-and-show: ~> if @$btn.has-class 'enable'
    @disable-other-btns!
    @$red-cc.add-class 'show'
    @ajax = $.get "/?random"+Math.random!, (data)~>
      $bubble = $ '#sum'
      @num = data - 0
      console.log "Button #{@name!} gets num #{@num}!"
      @$red-cc.text data
      @enable-other-btns!
      @disable-myself!
      if Button.is-all-btns-got-num!
        $bubble.add-class 'enable'
      @next?!
  random-fail-get-num: (currentSum)~> if @$btn.has-class 'enable'
    if Math.random! >= @@@FAIL_RATE
      throw message: @error-msgs, currentSum: currentSum, thrower: @
    else
      @allways-success-get-num currentSum

  allways-success-get-num: (currentSum)~> if @$btn.has-class 'enable'
    @disable-other-btns!
    @$red-cc.add-class 'show'
    @ajax = $.get "/?random"+Math.random!, (data)~>
      $bubble = $ '#sum'
      @num = data - 0
      console.log "Button #{@name!} gets num #{@num}!"
      @$red-cc.text data
      @enable-other-btns!
      @disable-myself!
      show-sth-on-the-bubble @normal-msg
      if Button.is-all-btns-got-num!
        ($ '.sum').add-class 'enable'
      try
        @next? currentSum + @num
      catch error
        show-sth-on-the-bubble error.message
        error.thrower.allways-success-get-num error.currentSum
$ ->
  add-clicking-to-get-num-to-all-btns!
  add-clicking-to-calculate-and-show-the-sum-to-the-bubble!
  add-leaving-to-reset-all-to-the-atplus!
  s1-wating-user-to-click!
  switch (window.location.pathname.split //\/|\.//)[1][1]-0
    | 2 => s2-auto-click-serial!
    | 3 => s3-auto-click-parallel!
    | 4 => s4-auto-click-random!
    | 5 => s5-auto-click-random-with-expection!

add-clicking-to-get-num-to-all-btns = !->
  normal-msgs = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  error-msgs = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪']
  for let dom-btn , i in $ '.button'
    button = new Button ($ dom-btn), normal-msgs[i], error-msgs[i], null

calculate-and-show-the-sum = !->
  sum = 0
  for b in Button.btns
    sum += b.num
  show-sth-on-the-bubble sum

show-sth-on-the-bubble = (content)!->
  ($ '.sum').text content
  console.log "The sum is #{content}!"
# reset-bubble = ->

add-clicking-to-calculate-and-show-the-sum-to-the-bubble = !->
  $bubble = $ '.sum'
  $bubble.on 'click', (event)!->  if $bubble.has-class 'enable'
    calculate-and-show-the-sum!

add-leaving-to-reset-all-to-the-atplus = !->
  atplus = $ '#atplus'
  atplus.on 'mouseleave', (event)->
    console.log "leave #{event.target} to #{event.toElement}"
    Button.reset-all-btns!
    $bubble = $ '#sum'
    $bubble.remove-class 'enable' .text ''

s1-wating-user-to-click = !->
  console.log 'wating user to click...'

s2-auto-click-serial = !->
  $api = $ '#api'
  $api.on 'click', (event)!->
    for let b, i in Button.btns
      if i < Button.btns.length-1
        b.next = Button.btns[i+1].get-num-and-show
      else
        b.next = calculate-and-show-the-sum
    Button.btns[0].$btn.click!

s3-auto-click-parallel = !->
  $api = $ '#api'
  $api.on 'click', (event)!->
    for let b, i in Button.btns
      b.next = calculate-and-show-the-sum
      b.get-num-and-show!
      b.enable-other-btns!

s4-auto-click-random = !->
  $api = $ '#api'
  $bubble = $ '#sum'
  $api.on 'click', (event)!->
    Button.shuffle-all-btns!
    for let b, i in Button.btns
      $bubble.text $bubble.text! + b.name!
      if i < Button.btns.length-1
        b.next = Button.btns[i+1].get-num-and-show
      else
        b.next = calculate-and-show-the-sum
    Button.btns[0].$btn.click!

s5-auto-click-random-with-expection = !->
  currentSum = 0
  $api = $ '#api'
  $bubble = $ '#sum'
  $api.on 'click', (event)!->
    Button.shuffle-all-btns!
    for let b, i in Button.btns
      $bubble.text $bubble.text! + b.name!
      if i < Button.btns.length-1
        b.next = Button.btns[i+1].random-fail-get-num
      else
        b.next = show-sth-on-the-bubble
    try
      Button.btns[0].random-fail-get-num currentSum
    catch error
      show-sth-on-the-bubble error.message
      error.thrower.allways-success-get-num error.currentSum
