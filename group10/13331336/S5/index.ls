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

button-click = (this_id) !->
	buttons = $ \.letter
	number = $ \.number
	lis = $ \.plank
	if number[this_id].style.display is \block
		return
	if lis[this_id].style.backgroundColor is "gray"
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

reset-info = !->
	$(\#rdorder)[0].innerHTML = ""
	$(\#big)[0].innerHTML = ""
	$(\#message)[0].innerHTML = ""

reset = !->
	reset-buttons!
	reset-info!
	$(\.apb)[0].state = \enable
	robot.state = 'enable'

robot = !->
	$(\.apb)[0].onclick = !->
		if robot.state is \disable
			return
		robot.state = \disable
		buttons = $ \.letter
		order = [0 to 4]
		information = ['A' to 'E']
		order.sort ->
			0.5 - Math.random!
		$('#rdorder')[0].innerHTML = information[order[0]] + information[order[1]] + information[order[2]] + information[order[3]] + information[order[4]];
		robot_action(order, 0)

robot-action = (order, index) !->
	if robot.state is \disable
		if index == 5
			bubble_handler!
			return
		else
			callback = ->
				robot_action(order, index + 1)
		switch order[index]
		case 0 then a_handler(callback)
		case 1 then b_handler(callback)
		case 2 then c_handler(callback)
		case 3 then d_handler(callback)
		case 4 then e_handler(callback)

window.onload = ->
	reset!
	robot!
	add-button-click!
	add-info-click!
	$(\#at-plus-container)[0].onmouseleave = reset

is-failed = ->
	Math.random() > 0.6;

a-handler = (callback)->
	if is_failed!
		$(\#message)[0].innerHTML = \这不是个天大的秘密
		console.log "A Fail:这不是个天大的秘密"
		callback?!
	else
		$(\#message)[0].innerHTML = \这是个天大的秘密
		console.log "A Success:这是个天大的秘密"
		buttons = $ \.letter
		number = $ \.number
		lis = $ \.plank
		show-number(0)
		disable-other-button(0)
		getnumber(0, callback)

b-handler = (callback)->
	if is-failed!
		$(\#message)[0].innerHTML = \我知道
		console.log "B Fail:我知道"
		callback?!
	else
		$(\#message)[0].innerHTML = \我不知道
		console.log "B Success:我不知道"
		buttons = $ \.letter
		number = $ \.number
		lis = $ \.plank
		show-number(1)
		disable-other-button(1)
		getnumber(1, callback)

c-handler = (callback)->
	if is_failed!
		$(\#message)[0].innerHTML = \你知道
		console.log "C Fail:你知道"
		callback?!
	else
		$(\#message)[0].innerHTML = \你不知道
		console.log "C Success:你不知道"
		buttons = $ \.letter
		number = $ \.number
		lis = $ \.plank
		show-number(2)
		disable-other-button(2)
		getnumber(2, callback)

d-handler = (callback)->
	if is_failed!
		$(\#message)[0].innerHTML = \他知道
		console.log "D Fail:他知道"
		callback?!
	else
		$(\#message)[0].innerHTML = \他不知道
		console.log "D Success:他不知道"
		buttons = $ \.letter
		number = $ \.number
		lis = $ \.plank
		show-number(3)
		disable-other-button(3)
		getnumber(3, callback)

e-handler = (callback)->
	if is_failed!
		$(\#message)[0].innerHTML = \不怪
		console.log "E Fail:不怪"
		callback?!
	else
		$(\#message)[0].innerHTML = \这是个天大的秘密
		console.log "A Success:这是个天大的秘密"
		buttons = $ \.letter
		number = $ \.number
		lis = $ \.plank
		show-number(4)
		disable-other-button(4)
		getnumber(4, callback)

bubble-handler = ->
	buttons = $ \.letter
	number = $ \number
	sum = 0
	[sum += parseInt(number[i].innerHTML) for i from 0 to 4 when number[i].innerHTML isnt '...']
	$(\#big)[0].innerHTML = sum
	$(\#message)[0].innerHTML = \楼主异步调用战斗力感人，目测不超过