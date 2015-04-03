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
		
	document.getElementsByClassName('icon')[0].onclick = -> 
		reset()
		robot()
	
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
			makeRequest(@id, manualClickCallback)

makeRequest = (id, callback) ->
	xmlHttp = new XMLHttpRequest()
	xmlHttp.onreadystatechange = ->
		callback(xmlHttp.responseText, id) if xmlHttp.readyState is 4 and xmlHttp.status is 200
	xmlHttp.open 'GET','/',true
	xmlHttp.send null


manualClickCallback = (number, id) ->
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
	$('message').innerHTML = ''
	$('info-bar').innerHTML = ''
	$('info-bar').className = 'bubbleDisable'

	for button in $$ 'button'
		button.className = 'active'
		button.disabled = ''
		button.removeChild button.getElementsByTagName('span')[0] if button.getElementsByTagName('span')[0]?


displayResultOnBubble = ->
	$('info-bar').className = 'bubbleActive'


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


robot = ->
	rand = getRandomOrder()
	clickButtonInRandomOrder(rand, 0, 0)


robotClickCallback = (number, id) ->
	thisButton = $ id
	if thisButton.getElementsByTagName('span')[0]
		thisButton.innerHTML = thisButton.innerHTML.replace '...', number
		thisButton.className = 'disable' 
		thisButton.disabled = 'disabled'

		for otherItem in $$ 'button'
			if otherItem isnt thisButton and not otherItem.getElementsByTagName('span')[0]
				otherItem.className = 'active'
				otherItem.disabled = '' 

		displayResultOnBubble() if robotAllButtonsHaveDone()


robotAllButtonsHaveDone = ->
	flag = true
	for item in $$ 'button'
		flag = false if not item.getElementsByTagName('span')[0]
	flag


clickButtonInRandomOrder = (rand, currentSum, indexInRand) ->
	if indexInRand is 5
		bubbleHandler(currentSum)
	else
		robotHandler = (error, sum, arr, index) ->
			console.log(error) if error isnt null
			clickButtonInRandomOrder(arr, sum, index + 1)

		indexInButtons = rand[indexInRand]
		switch indexInButtons
			when 0 then aHandler(currentSum, robotHandler, rand, indexInRand)
			when 1 then bHandler(currentSum, robotHandler, rand, indexInRand)
			when 2 then cHandler(currentSum, robotHandler, rand, indexInRand)
			when 3 then dHandler(currentSum, robotHandler, rand, indexInRand)
			when 4 then eHandler(currentSum, robotHandler, rand, indexInRand)

		
###
enableButtons = ->
	for item in $$ 'button'
		if not item.getElementsByTagName('span')[0]
			item.className = 'active'
			item.disabled = ''
###

failedToGetResponse = ->
	Math.random() > 0.5


updateCurrentSum = (currentSum) ->
	str = ''
	bubble = $ 'info-bar'
	if bubble.innerHTML.indexOf '<br>' 
		str = bubble.innerHTML.split('<')[0]
		str = str + "<br> #{currentSum}"
		bubble.innerHTML = str
	else 
		bubble.innerHTML = "#{bubble.innerHTML} <br> #{currentSum}"


aHandler = (currentSum, robotHandler, rand, index) ->
	$('a').innerHTML = $('a').innerHTML + "<span class='unread'>...</span>"
	$('a').disabled = 'disabled'
	for otherItem in $$ 'button' when otherItem isnt $('a')
		if not otherItem.getElementsByTagName('span')[0]
			otherItem.className = 'disable'
			otherItem.disabled = 'disabled'

	failed = failedToGetResponse()
	if failed
		$('message').innerHTML = "<strong>这不是个天大的秘密</strong>" 
	else 
		$('message').innerHTML = "这是个天大的秘密"
		makeRequest('a', robotClickCallback)
		currentSum += parseInt $('a').getElementsByTagName('span')[0].innerHTML	
	updateCurrentSum(currentSum)
	
	if failed then robotHandler('A failed!', currentSum, rand, index) else robotHandler(null, currentSum, rand, index)


bHandler = (currentSum, robotHandler, rand, index) ->
	$('b').innerHTML = $('b').innerHTML + "<span class='unread'>...</span>"
	$('b').disabled = 'disabled'
	for otherItem in $$ 'button' when otherItem isnt $('b')
		if not otherItem.getElementsByTagName('span')[0]
			otherItem.className = 'disable'
			otherItem.disabled = 'disabled'

	failed = failedToGetResponse()
	if failed
		$('message').innerHTML = "<strong>我知道</strong>" 
	else 
		$('message').innerHTML = "我不知道"
		makeRequest('b', robotClickCallback)
		currentSum += parseInt $('b').getElementsByTagName('span')[0].innerHTML	
	updateCurrentSum(currentSum)
	
	if failed then robotHandler('B failed!', currentSum, rand, index) else robotHandler(null, currentSum, rand, index)


cHandler = (currentSum, robotHandler, rand, index) ->
	$('c').innerHTML = $('c').innerHTML + "<span class='unread'>...</span>"
	$('c').disabled = 'disabled'
	for otherItem in $$ 'button' when otherItem isnt $('c')
		if not otherItem.getElementsByTagName('span')[0]
			otherItem.className = 'disable'
			otherItem.disabled = 'disabled'

	failed = failedToGetResponse()
	if failed
		$('message').innerHTML = "<strong>你知道</strong>" 
	else 
		$('message').innerHTML = "你不知道"
		makeRequest('c', robotClickCallback)
		currentSum += parseInt $('c').getElementsByTagName('span')[0].innerHTML	
	updateCurrentSum(currentSum)
	
	if failed then robotHandler('C failed!', currentSum, rand, index) else robotHandler(null, currentSum, rand, index)


dHandler = (currentSum, robotHandler, rand, index) ->
	$('d').innerHTML = $('d').innerHTML + "<span class='unread'>...</span>"
	$('d').disabled = 'disabled'
	for otherItem in $$ 'button' when otherItem isnt $('d')
		if not otherItem.getElementsByTagName('span')[0]
			otherItem.className = 'disable'
			otherItem.disabled = 'disabled'
	
	failed = failedToGetResponse()
	if failed
		$('message').innerHTML = "<strong>他知道</strong>" 
	else 
		$('message').innerHTML = "他不知道"
		makeRequest('d', robotClickCallback)
		currentSum += parseInt $('d').getElementsByTagName('span')[0].innerHTML	
	updateCurrentSum(currentSum)
	
	if failed then robotHandler('D failed!', currentSum, rand, index) else robotHandler(null, currentSum, rand, index)


eHandler = (currentSum, robotHandler, rand, index) ->
	$('e').innerHTML = $('e').innerHTML + "<span class='unread'>...</span>"
	$('e').disabled = 'disabled'
	for otherItem in $$ 'button' when otherItem isnt $('e')
		if not otherItem.getElementsByTagName('span')[0]
			otherItem.className = 'disable'
			otherItem.disabled = 'disabled'

	failed = failedToGetResponse()
	if failed
		$('message').innerHTML = "<strong>才怪就怪了</strong>" 
	else 
		$('message').innerHTML = "才怪"
		makeRequest('e', robotClickCallback)
		currentSum += parseInt $('e').getElementsByTagName('span')[0].innerHTML	
	updateCurrentSum(currentSum)
	
	if failed then robotHandler('E failed!', currentSum, rand, index) else robotHandler(null, currentSum, rand, index)


bubbleHandler = (sum) ->
	$('message').innerHTML = "楼主异步调用战斗力感人，目测不超过 #{sum}"