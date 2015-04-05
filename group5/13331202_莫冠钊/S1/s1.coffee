class Button
	@buttons = []
	constructor: (@dom)->
		@reset
		that = @
		@dom.click -> that.click_event()
		@constructor.buttons.push @
	
	click_event: -> if @dom.hasClass('enable') and not @is_get_num()
		@constructor.disable_other_buttons @
		@wait()
		@get_and_show()

	get_and_show: ->
		that = this;
		$.get '/', (number, result) -> if that.is_get_num()
			that.disable()
			that.show number
			that.constructor.enable_other_buttons that
			Button.info_event() if that.constructor.is_get_all()

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

init_for_buttons = ->
	for dom, i in $ '.button'
		button = new Button ($ dom)

init_for_info = ->
	info = $ '#info-bar'
	info .addClass('disable')
	info.click -> if info.hasClass('enable')
		info.find('.mysum') .text Button.get_sum()
		info.removeClass('enable')
		info.addClass('disable')

reset = ->
	Button.reset_all()
	info = $ '#info-bar'
	info .removeClass('enable') .addClass('disable')
	info.find('.mysum') .text ''

moust_event = ->
	$('.apb')[0].addEventListener('transitionend', reset, false);


$ ->
	init_for_buttons()
	init_for_info()
	reset()
	moust_event()