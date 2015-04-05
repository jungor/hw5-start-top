$ !->
  system.initial!
  add-clicking-to-fetch-numbers-to-all-buttons!
  add-clicking-to-calculate-result-to-the-bubble!
  add-resetting-when-leave-apb!
add-clicking-to-fetch-numbers-to-all-buttons = (next) !->
  for let dom, i in $ '#control-ring .button'
     ($ dom) .click !->
          click-to-fetch-number ($ @)
  next?!
add-clicking-to-calculate-result-to-the-bubble = !->
    $ '#info-bar' .click !->
      if $ '#info-bar' .has-class "enable"
          $ '#info-bar' .text system.sum
          $ '#info-bar' .remove-class "enable" .add-class "disable"
add-resetting-when-leave-apb = !->
  $ '#button' .mouseleave !-> system.reset!
click-to-fetch-number = (this-button) !->
    if !system.buttons_request[this-button.attr "title"] and system.get-request-lock! 
        this-button.find '.unread' .add-class "show" .text "..."
        disable-other-buttons this-button
        system.buttons_request[this-button.attr "title"] = $.get 'http://localhost:3000/S1/' (number, result)!->
            this-button.find '.unread' .text number
            system.sum += parse-int number
            enable-other-buttons!
            system.release-request-lock!
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
      $ '#info-bar' .remove-class "enable" .add-class 'disable' .text ""
      @sum = 0
      @request_command = false;