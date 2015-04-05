$ ->
    init!
    add-fetch-number-to-all-button-click!
    add-reset-to-apb-onmouseleave!

init =  !->
    for button in $ '.button'
        $ button .remove-class 'disable' .add-class 'enable' .find '.number' .remove-class 'display' .text '...'
        button.state = 'enable'
    $ '#result' .text ''
    $ '.info' .remove-class 'enable' .add-class 'disable'

add-fetch-number-to-all-button-click = !->
    for let button in $ '.button'
        $ button .click  !~>
            if button.state is 'enable'
                $ button .find '.number' .add-class 'display'
                disable-other-buttons!
                button.cancle = fetch-number-and-display button

disable-other-buttons =  !->
    for ith-button in $ '.button'
        if ith-button isnt this and ith-button.state isnt 'done'
            $ ith-button .remove-class 'enable' .add-class 'disable'
            ith-button.state = 'disable'

fetch-number-and-display = (button) -> $.get '/', (number) !->
    $ button .find '.number' .text number
    enable-other-buttons button
    calculate.add number
    all-number-fetched-callback!  if all-buttons-were-done!

calculate =
    sum: 0
    add: (number) -> @sum += parse-int number
    reset: !-> @sum = 0  

enable-other-buttons = (button) !->
    for ith-button in $ '.button'
        if ith-button isnt button and ith-button.state isnt 'done'
            $ ith-button .remove-class 'disable' .add-class 'enable'
            ith-button.state = 'enable'
    $ button .remove-class 'enable' .add-class 'disable'
    button.state = 'done'
    
all-number-fetched-callback =  !->
        $ '.info' .remove-class 'disable' .add-class 'enable'
        $ '.info' .click !-> if $ '.info' .has-class 'enable'
        #if语句防止全部获取数据后鼠标移出再移入bubble可点击
            $ '.info' .find '#result' .text calculate.sum
            $ '.info' .remove-class 'enable' .add-class 'disable'


all-buttons-were-done =  ->
    [return false for button in $ '.button' when button.state isnt 'done']
    true

add-reset-to-apb-onmouseleave = !->
    $ '#button' .mouseleave ->
        for button in $ '.button'
            button.cancle? .abort!
        init!