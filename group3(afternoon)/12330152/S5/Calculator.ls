# selector for id and classname
var buttons, displayer

const amsg = '这是个天大的秘密', anmsg = '这不是个天大的秘密!'
const bmsg = '我不知道', bnmsg = '我知道!'
const cmsg = '你不知道', cnmsg = '你知道!'
const dmsg = '他不知道', dnmsg = '他知道!'
const emsg = '才怪', enmsg = '才怪才怪!'

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
    initButton buttons[0], amsg, anmsg
    initButton buttons[1], bmsg, bnmsg
    initButton buttons[2], cmsg, cnmsg
    initButton buttons[3], dmsg, dnmsg
    initButton buttons[4], emsg, enmsg

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

    # reset the calculator when mouseout
    calculator.onmouseout = (evt) !->
        target = evt.relatedTarget
        if not inCalculator target
            calculator.removeAttribute 'open'
            region.removeAttribute 'open'
            init!

    getRandomOrder = ->
        list = [0, 1, 2, 3, 4]
        for i from 0 til 5
            l = parseInt (Math.random! * 5)
            r = parseInt (Math.random! * 5)
            tmp = list[l]
            list[l] = list[r]
            list[r] = tmp
        list

    showOrder = (order) !->
        text = ''
        order.forEach (index) !->
            button = buttons[index]
            text += button.id
        displayer.showText text

    atPlusButton.onclick = !->
        @disable!
        index = 0
        curSum = 0
        order = getRandomOrder!
        showOrder order
        clickNext = !->
            if index == 5
                displayer.onclick!
            else
                buttons[order[index]].onclick null, curSum, (nmsg, curSum) !->
                    # failed
                    if nmsg != ''
                        displayer.showTextAbove nmsg
                    # success
                    else
                        clickNext!
                index++
        clickNext!

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
    text = $ '#text'
    textAbove = $ '#text-above'

    # count how many nums are returned
    var count
    # keep cur sum
    curSum = 0

    displayer.numReturned = (num) !->
        curSum += num
        count := count + 1
        # enable the displayer when the 5 nums are returned
        if count == 5
            @enable!

    displayer.getNum = ->
        curSum

    displayer.showText = (str) !->
        text.innerHTML = str
        text.show!

    displayer.showTextAbove = (str) !->
        textAbove.innerHTML = str

    # show the sum
    displayer.onclick = !->
        @disable!
        text.innerHTML = curSum
        text.show!

    displayer.init = !->
        text.hide!
        count := 0
        @disable!
        text.innerHTML = ''
        textAbove.innerHTML = ''

    displayer.init!

!function initButton button, msg, nmsg
    num =  $ '.num', button .[0]
    # when init, set a random stamp
    # when send req, keep the stamp
    # when callback, compare the current stamp and the saved stamp
    var stamp

    button.onclick = (evt, curSum, cb) !->
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
            displayer.numReturned parseInt res
            num.innerHTML = res
            sum = parseInt(res) + curSum
            # random failing
            failed = Math.random! > 0.3
            if failed
                cb nmsg, curSum
            else
                displayer.showTextAbove msg
                cb '', curSum

    button.getNum = ->
        parseInt num.innerHTML

    button.init = !->
        button.enable!
        num.hide!
        num.innerHTML = ''
        stamp := Math.random!

    button.init!
