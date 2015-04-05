$ !->
	$ \.button .click getRamdomNumber
	$ \#at-plus-container .bind \mouseleave leave
		
			

leave = !->
	$ \.button .css \background-color \blue
	$ \.button .click getRamdomNumber
	[$ button .children! .eq 1 .hide! for button in $ \.button]
	[$ button .children! .eq 1 .html '' for button in $ \.button]
	$ \#info-bar .unbind \click
	$ \#sum .html ""

getRamdomNumber =  !->
	$ \.button .css \background-color \gray
	$ \.button .unbind \click
	$ @ .css \background-color \blue
	$ @ .children! .eq 1 .html \...
	$ @ .children! .eq 1 .show!
	$.get '/' (result)!~>
		$ @ .children! .eq 1 .html result
		[$ button .click getRamdomNumber for button in $ \.button when $ button .children! .eq 1 .html! == '']
		[$ button .css \background-color \blue for button in $ \.button when $ button .children! .eq 1 .html! == '']
		$ @ .css \background-color \gray
		$ @ .unbind \click
		if judge!
			$ \#info-bar .click getSum

judge = !->
	[return false for  unread in $ '.unread' when $ unread .html! is "..." or $ unread .html! is ""]
	return true


getSum = !->
	su = 0
	[su += parseInt ($ unread .text!)  for unread in $ '.unread']
	str = su.toString!
	$ \#sum .html str
	$ \#info-bar .unbind .\click




