class Button
	@buttons = []
	@sum = ->
		number = 0
		[number += button.num for button in @buttons]
		number
	@reset = !->
		[button.reset! for button in @buttons]
	(@dom)->
		@unread = $ @dom .find '.unread'
		@state = 'clickable'
		@dom.click !~> if @state is 'clickable'
			@disable-other-buttons!
			@wait!
			@fetch-random-number!
		@@@buttons.push @
	disable-other-buttons: !->
		[button.disable! for button in @@@buttons when button isnt @ and button.state isnt 'unclickable' and button.state isnt 'done']
	enable-other-buttons: !->
		[button.enable! for button in @@@buttons when button isnt @ and button.state isnt 'clickable' and button.state isnt 'done']
	wait: !->
		@unread.text '...'
	fetch-random-number: !->
		$.get '/api/random', (number, result)!~>
			@num = parse-int number
			@show-number number
			@disable!
			@enable-other-buttons!
			@done!
			@@@all-number-fetched-callback! if @all-buttons-is-done!
	done: !->
		@state = 'done'
	disable: !->
		@state = 'unclickable' ; @dom.remove-class 'buttons' .add-class 'disabled-buttons'
	enable: !->
		@state = 'clickable' ; @dom.remove-class 'disabled-buttons' .add-class 'buttons'
	show-number: (number)!->
		@unread.text number
	all-buttons-is-done: ->
		[return false for button in @@@buttons when button.state isnt 'done']
		true
	reset: !->
		@unread.text ''
		@enable!

$ ->
	add-click-to-fetch-random-number-to-all-buttons!
	add-click-to-calculate-sum-to-the-info!
	reset-when-leave-apb!

add-click-to-fetch-random-number-to-all-buttons = !->
	for let dom, i in $ '#control-ring .buttons'
		button = new Button ($ dom)

add-click-to-calculate-sum-to-the-info = !->
	info = $ '#info'
	Button.all-number-fetched-callback = !->
		info.remove-class 'disabled-info' .add-class 'enabled-info'
	info.click !-> if info.has-class 'enabled-info'
		info.find '#sum' .text Button.sum!

reset-when-leave-apb = !->
	apb = $ '#bottom-positioner'
	apb.mouseleave !->
		Button.reset!
		info = $ '#info'
		info.remove-class 'enabled-info' .add-class 'disabled-info'
		info.find '#sum' .text ''

