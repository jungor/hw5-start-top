window.onload = ->
  atplus_white = document.getElementById "atplus_white"
  atplus_green = document.getElementById "atplus_green"
  all = document.getElementById "all"
  container = document.getElementById "container"
  elements = ["A","B","C","D","E"]
  num = 0
  k = 0
  addAll = 0
  clicked = []
  
  okFunc = (obj,elements,xmlHttp) ->
    if xmlHttp.readyState is 4 and xmlHttp.status is 200
      addAll += parseInt xmlHttp.responseText
      num++
      div = obj.lastChild
      div.innerHTML = xmlHttp.responseText
      obj.style.backgroundColor = "gray"
      obj.canClick = false
      for i in[0..4] when !clicked[i]
        elements[i].canClick = true
        elements[i].style.backgroundColor = "rgba(48, 63, 159, 1)"
      if k is 5
        all.click()
    null

  startAjax = (obj) ->
    xmlHttp = null
    if !!window.ActiveXObject
      xmlHttp = new ActiveXObject("Microsoft.XMLHTTP")
    else if !!window.XMLHttpRequest
      xmlHttp = new XMLHttpRequest()
    xmlHttp.open "POST", "/", true
    xmlHttp.onreadystatechange = okFunc.bind null,obj,elements,xmlHttp
    xmlHttp.setRequestHeader "Content-Type","application/x-www-form-urlencoded"  
    xmlHttp.send document
    null

  all.onclick = ->
    if num is 5
      textNode = document.createTextNode addAll
      document.getElementById('addAll').appendChild textNode
      @.onclick = null
    null
	
  all.onmouseover = ->
    @.style.cursor = "pointer"
    null
	
  atplus_green.onclick = ->
    k++
    elements[0].click()
    this.onclick = null
    null

  atplus_green.onmouseover = ->
    this.style.cursor = "pointer"
    null
	
  atplus_white.onmouseover = ->
    atplus_white.style.opacity = 0
    atplus_white.style.zIndex = -1000
    atplus_green.style.cssText = "opacity:1;transform:scale(1.5,1.5);background-color:rgba(48, 63, 159, 1)"
    elements[0].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);transform:translate(-82px,-40px)"
    elements[1].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-100px,0px)"
    elements[2].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-80px,50px)"
    elements[3].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(-30px,85px)"
    elements[4].style.cssText = "opacity:1;background-color:rgba(48, 63, 159, 1);;transform:translate(30px,80px)"
    all.style.cssText = "opacity:1;background-color:gray;transform:translate(-50px,-80px);width:150px;height:150px;color:white;text-align:center;font-weight:bold"
    null
  
  container.onmouseout = ->
    window.location = ""
  
  for element,i in elements
    elements[i] = document.getElementById element
    elements[i].canClick = true
    elements[i].onclick = do (i,elements) -> 
      -> 
        if(!@canClick)
          return null
        if k < 5
          k++
          elements[k - 1].click()
        for j in [0..4] when i isnt j
          elements[j].style.backgroundColor = "gray"
          elements[j].canClick = false
        div = document.createElement 'div'
        div.style.cssText = "position:absolute;right:-5px;top:-5px;width:17px;height:17px;color:white;text-align:center;font-size:12px;z-index:50;background-color:red"
        div.innerHTML = "..."
        clicked[i] = true
        @.appendChild div
        startAjax @,elements
        null
    elements[i].onmouseover = ->
      @.style.cursor = "pointer"
  null