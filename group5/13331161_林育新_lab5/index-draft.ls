#define the class of button
class Button
	
	@btns = []
	@disable-all-other-button = (this-button) -> [button.disable! for button in @btns when button isnt this-button and button.status isnt \done]
	@enable-all-other-button = (this-button) -> [button.enable! for button in @btns when button isnt this-button and button.status isnt \done]
	@reset-all = !-> [btn.reset! for btn in @btns]

	#constructor
	#status contains 3, enable disabled and done
	(@btn) ->
		@status = \enable
		@btn.add-class \enable
		@btn.click !~> if @status is \enable
			@btn.find \.unread .remove-class \unseen
			@@@disable-all-other-button @
			@pull-requerst-to-server-and-show!
		@@@btns.push @

	pull-requerst-to-server-and-show : !-> $.get '/' + Math.random!, (number) !~>
		@done!
		Bubble.all-number-is-click-and-enable-bubble! if @all-number-is-click!
		@@@enable-all-other-button @
		@show-number-in-span number
		calculate.add number

	show-number-in-span : (number) !->
		@btn.find \.unread .text number
		@btn .add-class \disabled

	all-number-is-click : ->
		[return false for btn in @@@btns when btn.status isnt \done]
		true

	done : !->
		@status = \done
		@btn.remove-class \enable .add-class \disabled

	disable : !->
		@status = \disabled
		@btn.remove-class \enable .add-class \disabled

	enable : !->
		@status = \enable
		@btn.remove-class \disabled .add-class \enable

	reset : !->
		@status = \enable
		@btn. remove-class \disabled .add-class \enable
		@btn.find \.unread .text '...'

class Bubble

	(@bubble) ->
		@bubble.add-class \disabled

	@reset-bubble = !-> @bubble.reset!

	@all-number-is-click-and-enable-bubble = (@bubble) !~>
		@bubble.remove-class \disabled .add-class \enable
		@bubble.click !~> if @bubble.has-class \enable
			@show-result-in-info calculate.sum
	
	show-result-in-info : !->
		@bubble.find \.info .text calculate.sum

	reset : !->
		@bubble .remove-class \enable .add-class \disabled
		@bubble.find \.info .text ''

calculate =
	sum : 0
	add : (number) -> @sum += +number
	reset : !-> @sum = 0

$ ->
	add-fetch-number-to-all-button-click!
	add-reset-to-apb-onmouseleave!
	add-init-to-bubble-click!
	add-result-to-bubble-click!

add-fetch-number-to-all-button-click = ->
	for btn in $ \.button
		btn = new Button($ btn)

add-reset-to-apb-onmouseleave = !->
	$ '#button' .mouseleave ->
		for btn in $ \.button
			init!

add-init-to-bubble-click = !->
	info-bubble = $ \#info-bar
	bubble = new Bubble($ info-bubble)

init = !->
	Button.reset-all!
	Bubble.reset!
	calculate.reset!