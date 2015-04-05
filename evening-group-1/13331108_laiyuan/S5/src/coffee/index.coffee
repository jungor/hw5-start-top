class Button
    Button::buttons = []

    Button::disableButtonsExcept = (thisButton)->
        for button, i in Button::buttons
            if button isnt thisButton and button.disabled isnt true
                button.disabled = true
                button.dom.css('background-color', '#686868')

    Button::enableButtons = ()->
        for button in Button::buttons
            if button.disabled is true and button.dom.find('.unread').css('opacity') is '0'
                button.disabled = false
                button.dom.css('background', 'rgb(48, 63, 159)')

    Button::ifAllButtonsDoneThenEnableBubble = ->
        for button in Button::buttons
            if button.disabled isnt true
                return
        $('#info-bar').attr('enabled', 'true')
        $('#info-bar').css('background-color', 'rgb(48, 63, 159)')

    Button::resetAllButtons = ->
        for button in Button::buttons
            button.disabled = false
            dom = button.dom
            dom.css('background-color', 'rgb(48, 63, 159)')
            dom.find('.unread').css('opacity', '0').text ''

    constructor: (@dom, @goodMessages, @badMessages)->
        @addClickHandler()
        @disabled = false
        Button::buttons.push @

    addClickHandler: ->
        @dom.click =>
            if @disabled
                return
            else
                @dom.find('.unread').css('opacity', '1').text '...'
                Button::disableButtonsExcept(@)
                @getRandomNumberAndShow()

    getRandomNumberAndShow: ()->
        $.get '/', (data)=>
            if @disabled is false
                if @success()
                    @dom.find('.unread').text(data)
                    @disabled = true
                    @dom.css('background-color', '#686868')
                    Button::enableButtons()
                    Button::ifAllButtonsDoneThenEnableBubble()
                    if robot.state is 'working'
                        robot.clickNext()

    success: ->
        if Math.random() > 0.3
            @showMessage(true)
            true
        else
            @showMessage(false)
            @getRandomNumberAndShow()
            false

    showMessage: (good)->
        if good
            console.log "Button #{@dom.find('.button-id').text()} say: " + @goodMessages
        else
            console.log "Handle error from #{@dom.find('.button-id').text()} , message is: #{@badMessages}"

$ ->
    robot.init()
    addEventHandlerToButtons()
    addEventHandlerToBubble()
    addResetWhenLeavingApb()
    robotClickingHandler()

addEventHandlerToButtons = (next)->
    goodMessages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
    badMessages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪']
    for dom, i in $ '#control-ring li.button'
        button = new Button($(dom), goodMessages[i], badMessages[i])

addEventHandlerToBubble = ->
    bubble = $('#info-bar')
    bubble.attr 'enabled', 'false'
    bubble.click ->
        if bubble.attr('enabled') is 'true'
            bubble.find('span').text countResult()
            bubble.attr 'enabled', 'false'
            bubble.css('background-color', '#686868')
            if robot.state is 'working'
                console.log "大气泡： 楼主异步调用战斗力感人， 目测不超过" + countResult()

countResult = ->
    result = 0
    for dom in $('#control-ring li.button')
        number = $($(dom).find('span')[1]).text()
        result += parseInt number
    result

addResetWhenLeavingApb = ->
    $('div#button').on 'mouseleave', ->
        Button::resetAllButtons()
        resetBubble()
        robot.reset()

resetBubble = ->
    bubble = $('#info-bar')
    bubble.find('span').text ''
    bubble.attr 'enabled', 'false'
    bubble.css('background-color', '#686868')

robotClickingHandler = ->
    $('.apb').click ->
        if robot.state is 'resting'
            robot.state = 'working'
            robot.getRandomOrder()
            robot.clickNext()

robot =
    init: ->
        @buttons = $ '#control-ring .button'
        @order = ['A', 'B', 'C', 'D', 'E']
        @currentIndex = 0
        @state = 'resting'

    clickNext: ->
        if @currentIndex is @order.length then $('#info-bar').click() else @getNextButton().click()

    getNextButton: ->
        @buttons[@order[@currentIndex++].charCodeAt() - 'A'.charCodeAt()]

    reset: ->
        @state = 'resting'
        @currentIndex = 0

    getRandomOrder: ->
        for button, i in @order
            @order[i] = undefined
        original = ['A', 'B', 'C', 'D', 'E']
        count = 0
        while true
            random = Math.floor(Math.random() * 5)
            if @order[random] is undefined
                @order[random] = original[count++]
            if count is 5
                break
        @printOrder()

    printOrder: ->
        $('#info-bar').find('span').text @order

