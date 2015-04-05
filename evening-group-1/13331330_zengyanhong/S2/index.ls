class Button
	@buttons = []
	

	(@dom) ->
		@reset!
		@dom.add-class \enable
		@dom.click !~> if @dom.has-class \enable
			@@@disable-all-other-buttons @
			@wait!
			@fectch-number-and-show!
		@@@buttons.push @

	@disable-all-other-buttons = (this-button)-> [button.disable! for button in @buttons when button isnt this-button]

	@enable-all-other-buttons = (this-button)-> [button.enable! for button in @buttons when button isnt this-button and button.dom.find \.unread .text! is '']

	@reset-all = !-> [button.reset! for button in @buttons]

	@all-button-is-done = !-> 
		[return false for button in @buttons when button.dom.find \.unread .text! is '...' or button.dom.find \.unread .text! is '']
		return true

	@all-number-fetched-callback = !->
		$ \#info-bar .add-class \enable

	disable: !-> @dom.remove-class \enable

	enable: !-> @dom.add-class \enable

	wait: !-> 
		@dom.find \.unread .css \display, \block
		@dom.find \.unread .text '...'

	reset: !->
		@dom.add-class \enable
		@dom.find \.unread .text ''
		@dom.find \.unread .css \display, \none

	fectch-number-and-show: !-> $.get '/', (number, result)!~>
		@@@enable-all-other-buttons @
		calculator.add number
		@dom.find \.unread .text number
		@.disable!
		@@@all-number-fetched-callback! if @@@all-button-is-done!
		robot.click-next!


		

calculator =
	sum: 0
	add: (num) -> @sum += parse-int num
	reset: !-> @sum = 0

robot = 
	initial: !->
		@sequence = ['A' to 'E']
		@buttons = $ \.button
		@bubble = $ \#info-bar
		@index = 0

	click-next: !->
		if @index is @sequence.length
			@bubble.add-class \enable
			@bubble.click!
		else
			@buttons[@index++].click!





reset = ->
	bubble = $ \#info-bar
	bubble.find \.unread .text ''
	calculator.reset!
	Button.reset-all! 
	bubble.remove-class \enable
	robot.initial!


init-for-s1 = ->
	for let dom, i in $ \.button
		button = new Button ($ dom)

	container = $ \#at-plus-container
	container.mouseleave !->
		reset!


	bubble = $ \#info-bar
	bubble.click !-> if bubble.has-class \enable
		bubble.find \.unread .text calculator.sum
		bubble.remove-class \enable

init-for-s2 = ->
	tmp = $ \.apb
	tmp.click !->
		robot.click-next!

$ ->
	robot.initial!
	init-for-s1!
	init-for-s2!

	

