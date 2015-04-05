flag = 0
chars = ["A", "B", "C", "D", "E"]
queue = []
display-num = (data, item) !-> 
	item.lastChild.innerHTML = String data
ajax-get = (item, func) !->
	xml-http-reg = null
	xml-http-reg = new XML-http-request()
	if xml-http-reg is not null
		xml-http-reg.open 'get', '/', true
		xml-http-reg.send null
		xml-http-reg.onreadystatechange =!->
			if xml-http-reg.ready-state is not 4 then return
			func xml-http-reg.response-text, item
			item.style.background = 'grey'
			enable-other item
			big-bubble-handler!
			if flag
				robot-handler!
big-bubble-handler =!->
	bubbles = document.get-elements-by-class-name 'bubble'
	i = 0
	while bubbles[i].style.background is 'rgb(128, 128, 128)'
		i++
		if i is 5 then break
	if i is 5
		big-bubble = document.get-element-by-id 'bigOne'
		big-bubble.parent-node.parent-node.style.background = 'blue'
		document.get-element-by-id 'info-bar' .onclick = !->
			sum-bubble big-bubble
		return true
sum-bubble = (item) !->
	sum = 0
	bubbles = document.get-elements-by-class-name 'bubble'
	for i to bubbles.length-1
		sum += Number bubbles[i].lastChild.innerHTML
	item.innerHTML = String sum
	item.parent-node.parent-node.style.background = 'grey'
create-click-bubble = !->
	bubbles = document.get-elements-by-class-name 'bubble'
	for item in bubbles
		item.last-child.style.display = 'none'
		item.onclick = !->
			click-handler(this)
click-handler = (item)!->
	item.last-child.style.display = 'block'
	item.last-child.innerHTML = '...'
	item.onclick = !->
	ajax-get item, display-num
	disable-other item
disable-other = (item)!->
	bubbles-handler 'grey', item, (item_)->
enable-other = (item)!->
	bubbles-handler 'blue', item, (item_)!->
		click-handler item_
bubbles-handler = (color, item, func)!->
	bubbles = document.get-elements-by-class-name 'bubble'
	for i to bubbles.length-1
		if bubbles[i].last-child.style.display is not 'none' then continue
		if bubbles[i] is not item
			bubbles[i].style.background = color
			bubbles[i].onclick = !->
				func(this)
if-get-num = !->
	bubbles = document.get-elements-by-class-name 'bubble'
	for i to bubbles.length-1
		if bubbles[i].last-child.innerHTML is '...' then return	true
	return false
clear-all = !->
	location.reload!
if-push = (data, q) !->
	for i to q.length-1
		if data is q[i] then return false
	return true
display-queue = !->
	x = ''
	for i to 4
		x += chars[queue[i]]
	document.get-element-by-id 'text' .innerHTML = x
window.onload = !->
	create-click-bubble!
	while queue.length is not 5
		data = Math.floor(Math.random()*10)%5
		if if-push data, queue then queue.push data
	display-queue!
	document.get-element-by-id 'at-plus-container' .onmouseleave =!->
		clear-all!
	document.get-elements-by-class-name('icon')0 .onclick =!->
		robot-handler!
		flag := 1
robot-handler = !->
	bubbles = document.get-elements-by-class-name 'bubble'
	for i to bubbles.length-1
		if if-get-num! then return
		if queue[flag] is not i then continue
		if bubbles[i].last-child.style.display is not 'none'
			continue
		else
			bubbles[i].click!
			flag++
			break
	if big-bubble-handler! then document.get-element-by-id 'info-bar' .click!