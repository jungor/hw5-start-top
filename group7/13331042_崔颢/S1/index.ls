class Handler
	@all-circles = []

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

	(@the-circle, @bubble) ->
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

	reset: !->
		@status = 'clickable'
		@the-circle.add-class 'clickable'
		init = @the-circle.text![0]
		@the-circle.text init


class Bubble
	(@the-bubble) ->
		@status = 'unclickable'
		@the-bubble.remove-class 'clickable'
		@the-bubble.click !~> 
			@sum-all-and-show! if @status is 'clickable'

	set-clickable: !->
		@status = 'clickable'
		@the-bubble.add-class 'clickable'

	sum-all-and-show: !->
		sum = 0
		for circle in Handler.all-circles
			tem = circle.the-circle.find '.unread' .text!
			sum += parse-int tem
		@the-bubble.text sum
		@the-bubble.status = 'unclickable'
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


init-big-bubble = !->
	bubble = $ '#info-bar'
	bubble-handler = new  Bubble ($ bubble)
	return bubble-handler

init-all-small-cirlces = (bubble) !->
	circles = $ '#control-ring .button'
	for let circle in circles
		now-circle = new Handler ($ circle), bubble

init-reset-button = (bubble) !->
	reset = $ '#bottom-positioner'
	reset-handler = new Reset ($ reset), bubble



$ ->
	bubble = init-big-bubble!
	init-all-small-cirlces bubble
	init-reset-button bubble
