$ !->
	display-the-span! #span元素的...一开始不显示
	add-click-event-to-atplus! #为atplus按钮添加点击事件
	add-leave-event-to-atplus! #为鼠标离开atplus添加事件

var count, sum, isclicked, arr
count = 0
sum = 0
isclicked = false
arr = [0 til 5]

random-sort = (a, b) -> #随机排序的cmp函数
	if Math.random! > 0.5
		-1
	else
		1

display-the-span = !-> #隐藏span的数字
	$ '.num' .css 'display', 'none'

add-click-event-to-atplus = !->
	$ '#at-plus-container' .click robot-initial 

robot-initial = !-> #模拟机器人的执行步骤
	if !isclicked
		isclicked := true
		make-a-random-list!
		
		buttonset = document.getElementsByClassName 'button'
		buttons-clicking-event buttonset[arr[0]]

make-a-random-list = !->
	arr := arr.sort random-sort
	alpha = <[A B C D E]>
	str = '排序顺序： '
	for i from 0 til 5
		str = str + alpha[arr[i]]
	$ '.sortinfo' .html str


buttons-clicking-event = (obj) !->
	if obj isnt null
		t = obj.childNodes[0]
		t2 = obj
		buttonset = $ '.button'

		if !$(t.parentNode).hasClass 'clicked' and !$(t.parentNode).hasClass 'cannotclick'
			for i in buttonset
				if i != t2
					$ i .css 'background-color', 'rgba(0,0,20,.6)'
					$ i .addClass 'cannotclick'

			t.style.display = 'inline';
			$ t.parentNode .addClass 'clicked'

			xhr = new XMLHttpRequest!
			xhr.open "GET", "http://localhost:3000/", true
			xhr.onreadystatechange = !->
				if(xhr.readyState ~= 4 and xhr.status ~= 200)
					t.innerHTML = xhr.responseText
					n = parseInt xhr.responseText
					t.parentNode.style.backgroundColor = 'rgba(0,0,20,.6)'
					if !isNaN n
						sum := sum + n
					console.log sum
					count := count + 1
					console.log count
					if count ~= 5
						set-bubble-color-to-click!
						$ '.sum' .html sum
						$ '.info' .css 'background-color', 'rgba(0, 0, 20, .6)'

					for i in buttonset
						if i != t2 and !$ i .hasClass 'clicked'
							$ i .css 'background-color', 'rgba(48, 63, 159, 1)';
							$ i .removeClass 'cannotclick'
					
					buttonsets = document.getElementsByClassName 'button'
					if count isnt 5
						buttons-clicking-event buttonsets[arr[count]]
			
			xhr.send null

set-bubble-color-to-click = !-> #让bubble换成可点击的颜色
	bubble = $ '.info'
	bubble.css 'background-color', 'rgba(48, 63, 159, 1)'
	bubble.css 'transition', 'all 0.6s'

add-leave-event-to-atplus= !-> #给鼠标离开atplus添加事件
	$ '#at-plus-container' .mouseleave leave-the-apb

leave-the-apb = !-> #离开atplus之后具体发生的行为
	$ '.num' .html '...'
	$ '.num' .css 'display', 'none'
	$ '.button' .removeClass 'cannotclick'
	$ '.button' .removeClass 'clicked'
	$ '.button' .css 'background-color', 'rgba(48,63,159,1)'
	$ '.info' .css 'background-color', 'rgba(0,0,20,.6)'
	$ '.sum' .html ''
	$ '.sortinfo' .html ''
	sum := 0
	count := 0
	isclicked := false
	# location.reload!