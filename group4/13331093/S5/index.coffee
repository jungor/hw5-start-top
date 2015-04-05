$(document).ready ->
    init()

class Button
    FAILRATE = 1
    constructor: (dom, @goodMessages, @badMessages, @numberFetchhCallBack) ->
        @name = dom[0].title
        @reddot = dom.children()[0]
        dom.click =>
            return if @reddot.innerHTML == '...' or dom.hasClass 'disable'
            @reddot.hidden = false
            @reddot.innerHTML = '...'
            otherButtons = GetOtherButtons()
            DisableButton i for i in otherButtons
            GetNumberAndShow()
            console.log "Click on ", @name

        GetOtherButtons = ->
            otherButtons = []
            buttons = GetAllButton()
            [otherButtons.push i if i != dom[0]] for i in buttons
            otherButtons

        GetNumberAndShow = ->
            $.get '/api/random', (number, result) ->
                return if not isvalid()
                DisableButton dom
                dom.children()[0].innerHTML = number
                EnableUnclickButton()
                CheckAllButtonClick()
                SuccessOrFail(number)

        isvalid = ->
            return false if dom.children()[0].innerHTML != '...' or dom.hasClass('disable')
            return true

        EnableUnclickButton = ->
            buttons = GetAllButton()  
            [EnableButton i if i.children[0].innerHTML == ""] for i in buttons

        CheckAllButtonClick = ->
            buttons = GetAllButton()
            check = true
            [check = false if $(i).hasClass 'enable'] for i in buttons
            enableBubble() if check

        SuccessOrFail = (number) =>
            if Math.floor(Math.random()*10) > FAILRATE
                ShowMessage()
                @numberFetchhCallBack null, number
            else
                @numberFetchhCallBack @badMessages, number
            return

        ShowMessage = => console.log "Button #{@name} say: #{@goodMessages}" ; ShowMessageOnBubble @goodMessages

DisableButton = (button) -> $(button).removeClass "enable" ; $(button).addClass "disable"

EnableButton = (button) -> $(button).removeClass "disable" ; $(button).addClass "enable"

GetAllButton = -> $ '.button'

enableBubble = -> $('#info-bar').removeClass 'disable' ; $('#info-bar').addClass 'enable'

disableBubble = -> $('#info-bar').removeClass 'enable' ; $('#info-bar').addClass 'disable'

resetBubble = -> disableBubble() ; $('#info-bar span')[0].innerHTML = ""

resetButton = ->
    [i.hidden = true, i.innerHTML = ""] for i in $('.button span')
    buttons = GetAllButton()
    EnableButton i for i in buttons

reset = ->
    resetButton()
    resetBubble()
    resetRobot()
    $('#info-bar span')[1].innerHTML = ''

AddClearEvent = ->
    $('#at-plus-container').mouseleave ->
        reset()
    $('#at-plus-container').mouseenter ->
        reset()

ShowMessageOnBubble = (msg) -> $('#info-bar span')[0].innerHTML = msg

init = ->
    aHandler.create()
    bHandler.create()
    cHandler.create()
    dHandler.create()
    eHandler.create()
    bubbleHandler.create()
    robot.create()
    AddClearEvent()
    AddClickEventToApb()
    reset()

bubbleHandler =
    create : ->
      @bubble = $('#info-bar')
      @bubbletext = $('#info-bar span')[0]
      @bubble.click =>
        return if $('#info-bar').hasClass 'disable'
        if not robot.running
          normalclicksum = 0
          normalclicksum += parseInt i.children[0].innerHTML for i in GetAllButton()
          $('#info-bar span')[0].innerHTML = normalclicksum
        ShowMessageOnBubble '楼主异步调用战斗力感人，目测不超过' + @currentSum if robot.running
        disableBubble()
    click: (@currentSum) ->
      @bubble.click()
    

aHandler =
  create : ->
    @button = $ '.mask'
    new Button @button, '这是个天大的秘密', '这不是个天大的秘密' , (error, number) =>
      console.log "Handle error from A, message is: #{error}" if error
      @currentSum += parseInt number
      robot.ClickNext(@currentSum) if robot.running
  click: (@currentSum) ->
    @button.click()

bHandler =
  create : ->
    @button = $ '.history'
    new Button @button, '我不知道', '我知道' , (error, number) =>
      console.log "Handle error from B, message is: #{error}" if error
      @currentSum += parseInt number
      robot.ClickNext(@currentSum) if robot.running
  click: (@currentSum) ->
    @button.click()

cHandler =
  create : ->
    @button = $ '.message'
    new Button @button, '你不知道', '你知道' , (error, number) =>
      console.log "Handle error from C, message is: #{error}" if error
      @currentSum += parseInt number
      robot.ClickNext(@currentSum) if robot.running
  click: (@currentSum) ->
    @button.click()

dHandler =
  create : ->
    @button = $ '.setting'
    new Button @button, '他不知道', '他知道' , (error, number) =>
      console.log "Handle error from D, message is: #{error}" if error
      @currentSum += parseInt number
      robot.ClickNext(@currentSum) if robot.running
  click: (@currentSum) ->
    @button.click()

eHandler =
  create : ->
    @button = $ '.sign'
    new Button @button, '才怪', '才不怪' , (error, number) =>
      console.log "Handle error from E, message is: #{error}" if error
      @currentSum += parseInt number
      robot.ClickNext(@currentSum) if robot.running
  click: (@currentSum) ->
    @button.click()


resetRobot = ->
    robot.sequence = ['A','B','C','D','E']
    robot.cursor = 0
    robot.running = false


robot =
  create : ->
    @buttons = [aHandler, bHandler, cHandler, dHandler, eHandler]
    @bubble = bubbleHandler
    @sequence = ['A','B','C','D','E']
    @cursor = 0
    @running = false

  ClickNext: (@currentSum) ->
    return if not @running
    if @cursor == @sequence.length
        @bubble.click(@currentSum)
        @cursor = 0
        @running = false
        return
    if $(@buttons[@sequence[@cursor].charCodeAt() - 'A'.charCodeAt()]).hasClass "disable"
        @cursor++
        @ClickNext(@currentSum)
    else
        @GetNextButton().click(@currentSum)

  GetNextButton: -> @buttons[@sequence[@cursor++].charCodeAt() - 'A'.charCodeAt()]

  ShuffleOrder: -> @sequence.sort -> 0.5 - Math.random()

  ShowOrder: -> ShowMessageOnBubble @sequence.join ', '

AddClickEventToApb = ->
    $('#button .apb').click ->
      return if robot.running is true
      robot.ShuffleOrder()
      robot.ShowOrder()
      robot.running = true
      robot.ClickNext(0)
