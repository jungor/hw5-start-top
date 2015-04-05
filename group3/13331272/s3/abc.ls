$ ->
	robot.initial!
	$ \.button .click getRamdomNumber
	$ \#at-plus-container .bind \mouseleave leave
	$ '.apb' .click s3
	robot.state = 'off' 
	
leave = !->
	$ \.button .css \background-color \blue
	$ \.button .click getRamdomNumber
	$ \.button .attr \title 'off'
	[$ button .children! .eq 1 .hide! for button in $ \.button]
	[$ button .children! .eq 1 .html "" for button in $ \.button]
	$ \#info-bar .unbind \click
	$ \#sum .html ""
	robot.state = 'off'
	robot.cursor = 0
	robot.initial!

getRamdomNumber =  !-> 
	if robot.state is 'off' or (robot.state is 'on' and ($ @ .attr \title) is 'off')
		name = $ @ .attr \class
		if robot.state isnt 'on'
			$ \.button .css \background-color \gray
			$ \.button .unbind \click
		$ @ .css \background-color \blue
		$ @ .children! .eq 1 .html \...
		$ @ .children! .eq 1 .show!
		$ @ .attr \title 'on'
		$.get "/?request_from=#{name}" (result)!~>
			$ @ .children! .eq 1 .html result
			if robot.state isnt 'on'
				[$ button .click getRamdomNumber for button in $ \.button when $ button .children! .eq 1 .text! == ""]
				[$ button .css \background-color \blue for button in $ \.button when $ button .children! .eq 1 .text! == ""]
			$ @ .css \background-color \gray
			$ @ .unbind \click
			if judge!
				$ \#info-bar .click getSum
				if robot.state is 'on'
					$ \#info-bar .click!
		

judge = !->
	[return false for  unread in $ '.unread' when $ unread .text! is "..." or $ unread .text! is ""]
	return true

distinguish = !->
	[return true for  unread in $ '.unread' when $ unread .text! is ""]
	return false

getSum = !->
	su = 0
	[su += parseInt ($ unread .text!)  for unread in $ '.unread']
	str = su.toString!
	$ \#sum .html str
	$ \#info-bar .unbind .\click

s3 = !->
	if robot.state is 'off' and distinguish!
		robot.state = 'on'
		robot.all-click!

robot =
	initial: !->
		@buttons = $ \.button
		@bubble = $ \#info-bar
		@seq = ['A' to 'E']
		@cursor  = 0
		@state = 'off'
	click-next: !->
		if @cursor is @seq.length then @bubble.click! else @get-next!click!
	get-next: !->
		return @buttons[@cursor++]
	all-click: !->
		@buttons.click!
	

  			







