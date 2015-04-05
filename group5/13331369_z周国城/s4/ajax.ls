class Button
	@fail-rate = 0.3
	@buttons = []
	@enable-other-buttons = (myown)!-> [button.enable! for button in @buttons when button isnt myown and button.state isnt "done"]
	@disable-other-buttons = (myown)-> [button.disable! for button in @buttons when button isnt myown and button.state isnt "done"]
	@all-numbers-get = ->
		[return false for button in @buttons when button.state isnt "done"]
		true
	@reset-all-buttons = !-> [button.reset! for button in @buttons]
	(@dom, @good-messages, @bad-messages, @number-fetch-back)!->
		@name = @dom.find '.title' .text!
		@state = 'enable' ; @dom.add-class 'enable'
		@@@disable-other-buttons!
		@dom.click !~> if @state is 'enable'
			@@@disable-other-buttons @
			@wait!
			@dom.find '.unread' .text '...'
			@fetch-number-and-show!
		@@@buttons.push @

	wait: !-> @state = "waiting"; @dom.remove-class 'enable' .add-class 'waiting'

	fetch-number-and-show: !-> $.get '/' (number, result) !~>
		@done!
		@@@bubble-can-click-when-all-the-numbers-get! if @@@all-numbers-get!
		@@@enable-other-buttons @
		@dom.find '.unread' .text number
		@success-or-fail number

	success-or-fail: (number)!->
		if isSuccess = Math.random! > @@@fail-rate
			@show-message @good-messages
			@number-fetch-back error = null, number
		else
			@number-fetch-back @bad-messages, number

	done: !-> @state = "done"; @dom.remove-class 'waiting' .add-class 'done'

	enable: !-> @state = "enable"; @dom.remove-class 'disable' .add-class 'enable'

	disable: !-> @state = "disable"; @dom.remove-class 'enable' .add-class 'disable'

	reset: !->
		@state = "enable"; @dom.remove-class 'waiting done disable' .add-class 'enable'
		@dom.find '.unread' .text ''

	show-message: !-> console.log "Button #{@name} say: #{@good-messages}"


$ -> 
	add-click-event-to-a-buttons!
	robot.initial!
	add-click-event-to-all-buttons !-> robot.next-to-click!
	add-sum-to-bubble!
	add-leave-event-to-the-area!

add-click-event-to-a-buttons = !->
	a-button = $ '.apb'
	a-button.click !->
		generate-the-random-list-for-clicking!
		# robot.next-to-click!

add-sum-to-bubble = !->
	bubble = $ '#info-bar'
	bubble.add-class 'disable'
	Button.bubble-can-click-when-all-the-numbers-get = !-> bubble.remove-class 'disable' .add-class 'enable'
	bubble.click !-> if bubble.has-class 'enable'
		bubble.find '.sum' .text add-the-fetch-number-to-sum.sum

add-click-event-to-all-buttons = (next)!->
	good-messages = ['这是个天大的秘密', '我不知道', '你不知道', '他不知道', '才怪']
	bad-messages = ['这不是个天大的秘密', '我知道', '你知道', '他知道', '才怪']
	# $ '#info-bar'.add-class 'disable'
	for let dom, i in $ '#button .button'
		new Button ($ dom), good-messages[i], bad-messages[i], (error, number)->
			if error
				console.log "Error from #{button.name}, message is: #{error.message}"
				# number = error.data
			add-the-fetch-number-to-sum.add number
			next?!

add-the-fetch-number-to-sum = 
	sum: 0
	add: (number)-> @sum += parse-int number
	reset: !-> @sum = 0

add-leave-event-to-the-area = !->
	$ '.apb' .on 'transitionend' !->
		reset!

reset = !->
	add-the-fetch-number-to-sum.reset!
	Button.reset-all-buttons!
	reset-for-bubble!
	robot.initial!

reset-for-bubble = !->
	bubble = $ '#info-bar'
	bubble.remove-class 'enable'
	bubble.add-class 'disable'
	bubble.find '.sum' .text ''



robot = 
	initial: !->
		@button = $ '#button .button'
		@bubble = $ '#info-bar'
		@numberHasClick = 0
		@list = ['A' to 'E']
		[$ radius .text '' for radius, i in $ '.info .unread']
		
	next-to-click: !-> if @numberHasClick is 5 then @bubble.click! else @get-the-next-button-to-click!click!
	get-the-order: !-> @list.sort -> 0.5 - Math.random!
	get-the-next-button-to-click: ->
		index = @list[@numberHasClick++].char-code-at! - 'A'.char-code-at!
		@button[index]
	show-the-order: !->
		[$ radius .text @list[i] for radius, i in $ '.info .unread']


generate-the-random-list-for-clicking = !->
	robot.get-the-order!
	robot.next-to-click!
	robot.show-the-order!



	