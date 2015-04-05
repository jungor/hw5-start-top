$ = (id) -> document.getElementById id
$$ = (classN) -> document.getElementsByClassName classN

window.onload = ->
	info_bar = $ 'info-bar'
	buttons = $$ 'button'
	$$('apb').disabled = 0
	$('apb').onclick = ->
		@disabled = 1
		getRNumAtTheSameTime()

	getRandomNumbers()
	$('bottom-positioner').onmouseleave = resetCalculator

getRandomNumbers = ->
	info_bar = $ 'info-bar'
	buttons = $$ 'button'
	for button in buttons
		button.onclick = ->
			getRandomNumber(buttons, @id)

getRNumAtTheSameTime = ->
	info_bar = $ 'info-bar'
	buttons = $$ 'button'
	$('apb').disabled = 1
	for button in buttons
		getRandomNumber(buttons, button.id)


getRandomNumber = (buttons, id) ->
	button = $ id
	button.childNodes[1].classList.add 'opacity'
	button.childNodes[1].innerHTML = "..."
	disableOtherButtons(buttons, id)
	getRandomNumberFromServer(id)

getRandomNumberFromServer = (id) ->
	xmlhttp = new XMLHttpRequest()
	xmlhttp.onreadystatechange = ->
		if xmlhttp.readyState is 4 and xmlhttp.status is 200
			returnRandomNumber(xmlhttp.responseText, id)
			xmlhttp = null
	realUrl = '../server' + "?time=" + new Date().getTime()
	realUrl = encodeURI(encodeURI(realUrl))
	xmlhttp.open 'GET',realUrl,true
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

disableOtherButtons = (buttons, id) ->
	clickedButton = $ id
	for button in buttons when button isnt clickedButton
		button.disabled = 1
		button.classList.add 'grey'

enableOtherButtons = (buttons, clickedButton) ->
	for button in buttons
		if button isnt clickedButton and not button.childNodes[1].classList.contains 'opacity'
			button.disabled = 0
			button.classList.remove 'grey'

isInfo_barActive = (info_bar, buttons) ->
	flag = true
	for button in buttons
		if button.childNodes[1].innerHTML is '' or button.childNodes[1].innerHTML is '...'
			flag = false 

	if flag is true
		info_bar.disabled = 0
		info_bar.classList.remove 'grey'
		info_bar.onclick = Sum
		Sum()
	return flag

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
