$ !->
  system.initial!
  robot.initial!
  add-resetting-when-leave-apb!
  robot-generate-a-random-order-and-then-click!
aHandler = (next) !->
  if !system.buttons_request["A"] and system.get-request-lock! 
        this-button = $ '#A_btn'
        this-button .find '.unread' .add-class "show" .text "..."
        disable-other-buttons $ '#A_btn'
        system.buttons_request["A"] = $.get 'http://localhost:3000/S4/' (number, result)!->
            this-button.find '.unread' .text number
            system.sum += parse-int number
            enable-other-buttons!
            system.release-request-lock!
            sucess = Math.random! > 0.3
            if !sucess
                console .log 'A Faild!'
                return ['这不是个天大的秘密', system.sum]
            else
                $ '#say' .text '这是个天大的秘密'
            next?!
bHandler = (next) !->
  if !system.buttons_request["B"] and system.get-request-lock! 
        this-button = $ '#B_btn'
        this-button .find '.unread' .add-class "show" .text "..."
        disable-other-buttons $ '#A_btn'
        system.buttons_request["B"] = $.get 'http://localhost:3000/S4/' (number, result)!->
            this-button.find '.unread' .text number
            system.sum += parse-int number
            enable-other-buttons!
            system.release-request-lock!
            sucess = Math.random! > 0.3
            if !sucess
                console .log 'B Faild!'
                return ['我知道', system.sum]
            else
                $ '#say' .text '我不知道'
            next?!
cHandler = (next) !->
  if !system.buttons_request["C"] and system.get-request-lock! 
        this-button = $ '#C_btn'
        this-button .find '.unread' .add-class "show" .text "..."
        disable-other-buttons $ '#A_btn'
        system.buttons_request["C"] = $.get 'http://localhost:3000/S4/' (number, result)!->
            this-button.find '.unread' .text number
            system.sum += parse-int number
            enable-other-buttons!
            system.release-request-lock!
            sucess = Math.random! > 0.3
            if !sucess
                console .log 'C Faild!'
                return ['你知道', system.sum]
            else
                $ '#say' .text  '你不知道'
            next?!
dHandler = (next) !->
  if !system.buttons_request["D"] and system.get-request-lock! 
        this-button = $ '#D_btn'
        this-button .find '.unread' .add-class "show" .text "..."
        disable-other-buttons $ '#A_btn'
        system.buttons_request["D"] = $.get 'http://localhost:3000/S4/' (number, result)!->
            this-button.find '.unread' .text number
            system.sum += parse-int number
            enable-other-buttons!
            system.release-request-lock!
            sucess = Math.random! > 0.3
            if !sucess
                console .log 'D Faild!'
                return ['他知道', system.sum]
            else
                $ '#say' .text '他不知道'
            next?!
eHandler = (next) !->
  if !system.buttons_request["E"] and system.get-request-lock! 
        this-button = $ '#E_btn'
        this-button .find '.unread' .add-class "show" .text "..."
        disable-other-buttons $ '#A_btn'
        system.buttons_request["E"] = $.get 'http://localhost:3000/S4/' (number, result)!->
            this-button.find '.unread' .text number
            system.sum += parse-int number
            enable-other-buttons!
            system.release-request-lock!
            sucess = Math.random! > 0.3
            if !sucess
                console .log 'E Faild!'
                return ['才怪', system.sum]
            else
                $ '#say' .text '才怪'
            next?!
bubbleHandler = !->
    if $ '#info-bar' .has-class "enable"
          $ '#info-bar' .find '.sum' .text system.sum
          $ '#say' .text "楼主异步调用战斗力感人，目测不超过" + system.sum
          $ '#info-bar' .remove-class "enable" .add-class "disable"
add-resetting-when-leave-apb = !->
  $ '#button' .mouseleave !-> system.reset!
disable-other-buttons = (this-button) !->
    for let dom, i in $ '#control-ring .button'
        if (($ dom).attr "title") != (this-button.attr "title")
            ($ dom).remove-class 'enable' .add-class 'disable'
enable-other-buttons = !->
    for let dom, i in $ '#control-ring .button'
        if !system.buttons_request[($ dom) .attr "title"]
            ($ dom).remove-class 'disable' .add-class 'enable'
        else
            ($ dom).remove-class 'enable' .add-class 'disable'
    if system.all-button-has-fetched-number!
        $ '#info-bar' .remove-class "disable" .add-class "enable"
system = 
    initial: !->
      @buttons_request = []
      @sum = 0
      @request_command = false;
    get-request-lock: ->
      if @request_command == false
        @request_command = true
      else
        false
    release-request-lock:!->
      @request_command = false
    all-button-has-fetched-number:->
      [return false for i in [\A to \E] when !@buttons_request[i]]
      true
    reset: !->
      for i in [\A to \E]
          if @buttons_request[i] && @buttons_request[i].ready-state != 4
              @buttons_request[i].abort!
          @buttons_request[i] = undefined
      for let dom, i in $ '#control-ring .button'
          ($ dom).find '.unread' .remove-class "show" .add-class "unshow"
          ($ dom).remove-class 'disable' .add-class 'enable'
      $ '#info-bar' .remove-class "enable" .add-class 'disable'
      $ '#info-bar' .find '.sum' .text ""
      $ '#info-bar' .find '.random_sort' .text ""
      @sum = 0
      @request_command = false;
      $ '#say' .text ""
      robot.initial!
robot =
    initial: !->
        @bubble = $ '#info-bar'
        @sequence = ['A' to 'E']
        @cursor = 0
        @handlers = [aHandler, bHandler, cHandler, dHandler, eHandler]

    shuffle-order: !-> @sequence.sort -> 0.5 - Math.random!

    click-next: !-> if @cursor is @sequence.length then bubbleHandler! else @get-next-handler! !-> robot.click-next!

    get-next-handler: -> 
        index = @sequence[@cursor++].char-code-at! - 'A'.char-code-at!
        @handlers[index]

    show-order: !-> @bubble.find '.random_sort' .text @sequence.join ', '
robot-generate-a-random-order-and-then-click = !-> $ '#button .apb' .click !->
    robot.shuffle-order!
    robot.show-order!
    robot.click-next!