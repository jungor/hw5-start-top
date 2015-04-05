$ !->
  reset-all-circles-when-mouseout!
  add-click-to-and-disable-sum-circle!
  add-click-to-and-enable-small-circle!
  s2-add-click-to-aplus-circle!
  # s3-add-click-to-aplus-circle!
  # s4-add-click-to-aplus-circle!
  # s5-add-click-to-aplus-circle!

reset-all-circles-when-mouseout = !-> $ '#part0' .mouseleave all-circle-reset

add-click-to-and-disable-sum-circle = !-> ($ '#sum-circle').add-class 'disable' .click click-sum-circle

add-click-to-and-enable-small-circle = !->
  [circle.add-class 'enable' .click (click-small-circle circle) for circle in get-small-circles!]

click-small-circle = (circle, callback, order, good-message, bad-message, cumulate-sum)->
  !->
    unless circle.has-class 'enable' then return
    wait circle
    disable-other-circles!
    ajax-get-number circle, callback, order, good-message, bad-message, cumulate-sum

ajax-get-number = (circle, callback, order, good-message, bad-message, cumulate-sum)!-> $.get '/' + Math.random!, (number, result)!->
  unless circle.has-class 'waiting' then return

  display-number circle, number
  done circle
  enable-other-circles!

  if all-small-circles-inactive! then sum-circle-active!

  unless isNaN cumulate-sum
    cumulate-sum += parse-int number
    show-sum cumulate-sum

  if good-message
    if Math.random! > 0.3 then show-message good-message[5 - order.length] else show-message bad-message[5 - order.length]

  callback? circle, order, good-message, bad-message, cumulate-sum

display-number = (circle, number)!-> circle .find '.text' .text number

get-small-circles = -> [($ '#circle' + i.to-string!) for i to 4]

disable-other-circles = !-> [disable circle for circle in get-small-circles! when circle.has-class 'enable']

enable-other-circles = !-> [enable circle for circle in get-small-circles! when circle.has-class 'disable']

all-circle-reset = !->
  small-circle-reset!
  sum-circle-reset!

click-sum-circle = !->
  if ($ '#sum-circle').has-class 'disable' then return
  show-sum get-sum!

get-sum = ->
  circles = get-small-circles!
  sum = 0
  [sum += parse-int (circles[i].find '.text').text! for i to 4]
  sum

show-sum = (sum)!-> $ '#sum-circle #sum' .text sum.to-string!

all-small-circles-inactive = ->
  [return false for i to 4 when not ($ '#circle' + i.to-string!).has-class 'done']
  true

sum-circle-active = !-> enable ($ '#sum-circle')

wait = (circle)!->
  (circle.find '.text').text '...'
  circle.remove-class 'enable' .add-class 'waiting'

done = (circle)!-> circle.remove-class 'waiting' .add-class 'done'

disable = (circle)!-> circle.remove-class 'enable' .add-class 'disable'

enable = (circle)!-> circle.remove-class 'disable' .add-class 'enable'

small-circle-reset = !-> [circle.remove-class 'disable waiting done' .add-class 'enable' for circle in get-small-circles!]

sum-circle-reset = !->
  sum-circle = $ '#sum-circle'
  sum-circle. children! .text ''
  disable sum-circle

s2-add-click-to-aplus-circle = !-> $ '#image2' .click s2-robot

s2-robot = !-> do click-small-circle ($ '#circle0'), s2-robot-callback

s2-robot-callback = (circle)!->
  if (circle .attr 'id') is 'circle4' then click-sum-circle!
  else do click-small-circle (s2-next-circle circle), s2-robot-callback

s2-next-circle = (circle)-> $ '#circle' + ((get-circle-number circle) + 1).to-string!

get-circle-number = (circle)-> parse-int (circle.attr 'id')[6]

s3-add-click-to-aplus-circle = !-> $ '#image2' .click s3-robot

s3-robot = !->
  for circle in get-small-circles!
    do click-small-circle circle, click-sum-circle
    enable-other-circles!

s4-add-click-to-aplus-circle = !-> $ '#image2' .click s4-robot

s4-robot = !->
  if ($ '#sum-circle #order').text! isnt '' then return
  order = randomize-order!
  show-order order
  do click-small-circle (transform-order order.shift!), s4-robot-callback, order

transform-order = (single-order)-> $ ('#circle' + (single-order.char-code-at! - 'A'.char-code-at!).to-string!)

randomize-order = -> ['A' to 'E'].sort -> 0.5 - Math.random!

show-order = (order)!-> ($ '#sum-circle #order').text (order.join ',')

s4-robot-callback = (circle, order)!->
  if order.length is 0 then click-sum-circle!
  else do click-small-circle (transform-order order.shift!), s4-robot-callback, order

s5-add-click-to-aplus-circle = !-> $ '#image2' .click s5-robot

s5-robot = !->
  if ($ '#sum-circle #order').text! isnt '' then return
  good-message = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
  bad-message = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才不怪']
  cumulate-sum = 0
  order = randomize-order!
  show-order order
  do click-small-circle (transform-order order.shift!), s5-robot-callback, order, good-message, bad-message, cumulate-sum

s5-robot-callback = (circle, order, good-message, bad-message, cumulate-sum)!->
  if order.length is 0 then show-final-message(cumulate-sum)
  else do click-small-circle (transform-order order.shift!), s5-robot-callback, order, good-message, bad-message, cumulate-sum

show-message = (message)!-> ($ '#sum-circle #message') .text message

show-final-message = (cumulate-sum)!-> ($ '#sum-circle #message').text '楼主异步调用战斗力感人，目测不超过' + cumulate-sum.to-string!