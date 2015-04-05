$ = (id) -> document.getElementById id
$$ = (classN) -> document.getElementsByClassName classN

window.onload = ->
	buttons = $$ 'button'
	info_bar = $ 'info-bar'
	getRandomNumbers(buttons, info_bar)

getRandomNumbers = (buttons, info_bar)->
	for button in $$ 'button'
		button.onclick = ->
				@childNodes[1].classList.add 'opacity'
				@childNodes[1].innerHTML = '...'
				disableOtherButtons(buttons, @id)
				getRandomNumberFromServer(@id)

disableOtherButtons = (buttons, id) ->
	clickedButton = $ id
	for button in buttons when button isnt clickedButton
		button.disabled = 1
		button.classList.add 'grey'

getRandomNumberFromServer = (id) ->
	xmlhttp = new XMLHttpRequest()
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
	for button in buttons
		sum += parseInt button.childNodes[1].innerHTML
	@innerHTML = sum
	@disable = 1
	@classList.add 'grey'
	$('button').onmouseout = resetCalculator

resetCalculator = ->
	info_bar = $ 'info-bar'
	info_bar.disabled = 1
	info_bar.innerHTML = ''
	info_bar.classList.toggle 'grey', true
	buttons = $$ 'button'
	for button in buttons
		button.classList.toggle 'grey', false
		button.childNodes[1].classList.toggle 'opacity', false
		button.disabled = 0
