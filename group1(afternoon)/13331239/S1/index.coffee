$ = (id) -> document.getElementById id
$$ = (className) -> document.getElementsByClassName className

window.onload = ->
	bigButton = $('big-bar')
	btn = $('button')
	hoverArea = $('at-plus-container')
	buttons = $$('button')
	bigButton.disabled = 1
	resetCalculator()
	bigButton.onclick = -> calculateSum()
	btn.onmouseout = -> 
		e = window.event
		reltg = (if e.relatedTarget then e.relatedTarget else e.toElement)
		while reltg and reltg isnt this 
			reltg = reltg.parentNode
		resetCalculator() if reltg isnt this
	getRandomNunber(bigButton, buttons)

connectServer = (id) ->
	xmlHttp = new XMLHttpRequest()
	xmlHttp.open 'GET', '../server',true
	xmlHttp.send null
	xmlHttp.onreadystatechange = ->
		callback(xmlHttp.responseText, id) if xmlHttp.readyState is 4 and xmlHttp.status is 200

getRandomNunber = (bigButton, buttons) ->
	for item in buttons
		item.onclick = ->
			@childNodes[1].classList.add('waiting')
			@childNodes[1].innerHTML = '...'
			disableOtherButtons(buttons, @)
			connectServer(@id)

callback = (number, id) ->
	thisButton = $ id
	thisButton.childNodes[1].innerHTML = number
	thisButton.classList.add('inactive')
	thisButton.disabled = 1
	enableOtherButtons(thisButton)
	ifActivateBigButton()

disableOtherButtons = (buttons, button) ->
	for item in buttons
		if item isnt button
			item.classList.add('inactive')
			item.disabled = 1

enableOtherButtons = (button) ->
	buttons = $$('button')
	for item in buttons
		if item isnt button and !item.childNodes[1].classList.contains('waiting')
			item.classList.remove('inactive')
			item.disabled = 0
		
ifActivateBigButton = ->
	buttons = $$('button')
	bigButton = $('big-bar')
	for item in buttons
		if !item.childNodes[1].classList.contains('waiting')
			return
	bigButton.disabled = 0
	bigButton.classList.remove('inactive')

calculateSum = ->
	buttons = $$('button')
	bigButton = $('big-bar')
	sum = 0
	for item in buttons
		sum += parseInt(item.childNodes[1].innerHTML)

	bigButton.innerHTML = sum
	bigButton.disabled = 1
	bigButton.classList.add('inactive')

resetCalculator = ->
	buttons = $$('button')
	bigButton = $('big-bar')

	bigButton.disabled = 1;
	bigButton.innerHTML = ''
	bigButton.classList.toggle('inactive', true)

	for item in buttons
		item.disabled = 0
		item.classList.toggle('inactive', false)
		item.childNodes[1].classList.toggle('waiting', false)