getnumber = (this_id, callback)->
	request = new XMLHttpRequest!
	request.onreadystatechange = ->
		if request.readyState==4 and request.status==200
			$("#" + this_id)[0].innerHTML=request.responseText;
			enable_other_button(this_id)
			if all_button_done!
				add_info_click!
			callback?!
	request.open("GET","/" + this_id,true)
	request.send!

enable_other_button = (this_id)->
	lis = $(".plank")
	number = $(".number")
	for i from 0 to 4
		if number[i].classList.contains("appear")
			lis[i].style.backgroundColor = 'gray'
		else
			lis[i].style.backgroundColor = 'rgba(48,63,159,.8)'  

disable_other_button = (this_id)->
	lis = $(".plank")
	[lis[i].style.backgroundColor = 'gray' for i from 0 to 4 when i isnt this_id]

show_number = (this_id)->
	number = $(".number")
	number[this_id].classList.remove("disappear")
	number[this_id].classList.add("appear")

all_button_done = ->
	number = $(".number")
	[return false for i from 0 to 4 when number[i].innerHTML is "..."]
	true

button_click = (this_id)!->
	buttons = $(".letter")
	number = $(".number")
	lis = $(".plank")
	if number[this_id].style.display is "block"
		return
	show_number(this_id)
	disable_other_button(this_id)
	getnumber(this_id,buttons[this_id].callback)

add_button_click = ->
	buttons = $(".letter")
	for i from 0 to 4
		buttons[i].Index = i
		buttons[i].onclick = ->
			button_click(this.Index)

add_info_click = ->
	buttons = $(".letter")
	$('#info-bar')[0].onclick = ->
		if all_button_done! isnt true
			return;
		number = $(".number")
		k = 0
		[k += parseInt(number[i].innerHTML) for i from 0 to 4]
		$('#big')[0].innerHTML = k;

reset_number = ->
	number = $('.number')
	for i from 0 to 4
		number[i].innerHTML = '...';
		number[i].classList.add("disappear");
		number[i].classList.remove("appear");

reset_buttons = ->
	enable_other_button(-1)
	reset_number!

reset_info = ->
	$('#big')[0].innerHTML = ""

reset = ->
	reset_buttons!
	reset_info!
	$(".apb")[0].state = 'enable'

robot = ->
	$(".apb")[0].onclick = ->
		robot_action()

robot_action = ->
	buttons = $(".letter")
	for let i from 0 to 4
		buttons[i].callback = ->
			$('#info-bar')[0].click!
		buttons[i].click!

window.onload = ->
	reset!
	robot!
	add_button_click!
	add_info_click!
	$('#at-plus-container')[0].onmouseleave = reset