class Button
	@buttons = []
	@good_messages = 
		['这是个天大的秘密', '我不知道'
		'你不知道', '他不知道', '才怪']
	@bad_messages =
  		['这不是个天大的秘密', '我知道'
  		'你知道', '他知道', '才不怪']
	constructor: (@dom)->
		@reset
		that = @
		@dom.click -> that.click_event()
		@constructor.buttons.push @
	
	click_event: (click_finish_next)-> if @dom.hasClass('enable') and not @is_get_num()
		@constructor.disable_other_buttons @
		@wait()
		@get_and_show(click_finish_next)

	get_and_show: (event_finish_next, currentSum, fail)->
		that = this;
		$.get '/', (number, result) -> if that.is_get_num()
			that.disable()
			that.constructor.enable_other_buttons that
			if fail is undefined
				that.show number
				that.constructor.info_event() if that.constructor.is_get_all()
				cumulate.add number
				event_finish_next?(currentSum+parseInt(number))
			else event_finish_next?(currentSum)

	disable: -> @dom .removeClass('enable') .addClass('disable')
	
	enable: -> @dom .removeClass('disable') .addClass('enable')

	is_get_num: -> return @dom.find('.unread') .css("display") isnt 'none'
	
	wait: -> @dom.find('.unread') .css("display", "block")
	
	hide: -> @dom.find('.unread') .css("display", "none"); @dom.find('.unread') .text('...')

	show: (number)-> @dom.find('.unread') .text(number)
	
	reset: -> @enable(); @hide();

	@S5_button_event: (number, event_finish_next, currentSum) ->
		switch number
			when 0 then Button.a_handler(event_finish_next, currentSum)
			when 1 then Button.b_handler(event_finish_next, currentSum)
			when 2 then Button.c_handler(event_finish_next, currentSum)
			when 3 then Button.d_handler(event_finish_next, currentSum)
			when 4 then Button.e_handler(event_finish_next, currentSum)
			else return

	@a_handler = (event_finish_next, currentSum)->
		try
			button = Button.buttons[0]
			button.wait()
			Button.disable_other_buttons button
			throw({message: Button.bad_messages[0], currentSum:currentSum}) if Button.is_fail() 
			button.get_and_show(event_finish_next, currentSum)
			Button.show_message Button.good_messages[0]
		catch error
			button.get_and_show(event_finish_next, currentSum, true)
			console.log("Error occurs in a_handler while the current sum is :"+error['currentSum'])
			console.log error['message']
			Button.show_message error['message']

	@b_handler = (event_finish_next, currentSum)->
		try 
			button = Button.buttons[1]
			button.wait()
			Button.disable_other_buttons button
			throw({message: Button.bad_messages[1], currentSum:currentSum}) if Button.is_fail() 
			button.get_and_show(event_finish_next, currentSum)
			Button.show_message Button.good_messages[1]
		catch error
			button.get_and_show(event_finish_next, currentSum, true)
			console.log("Error occurs in b_handler while the current sum is :"+error['currentSum'])
			console.log error['message']
			Button.show_message error['message']

	@c_handler = (event_finish_next, currentSum)->
		try
			button = Button.buttons[2]
			button.wait()
			Button.disable_other_buttons button
			throw({message: Button.bad_messages[2], currentSum:currentSum}) if Button.is_fail()
			button.get_and_show(event_finish_next, currentSum)
			Button.show_message Button.good_messages[2]
		catch error
			button.get_and_show(event_finish_next, currentSum, true)
			console.log("Error occurs in c_handler while the current sum is :"+error['currentSum'])
			console.log error['message']
			Button.show_message error['message']

	@d_handler = (event_finish_next, currentSum)->
		try
			button = Button.buttons[3]
			button.wait()
			Button.disable_other_buttons button
			throw({message: Button.bad_messages[3], currentSum:currentSum}) if Button.is_fail()
			button.get_and_show(event_finish_next, currentSum)
			Button.show_message Button.good_messages[3]
		catch error
			button.get_and_show(event_finish_next, currentSum, true)
			console.log("Error occurs in d_handler while the current sum is :"+error['currentSum'])
			console.log error['message']
			Button.show_message error['message']

	@e_handler = (event_finish_next, currentSum)->
		try
			button = Button.buttons[4]
			button.wait()
			Button.disable_other_buttons button
			throw({message: Button.bad_messages[4], currentSum:currentSum}) if Button.is_fail()
			button.get_and_show(event_finish_next, currentSum)
			Button.show_message Button.good_messages[4]
		catch error
			button.get_and_show(event_finish_next, currentSum, true)
			console.log("Error occurs in e_handler while the current sum is :"+error['currentSum'])
			console.log error['message']
			Button.show_message error['message']

	@bubble_Handler = ->
		$('.apb') .removeClass('disable') .addClass('enable')
		Button.info_event()
		setTimeout((->
			$('.mysum') .text(cumulate.sum)
			Button.show_message "楼主异步调用战斗力感人，目测不超过"+cumulate.sum
			$('#info-bar') .removeClass('enable') .addClass('disable')),500)

	@info_event = -> $('#info-bar') .removeClass('disable') .addClass('enable')
	@is_fail = -> Math.random() > 0.4
	@show_message: (message)-> $('#message').text message
	@get_sum: -> 
		sum = 0;
		for button in @buttons
			sum += parseInt(button.dom.find('.unread').text())
		return sum
	@reset_all = -> button.reset() for button in @buttons
	@enable_other_buttons = (this_button)->
		button.enable() for button in @buttons when button isnt this_button and not button.is_get_num()
	@disable_other_buttons = (this_button)->
		button.disable() for button in @buttons when button isnt this_button and not button.is_get_num()

	@is_get_all = ->
		return false for button in @buttons when button.dom.find('.unread') .text() is '...'
		return true
cumulate = 
	sum: 0
	add: (number)-> @sum += parseInt number
	reset: -> @sum = 0

robot = 
	initial: ->
		@buttons = Button.buttons
		@info = $ '#info-bar'
		@current = 0
		@order = [0,1,2,3,4]
		@order_char = ['A','B','C','D','E']
	get_next_button: -> @buttons[@order[@current++]]
	
	click_next: (currentSum)->
		if robot.current >= robot.buttons.length then Button.bubble_Handler()
		else Button.S5_button_event(robot.order[robot.current++], robot.click_next, currentSum)

	make_order: -> @order.sort -> Math.random() - 0.5

	show_order: ->
		str = @order_char[@order[0]]+'、'+@order_char[@order[1]]+'、'+@order_char[@order[2]]+'、'+
		@order_char[@order[3]]+'、'+@order_char[@order[4]]
		$('#order') .text(str)



init_for_buttons = ->
	for dom in $ '.button'
		button = new Button ($ dom)

init_for_info = ->
	info = $ '#info-bar'
	info .addClass('disable')
	info.click -> if info.hasClass('enable')
		info.find('.mysum') .text Button.get_sum()
		info.removeClass('enable')
		info.addClass('disable')
		$('.apb') .removeClass('disable') .addClass('enable')

reset = ->
	$('#order') .text ''
	$('#message') .text ''
	cumulate.reset()
	Button.reset_all()
	info = $ '#info-bar'
	info .removeClass('enable') .addClass('disable')
	info.find('.mysum') .text ''
	$('.apb') .removeClass('disable') .addClass('enable')

mouse_event = ->
	$('.apb')[0].addEventListener('transitionend', reset, false);

init_for_apb = ->
	$('.apb').click -> if $('.apb') .hasClass('enable')
		reset()
		robot.current = 0; robot.make_order(); robot.show_order();
		$('.apb') .removeClass('enable') .addClass('disable')
		robot.click_next(cumulate.sum)

$ ->
	init_for_buttons()
	init_for_info()
	robot.initial()
	init_for_apb()
	reset()
	mouse_event()