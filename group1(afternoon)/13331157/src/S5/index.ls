$ ->
    buttons = $ '.button'
    for let item, i in buttons
        item.status = -1                        # status代表按钮的状态, -1 表示按钮为经过点击, 
                                                # 0 表示按钮已点击且正在取数, 1 表示按钮取数完成
        item.onclick =!-> click-on-button item  # 为每个按钮添加 click-on-button 事件

    info = $ '.info'
    info[0].onclick =!->
        if $ '.info' .has-class 'enable'  # 如果 info 为可点击状态
            get-and-show-the-sum!         # 获取和并显示
            make-bubble-disable!          # 将 info 置为不可点击状态

    main = $ '#button'
    main .on 'mouseleave' !->
        reset-all!        # 重置所有

    apb = $ '.apb'
    apb[0].onclick =!->
        for item in buttons
            if item.status === 0
                return
        reset-all!               # 进行重置
        handler-manager.get-sequence!    # 获取点击序列
        handler-manager.show-sequence!   # 显示点击序列
        handler-manager.set-order!       # 根据点击序列确定点击顺序
        handler-manager.start-click!     # 模拟点击开始

#--------------------     S5    -----------------------------#

a-handler =(argus, callback)->
    if argus['message']
        show-message argus['message']
    buttons = $ '.button'
    button = buttons[0]
    set-status-as-waiting button
    set-other-as-disable button
    $.get 'http://localhost:3000', (number)!~>
        try
            if Math.random! < 0.3                  # 生成的随机数小于0.3 抛出异常
                set-status-as-error button         # 将按钮的状态设置为 error
                throw {currentSum:argus['currentSum'], message:"Error from A: 这不是一个天大的秘密"}
            show-message "这是一个天大的秘密"
            set-status-as-done button
            show-the-number button,number
            set-other-as-enable button
            if callback                             # 执行callback函数
                sum =  argus['currentSum']+parse-int number
                callback {currentSum:sum, message:null},callback.next
        catch
            if callback
                callback e,callback.next

b-handler =(argus, callback)->
    if argus['message']
        show-message argus['message']
    buttons = $ '.button'
    button = buttons[1]
    set-status-as-waiting button
    set-other-as-disable button
    $.get 'http://localhost:3000', (number)!~>
        try
            if Math.random! < 0.3
                set-status-as-error button
                throw {currentSum:argus['currentSum'], message:"Error from B: 我知道"}
            show-message "我不知道"
            set-status-as-done button
            show-the-number button,number
            set-other-as-enable button
            if callback
                sum =  argus['currentSum']+parse-int number
                callback {currentSum:sum, message:null},callback.next
        catch
            if callback
                callback e,callback.next

c-handler =(argus, callback)->
    if argus['message']
        show-message argus['message']
    buttons = $ '.button'
    button = buttons[2]
    set-status-as-waiting button
    set-other-as-disable button
    $.get 'http://localhost:3000', (number)!~>
        try
            if Math.random! < 0.3
                set-status-as-error button
                throw {currentSum:argus['currentSum'], message:"Error from C: 你知道"}
            show-message "你不知道"
            set-status-as-done button
            show-the-number button,number
            set-other-as-enable button
            if callback
                sum =  argus['currentSum']+parse-int number
                callback {currentSum:sum, message:null},callback.next
        catch
            if callback
                callback e,callback.next

d-handler =(argus, callback)->
    if argus['message']
        show-message argus['message']
    buttons = $ '.button'
    button = buttons[3]
    set-status-as-waiting button
    set-other-as-disable button
    $.get 'http://localhost:3000', (number)!~>
        try
            if Math.random! < 0.3
                set-status-as-error button
                throw {currentSum:argus['currentSum'], message:"Error from D: 他知道"}
            show-message "他不知道"
            set-status-as-done button
            show-the-number button,number
            set-other-as-enable button
            if callback
                sum =  argus['currentSum']+parse-int number
                callback {currentSum:sum, message:null},callback.next
        catch
            if callback
                callback e,callback.next

e-handler =(argus, callback)->
    if argus['message']
        show-message argus['message']
    buttons = $ '.button'
    button = buttons[4]
    set-status-as-waiting button
    set-other-as-disable button
    $.get 'http://localhost:3000', (number)!~>
        try
            if Math.random! < 0.3
                set-status-as-error button
                throw {currentSum:argus['currentSum'], message:"Error from E: 不怪不怪"}
            show-message "才怪"
            set-status-as-done button
            show-the-number button,number
            set-other-as-enable button
            if callback
                sum =  argus['currentSum']+parse-int number
                callback {currentSum:sum, message:null},callback.next
        catch
            if callback
                callback e,callback.next

bubble-handler =(argus, callback)->
    if argus['message']
        show-message argus['message']
    get-and-show-the-sum!
    make-bubble-disable!
    show-message "楼主异步调用战斗力感人，目测不超过"+argus['currentSum'].toString()

show-message =(message)->                          # 显示message
    $ '._message' .remove!
    newDiv = $ "<div class='_message'>"+message+"</div>"
    $ '#info-bar' .append newDiv
    console.log message

handler-manager =
    map: { 'A': a-handler, 'B': b-handler, 'C': c-handler, 'D': d-handler , 'E': e-handler}
    sequence: []
    get-sequence:-> @sequence = generate-sequence!   # 获取随机序列
    show-sequence: -> show-sequence @sequence        # 显示随机序列
    set-order: ->                                    # 根据sequence确定执行顺序
        for item, i in @sequence
            if i < @sequence.length-1
                @map[item].next = @map[@sequence[i+1]]
            else
                @map[item].next = bubble-handler
    start-click: ->                                   # 模拟点击开始
        @map[@sequence[0]] {currentSum:0, message:null},@map[@sequence[1]]

set-status-as-error =(button)->
    button.status = 2
    remove-all-class button
    ($ button).add-class 'disable'
    ($ button) .find '.unread' .css {'opacity':'0'}

#------------------------    S1   -------------------------------#

generate-sequence =->
    sequence = ['A' to 'E'].sort -> 0.5-Math.random!
    show-sequence sequence
    return sequence

show-sequence =(sequence)->
    div = $ "<div class='sequence'>"+sequence+"</div>"
    $ '#info-bar' .append div

click-on-button = (button)->
    if button.status == 1    # 如果按钮状态为已经完成了点击, 再次点击无效
        return
    if a-button-is-waiting!  # 如果按钮中有正在取数的按钮, 点击无效
        return
    if ($ button).has-class 'disable'
        return
    $.get 'http://localhost:3000', (number)!~>
        if button.status === 0
            set-status-as-done button
            show-the-number button,number
            set-other-as-enable button
            if all-buttons-done!
                make-bubble-enable!
    set-status-as-waiting button
    set-other-as-disable button

a-button-is-waiting =->
    buttons = $ '.button'
    for item in buttons
        if item.status == 0
            return true
    return false

set-status-as-done =(button)->    # 将按钮状态设置为 done
    button.status = 1
    remove-all-class button
    ($ button).add-class 'done'

set-status-as-waiting =(button)->    # 将按钮状态设置为 waiting
    button.status = 0
    remove-all-class button
    ($ button).add-class 'waiting'
    ($ button) .find '.unread' .css {'opacity':'1'}

set-status-as-enable =(button)->    # 将按钮状态设置为 enable
    button.status = -1
    remove-all-class button
    ($ button).add-class 'enable'
    ($ button) .find '.unread' .css {'opacity':'0'}
    ($ button) .find '.unread' .text '...'

set-status-as-disable =(button)->    # 将按钮状态设置为 diable
    button.status = -1
    remove-all-class button
    ($ button).add-class 'disable'

set-other-as-enable =(button)->       # 将其他按钮激活
    for item in $ '.button'
        if item.status != 1  && item.status != 2
            set-status-as-enable item

set-other-as-disable =(button)->      # 将其他按钮灭活
    for item in $ '.button'
        if item.status == -1
            set-status-as-disable item

show-the-number =(button,number)->
    ($ button) .find '.unread' .text number

all-buttons-done =->
    buttons = $ '.button'
    for item in buttons
        if item.status !== 1
            return false
    return true

make-bubble-enable =->
    $ '.info' .remove-class 'disable'
    $ '.info' .add-class 'enable'

remove-all-class = (button)->
    $button = $ button
    $button.remove-class 'enable'
    $button.remove-class 'disable'
    $button.remove-class 'done'
    $button.remove-class 'waiting'

get-and-show-the-sum =->
    buttons = $ '.button'
    S = 0
    for item in buttons
        if item.status == 1
            S += parse-int (($ item).find '.unread' .text!)
    $ '.info .sum' .text S

make-bubble-disable =->
    $ '.info' .remove-class 'enable'
    $ '.info' .add-class 'disable'

reset-all =->
    buttons = $ '.button'
    for item in buttons
        set-status-as-enable item
        item.status = -1
    make-bubble-disable!
    $ '.info .sum' .text ''
    $ '.sequence' .remove!
    $ '._message' .remove!
