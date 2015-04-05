class Button
	@buttons = []
	constructor: (@dom)->
		@reset
		that = @
		@dom.click -> that.click_event()
		@constructor.buttons.push @
	
	click_event: (click_finish_next)-> if @dom.hasClass('enable') and not @is_get_num()
		@constructor.disable_other_buttons @
		@wait()
		@get_and_show(click_finish_next)

	get_and_show: (click_finish_next)->
		that = this;
		$.get '/', (number, result) -> if that.is_get_num()
			that.disable()
			that.show number
			that.constructor.enable_other_buttons that
			Button.info_event() if that.constructor.is_get_all()
			click_finish_next?()


	disable: -> @dom .removeClass('enable') .addClass('disable')
	
	enable: -> @dom .removeClass('disable') .addClass('enable')

	is_get_num: -> return @dom.find('.unread') .css("display") isnt 'none'
	
	wait: -> @dom.find('.unread') .css("display", "block")
	
	hide: -> @dom.find('.unread') .css("display", "none"); @dom.find('.unread') .text('...')

	show: (number)-> @dom.find('.unread') .text(number)
	
	reset: -> @enable(); @hide();

	@info_event: -> $('#info-bar') .removeClass('disable') .addClass('enable')
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

robot = 
	initial: ->
		@buttons = Button.buttons
		@info = $ '#info-bar'
		@current = 0
		@order = [0,1,2,3,4]
		@order_char = ['A','B','C','D','E']
	get_next_button: -> @buttons[@order[@current++]]
	
	click_next: ->
		if robot.current is Button.buttons.length then robot.current = 0; setTimeout((-> robot.info.click()), 500)
		else robot.get_next_button().click_event(robot.click_next)

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
		robot.click_next()

$ ->
	init_for_buttons()
	init_for_info()
	robot.initial()
	init_for_apb()
	reset()
	mouse_event()