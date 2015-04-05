$ ->
	buttons = $ '#control-ring li'
	bubble = $ '#info-bar'

	buttons.click !->
		click-on-a-button @
	
	bubble.click !->
		click-on-the-bubble bubble
			
click-on-a-button = (the-button) !->
	disable = $ the-button .attr "state"
	if disable isnt "disable" and disable isnt "clicked"
		display-the-red-badge the-button
		disable-all-other-buttons the-button
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

enable-other-buttons = (the-button) !->
	buttons = $ '#control-ring li'
	for button in buttons when button isnt the-button
		clicked = $ button .attr "state"
		if clicked isnt "clicked"
			$ button .attr "state" ""
			$ button .css "background-color" "#192E89"

click-on-the-bubble = (bubble) !->
	sum-area = $ 'sum'
	sum = 0
	for button in buttons
		if $ button .html is "" or $ button .html is "..."
			return
		sum += parseInt($ button .children '.unread' .html!)
	sum-area .html = sum




initial-atplus = !->
	if @mouse-outof-atplus!
		@reset-everything!
