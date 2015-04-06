get-number = (this_id)!->
	request = new XMLHttpRequest!
	request.onreadystatechange = !->
		if request.readyState==4 and request.status==200
			$("#" + this_id)[0].innerHTML=request.responseText
			enable-other-button(this_id)
			if all-button-done!
				add-info-click!
	request.open("GET","/" + this_id,true)
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
	get-number(this_id)

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

window.onload = ->
	reset!
	add-button-click!
	add-info-click!
	$(\#at-plus-container)[0].onmouseleave = reset