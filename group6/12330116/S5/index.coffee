window.onload = ->
  startAjax = (err,message,cb) ->
    xmlHttp;
    if !!window.ActiveXObject  
      xmlHttp = new ActiveXObject "Microsoft.XMLHTTP"  
    else if !!window.XMLHttpRequest
      xmlHttp = new XMLHttpRequest()  
    xmlHttp.open "POST", "/", true
    okFunc = ->
      if xmlHttp.readyState is 4 and xmlHttp.status is 200
        cb err,message,xmlHttp.responseText
    xmlHttp.onreadystatechange = okFunc
    xmlHttp.setRequestHeader "Content-Type","application/x-www-form-urlencoded"  
    xmlHttp.send document
    null
	
  aHandler = (cb) ->
    random = Math.random()
    if random < 0.5
      message = "这是个天大的秘密"
      err = false
      startAjax err,message,cb
    else
      message = "这不是个天大的秘密"
      err = true
      startAjax err,message,cb
    null
		
  bHandler = (cb) ->
    random = Math.random()
    if random < 0.5
      message = "我不知道" 
      err = false
      startAjax err,message,cb
    else
      message = "我知道"
      err = true
      startAjax err,message,cb		
    null

  cHandler = (cb) ->
    random = Math.random()
    if random < 0.5
      message = "你不知道"
      err = false
      startAjax err,message,cb
    else
      message = "你知道"
      err = true
      startAjax err,message,cb
    null
	  
  dHandler = (cb) ->
    random = Math.random()
    if random < 0.5
      message = "他不知道"
      err = false
      startAjax err,message,cb
    else
      message = "他知道"
      err = true
      startAjax err,message,cb
    null
	  
  eHandler = (cb) ->
    random = Math.random()
    if random < 0.5
      message = "才怪"
      err = false
      startAjax err,message,cb 
    else
      message = "就是"
      err = true
      startAjax err,message,cb
    null
	  
  bubbleHandler = (hint,addAll) ->
    message= "楼主异步调用战斗力感人，目测不超过" + addAll
    hint.innerHTML = message
    null  

  document.getElementById("atplus_green").onclick = ->
    elements = ["A","B","C","D","E"]
    sort = [0..4]
    for i in [0..10]
      index = Math.floor (Math.random() * sort.length)	  
      mid = sort[4]
      sort[4] = sort[index]
      sort[index] = mid
    handlers = [aHandler,bHandler,cHandler,dHandler,eHandler];
    div = document.createElement 'div'
    clicked = []
    k = 0
    addAll = 0
    div.style.cssText = "position:absolute;top:-40px;left:25px;width:100px;color:red;background-color:white"
    document.getElementById('all').appendChild div
    for element,i in elements
      elements[i] = document.getElementById element
      elements[i].canClick = true
      elements[i].onclick = do (i,elements) -> 
        -> 
          if(!@canClick)
            return null
          for j in [0..4] when i isnt j
            elements[j].style.backgroundColor = "gray"
            elements[j].canClick = false
          xdiv = document.createElement 'div'
          xdiv.style.cssText = "position:absolute;right:-5px;top:-5px;width:17px;height:17px;color:white;text-align:center;font-size:12px;z-index:50;background-color:red"
          xdiv.innerHTML = "..."
          clicked[i] = true
          @.appendChild xdiv
          handlers[i] handler
          null
      elements[i].onmouseover = ->
        @.style.cursor = "pointer"
		
    handler = (err,message,num) ->
      if !!err
        div.innerHTML = "Error:" + message
        return null
      addAll += parseInt num
      div.innerHTML = message
      x = elements[sort[k]].lastChild
      x.innerHTML = num
      elements[sort[k]].style.backgroundColor = "gray"
      elements[sort[k]].canClick = false
      for i in[0..4] when !clicked[i]
        elements[i].canClick = true
        elements[i].style.backgroundColor = "rgba(48, 63, 159, 1)"
      k++
      if k < 5
        elements[sort[k]].click();
      else if k is 5
        document.getElementById("all").onclick = bubbleHandler.bind null,div,addAll
        document.getElementById("all").click()		  
    elements[sort[0]].click()
    this.onclick = null
    null
    
  document.getElementById("atplus_green").onmouseover = ->
    this.style.cursor = "pointer"
    null

  document.getElementById("all").nmouseover = ->
    this.style.cursor = "pointer"
    null
	
  document.getElementById("atplus_white").onmouseover = ->
    document.getElementById("atplus_white").style.opacity = 0
    document.getElementById("atplus_white").style.zIndex = -1000
    document.getElementById("atplus_green").style.cssText = "opacity:1;transform:scale(1.5,1.5);background-color:rgba(48, 63, 159, 1)"
    document.getElementById("A").style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);transform:translate(-82px,-40px)"
    document.getElementById("B").style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-100px,0px)"
    document.getElementById("C").style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-80px,50px)"
    document.getElementById("D").style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-30px,85px)"
    document.getElementById("E").style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(30px,80px)"
    document.getElementById("all").style.cssText = "opacity:1;background-color:gray;transform:translate(-50px,-80px);width:150px;height:150px;color:white;text-align:center;font-weight:bold"
    null
  
  document.getElementById("container").onmouseout = ->
    window.location = ""
    null
	
  null