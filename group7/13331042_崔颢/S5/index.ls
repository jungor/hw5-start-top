class Handler
	@fail-rate = 0.4
	@message-box = $ '#message'
	@all-circles = []
	@call-back = ->
		null

	@set-call-back = (tem-call-back) !->
		@call-back = tem-call-back

	@disable-other-circles = (now-circle) !->
		for circle in @all-circles
			if circle isnt now-circle and circle.status isnt 'finished'
				circle.status = 'unclickable'
				circle.the-circle.remove-class 'clickable'

	@enable-other-circles = (now-circle) !->
		for circle in @all-circles
			if circle isnt now-circle and circle.status isnt 'finished'
				circle.the-circle.add-class 'clickable'
				circle.status = 'clickable'

	@check-if-all-finished = ->
		[return false for circle in @all-circles when circle.status isnt 'finished']
		true

	(@the-circle, @bubble, @success-message, @fail-message, @random-call-back) ->
		@status = "clickable"
		@the-circle.add-class 'clickable'
		@@@all-circles.push @
		@the-circle.click !~> if @status is 'clickable'
			@@@disable-other-circles @
			@status = 'acquiring'
			@the-circle.append '<span class="unread" style="font-size:5px">..</span>'
			@get-number!
		
	get-number: !-> $.get '/', (num, state) !~> if @status is 'acquiring'
		@the-circle.find '.unread' .text num
		@status = 'finished'
		@the-circle.remove-class 'clickable'
		@@@enable-other-circles @
		@bubble.set-clickable! if @@@check-if-all-finished!
		@random-error num

		@@@call-back!

	random-error: (num) !->
		flag = Math.random! > @@@fail-rate
		if flag
			($ @@@message-box).text @success-message
		if Robot.is-working
			@random-call-back flag, num


	reset: !->
		@@@message-box.text ''
		@status = 'clickable'
		@the-circle.add-class 'clickable'
		init = @the-circle.text![0]
		@the-circle.text init


class Bubble
	@message-box = $ '#message'

	(@the-bubble) ->
		@status = 'unclickable'
		@the-bubble.remove-class 'clickable'
		@the-bubble.click !~> if @status is 'clickable'
			@sum-all-and-show! 

	set-clickable: !->
		@status = 'clickable'
		@the-bubble.add-class 'clickable'

	sum-all-and-show: !->
		sum = 0
		for circle in Handler.all-circles
			tem = circle.the-circle.find '.unread' .text!
			sum += parse-int tem
		@the-bubble.html @the-bubble.text!+'</br>'+sum
		@@@message-box.text "楼主异步调用战斗力惊人，目测不超过"+sum
		@status = 'unclickable'
		@the-bubble.remove-class 'clickable'

	reset: !->
		@status = 'unclickable'
		@the-bubble.remove-class 'clickable'
		@the-bubble.text ''


class Reset
	(@the-reset, @bubble) ->
		@the-reset.mouseleave !~>
			for circle in Handler.all-circles
				circle.reset!
			@bubble.reset!
			Robot.reset!
			Handler.call-back = ->
				null


class Robot
	@now-num = -1
	@is-working = false
	@seq = ['A' to 'E']

	@get-sequence = !->
		@seq.sort -> 0.5 - Math.random!
	
	@reset = ->
		@now-num = 0
		@is-working = false

	@get-next = !->
		for now in @seq
			if Handler.all-circles[now.char-code-at! - 'A'.char-code-at!].status is 'finished'
				continue
			else break
		@now-num = now.char-code-at! - 'A'.char-code-at!

	start: !-> if @@@is-working
		if Handler.check-if-all-finished! is false
			@@@get-sequence!
			$ '#info-bar' .text @@@seq.join '、'
			call-back = !->
				if Handler.check-if-all-finished!
					Robot.bubble.click!
					Robot.is-working = false
				else 
					Robot.get-next!
					Robot.circles[Robot.now-num].click!

			Handler.set-call-back call-back
			@@@get-next!
			@@@circles[@@@now-num].click!


init-big-bubble = !->
	bubble = $ '#info-bar'
	bubble-handler = new Bubble ($ bubble)
	return bubble-handler

init-all-small-cirlces = (bubble) !->
	init-a-handler bubble
	init-b-handler bubble
	init-c-handler bubble
	init-d-handler bubble
	init-e-handler bubble

init-reset-button = (bubble) !->
	reset = $ '#bottom-positioner'
	reset-handler = new Reset ($ reset), bubble

init-robot = (bubble) !->
	Robot.circles = $ '#control-ring .button'
	Robot.bubble = $ '#info-bar'
	robot = new Robot bubble
	return robot


init-a-handler = (bubble)->
	circles = $ '#control-ring .button'
	a-dom = circles[0]
	success-massage = '这是个天大的秘密'
	fail-message = '这不是秘密'
	a-button = new Handler ($ a-dom), bubble, success-massage, fail-message, (success, number) !->
		if success
			console.log("A succeeds!")
		else
			console.log("A meets an error, with message: "+fail-message)
			
init-b-handler = (bubble)->
	circles = $ '#control-ring .button'
	b-dom = circles[1]
	success-massage = '我不知道'
	fail-message = '我知道'
	b-button = new Handler ($ b-dom), bubble, success-massage, fail-message, (success, number) !->
		if success
			console.log("B succeeds!")
		else
			console.log("B meets an error, with message: "+fail-message)

init-c-handler = (bubble)->
	circles = $ '#control-ring .button'
	c-dom = circles[2]
	success-massage = '你不知道'
	fail-message = '你知道'
	c-button = new Handler ($ c-dom), bubble, success-massage, fail-message, (success, number) !->
		if success
			console.log("C succeeds!")
		else
			console.log("C meets an error, with message: "+fail-message)

init-d-handler = (bubble)->
	circles = $ '#control-ring .button'
	d-dom = circles[3]
	success-massage = '他不知道'
	fail-message = '他知道'
	d-button = new Handler ($ d-dom), bubble, success-massage, fail-message, (success, number) !->
		if success
			console.log("D succeeds!")
		else
			console.log("D meets an error, with message: "+fail-message)
			

init-e-handler = (bubble)->
	circles = $ '#control-ring .button'
	e-dom = circles[4]
	success-massage = '才怪'
	fail-message = '就对了'
	e-button = new Handler ($ e-dom), bubble, success-massage, fail-message, (success, number) !->
		if success
			console.log("E succeeds!")
		else
			console.log("E meets an error, with message: "+fail-message)



$ ->
	bubble = init-big-bubble!
	init-all-small-cirlces bubble
	init-reset-button bubble
	robot = init-robot bubble
	
	$ '#button .apb' .click !-> if Robot.is-working is false
		Robot.is-working = true
		robot.start!
