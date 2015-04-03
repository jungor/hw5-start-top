$ = (id) -> document.getElementById id
$$ = (tag) -> document.getElementsByTagName tag


window.onload = ->
	$('info-bar').className = 'bubbleDisable'
	$('info-bar').onclick = ->
		@innerHTML = result if flag is 'DONE' and result
		@className = 'bubbleDisable'

	$('button').onmouseout = ->
		e = window.event
		reltg = (if e.relatedTarget then e.relatedTarget else e.toElement)
		while reltg and reltg isnt this 
			reltg = reltg.parentNode 
		reset() if reltg isnt this


	document.getElementsByClassName('icon')[0].onclick = -> 
		reset()
		robot()

	addClickHandlerToAllButtons()


result = 0
flag = 'LOADING'
robotIsWorking = false


enableButtons = ->
	for item in $$ 'button'
		item.disabled = '' 
		item.className = 'active'


reset = ->
	result = 0
	flag = 'LOADING'
	robotIsWorking = false

	$('info-bar').innerHTML = ''
	$('info-bar').className = 'bubbleDisable'

	for button in $$ 'button'
		button.className = 'active'
		button.disabled = ''
		button.removeChild button.getElementsByTagName('span')[0] if button.getElementsByTagName('span')[0]?


addClickHandlerToAllButtons = ->
	for item in $$('button') 
		item.onclick = -> 
			@innerHTML = @innerHTML + "<span class='unread'>...</span>"
			@disabled = 'disabled'
			for otherItem in $$ 'button' when otherItem isnt this
				if not otherItem.getElementsByTagName('span')[0]
					otherItem.className = 'disable'
					otherItem.disabled = 'disabled'
			makeRequest(@id)


makeRequest = (id) ->
	xmlHttp = new XMLHttpRequest()
	xmlHttp.onreadystatechange = ->
		callback(xmlHttp.responseText, id) if xmlHttp.readyState is 4 and xmlHttp.status is 200
	xmlHttp.open 'GET','/',true
	xmlHttp.send null


callback = (number, id) ->
	thisButton = $ id
	if thisButton.getElementsByTagName('span')[0]
		thisButton.innerHTML = thisButton.innerHTML.replace '...', number
		thisButton.className = 'disable' 
		thisButton.disabled = 'disabled'

		flag = 'DONE'
		for otherItem in $$ 'button'
			if otherItem isnt thisButton and not otherItem.getElementsByTagName('span')[0] or otherItem.getElementsByTagName('span')[0].innerHTML is '...'
				otherItem.className = 'active'
				otherItem.disabled = '' 
				flag = 'LOADING'

		result += parseInt number
		displayResultOnBubble() if flag is 'DONE'
		robot() if robotIsWorking and flag is 'DONE'


displayResultOnBubble = ->
	$('info-bar').className = 'bubbleActive'


robot = () ->
	robotIsWorking = true
	if flag is 'LOADING'
		for item in $$ 'button' 
			item.click()
			enableButtons()
	$('info-bar').click() if flag is 'DONE'


