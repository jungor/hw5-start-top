window.onload = !->
	make-all-button-can-be-clicked!
	$ "button" .onmouseleave = reborn-all-buttons
	$ "icon" .addEventListener \click robot-click-A-to-E
	
newOrder = 1
robot-click-A-to-E = !->
	$ "icon" .removeEventListener \click robot-click-A-to-E
	order = get-order!
	newOrder := order
	s2-callback order


get-order = ->
	if newOrder is 1
		hash = []
		for i from 0 til 5
			hash[i] = 0
		str = ""
		n = 0
		while n < 5
			random = Math.floor Math.random! * 5
			if hash[random] is 0
				n++
				hash[random] = 1
				str = str + random.toString!
		order = ""
		for i from 0 til 5
			if str[i] is \0
				order = order+\A
			else if str[i] is \1
				order = order+\B
			else if str[i] is \2
				order = order+\C
			else if str[i] is \3
				order = order+\D
			else if str[i] is \4
				order = order+\E
		$ "info" .style.fontSize = \32px
		$ "info" .innerHTML = order
	return str
	
s2-callback = (order) !->
	if order isnt \1
		abcde = $ "control-ring" .children
		for i from 0 til abcde.length
			thisbutton = parseInt order[i]
			if abcde[thisbutton].childNodes.length is 1
				abcde[thisbutton].click!
				return

make-all-button-can-be-clicked = !->
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length
		abcde[i].addEventListener \click get-number


reborn-all-buttons = !->
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length		
		make-button-enable abcde[i]
	bubble = $ "info"
	bubble.removeEventListener \click get-result
	bubble.style.backgroundColor = \grey
	bubble.innerHTML= ""
	$ "icon" .addEventListener \click robot-click-A-to-E
	for i from 0 til abcde.length		
		abcde[i].style.backgroundColor = \blue
	newOrder := 1

make-button-disable = (button) !->
	button.removeEventListener \click get-number
	button.style.backgroundColor = \grey

make-button-enable = (button) !->
	if button.childNodes.length is 2
		button.removeChild button.childNodes[1]
	button.addEventListener \click get-number
	button.style.backgroundColor = \blue

get-number = !->
	rc = document.createElement \span
	rc.innerText = \...
	rc.className = \redcircle
	rc.style.fontSize=\5px
	@appendChild(rc)
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length
		if abcde[i] isnt @
			make-button-disable abcde[i]
	thisbutton = @
	/* sent-request-to-server rc,thisbutton */

	if window.XMLHttpRequest
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject \Microsoft.XMLHTTP
	xmlhttp.onreadystatechange = !->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			rc.innerText = xmlhttp.responseText
			wait-number thisbutton, newOrder
	xmlhttp.open \GET \/ true
	xmlhttp.send()
/*sent-request-to-server = (rc, thisbutton) !->
	$.get('/', (data, status) !->
					rc.innerText = xmlhttp.data
					wait-number thisbutton)*/
# above is trying to make it shorter by jquery, but I failed...
wait-number = (thisbutton, order) !->
	flag = 1
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length
		if abcde[i].childNodes.length is 1
			make-button-enable abcde[i]
			flag = 0
	make-button-disable thisbutton
	if flag is 1
		result = $ "info"
		get-result result
	s2-callback order

get-result = (bubble) !->
	abcde = $ "control-ring" .children
	sum = 0
	for i from 0 til abcde.length
		sum = sum + parseInt abcde[i].lastChild.innerText
	bubble.innerHTML = sum