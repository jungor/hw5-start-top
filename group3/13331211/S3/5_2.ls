/*when onload: 

	add clickListener for all-little-buttons

	able all buttons

			clickListener:
				send number request to server
					when request ready:
						disable me
						able others
						if all-buttons clicked
							able big-bubble

				set waiting style for me
				disable others

	disable big bubble

	!I DONT HANDLE RESET !
	!REMEMBER TO CHANGE IT!
*/
/*
HOW TO USE LSP??
	VAR ->
	FUNCTION->
		fname = (arguments) -> //!-> if no return
			//add code here//
	GETELEMENT->
	ADDLISTENER->
	CALLBACK->
*/

window.onload = !->
	set-unvisible-all-unreads!
	disable-big-bubble!
	robot-boot!

robot-boot = !->
	robot-button = $ '#bottom-positioner'
	robot-button.[0].onclick = robot-start
	add-click-listener-for-all-little-buttons!

robot-start = !->
	for i from 0 to 4
		robot-click i

robot-click = (n)!->
	greys = $ \li
	greys[n].onclick event


set-unvisible-all-unreads = !->
	reds = $ '.unread'
	for i from 0 to reds.length-1
		set-unvisible reds.[i]

add-click-listener-for-all-little-buttons = !->
	greys = $ \li
	for i from 0 to greys.length - 1
		/*do*/  /*(i) -> 
			(i) !-> do */
		enable greys[i]

set-unvisible = (red) !->
	$(red) .css 'display', 'none'

set-visible = (red) !->
	$(red) .css 'display', ''

get-ran = (red, grey)!->
	$.get('/?random=' + Math.random(), (data, status) !-> 
					$(red).html(data)
					check-and-set(red, grey))
	/*data = $.ajax({url:"/", success: !->
		$(red).html(data.responseText)
		check-and-set(red, grey)
	})*/
	
	/*xmlhttp = new XMLHttpRequest()
	xmlhttp.onreadystatechange  = !->
		if xmlhttp.readyState==4 && xmlhttp.status==200
			$(red).html(xmlhttp.responseText)
			check-and-set(red, grey)
	xmlhttp.open("GET","/",true)
	xmlhttp.send()*/
	

check-and-set = (red, grey) !->
	greys = $ \li
	check-all = true
	for i from 0 to greys.length - 1
		/*if ! $(greys[i]).hasClass 'checked'
			enable greys[i]*/
		red = greys[i].getElementsByClassName('unread').[0]
		if $(red).html() == "" || $(red).html() ==  '...'
			check-all = false
	$(grey).addClass 'checked'
	disable grey
	if check-all
		bubble = $ '#info-bar'
		enable-big-bubble(bubble)



click-listener = !->
	red = @getElementsByClassName('unread').[0]
	set-waiting-style(red)
	get-ran(red, @)
	set-visible red
	greys = $ 'li'
	/*for i from 0 to greys.length - 1 
		disable(greys[i])*/
	enable(@)

enable = (grey) !->
	$(grey).css('backgroundColor', 'blue')
	/*$(grey).click(click-listener)*/
	grey.onclick = click-listener

disable = (grey) !->
	$(grey).css('backgroundColor', 'grey')
	grey.onclick = null

disable-big-bubble = !->
	bubble = $ '#info-bar'
	$(bubble).css('backgroundColor', 'grey')
	bubble.onclick = null

bubble-listener = !->
	greys = $ 'li'
	sum = 0
	for i from 0 to greys.length - 1
		red = greys[i].getElementsByClassName('unread').[0]
		sum += Number(red.innerHTML)
	this.innerHTML = sum

enable-big-bubble = (bubble) !->
	$(bubble).css('backgroundColor', 'blue')
	bubble.[0].onclick = bubble-listener
	bubble.[0].onclick event


set-waiting-style = (red) !->
	$(red).html('...')

