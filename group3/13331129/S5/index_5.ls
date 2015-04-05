	class Button
		@FAILURE-RATE = 0.3
		
		@buttons = []

		@disable-other-buttons = (this-button) !-> [button.disable! for button in @buttons when button.dom isnt this-button and button.state isnt 'done']
		
		@enable-other-buttons = (this-button) !-> [button.enable! for button in @buttons when button.dom isnt this-button and button.state isnt 'done']
		
		@reset-all = !-> [button.reset! for button in @buttons]

		@all-button-is-done = ->
			[return false for button in @buttons when button.state isnt 'done']
			true
	    

		(@dom, @good-message, @bad-message, @number-fetched-callback)->
			@state = "enabled"
			$ @dom .css "background-color" "blue"
			$ @dom .find ".unread" .css "display" "none"

			$ @dom .on "click" !~> if @state is "enabled"
				@@@disable-other-buttons @dom
				$ @dom .find ".unread" .css "display" "inline";
				@showWaiting!
				@fetch-number-and-show!

			@@@buttons.push @

		showWaiting: !-> $ @dom .find '.unread' .text "..."

		success-or-fail: (number)!->
			if is-success = Math.random! > @@@FAILURE-RATE
				@show-message @good-message
				@number-fetched-callback error = null, number
			else
				@show-message @bad-message
				@number-fetched-callback message: @bad-message, data: number 


		fetch-number-and-show: !-> $.get '/', (number, result) !~>
			@done!
			add-clicking-to-bubble! if @@@all-button-is-done!
			@@@enable-other-buttons @
			@show-number number
			calculate-sum! if @@@all-button-is-done! and robot.cursor is 5
			$ @dom .css "background-color" "grey" if @state is "done"
			@success-or-fail number

		show-number: (number)!-> $ @dom .find '.unread' .text number

		show-message: (message) !-> 
			for dom, i in $ ".callback"
				if $ dom .text! is ""
					$ dom .text message ; break

		disable: !-> @state = "disabled" ; $ @dom .css "background-color" "grey"

		enable: !-> @state = "enabled" ; $ @dom .css "background-color" "blue"

		reset: !-> @state = "enabled" ; $ @dom .css "background-color" "blue" ; $ @dom .find ".unread" .css "display" "none"

		done: !-> @state = "done"
	
	$ ->
		add-resetting-when-leave-apb!
		create-five-buttons !-> robot.click-next!
		robot.init!
		prestart-robot!

	create-five-buttons = (next) !->
		good-messages = ['A:这是个天大的秘密', 'B:我不知道', 'C:你不知道', 'D:他不知道', 'E:才怪']
		bad-messages = ['A:这不是个天大的秘密', 'B:我知道', 'C:你知道', 'D:他知道', 'E:不怪']
		for let dom, i in $ '#control-ring .button'
			button = new Button (dom), good-messages[i], bad-messages[i], (error, number) !->
				next?!

	reset = !->
		bubble = $ '#info-bar'
		bubble .css "background-color" "gray"
		$ ".sum" .text ""
		Button.reset-all!
		robot.init!
		$ ".callback" .text ""

	add-resetting-when-leave-apb = !->
		is-enter-other = false
		$ '.button, #info-bar, #test, img' .on 'mouseenter' !-> is-enter-other := true
		$ '#test, #info-bar, .button' .on 'mouseleave' (event) !->
			is-enter-other := false
			set-timeout !->
				reset! if not is-enter-other
			, 0

	add-clicking-to-bubble = !->
		bubble = $ '#info-bar'
		bubble .css "background-color" "blue"
		bubble.click !-> if Button.all-button-is-done!
			calculate-sum!

	calculate-sum = !->
		sum = 0
		for button in Button.buttons
			sum := sum + parse-int ($ button.dom .find ".unread" .text!)
		$ ".sum" .text sum
		$ ".callback" .eq(5) .text "大气泡：楼主异步调用战斗力感人，目测不超过#{sum}"
		$ '#info-bar' .css "background-color" "gray"

robot = 
	init: !->
		@buttons = $ '.button'
		@bubble = $ '#info-bar'
		@sequence = ['A' to 'E']
		@cursor = 0

	shuffle-order: !-> @sequence.sort -> 0.5 - Math.random!

	click-next: !-> if @cursor is @sequence.length then @bubble.click! else robot.get-next-button!click!
	
	get-next-button: ->
		index = @sequence[@cursor++].char-code-at! - 'A'.char-code-at!
		@buttons[index]

	show-order: !-> $ '.order' .text @sequence.join ', '

prestart-robot = !-> $ '.apb' .click !->
	robot.shuffle-order!
	robot.show-order!
	robot.click-next!
