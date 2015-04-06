class Button
	@buttons = new Array

	(@dom, @result-received-callback)->
		@state = 'enabled'
		@dom.click !~> if @state is 'enabled'
			@@@disabled-other-buttons @
			@waiting-result!
			@show-result-and-make-other-buttons-active!
		@@@buttons.push @

	@disabled-other-buttons = (this-button)!->
		[button.disabled! for button in @buttons when button isnt this-button and button.state isnt 'done']

	@enabled-other-button = (this-button)!->
		[button.enabled! for button in @buttons when button isnt this-button and button.state isnt 'done']

	@all-button-status-is-done = ->
		[return false for button in @buttons when button.state isnt 'done']
		true

	@all-button-reset = !->
		[button.reset! for button in @buttons]


	show-result-and-make-other-buttons-active: !->
		$.get '/key='+@dom.id, (number, result)!~>
			@done!
			@@@enabled-other-button @
			@show-number number
			calculator.add-to-sum number
			@all-button-ready-callback! if @@@all-button-status-is-done!
			robot.click-next!

	all-button-ready-callback: !->
		($ '#info-bar') .add-class 'active'

	show-number: (number)!->
		@dom.find 'span' .text number

	disabled: !->
		@state = 'disabled'
		@dom.add-class 'disabled'

	enabled: !->
		@state = 'enabled'
		@dom.remove-class 'disabled'

	waiting-result: !->
		@state = 'waiting'
		@dom.find 'span' .add-class 'unread'
		@dom.find 'span' .text '···'
		@dom.add-class 'disabled'

	done: !->
		@state = 'done'

	reset: !->
		@state = 'disabled'
		@dom.remove-class 'disabled'
		@dom.find 'span' .text ''
		@dom.find 'span' .remove-class 'unread'

calculator = 
	sum: 0
	add-to-sum: (number)!->
		@sum += parse-int number
	reset: !->
		@sum = 0

$ !->
	robot.initial!
	add-clicking-events-to-all-buttons !-> robot.click-next!
	add-clicking-events-to-bubble!
	add-resetting-events-when-leave!
	s2-robot!

add-clicking-events-to-all-buttons = (next)->
	for let dom in $ '#control-ring .button'
		button = new Button ($ dom), (number)!->
			# next?!

add-clicking-events-to-bubble = !->
	bubble = $ '#info-bar'
	bubble.click !-> if bubble.has-class 'active'
		bubble.text calculator.sum

add-resetting-events-when-leave = !->
	$ '#bottom-positioner' .mouseleave (event)!->
		calculator.reset!
		Button.all-button-reset!
		bubble = $ '#info-bar'
		bubble.remove-class 'active' if bubble.has-class 'active'




robot =
	initial: !->
		@buttons = $ '#control-ring .button'
		@bubble = $ '#info-bar'
		@sequence = ['A' to 'E']
		@cursor = 1

	click-next: !-> if @cursor is @sequence.length then @bubble.click! else @get-next-button!click!

	get-next-button: -> 
		index = @sequence[@cursor++].char-code-at! - 'A'.char-code-at!
		@buttons[index]

s2-robot = !-> $ '#at-plus-container' .click !-> robot.buttons[0].click!

