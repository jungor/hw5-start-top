k = $("#control-ring li")
reset = ->0
modifyLabel =(unread,data) ->
		unread.innerHTML = data
		0
enable = ->
	liList = $("#control-ring li")
	color "rgba(61,40,166,1)",li for li in liList when not $(li).find("[class=unread]").get(0)
	$("#control-ring").click(addModify)
	0
calculate=->
	sum = 0
	add =(span)->
		sum = sum+parseInt(span.innerHTML)
	add span for span in $("[class=unread] span")
	$("#cal-result").get(0).innerHTML = sum;
	$(".info").css("background-color","grey")
	$("#info-bar").unbind("click")
setBubbleEnable=->
	color "rgba(61,40,166,1)",".info"
	$("#info-bar").click(calculate)

callback = (data,textStatus)->
	UnreadList = $("[class=unread] span")
	modifyLabel unread,data for unread in UnreadList when unread.innerHTML == "..."
	enable()
	if ($("li [class=unread]").length == 5)
		setBubbleEnable()
		$("#control-ring").unbind("click")
	0
callback2 = (data,textStatus)->
	UnreadList = $("[class=unread] span")
	modifyLabel unread,data for unread in UnreadList when unread.innerHTML == "..."
	enable()

	if ($("li [class=unread]").length == 5)
		calculate()
	oneFingerNiubi()
	0
color =(colorName,li) ->
	$(li).css("background-color","#{colorName}")
disable = ->
	liList = $("#control-ring li")
	color "grey",li for li in liList
	$("#control-ring").unbind("click")
	0
addModify = (e)->
	tar = e.target || window.target
	if not $(tar).find("span").get(0)
		tar = tar.parentNode
	if not $(tar).find("[class=unread]").get(0)
		setLabel(tar)
		$.get("/",callback) #ajax
		disable()
setLabel = (tar)->
	unread = $("<div class='unread'><span>...</span></div>")
	$(tar).append(unread.get(0))
	0
oneFingerNiubi =->
	clickBtn=(li)->
		setLabel(li)
		$.get("/",callback2) #ajax
		disable()
	liList = $("#control-ring li")
	for li in liList when not $(li).find("[class=unread]").get(0)
		clickBtn li
		return 0

$("#control-ring").click(addModify)
$("#icon").bind("onmouseover","reset()")
oneFingerNiubi()