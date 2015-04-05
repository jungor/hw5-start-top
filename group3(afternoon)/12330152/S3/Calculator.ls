# selector for id and classname
var buttons, displayer

HTMLElement.prototype.enable = !->
    this.removeAttribute 'disabled'

HTMLElement.prototype.disable = !->
    this.setAttribute 'disabled', 'true'

HTMLElement.prototype.show = !->
    this.removeAttribute 'hide'

HTMLElement.prototype.hide = !->
    this.setAttribute 'hide', ''

HTMLCollection.prototype.forEach = (cb) !->
    for i from 0 til this.length
        cb this[i]

window.initCalculator = !->
    displayer := $ '#displayer'
    buttons := $ '.button'

    calculator = $ '#calculator'
    region = $ '#calculator-region'
    atPlusButton = $ '#at-plus-button'

    # init buttons and displayer
    initDisplayer!
    buttons.forEach (button) !->
        initButton button

    # open the calculator when mouseover
    calculator.onmouseover = !->
        calculator.setAttribute 'open', ''
        region.setAttribute 'open', ''

    # check if the element is in #calculator
    inCalculator = (element) ->
        if element == null
            false
        else if element.id == 'calculator'
            true
        else
            inCalculator element.parentNode

    # reset the calculator when mouse moves out
    calculator.onmouseout = (evt) !->
        target = evt.relatedTarget
        if not inCalculator target
            calculator.removeAttribute 'open'
            region.removeAttribute 'open'
            init!

    atPlusButton.onclick = !->
        @disable!
        count = 0
        buttons.forEach (button) !->
            button.disable!
        buttons.forEach (button) !->
            button.onclick null, !->
                count++
                if count == 5
                    displayer.click!

    init = !->
        atPlusButton.enable!
        displayer.init!
        buttons.forEach (button) !->
            button.init!

    init!

# definitions

function $ idOrClass, element
    element or (element = document)
    if idOrClass[0] == '#'
        id = idOrClass.substr 1
        element.getElementById id
    else
        classname = idOrClass.substr 1
        element.getElementsByClassName classname

# get random num from the server
!function getRandom cb
    req = new XMLHttpRequest!
    # add random to disable caching
    req.open 'get', "/&random=#{Math.random!}"
    req.onload = !->
        res = this.responseText
        cb res
    req.send!

!function initDisplayer
    # count how many nums are returned
    var count

    displayer.numReturned = !->
        count := count + 1
        # enable the displayer when the 5 nums are returned
        if count == 5
            @enable!

    # cal the sum from buttons
    displayer.onclick = !->
        @disable!
        sum = 0
        buttons.forEach (button) !->
            sum += button.getNum!
        text.innerHTML = sum

    displayer.init = !->
        count := 0
        @disable!
        text.innerHTML = ''

    displayer.init!

!function initButton button
    num =  $ '.num', button .[0]
    # when init, set a random stamp
    # when send req, keep the stamp
    # when callback, compare the current stamp and the saved stamp
    var stamp

    button.onclick = (evt, cb) !->
        num.show!
        num.innerHTML = '...'
        # disable this button
        @.disable!
        # tmp-disable the other enabled buttons
        thisButton = @
        enabledButtons = []
        buttons.forEach (button) !->
            if not button.hasAttribute 'disabled' and button !== thisButton
                button.disable!
                enabledButtons.push button
        _stamp = stamp
        getRandom (res) !->
            return if _stamp != stamp
            # enable the tmp-disabled buttons
            enabledButtons.forEach (button) !->
                button.enable!
            displayer.numReturned!
            num.innerHTML = res
            cb! if cb

    button.getNum = ->
        parseInt num.innerHTML

    button.init = !->
        button.enable!
        num.hide!
        num.innerHTML = ''
        stamp := Math.random!

    button.init!
