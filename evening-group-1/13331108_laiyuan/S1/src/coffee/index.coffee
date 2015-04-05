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
                @dom.find('.unread').text(data)
                @disabled = true
                @dom.css('background-color', '#686868')
                Button::enableButtons()
                Button::ifAllButtonsDoneThenEnableBubble()

$ ->
    addEventHandlerToButtons()
    addEventHandlerToBubble()
    addResetWhenLeavingApb()

addEventHandlerToButtons = ->
    goodMessages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
    badMessages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪']
    for dom, i in $ '#control-ring li.button'
        button = new Button($ dom, goodMessages[i], badMessages[i])

addEventHandlerToBubble = ->
    bubble = $('#info-bar')
    bubble.attr 'enabled', 'false'
    bubble.click ->
        if bubble.attr('enabled') is 'true'
            bubble.find('span').text countResult()
            bubble.attr 'enabled', 'false'
            bubble.css('background-color', '#686868')

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

resetBubble = ->
    bubble = $('#info-bar')
    bubble.find('span').text ''
    bubble.attr 'enabled', 'false'
    bubble.css('background-color', '#686868')

