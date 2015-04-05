	class Button
		@FAILURE-RATE = 0.3
		
		@buttons = []

		@disable-other-buttons = (this-button) !-> [button.disable! for button in @buttons when button.dom isnt this-button and button.state isnt 'done']
		
		@enable-other-buttons = (this-button) !-> [button.enable! for button in @buttons when button.dom isnt this-button and button.state isnt 'done']
		
		@reset-all = !-> [button.reset! for button in @buttons]

		@all-button-is-done = ->
			[return false for button in @buttons when button.state isnt 'done']
			true
	    

		(@dom) -> 
			@state = "enabled"
			$ @dom .css "background-color" "blue"
			$ @dom .find ".unread" .css "display" "none"

			$ @dom .on "click" !~> if @state is "enabled"
				@@@disable-other-buttons @dom
				$ @dom .find ".unread" .css "display" "inline";
				@showWaiting!
				@fetch-number-and-show!
				@done!

			@@@buttons.push @

		showWaiting: !-> $ @dom .find '.unread' .text "..."


		fetch-number-and-show: !-> $.get '/', (number) !~>
			add-clicking-to-bubble! if @@@all-button-is-done!
			@@@enable-other-buttons @
			@show-number number
			$ @dom .css "background-color" "grey" if @state is "done"
			calculate-sum! if @@@all-button-is-done! and robot.cursor is 5
			robot.click-next! if robot.cursor isnt 0 and robot.cursor isnt 5

		show-number: (number)!-> $ @dom .find '.unread' .text number

		disable: !-> @state = "disabled" ; $ @dom .css "background-color" "grey"

		enable: !-> @state = "enabled" ; $ @dom .css "background-color" "blue"

		reset: !-> @state = "enabled" ; $ @dom .css "background-color" "blue" ; $ @dom .find ".unread" .css "display" "none"

		done: !-> @state = "done"
	
	$ ->
		create-five-buttons!
		add-resetting-when-leave-apb!
		robot.init!
		prestart-robot!

	create-five-buttons = !->
		for let dom, i in $ '#control-ring .button'
			button = new Button (dom)

	reset = !->
		bubble = $ '#info-bar'
		bubble .css "background-color" "gray"
		$ ".sum" .text ""
		Button.reset-all!
		robot.init!
		prestart-robot!

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

prestart-robot = !-> $ '.apb' .click !-> robot.click-next!; $ '.apb' .unbind "click"
