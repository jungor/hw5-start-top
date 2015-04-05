class Button
	@buttons = []
	constructor: (@dom)->
		@reset
		that = @
		@dom.click -> that.click_event()
		@constructor.buttons.push @
	
	click_event: (index)-> if @dom.hasClass('enable') and not @is_get_num()
		@wait()
		@get_and_show(index)

	get_and_show: (index)->
		that = this;
		$.get '/'+index, (number, result) -> if that.is_get_num()
			that.disable()
			that.show number
			Button.info_event() if that.constructor.is_get_all()


	disable: -> @dom .removeClass('enable') .addClass('disable')
	
	enable: -> @dom .removeClass('disable') .addClass('enable')

	is_get_num: -> return @dom.find('.unread') .css("display") isnt 'none'
	
	wait: -> @dom.find('.unread') .css("display", "block")
	
	hide: -> @dom.find('.unread') .css("display", "none"); @dom.find('.unread') .text('...')

	show: (number)-> @dom.find('.unread') .text(number)
	
	reset: -> @enable(); @hide();

	@info_event: -> $('#info-bar') .removeClass('disable') .addClass('enable'); setTimeout((-> $('#info-bar').click()), 500)
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
	get_next_button: -> @buttons[@current++]
	click_all: -> button.click_event(index) for button, index in @buttons


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
	Button.reset_all()
	info = $ '#info-bar'
	info .removeClass('enable') .addClass('disable')
	info.find('.mysum') .text ''
	$('.apb') .removeClass('disable') .addClass('enable')

mouse_event = ->
	$('.apb')[0].addEventListener('transitionend', reset, false);

init_for_apb = ->
	$('.apb').click -> if $('.apb') .hasClass('enable')
		reset(); robot.current = 0; $('.apb') .removeClass('enable') .addClass('disable'); robot.click_all()

$ ->
	init_for_buttons()
	init_for_info()
	robot.initial()
	init_for_apb()
	reset()
	mouse_event()