class Robot
	@robot-click = false
	S2-click-button-in-order: (b) !->
		icon = $ \.icon
		icon[0] .onclick = ->
			if @@robot-click is false
				b.get-number-for-this-button(Buttons.buttons[0])
				@@robot-click = true
	reset-robot: -> @@robot-click = false
		
class Calculator
	@sum = 0;
	@num-of-sumed = 0
	-> $ \.info .addClass 'disabled'

	calculate-the-sum: (num) !->
		@@sum += parseInt num
		if ++@@num-of-sumed == Buttons.buttons.length
			set-class-able($ \.info)
			info = $ \.info
			info[0] .onclick = !-> prototype.show-the-sum!

	show-the-sum: !-> $ \.page .text @@sum and set-class-disabled($ \.info)

	reset-calculator: !-> $ \.page .text '' and @@sum = @@num-of-sumed = 0

reset-the-whole = ->
	console.log 'reset'
	c = new Calculator
	b = new Buttons
	r = new Robot
	c.reset-calculator!
	b.reset-buttons!
	r.reset-robot!

set-class-disabled = (x) -> $ x .addClass 'disabled' and $ x .removeClass 'able'
set-class-able = (x) -> $ x .addClass 'able' and $ x .removeClass 'disabled'

class Buttons
	@buttons = []
	
	!->
		@@buttons = $ \.button
		for x in @@buttons then $ x .addClass 'able' and x.state = 'ready'
	
	bind-click-to-buttons: !->
		a = for let x, i in @@buttons
			-> x .onclick = !->
				if x.state is 'ready'
					console.log 'you have clicked ' + x.innerHTML + ' ' + x.state
					prototype.get-number-for-this-button x
		i = 0
		while i < a.length, i++ then a[i]!

	get-number-for-this-button: (x) !->
		$ x .append "<span>...</span>"
		$ x .find \span .addClass \unread

		ranNum = void

		@change-buttons-to-disabled x
		$ .get '/', (result) !->
			ranNum = result
			$ x .find "span" .text ranNum
			prototype.change-buttons-to-able x

			c = new Calculator
			c.calculate-the-sum ranNum
			get-next x

	change-buttons-to-disabled: (x) !->
		console.log 'you are in change-buttons-to-disabled'
		for y in @@buttons when y.state is 'ready' then if y isnt x then set-class-disabled(y) and y.state = 'wait'
	change-buttons-to-able: (x) !->
		console.log 'you are in change-buttons-to-able'
		x.state = 'done' and $ x .addClass 'disabled' and $ x .removeClass 'able'
		for y in @@buttons when y.state is 'wait' then set-class-able(y) and y.state = 'ready'

	reset-buttons: -> 
		$ \.unread .remove!
		for y in Buttons.buttons then set-class-able(y) and y.state = 'ready'

get-next = (x) ->
	for let y, i in Buttons.buttons when y is x then
		if i != Buttons.buttons.length-1
			b = new Buttons
			b.get-number-for-this-button Buttons.buttons[++i]
		else
			c = new Calculator
			c.show-the-sum!

<-! $
b = new Buttons
b.bind-click-to-buttons!
robot = new Robot
robot.S2-click-button-in-order b

<-! $ \#button .on \mouseleave
reset-the-whole!
