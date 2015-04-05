$ ->
	init!
	add-number-to-all-button-click!
	add-reset-to-apb-mouseleave!
	add-sequence-click-to-apb!

init = !->
	#init the button
	for btn in $ \.button
		btn.status = \enable
		$ btn .remove-class 'disabled done' .add-class \enable
		$ btn .find \.unread .text '...' .add-class \unseen

	#init the bubble
	$ \#info-bar .remove-class \enable .add-class \disabled .find \.info .text ''

	#init the Robot
	Robot.initial!

add-number-to-all-button-click = !->
	#using let for closure, avoid the lose of this
	for let btn in $ \.button
		$ btn .click !~>
			if btn.status is \enable
				$ btn .find \.unread .remove-class \unseen
				disable-all-other-button btn
				btn.leave = pull-requerst-to-server-and-show-number btn

disable-all-other-button = (btn) !->
	for button in $ \.button
		if button isnt btn and button.status isnt \done
			button.status = \disabled
			$ button .remove-class \enable .add-class \disabled

pull-requerst-to-server-and-show-number = (btn) -> $.get '/' + Math.random!, (number) !->
	$ btn .find \.unread .text number
	enable-all-other-button btn
	calculate.add number
	add-result-to-bubble! if all-button-is-done!
	Robot.click-next!

calculate = 
	sum : 0
	add : (number) -> @sum += +number
	reset : !-> @sum = 0

enable-all-other-button = (btn) !->
	for button in $ \.button
		if button isnt btn and button.status isnt \done
			$ button .remove-class \disabled .add-class \enable
			button.status = \enable
	$ btn .remove-class \enable .add-class \disabled
	btn.status = \done

all-button-is-done = ->
	[return false for btn in $ \.button when btn.status isnt \done]
	true

add-result-to-bubble = !->
	$ \#info-bar .remove-class \disabled .add-class \enable
	$ \#info-bar .click !->
		$ \#info-bar .find \.info .text calculate.sum

add-reset-to-apb-mouseleave = !->
	$ \#button .mouseleave ->
		for btn in $ \.button
			btn.leave? .abort!
		init!

#s2 Robot click sequentially
Robot = 
	initial: !->
		@btns = $ \.button
		@cursor = 0

	click-next: ->
		if @cursor is @btns.length
			$ \#info-bar .click!
		else
			@btns[@cursor++].click!

add-sequence-click-to-apb = !-> $ \.apb .click !->
	Robot.click-next!
