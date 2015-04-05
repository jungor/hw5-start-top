$ = (id) -> document.getElementById id
$$ = (tag) -> document.getElementsByTagName tag


window.onload = ->
	$('info-bar').className = 'bubbleDisable'
	$('info-bar').onclick = ->
		@innerHTML = calculateResult() if allButtonsHaveDone()
		@className = 'bubbleDisable'

	$('button').onmouseout = ->
		e = window.event
		reltg = (if e.relatedTarget then e.relatedTarget else e.toElement)
		while reltg and reltg isnt this 
			reltg = reltg.parentNode 
		reset() if reltg isnt this
	
	addClickHandlerToAllButtons()


addClickHandlerToAllButtons = ->
	for item in $$ 'button'
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

		for otherItem in $$ 'button'
			if otherItem isnt thisButton and not otherItem.getElementsByTagName('span')[0]
				otherItem.className = 'active'
				otherItem.disabled = '' 

		displayResultOnBubble() if allButtonsHaveDone()


allButtonsHaveDone = ->
	flag = true
	for item in $$ 'button'
		flag = false if not item.getElementsByTagName('span')[0] or item.getElementsByTagName('span')[0] is '...'
	flag


calculateResult = ->
	result = 0
	for item in $$ 'button'
		result += parseInt item.getElementsByTagName('span')[0].innerHTML
	result 


reset = ->
	$('info-bar').innerHTML = ''
	$('info-bar').className = 'bubbleDisable'

	for button in $$ 'button'
		button.className = 'active'
		button.disabled = ''
		button.removeChild button.getElementsByTagName('span')[0] if button.getElementsByTagName('span')[0]?


displayResultOnBubble = ->
	$('info-bar').className = 'bubbleActive'