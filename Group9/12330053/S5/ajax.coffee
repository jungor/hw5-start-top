k = $("#control-ring li")
reset = ->0
modifyLabel =(unread,data) ->
		unread.innerHTML = data
		0
enable = ->
	liList = $("#control-ring li")
	color "rgba(61,40,166,1)",li for li in liList when not $(li).find("[class=unread]").get(0)
	0
calculate=->
	sum = 0
	add =(span)->
		sum = sum+parseInt(span.innerHTML)
	add span for span in $("[class=unread] span")
	$(".info").css("background-color","grey")
	$("#info-bar").unbind("click")
	return sum
setBubbleEnable=->
	color "rgba(61,40,166,1)",".info"
	$("#info-bar").click(bubbleHandler)

callback = (data,textStatus)->
	UnreadList = $("[class=unread] span")
	modifyLabel unread,data for unread in UnreadList when unread.innerHTML == "..."
	enable()
	if ($("li [class=unread]").length == 5)
		setBubbleEnable()
		$("#control-ring").unbind("click")
	0
callback4 = (data,curSum,tarNum)->

	UnreadList = $("[class=unread] span")
	for unread in UnreadList when unread.innerHTML == "..."
		modifyLabel unread,data
		curSum += parseInt(data)
		break
	enable()
	exception =  Math.floor(Math.random()*2)
	error = ''
	if exception > 0
		error = "？不！"
	switch tarNum
		when 0 then showMessage("这是个天大的秘密#{error}")
		when 1 then showMessage("我不知道#{error}")
		when 2 then showMessage("你不知道#{error}")
		when 3 then showMessage("他不知道#{error}")
		when 4 then showMessage("才怪#{error}")
	if ($("li [class=unread]").length == 5)
		bubbleHandler curSum
	else
		robot $("li [class=unread]").length,curSum
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
showMessage = (str)->
	msg = $("<span>#{str}</span>")
	$("#msg").append(msg)
	console.log(str)
aHandler=(tar,curremntSum)->
	if not $(tar).find("[class=unread]").get(0)
		setLabel(tar)
		$.get("/",(data)->callback4(data,curremntSum,0)) #ajax
		disable()


bHandler=(tar,curremntSum)->
	if not $(tar).find("[class=unread]").get(0)
		setLabel(tar)
		$.get("/",(data)->callback4(data,curremntSum,1)) #ajax
		disable()

cHandler=(tar,curremntSum)->
	if not $(tar).find("[class=unread]").get(0)
		setLabel(tar)
		$.get("/",(data)->callback4(data,curremntSum,2)) #ajax
		disable()
dHandler=(tar,curremntSum)->
	if not $(tar).find("[class=unread]").get(0)
		setLabel(tar)
		$.get("/",(data)->callback4(data,curremntSum,3)) #ajax
		disable()
eHandler=(tar,curremntSum)->
	if not $(tar).find("[class=unread]").get(0)
		setLabel(tar)
		$.get("/",(data)->callback4(data,curremntSum,4)) #ajax
		disable()
bubbleHandler=(sum)->
	tar = $(".info-bar").get(0)
	showMessage("楼主异步调用战斗力感人，目测不超过#{sum}")
robot = (seq,curremntSum)->
	if seq > 4
		return 0
	newList = $("#seqNum").html().split("")
	for k in [0..4]
		switch newList[k]
			when "A" then newList[k] = 0
			when 'B' then newList[k] = 1
			when 'C' then newList[k] = 2
			when 'D' then newList[k] = 3
			when 'E' then newList[k] = 4
	curIndex = newList[seq]
	tar = $("#control-ring li").get(curIndex)
	switch seq
		when 0 then aHandler(tar,curremntSum)
		when 1 then bHandler(tar,curremntSum)
		when 2 then cHandler(tar,curremntSum)
		when 3 then dHandler(tar,curremntSum)
		when 4 then eHandler(tar,curremntSum)

RandomRobot =->
	numList = ["A","B","C","D","E"]
	str = ""
	newList = []
	while newList.length < 5
		cur = Math.floor(Math.random()*5)
		k = true
		for item in newList
			if item == cur then k = false
		if k
			newList.push(cur)
			str += numList[cur]
	curSeq = $("<span id='seqNum'>#{str}</span>")
	$(".info").append(curSeq)
	$(".icon").unbind("click")
	robot 0,0


#$("#control-ring").click(addModify)
$(".icon").click(RandomRobot)
$(".icon").bind("onmouseover","reset()")
liList = $("#control-ring li")
$(liList.get(0)).click(aHandler)
$(liList.get(1)).click(bHandler)
$(liList.get(2)).click(cHandler)
$(liList.get(3)).click(dHandler)
$(liList.get(4)).click(eHandler)
