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

#------------------------     S1     -------------------------------#
click-on-button = (button)->
    if button.status == 1    # 如果按钮状态为已经完成了点击, 再次点击无效
        return
    if a-button-is-waiting!  # 如果按钮中有正在取数的按钮, 点击无效
        return
    set-status-as-waiting button    # 将按钮状态设置为 waiting
    set-other-as-disable button     # 将其他按钮灭活
    $.get 'http://localhost:3000', (number)!~>
        if button.status === 0
            set-status-as-done button        # 将按钮状态设置为 done
            show-the-number button,number    # 显示获取的数字
            set-other-as-enable button       # 将其他按钮激活
            if all-buttons-done!
                make-bubble-enable!          # 将 bubble(大气泡)激活

a-button-is-waiting =->            # 判断是否有按钮正在取数
    buttons = $ '.button'
    for item in buttons
        if item.status == 0
            return true
    return false

remove-all-class = (button)->
    $button = $ button
    $button.remove-class 'enable'
    $button.remove-class 'disable'
    $button.remove-class 'done'
    $button.remove-class 'waiting'

set-status-as-done =(button)->    # 将按钮状态设置为 done
    button.status = 1
    remove-all-class button
    ($ button).add-class 'done'

set-status-as-waiting =(button)->   # 将按钮状态设置为 waiting
    button.status = 0
    remove-all-class button
    ($ button).add-class 'waiting'
    ($ button) .find '.unread' .css {'opacity':'1'}

set-status-as-enable =(button)->     # 将按钮状态设置为 enable
    button.status = -1
    remove-all-class button
    ($ button).add-class 'enable'
    ($ button) .find '.unread' .css {'opacity':'0'}
    ($ button) .find '.unread' .text '...'

set-status-as-disable =(button)->     # 将按钮状态设置为 disable
    button.status = -1
    remove-all-class button
    ($ button).add-class 'disable'

set-other-as-enable =(button)->       # 将其他按钮激活
    for item in $ '.button'
        if item.status != 1
            set-status-as-enable item

set-other-as-disable =(button)->      # 将其它按钮灭活
    for item in $ '.button'
        if item.status == -1
            set-status-as-disable item

show-the-number =(button,number)->     # 显示获取的数字
    ($ button) .find '.unread' .text number

all-buttons-done =->            # 判断是否所有按钮都是 done状态
    buttons = $ '.button'
    for item in buttons
        if item.status !== 1
            return false
    return true

make-bubble-enable =->          # 将bubble激活
    $ '.info' .remove-class 'disable'
    $ '.info' .add-class 'enable'

get-and-show-the-sum =->        # 获取和并显示
    buttons = $ '.button'
    S = 0
    for item in buttons
        S += parse-int (($ item).find '.unread' .text!)
    $ '.info .sum' .text S

make-bubble-disable =->        # 将bubble灭活
    $ '.info' .remove-class 'enable'
    $ '.info' .add-class 'disable'

reset-all =->                  # 重置
    buttons = $ '.button'
    for item in buttons
        set-status-as-enable item
        item.status = -1
    make-bubble-disable!
    $ '.info .sum' .text ''
