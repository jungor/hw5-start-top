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
				enable-other item
				item.style.background = 'grey'
				big-bubble-handler!
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
	else
		robot-handler!
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
	disable-other item
	item.last-child.style.display = 'block'
	item.last-child.innerHTML = '...'
	item.onclick = !->
	ajax-get item, display-num
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
				click-handler(this)
clear-all = !->
	location.reload!
window.onload = !->
	create-click-bubble!
	document.get-element-by-id 'at-plus-container' .onmouseleave =!->
		clear-all!
	document.get-elements-by-class-name('icon')0 .onclick =!->
		robot-handler!
robot-handler = !->
	bubbles = document.get-elements-by-class-name 'bubble'
	for i to bubbles.length-1
		if bubbles[i].last-child.style.display is 'none'
			continue
		else
			bubbles[i].click!
			break