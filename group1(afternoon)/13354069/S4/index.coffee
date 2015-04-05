$ = (id) -> document.getElementById id
$$ = (tag) -> document.getElementsByTagName tag


window.onload = ->
	$('info-bar').className = 'bubbleDisable'
	$('info-bar').onclick = ->
		@innerHTML = calculateResult() if flag is 'DONE'
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


flag = 'LOADING'
robotIsWorking = false


howManyButtonsHaveGetRandomNumber = ->
	num = 0
	for item in $$ 'button' 
		num++ if item.getElementsByTagName('span')[0] and item.getElementsByTagName('span')[0].innerHTML isnt '...'
	num


calculateResult = ->
	result = 0
	for item in $$ 'button'
		result += parseInt item.getElementsByTagName('span')[0].innerHTML
	result 


reset = ->
	flag = 'LOADING'
	robotIsWorking = false

	$('info-bar').innerHTML = ''
	$('info-bar').className = 'bubbleDisable'

	for button in $$ 'button'
		button.className = 'active'
		button.disabled = ''
		button.removeChild button.getElementsByTagName('span')[0] if button.getElementsByTagName('span')[0]?


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

		flag = 'DONE'
		for otherItem in $$ 'button'
			if otherItem isnt thisButton and not otherItem.getElementsByTagName('span')[0]
				otherItem.className = 'active'
				otherItem.disabled = '' 
				flag = 'LOADING'

		displayResultOnBubble() if flag is 'DONE'
		robot() if robotIsWorking


displayResultOnBubble = ->
	$('info-bar').className = 'bubbleActive'


robot = () ->
	if flag is 'LOADING'
		rand = getRandomOrder() if not robotIsWorking
		robotIsWorking = true
		id = $('info-bar').innerHTML[howManyButtonsHaveGetRandomNumber()].toLowerCase()
		$(id).click()
	else
		$('info-bar').click() 


getRandomOrder = ->
	rand = []
	i = 0
	while i < 5
		val =  Math.floor Math.random()*5
		j = 0
		temp = rand.length
		while j < rand.length
			break if rand[j] is val
			j++
		if j is temp then rand[j] = val else i--
		i++

	str = ''
	for item in rand
		switch item
			when 0 then str += 'A'
			when 1 then str += 'B'
			when 2 then str += 'C'
			when 3 then str += 'D'
			when 4 then str += 'E'
			else console.log 'RANDOM ERROR!'
	$('info-bar').innerHTML = str
	rand