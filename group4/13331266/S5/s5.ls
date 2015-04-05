window.onload = !->
	make-all-button-can-be-clicked!
	$ "button" .onmouseleave = reborn-all-buttons
	$ "icon" .onclick = robot-click-A-to-E
	
robot-click-A-to-E = !->
	$ "icon" .onclick = ""
	order = get-order!
	s5-callback order, 0, 0

get-order = ->
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
	$ "info" .style.fontSize = \16px
	return str

s5-callback = (order, count, currentSum) !-> # count for how many buttons have been clicked
	abcde = $ "control-ring" .children
	thisbutton = parseInt order[count]
	abcde[thisbutton].onclick order, count, currentSum, event
			

make-all-button-can-be-clicked = !->
	abcde = $ "control-ring" .children
	abcde[0].onclick = A-handler
	abcde[1].onclick = B-handler
	abcde[2].onclick = C-handler
	abcde[3].onclick = D-handler
	abcde[4].onclick = E-handler # better use loop to deal with thousands of buttons

reborn-all-buttons = !->
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length		
		make-button-enable abcde[i]
	bubble = $ "info"
	bubble.style.backgroundColor = \grey
	bubble.innerHTML= ""
	$ "icon" .onclick = robot-click-A-to-E
	for i from 0 til abcde.length		
		abcde[i].style.backgroundColor = \blue

make-button-disable = (button) !->
	button.onclick = ""
	button.style.backgroundColor = \grey

make-button-enable = (button) !->
	if button.childNodes.length is 2
		button.removeChild button.childNodes[1]
	abcde = $ "control-ring" .children
	if abcde[0] is button
		abcde[0].onclick = A-handler
	if abcde[1] is button
		abcde[1].onclick = B-handler
	if abcde[2] is button
		abcde[2].onclick = C-handler
	if abcde[3] is button
		abcde[3].onclick = D-handler
	if abcde[4] is button
		abcde[4].onclick = E-handler # better use loop to deal with thousands of buttons
	button.style.backgroundColor = \blue 

A-handler = (order, count, currentSum)!->
	try
		rc = document.createElement \span
		rc.innerText = \...
		rc.className = \redcircle
		rc.style.fontSize=\5px
		@appendChild(rc)
		thisorder = order
		thissum = currentSum
		abcde = $ "control-ring" .children
		for i from 0 til abcde.length
			if abcde[i] isnt @
				make-button-disable abcde[i]
		thisbutton = @
		if Math.random! > 0.8
			throw "这不是个天大的秘密" #wrong
		message = \这是个天大的秘密
		bubble-handler message, currentSum
	catch err
		bubble-handler err, currentSum
	if window.XMLHttpRequest
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject \Microsoft.XMLHTTP
	xmlhttp.onreadystatechange = !->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			rc.innerText = xmlhttp.responseText
			thissum := thissum + parseInt xmlhttp.responseText
			flag = 1
			abcde = $ "control-ring" .children
			for i from 0 til abcde.length
				if abcde[i].childNodes.length is 1
					make-button-enable abcde[i]
					flag = 0
			make-button-disable thisbutton
			if flag is 1
				bubble-handler \caculate, thissum
			count++
			if count isnt 5 and check-mouse-leave! is 0
				s5-callback thisorder, count, thissum
	xmlhttp.open \GET \/ true
	xmlhttp.send()

B-handler = (order, count, currentSum)!->
	try
		rc = document.createElement \span
		rc.innerText = \...
		rc.className = \redcircle
		rc.style.fontSize=\5px
		@appendChild(rc)
		thisorder = order
		thissum = currentSum
		abcde = $ "control-ring" .children
		for i from 0 til abcde.length
			if abcde[i] isnt @
				make-button-disable abcde[i]
		thisbutton = @
		if Math.random! > 0.8
			throw "我知道" #wrong
		message = \我不知道
		bubble-handler message, currentSum
	catch err
		bubble-handler err, currentSum
	if window.XMLHttpRequest
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject \Microsoft.XMLHTTP
	xmlhttp.onreadystatechange = !->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			rc.innerText = xmlhttp.responseText
			thissum := thissum + parseInt xmlhttp.responseText
			flag = 1
			abcde = $ "control-ring" .children
			for i from 0 til abcde.length
				if abcde[i].childNodes.length is 1
					make-button-enable abcde[i]
					flag = 0
			make-button-disable thisbutton
			if flag is 1
				bubble-handler \caculate, thissum
			count++
			if count isnt 5 and check-mouse-leave! is 0
				s5-callback thisorder, count, thissum
	xmlhttp.open \GET \/ true
	xmlhttp.send()

C-handler = (order, count, currentSum)!->
	try
		rc = document.createElement \span
		rc.innerText = \...
		rc.className = \redcircle
		rc.style.fontSize=\5px
		@appendChild(rc)
		thisorder = order
		thissum = currentSum
		abcde = $ "control-ring" .children
		for i from 0 til abcde.length
			if abcde[i] isnt @
				make-button-disable abcde[i]
		thisbutton = @
		if Math.random! > 0.8
			throw "你知道" #wrong
		message = \你不知道
		bubble-handler message, currentSum
	catch err
		bubble-handler err, currentSum
	if window.XMLHttpRequest
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject \Microsoft.XMLHTTP
	xmlhttp.onreadystatechange = !->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			rc.innerText = xmlhttp.responseText
			thissum := thissum + parseInt xmlhttp.responseText
			flag = 1
			abcde = $ "control-ring" .children
			for i from 0 til abcde.length
				if abcde[i].childNodes.length is 1
					make-button-enable abcde[i]
					flag = 0
			make-button-disable thisbutton
			if flag is 1
				bubble-handler \caculate, thissum
			count++
			if count isnt 5 and check-mouse-leave! is 0
				s5-callback thisorder, count, thissum
	xmlhttp.open \GET \/ true
	xmlhttp.send()

D-handler = (order, count, currentSum)!->
	try
		rc = document.createElement \span
		rc.innerText = \...
		rc.className = \redcircle
		rc.style.fontSize=\5px
		@appendChild(rc)
		thisorder = order
		thissum = currentSum
		abcde = $ "control-ring" .children
		for i from 0 til abcde.length
			if abcde[i] isnt @
				make-button-disable abcde[i]
		thisbutton = @
		if Math.random! > 0.8
			throw "他知道" #wrong
		message = \他不知道
		bubble-handler message, currentSum
	catch err
		bubble-handler err, currentSum
	if window.XMLHttpRequest
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject \Microsoft.XMLHTTP
	xmlhttp.onreadystatechange = !->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			rc.innerText = xmlhttp.responseText
			thissum := thissum + parseInt xmlhttp.responseText
			flag = 1
			abcde = $ "control-ring" .children
			for i from 0 til abcde.length
				if abcde[i].childNodes.length is 1
					make-button-enable abcde[i]
					flag = 0
			make-button-disable thisbutton
			if flag is 1
				bubble-handler \caculate, thissum
			count++
			if count isnt 5 and check-mouse-leave! is 0
				s5-callback thisorder, count, thissum
	xmlhttp.open \GET \/ true
	xmlhttp.send()

E-handler = (order, count, currentSum)!->
	try
		rc = document.createElement \span
		rc.innerText = \...
		rc.className = \redcircle
		rc.style.fontSize=\5px
		@appendChild(rc)
		thisorder = order
		thissum = currentSum
		abcde = $ "control-ring" .children
		for i from 0 til abcde.length
			if abcde[i] isnt @
				make-button-disable abcde[i]
		thisbutton = @
		if Math.random! > 0.8
			throw "才不怪" #wrong
		message = \才怪
		bubble-handler message, currentSum
	catch err
		bubble-handler err, currentSum
	if window.XMLHttpRequest
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject \Microsoft.XMLHTTP
	xmlhttp.onreadystatechange = !->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			rc.innerText = xmlhttp.responseText
			thissum := thissum + parseInt xmlhttp.responseText
			flag = 1
			abcde = $ "control-ring" .children
			for i from 0 til abcde.length
				if abcde[i].childNodes.length is 1
					make-button-enable abcde[i]
					flag = 0
			make-button-disable thisbutton
			if flag is 1
				bubble-handler \caculate, thissum
			count++
			if count isnt 5 and check-mouse-leave! is 0
				s5-callback thisorder, count, thissum
	xmlhttp.open \GET \/ true
	xmlhttp.send()


bubble-handler = (message, currentSum) !->
	if message is \caculate
		bubble = $ "info"
		bubble.style.fontSize = \16px
		bubble.style.lineHight = \20px
		bubble.style.overFlow = \visible
		bubble.innerHTML = "楼主异步调用战斗力感人,\n目测不超过 " + currentSum
	else
		bubble = $ "info"
		bubble.innerHTML = message

# an effort to make perfect reset, but I failed :(
check-mouse-leave = ->
	area = $ "button"
	x=event.clientX;
	y=event.clientY;  
	divx1 = area.offsetLeft;  
	divy1 = area.offsetTop;  
	divx2 = area.offsetLeft + area.offsetWidth;  
	divy2 = area.offsetTop + area.offsetHeight;  
	if x < divx1 or x > divx2 or y < divy1 or y > divy2
		return 1
	return 0