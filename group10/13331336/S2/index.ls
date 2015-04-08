get-number = (this_id, callback)!->
	if window.XMLHttpRequest
		request = new XMLHttpRequest!
	else
		request = new ActiveXObject \Microsoft.XMLHTTP
	request.open("GET","/" + this_id,true)
	request.onreadystatechange = !->
		if request.readyState==4 and request.status==200
			$("#" + this_id)[0].innerHTML=request.responseText
			enable-other-button(this_id)
			if all-button-done!
				add-info-click!
			callback?!
	request.send!

enable-other-button = (this_id)->
	lis = $ \.plank
	number = $ \.number
	for i from 0 to 4
		if number[i].classList.contains \appear
			lis[i].style.backgroundColor = \gray
		else
			lis[i].style.backgroundColor = 'rgba(48,63,159,.8)'

disable-other-button = (this_id)->
	lis = $ \.plank
	[lis[i].style.backgroundColor = \gray for i from 0 to 4 when i isnt this_id]

show-number = (this_id)->
	number = $ \.number
	number[this_id].classList.remove \disappear
	number[this_id].classList.add \appear

all-button-done = ->
	number = $ \.number
	[return false for i from 0 to 4 when number[i].innerHTML is \...]
	true

button-click = (this_id)->
	buttons = $ \.letter
	number = $ \.number
	lis = $ \.plank
	if number[this_id].style.display is \block
		return
	if lis[this_id].style.backgroundColor is \gray
		return
	show-number(this_id)
	disable-other-button(this_id)
	get-number(this_id,buttons[this_id].callback)

add-button-click = ->
	buttons = $ \.letter
	for i from 0 to 4
		buttons[i].Index = i
		buttons[i].onclick = ->
			button-click(@Index)

add-info-click = !->
	buttons = $ \.letter
	$(\#info-bar)[0].onclick = !->
		if all-button-done! isnt true
			return
		number = $ \.number
		k = 0
		[k += parseInt(number[i].innerHTML) for i from 0 to 4]
		$(\#big)[0].innerHTML = k

reset-number = ->
	number = $ \.number
	for i from 0 to 4
		number[i].innerHTML = \...
		number[i].classList.add \disappear
		number[i].classList.remove \appear

reset-buttons = ->
	enable-other-button(-1)
	reset-number!

reset-info = ->
	$(\#big)[0].innerHTML = ""

reset = ->
	reset-buttons!
	reset-info!
	$(\.apb)[0].state = \enable

robot = !->
	$(\.apb)[0].onclick = !->
		robot-action()

robot-action = !->
	buttons = $ \.letter
	for let i from 0 to 3
		buttons[i].callback = ->
			buttons[i + 1].click!
	buttons[4].callback = ->
		$(\#info-bar)[0].click!
	buttons[0].click!

window.onload = !->
	reset!
	robot!
	add-button-click!
	add-info-click!
	$(\#at-plus-container)[0].onmouseleave = reset