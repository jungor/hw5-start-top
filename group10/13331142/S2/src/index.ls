class Button
	@request = null
	@buttons = []
	@disable-all-other-buttons = (current-button)->[button.disable! for button in @buttons when button isnt current-button and button.state isnt "done"]
	@enable-all-other-buttons = (current-button)->[button.enable! for button in @buttons when button isnt current-button and button.state isnt "done"]
	@all-button-is-done = ->
		[return false for button in @buttons when button.state isnt 'done']
		true
	@reset-all = !->
		[button.reset! for button in @buttons]
		@@request.abort! if @@request
	(@dom, @number-fetched-callback)->
		@state = 'enabled'
		@dom.add-class 'enabled'
		@dom.click !~> if @state is 'enabled'
			red-button = ($ @dom).find '.unread'
			($ red-button) .css('display', 'block')
			@@disable-all-other-buttons @
			@wait!
			@fetch-number-and-show!
		@@buttons.push @

	wait: !->
		@state = 'wait'
		@dom.remove-class 'enabled' .add-class 'waiting'

	disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'
	
	enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'

	done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'

	show-content: (content)!-> @dom.find '.unread' .text content

	fetch-number-and-show: !-> @@request = $.get '/api/random', (number, result)!~>
		@done!
		if @@all-button-is-done!
			$ '#info-bar' .remove-class 'disabled' .add-class 'enabled'
		@@enable-all-other-buttons @
		@show-content number
		cumulator.add number
		@number-fetched-callback!

	reset: !->
		@state = 'enabled'
		@dom.remove-class 'disabled waiting done' .add-class 'enabled'
		@dom.find '.unread' .text ''

cumulator =
	sum: 0
	add: (number)-> @sum += parse-int number
	reset: !-> @sum = 0

$ !->
	inital!
	add-clicking-to-fetch-numbers-to-all-buttons !-> robot.click-next!
	add-clicking-to-calculate-result-to-the-bubble!
	add-resetting-when-leave-apb!
	robot-in-s2!

inital = !->
	robot.inital!

add-clicking-to-fetch-numbers-to-all-buttons = (next)->
	for let dom, i in $ '#control-ring .button'
		button = new Button ($ dom), !->
			if (robot.if-robot)
				next!

add-clicking-to-calculate-result-to-the-bubble = !->
	bubble = $ '#info-bar'
	bubble.click !~> if bubble.has-class 'enabled'
		bubble.find '.amount' .text cumulator.sum

add-resetting-when-leave-apb = !->
	is-enter-other = false
	$ '#info-bar, #control-ring-container, .apb' .on 'mouseenter' !-> is-enter-other := true
	$ '#info-bar, #control-ring-container, .apb' .on 'mouseleave' (event)!-> 
		is-enter-other := false
		set-timeout !-> 
			inital! if not is-enter-other
		, 0

reset = !->
	cumulator.reset!
	$ '.unread' .css('display', 'none')
	$ '.amount' .text ''
	$ '#info-bar' .remove-class 'enabled' .add-class 'disabled'
	Button.reset-all!

robot-in-s2 = !->
	$ '.apb' .on 'click' !->
		robot.inital!
		robot.start!
		robot.click-next!

robot =
	inital: !->
		reset!
		@cursor = 0
		@buttons = $ '#control-ring .button'
		@if-robot = false

	start: !-> @if-robot = true
	click-next: !->
		if @cursor is @buttons.length
			($ '#info-bar').click!
		else
			@buttons[@cursor++].click!