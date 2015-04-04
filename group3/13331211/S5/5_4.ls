
window.onload = !->
	set-unvisible-all-unreads!
	disable-big-bubble!
	robot-boot!

robot-boot = !->
	robot-button = $ '#bottom-positioner'
	robot-button.[0].onclick = robot-start


ah = (n, randoms, total, handlers)!->
	try
		red = @getElementsByClassName('unread').[0]
		set-waiting-style(red)
		get-ran red, @, n, randoms, total, handlers
		set-visible red
		greys = $ 'li'
		for i from 0 to greys.length - 1 
			disable(greys[i])
		enable(@, handlers[randoms[n]])
		if Math.random() > 0.8
			throw message:'这不是个秘密'
		else 
			mes = '这是个秘密'
			set-mes mes
	catch error
		set-mes error.message
	  
	

bh = (n, randoms, total, handlers)!->
	try
		red = @getElementsByClassName('unread').[0]
		set-waiting-style(red)
		get-ran red, @, n, randoms, total, handlers
		set-visible red
		greys = $ 'li'
		for i from 0 to greys.length - 1 
			disable(greys[i])
		enable(@, handlers[randoms[n]])
		if Math.random() > 0.8
			throw message:'你知道'
		else 
			mes = '你不知道'
			set-mes mes
	catch error
		set-mes error.message

ch = (n, randoms, total, handlers)!->
	try
		red = @getElementsByClassName('unread').[0]
		set-waiting-style(red)
		get-ran red, @, n, randoms, total, handlers
		set-visible red
		greys = $ 'li'
		for i from 0 to greys.length - 1 
			disable(greys[i])
		enable(@, handlers[randoms[n]])
		if Math.random() > 0.8
			throw message:'我知道'
		else 
			mes = '我不知道'
			set-mes mes
	catch error
		set-mes error.message

dh = (n, randoms, total, handlers)!->
	try
		red = @getElementsByClassName('unread').[0]
		set-waiting-style(red)
		get-ran red, @, n, randoms, total, handlers
		set-visible red
		greys = $ 'li'
		for i from 0 to greys.length - 1 
			disable(greys[i])
		enable(@, handlers[randoms[n]])
		if Math.random() > 0.8
			throw message:'他知道'
		else 
			mes = '他不知道'
			set-mes mes
	catch error
		set-mes error.message

eh = (n, randoms, total, handlers)!->
	try
		red = @getElementsByClassName('unread').[0]
		set-waiting-style(red)
		get-ran red, @, n, randoms, total, handlers
		set-visible red
		greys = $ 'li'
		for i from 0 to greys.length - 1 
			disable(greys[i])
		enable(@, handlers[randoms[n]])
		if Math.random() > 0.8
			throw message:'不怪'
		else 
			mes = '才怪'
			set-mes mes
	catch error
		set-mes error.message

robot-start = !->
	handlers = [ah, bh, ch, dh, eh]
	randoms = [0 to 4]
	randoms.sort ->
		Math.random() - 0.5
	show-randoms-in-big-bubble randoms
	enable-all-buttons handlers, randoms
	robot-click 0, randoms, 0, handlers

enable-all-buttons = (handlers, randoms)!->
	greys = $ \li
	for i from 0 to greys.length - 1
		enable greys[i],  handlers[randoms[i]]

show-randoms-in-big-bubble = (randoms) !->
	bubble = $ '#info-bar'
	str = ''
	ini = ['a', 'b', 'c', 'd', 'e']
	for i from 0 to randoms.length-1
		str += ini[randoms[i]]
	bubble.[0].innerHTML = str

robot-click = (n, randoms, total, handlers) !->
	greys = $ \li
	grey = greys[randoms[n]]
	grey.onclick n, randoms, total, handlers, event

set-unvisible-all-unreads = !->
	reds = $ '.unread'
	for i from 0 to reds.length-1
		set-unvisible reds.[i]


set-unvisible = (red) !->
	$(red) .css 'display', 'none'

set-visible = (red) !->
	$(red) .css 'display', ''

get-ran = (red, grey, n, randoms, total, handlers) !->
	$.get('/', (data, status) !-> 
					$(red).html(data)
					total += Number data
					check-and-set-and-continue-click red, grey, n, randoms, total, handlers)


check-and-set-and-continue-click = (red, grey, n, randoms, total, handlers) !->
	if ! check-and-set red, grey, total, handlers, randoms
		robot-click n+1, randoms, total, handlers

set-mes = (mes) !->
	bubble = $ '#info-bar'
	bubble.[0].innerHTML = mes

check-and-set = (red, grey, total, handlers, randoms) ->
	greys = $ \li
	check-all = true
	for i from 0 to greys.length - 1
		if ! $(greys[i]).hasClass 'checked'
			enable greys[i], handlers[randoms[i]]
		red = greys[i].getElementsByClassName('unread').[0]
		if $(red).html() == ""
			check-all = false
	$(grey).addClass 'checked'
	disable grey
	if check-all
		bubble = $ '#info-bar'
		enable-big-bubble(bubble, total)
	return check-all

click-listener = !->
	red = @getElementsByClassName('unread').[0]
	set-waiting-style(red)
	get-ran(red, @)
	set-visible red
	greys = $ 'li'
	for i from 0 to greys.length - 1 
		disable(greys[i])
	enable(@)

enable = (grey, handler) !->
	$(grey).css('backgroundColor', 'blue')
	/*$(grey).click(click-listener)*/
	grey.onclick = handler

disable = (grey) !->
	$(grey).css('backgroundColor', 'grey')
	grey.onclick = null

disable-big-bubble = !->
	bubble = $ '#info-bar'
	$(bubble).css('backgroundColor', 'grey')
	bubble.onclick = null

bubble-listener = (total) !->
	this.innerHTML = "楼主异步战斗力感人\n目测不超过:<div>" + total + "</div>" 

enable-big-bubble = (bubble, total) !->
	$(bubble).css('backgroundColor', 'blue')
	bubble.[0].onclick = bubble-listener
	bubble.[0].onclick total, event


set-waiting-style = (red) !->
	$(red).html('...')

