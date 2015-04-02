$ !-> 
  bubbles = $ '#control-ring li'
  bar = $ '#info-bar'
  button = $ '#button'

  click-on-bubble = (certain-bubble) !->
    certain-bubble.state = 'clicked'
    little_red_circle = $ certain-bubble .children 'div'
    little_red_circle .css 'display' 'block'
    little_red_circle .html '...'
    for x in bubbles when x isnt certain-bubble and x.state is 'unclicked'
      $ x .removeClass 'enable' 
      $ x .addClass 'disable'

  show-number = (certain-bubble, number) !->
    little_red_circle = $ certain-bubble .children 'div'
    little_red_circle .html number
    $ certain-bubble .removeClass 'enable'
    $ certain-bubble .addClass 'disable'

  change-state = !->
    for x in bubbles when x.state is 'unclicked'
      $ x .removeClass 'disable'
      $ x .addClass 'enable'

  all-number-got = !->
    all_got = true
    for x in bubbles when x.state is 'unclicked'
      all_got = false
      break
    if all_got
      bar .removeClass 'disable'
      bar .addClass 'enable'

  add-up = !->
    if bar .hasClass 'enable' 
      sum = 0
      for x in bubbles
        sum += parseInt($ x .children 'div' .html!)
    if not bar .hasClass 'disable'
      bar .children! .html sum
      bar .removeClass 'enable'
      bar .addClass 'disable'

  do init = !->
    for x in bubbles
      x.state = 'unclicked'
      $ x .removeClass 'disable'
      $ x .addClass 'enable'
      little_red_circle = $ x .children 'div'
      little_red_circle .css 'display' 'none'
      bar .children! .html ''
    bar .removeClass 'enable'
    bar .addClass 'disable'

  bubbles.click !->
    if $ @ .hasClass 'enable' and @.state is 'unclicked'
      click-on-bubble @
      $ .get '/' (number)!~>
        if @state is 'unclicked' or $ @ .hasClass 'disable'
          return
        show-number @,number 
        change-state!
        all-number-got!

  bar.click !->
    add-up!

  button.mouseleave !->
    init!