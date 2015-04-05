$ = (id) -> document.getElementById id
$$ = (classN) -> document.getElementsByClassName classN
xmlhttp = new XMLHttpRequest()
arr = new Array(0, 1, 2, 3, 4)

window.onload = ->
	info_bar = $ 'info-bar'
	buttons = $$ 'button'
	$('apb').onclick = ->
		arr.sort(randomsort)
		@disabled = 1
		resetCalculator()
		autoClickInRandomOrder(0)
	getRandomNumbers(buttons, info_bar)

randomsort = (a, b) ->
	return Math.random()>.5 ? -1 : 1;

autoClickInRandomOrder = (k) ->
	buttons = $$ 'button'
	$('text').innerHTML = buttons[arr[0]].value + ' ' + buttons[arr[1]].value + ' ' + buttons[arr[2]].value + ' ' + buttons[arr[3]].value + ' ' + buttons[arr[4]].value
	if k >= buttons.length
		Sum()
		return
	buttons[arr[k]].childNodes[1].classList.add 'opacity'
	buttons[arr[k]].childNodes[1].innerHTML = "..."
	disableOtherButtons(buttons, buttons[arr[k]].id)
	ajax((rNum)->
		buttons[arr[k]].childNodes[1].innerHTML = rNum
		buttons[arr[k]].classList.add('grey')
		buttons[arr[k]].disabled = 1
		enableOtherButtons(buttons, buttons[arr[k]].id)
		autoClickInRandomOrder(k+1)
	)

ajax = (callback) ->
	xhr = new XMLHttpRequest()
	xhr.open 'GET', '../server', true
	xhr.send()
	xhr.onreadystatechange = ->
		if xhr.readyState is 4 and xhr.status is 200
			callback(xhr.responseText)


getRandomNumbers = (buttons, info_bar) ->
	for button in buttons
		button.onclick = ->
			getRandomNumber(@id)

getRandomNumber = (id) ->
	button = $ id
	buttons = $$ 'button'
	button.childNodes[1].classList.add 'opacity'
	button.childNodes[1].innerHTML = "..."
	disableOtherButtons(buttons, id)
	getRandomNumberFromServer(id)

disableOtherButtons = (buttons, id) ->
	clickedButton = $ id
	for button in buttons when button isnt clickedButton
		button.disabled = 1
		button.classList.add 'grey'

getRandomNumberFromServer = (id) ->
	xmlhttp.onreadystatechange = ->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			returnRandomNumber(xmlhttp.responseText, id)
	xmlhttp.open 'GET','../server',true
	xmlhttp.send()

returnRandomNumber = (rNum, id) ->
	clickedButton = $ id
	buttons = $$ 'button'
	info_bar = $ 'info-bar'
	clickedButton.childNodes[1].innerHTML = rNum
	clickedButton.classList.add 'grey'
	clickedButton.disabled = 1
	enableOtherButtons(buttons, clickedButton)
	isInfo_barActive(info_bar, buttons)

enableOtherButtons = (buttons, clickedButton) ->
	for button in buttons
		if button isnt clickedButton and not button.childNodes[1].classList.contains 'opacity'
			button.disabled = 0
			button.classList.remove 'grey'

isInfo_barActive = (info_bar, buttons) ->
	flag = true
	for button in buttons
		flag = false if not button.childNodes[1].classList.contains 'opacity'

	if flag is true
		info_bar.disabled = 0
		info_bar.classList.remove 'grey'
		info_bar.onclick = Sum

Sum = ->
	sum = 0
	buttons = $$ 'button'
	info_bar = $ 'info-bar'
	for button in buttons
		sum += parseInt button.childNodes[1].innerHTML
	info_bar.innerHTML = sum
	info_bar.disable = 1
	info_bar.classList.add 'grey'
	$('button').onmouseout = resetCalculator

resetCalculator = ->
	xmlhttp.abort()
	$('text').innerHTML = ''
	info_bar = $ 'info-bar'
	info_bar.disabled = 1
	info_bar.innerHTML = ''
	info_bar.classList.toggle 'grey', true
	apb = $ 'apb'
	apb.disabled = 0;
	buttons = $$ 'button'
	for button in buttons
		button.classList.toggle 'grey', false
		button.childNodes[1].classList.toggle 'opacity', false
		button.disabled = 0
