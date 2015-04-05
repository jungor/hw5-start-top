window.onload = !->
	make-all-button-can-be-clicked!
	$ "button" .onmouseleave = reborn-all-buttons

make-all-button-can-be-clicked = !->
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length
		abcde[i].addEventListener \click get-number


reborn-all-buttons = !->
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length
		if abcde[i].childNodes.length is 2
			abcde[i].removeChild abcde[i].childNodes[1]
		make-button-enable abcde[i]
	bubble = $ "info"
	bubble.removeEventListener \click get-result
	bubble.style.backgroundColor = \grey
	bubble.innerHTML= ""

make-button-disable = (button) !->
	button.removeEventListener \click get-number
	button.style.backgroundColor = \grey

make-button-enable = (button) !->
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
			wait-number thisbutton
	xmlhttp.open \GET \/ true
	xmlhttp.send()

/*sent-request-to-server = (rc, thisbutton) !->
	$.get('/', (data, status) !->
					rc.innerText = xmlhttp.data
					wait-number thisbutton)*/
# above is trying to make it shorter by jquery, but I failed...
wait-number = (thisbutton) !->
	flag = 1
	abcde = $ "control-ring" .children
	for i from 0 til abcde.length
		if abcde[i].childNodes.length is 1
			make-button-enable abcde[i]
			flag = 0
		make-button-disable thisbutton
		if flag is 1
			result = $ "info"
			result.addEventListener \click get-result;
			result.style.backgroundColor = \blue;

get-result = !->
	abcde = $ "control-ring" .children
	sum = 0
	for i from 0 til abcde.length
		sum = sum + parseInt abcde[i].lastChild.innerText
	@innerHTML = sum
	@removeEventListener \click get-result
	@style.backgroundColor = \grey



