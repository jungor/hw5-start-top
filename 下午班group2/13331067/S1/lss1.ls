var count, sum
count = 0
sum = 0

display-the-span = !-> #隐藏span的数字
	$ '.num' .css 'display', 'none'

click-to-fetch-a-number = !->#给每个button添加区数字事件
	$ '.button' .click buttons-event

buttons-event = !->
	t = @childNodes[0]
	t2 = @
	buttonset = $ '.button'
	if !$(t.parentNode).hasClass 'clicked' and !$(t.parentNode).hasClass 'cannotclick'
		for i in buttonset
			if i != @
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
		
		xhr.send null

set-bubble-color-to-click = !-> #让bubble换成可点击的颜色
	bubble = $ '.info'
	bubble.css 'background-color', 'rgba(48, 63, 159, 1)'
	bubble.css 'transition', 'all 0.6s'

click-to-calculate-the-sum = !-> #给bubble添加点击事件
	$ '.info' .click calculate-the-sum

calculate-the-sum = !-> #计算数字 浮现在大bubble中
	if count ~= 5
		$ '.sum' .html sum
		@style.backgroundColor = 'rgba(0,0,20,.6)'

mouse-leave-the-atplus = !-> #给鼠标离开atplus添加事件
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

$ !->
	display-the-span!
	click-to-fetch-a-number!
	click-to-calculate-the-sum!
	mouse-leave-the-atplus!