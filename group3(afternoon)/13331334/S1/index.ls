class Button
    @buttons = []
    @ajax-requests = []

    @disable-other-buttons = (current-button)!~>
        for button in @buttons when button isnt current-button
            ($ button.button) .add-class "disabled"

    @enable-other-buttons = (current-button)!->
        for button in @buttons when button isnt current-button and button .state != "done"
            ($ button.button) .remove-class "disabled"

    (button)!->
        @button = button
        @state = "enabled"
        ($ button) .on "click", @button-click-handler
        @circle = document .createElement "span"
        ($ @circle) .add-class "unread"
        @@@buttons .push @

    button-click-handler: !~>
        if @state == "enabled" and !(($ @button) .has-class "disabled")
            @@@disable-other-buttons @
            @fetch-and-show-number!

    fetch-and-show-number: !~>
        @state = "waiting"
        ($ @circle) .text "..."
        @button .appendChild @circle
        $ .get "/", (data)!~>
            @state = "done"
            ($ @button) .add-class "disabled"
            ($ @circle) .text data
            @@@enable-other-buttons @button
            check-all-completed!

check-all-completed = !->
    for button in Button .buttons
        if button.state != "done"
            return
    ($ "\#info-bar") .remove-class "disabled"

initialize-all-buttons = !->
    $ "li.button" .each (index)!->
        new Button @

initialize-infobar = !->
    ($ "\#info-bar") .on "click", !->
        if !(($ @) .has-class "disabled")
            sum-up-and-show!

sum-up-and-show = !->
    sum = 0
    for button in Button.buttons
        sum += parse-int (($ button.button.last-child).text!)
    ($ "\#info-bar span") .text sum .to-string
    ($ "\#info-bar") .add-class "disabled"

# due to the flaw in css
class Reset-observer
    !~>
        @set-function = null
        ($ "\#info-bar") .on "mouseleave", @reset
        ($ "li.button") .on "mouseleave", @reset
        ($ ".apb") .on "mouseleave", @reset
        ($ "\#info-bar") .on "mouseover", @cancel
        ($ "li.button") .on "mouseover", @cancel
        ($ ".apb") .on "mouseover", @cancel

    reset: !~>
        @set-function = set-timeout @do-reset, 1000

    cancel: !~>
        if @set-function
            clear-timeout @set-function
            @set-function = null

    do-reset: !->
        ($ "\#info-bar span") .text ""
        ($ "\#info-bar") .add-class "disabled"
        ($ ".unread") .remove!
        for ajax-request in Button.ajax-requests
            ajax-request .abort!
        Button.ajax-requests = []
        for button in Button.buttons
            button .state = "enabled"
            ($ button.button) .remove-class "disabled"

$ !->
    initialize-all-buttons!
    initialize-infobar!
    new Reset-observer
