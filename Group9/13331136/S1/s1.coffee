$ ->

	reset()
	#鼠标点击button
	$('.button').bind 'click', (event) -> if ($(this).hasClass "can_click") or $(this).hasClass "OK"
		clicked_and_get_num this
	#鼠标离开区域
	$('#bottom-positioner').bind 'mouseleave', (event) ->
		reset()
	#点击大气泡
	$(".icon").bind 'click', (event) -> if able_to_calculate()
		calculate_result()


#整体初始化
reset = ->
	enable_all_buttons()
	$(".info").eq(0).css "background-color", "#7E7E7E"
	$("#info-bar span").eq(0).text ""
	req?.abort()

#激活所有button
enable_all_buttons = ->
	$(".button span").hide()
	$(".button span").text "..."
	$(".button").removeClass "OK"
	enable $(".button").get i for i in [0..$(".button").size()-1]

#灭活所有button
disable_all_button = (button) ->
	disable $(".button").get i for i in [0..$(".button").size()-1]

#激活没有取数的button
enable_the_left_button = ->
	enable $(".button").get i for i in [0..$(".button").size()-1] when not $(".button").eq(i).hasClass "OK" 

#取数
clicked_and_get_num = (button) ->
	($ button).children().show()
	disable_all_button button
	window.req = $.ajax
	   url: "/"
	   type: 'GET'
	   dataType: "html"
	   error: (jqXHR, textStatus, errorThrown) ->
	   	console.log "AJAX Error: #{textStatus}"
	   success: (data, textStatus, jqXHR) ->
	   	change_the_state button, data
	   	enable_the_left_button()
	   	if able_to_calculate() then $(".info").eq(0).css "background-color", "#2D3AA4"

#取数后更改button状态
change_the_state = (button, num) ->
	($ button).children().text num
	$(button).addClass("OK")
	disable button

#激活button
enable = (button) ->
	$(button).css "background-color", "#2D3AA4"
	$(button).addClass "can_click"

#灭活button
disable = (button) ->
	$(button).css "background-color", "#7E7E7E"
	$(button).removeClass "can_click"

#判断是否可以计算结果
able_to_calculate = ->
	for i in [0..$(".button").size()-1]
		if not $(".button").eq(i).hasClass "OK"
			return false
	return true

#计算结果
calculate_result = ->
	sum = 0
	sum += parseInt $(".button span").eq(i).text() for i in [0..$(".button span").size()-1]
	show_result(sum)

#显示结果
show_result = (sum) ->
	$("#info-bar span").eq(0).text sum.toString()