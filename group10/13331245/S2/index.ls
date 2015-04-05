class Button
	@buttons = []

	(@dom, @number-fetched-callback)->
		@state = "enabled"; @dom.add-class 'enabled'
		@name = @dom.find 'div' .text!
		@dom.find 'span' .css (display: 'none')
		@dom.click !~> if @state is 'enabled'
			@dom.find 'span' .css (display: 'block')
			@@@disable-all-other-buttons @
			@wait!
			@fetch-number-and-show!
		@@@buttons.push @

	@disable-all-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button and button.state isnt 'done']

	@enable-all-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.state isnt 'done']

	@all-button-is-done = ->
		[return false for button in @buttons when button.state isnt 'done']
		true

	@reset-all = !-> [button.reset! for button in @buttons]

	disable: !-> @state = 'disabled' ; @dom.remove-class 'enabled' .add-class 'disabled'

	enable: !-> @state = 'enabled' ; @dom.remove-class 'disabled' .add-class 'enabled'

	wait: !-> @state = 'waiting' ; @dom.remove-class 'enabled' .add-class 'waiting'; @dom.find '.unread' .text('...')

	done: !-> @state = 'done' ; @dom.remove-class 'waiting' .add-class 'done'

	reset: !-> 
		@state = 'enabled' ; @dom.remove-class 'disabled waiting done' .add-class 'enabled'
		@dom.find '.unread' .text ''
		@dom.find 'span' .css (display: 'none')

	fetch-number-and-show: !-> $.get '../', (number, result)!~>
		@done!
		@@@all-number-fetched-callback! if @@@all-button-is-done!
		@@@enable-all-other-buttons @
		@show-number number
		@number-fetched-callback number

	show-number: (number)!-> @dom.find '.unread' .text number

sum-handler = 
	sum: 0
	add: (number)!-> @sum += parse-int number
	reset: !-> @sum = 0;

add-clicking-to-fetch-numbers-to-all-buttons = (next)-> 
	for let dom, i in $ '#control-ring .button'
		button = new Button ($ dom), (number)!-> 
			sum-handler.add number
			next?!

add-clicking-to-calculate-result-to-the-bubble = ->
	bubble = $ '#info-bar' 
	bubble.add-class 'disabled'
	Button.all-number-fetched-callback = !-> bubble.remove-class 'disabled' .add-class 'enabled'; bubble.css (background-color: 'rgba(48,63,159,1)')
	bubble.click !-> 
		if bubble.has-class 'enabled'
			bubble.find '#Sum' .text sum-handler.sum
			bubble.css (background-color: 'gray')

add-resetting-when-leave-apb = !->
	is-enter-other = false
	$ '#at-plus-container' .on 'mouseenter' !-> is-enter-other := true
	$ '#at-plus-container' .on 'mouseleave' (event)!-> 
		is-enter-other = false
		set-timeout !-> 
			reset! if not is-enter-other
		, 0

robot = 
	initial: !->
		@buttons = $ '#control-ring .button'
		@bubble = $ '#info-bar'
		@sequence = ['A' to 'E']
		@cursor = 0

	get-next-button: -> 
		index = @sequence[@cursor++].char-code-at! - 'A'.char-code-at!
		@buttons[index]

	click-next: !-> if @cursor is @sequence.length then @bubble.click! else @get-next-button!click!

	reset: !->
		@sequence = ['A' to 'E']
		@cursor = 0

reset = !->
	sum-handler.reset!
	Button.reset-all!
	bubble = $ '#info-bar'
	bubble.remove-class 'enabled' .add-class 'disabled'
	bubble.find '#Sum' .text ''
	robot.reset!

s2-robot-click-buttons-from-a-to-e-then-click-bubble = !-> $ '.apb' .click !-> robot.click-next!

$ ->
	robot.initial!
	add-clicking-to-fetch-numbers-to-all-buttons !-> robot.click-next!
	add-clicking-to-calculate-result-to-the-bubble!
	add-resetting-when-leave-apb!
	s2-robot-click-buttons-from-a-to-e-then-click-bubble!