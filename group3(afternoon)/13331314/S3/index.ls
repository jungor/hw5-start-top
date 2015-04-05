$ ->
	buttons = $ '#control-ring li'
	bubble = $ '#info-bar'
	icon = $ '.apb'

	buttons.click !->
		click-on-a-button @
	
	bubble.click !->
		click-on-the-bubble bubble

	icon.mouseover !->
		initial-atplus!

	icon.click !->
		robot3!

robot3 = !->
	buttons = $ '#control-ring li'
	for the-button in buttons
		the-button.click!


click-on-a-button = (the-button) !->
	display-the-red-badge the-button
	get-number-from-the-server the-button
	$ the-button .attr "state" "clicked"

display-the-red-badge = (the-button) !->
	badge = $ the-button .children '.unread'
	badge .css 'display','block' .html '...'

disable-all-other-buttons = (the-button) !->
	buttons = $ '#control-ring li'
	for button in buttons when button isnt the-button
		clicked =  $ button .attr "state"
		if clicked isnt "clicked"
			$ button .attr "state" "disable"
			$ button .css "background-color" "#7E7E7E"

get-number-from-the-server = (the-button) ->
	do
		data <-! $.get '/'
		$ the-button .children '.unread' .html data
		enable-other-buttons the-button
		$ the-button .css "background-color" "#7E7E7E"
		bubble = $ '#info-bar'
		bubble.click!

enable-other-buttons = (the-button) !->
	buttons = $ '#control-ring li'
	for button in buttons when button isnt the-button
		clicked = $ button .attr "state"
		if clicked isnt "clicked"
			$ button .attr "state" ""
			$ button .css "background-color" "#192E89"

click-on-the-bubble = (bubble) !->
	sum-area = $ '.sum'
	sum = 0
	numbers = $(".unread")
	for number in numbers
		if $ number .html! isnt "" or $ number .html! isnt "..."
			sum += parseInt($ number .html!)
	sum-area .html sum

initial-atplus = !->
	bubble = $ '.sum'
	badge = $ '.unread'
	buttons = $ '#control-ring li'
	$ buttons .attr "state" ""
	$ buttons .css "background-color" "#192E89"

	badge .css 'display','none' .html ''
	bubble .html ''
