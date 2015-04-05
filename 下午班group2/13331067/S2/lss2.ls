$ !->
	display-the-span! #span元素的...一开始不显示
	add-click-event-to-atplus! #为atplus按钮添加点击事件
	add-leave-event-to-atplus! #为鼠标离开atplus添加事件

var count, sum
count = 0
sum = 0

display-the-span = !-> #隐藏span的数字
	$ '.num' .css 'display', 'none'

add-click-event-to-atplus = !->
	$ '#at-plus-container' .click robot-initial 

robot-initial = !-> #模拟机器人的执行步骤
	firstbutton = document.getElementsByClassName('button')[0]
	buttons-clicking-event firstbutton

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

					for i in buttonset
						if i != t2 and !$ i .hasClass 'clicked'
							$ i .css 'background-color', 'rgba(48, 63, 159, 1)';
							$ i .removeClass 'cannotclick'
					
					buttons-clicking-event(t2.nextSibling.nextSibling)
			
			xhr.send null

	if obj ~= null
		$ '.sum' .html sum
		$ '.info' .css 'background-color', 'rgba(0, 0, 20, .6)'

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
	sum := 0
	count := 0
	# location.reload!