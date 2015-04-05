mousePosition = (ev) ->
  if ev.pageX || ev.pageY
    return {x: ev.pageX, y: ev.pageY}
  return { 
    x:ev.clientX + document.body.scrollLeft - document.body.clientLeft, 
    y:ev.clientY + document.body.scrollTop - document.body.clientTop }

judgeIn = (position, mousePos) ->
  if mousePos.x >= position.left && mousePos.x <= position.right && mousePos.y >= position.top && mousePos.y <= position.bottom
    return true
  return false

deleteSpan = (str) ->
  strs = str.split("<span")
  return strs[0];

addSpan = (str) ->
  str += "<span class='unread'>...</span>"
  return str

addSpanByNum = (str, num) ->
  str += "<span class='unread'>"+num.toString()+"</span>"
  return str

$ !->
  controlRing = document.getElementById("control-ring")
  info_bar = document.getElementById("info-bar")
  main_container = document.getElementById("button")
  ringListState = new Array(-1, -1, -1, -1, -1)
  resetControlRing()
  ringList = controlRing.children
  ringListLength = controlRing.childElementCount
  main_container.onmouseleave = (ev) !~>
      mousePos = mousePosition(ev)
      Position = main_container.getBoundingClientRect()
      if judgeIn(Position, mousePos)
        return
      for i from 0 to ringListState.length-1 by 1
        if ringListState[i] == -2 || ringListState[i] == -3 
          ringListState[i] = -3
        else 
          ringListState[i] = -1
      resetControlRing()
      resetBigButton()
      enableRingList(ringListState)
  main_container.onclick = !->
      for i from 0 to ringListState.length-1 by 1
        if ringListState[i] == -1 || ringListState[i] == -3
          continue
        return
      ringListClickByRobot(ringList, ringListState)
  

ringListClickByRobot = (ringList, ringListState) !->
  for i from 0 to ringListState.length-1 by 1
    disableAllRingListExceptThis(i)
    ringListState[i] = -2
    ringListSelected = ringList[i]
    ringListSelected.innerHTML = deleteSpan(ringListSelected.innerHTML)
    ringListSelected.innerHTML = addSpan(ringListSelected.innerHTML);  
    ringListNum = 0
    temp = ringListState
    XMLHttp.sendReq('GET', 'http://localhost:3000', '', (random_num) !~>
      ringListState = temp
      for i from 0 to ringListNum-1 by 1
        if ringListState[i] == -1
          ringListState = [-1, -1, -1, -1, -1]
          enableRingList(ringListState)
          return
      ringListSelected = ringList[ringListNum];
      ringListSelected.innerHTML = deleteSpan(ringListSelected.innerHTML);
      ringListSelected.innerHTML = addSpanByNum(ringListSelected.innerHTML, random_num);
      ringListState[ringListNum] = random_num;
      disableThisRingList(ringListNum);
      enableRingList(ringListState);
      checkBigButton(ringListState);
      ringListNum++;
      if ringListNum == ringListState.length
        disableBitButtonNotChangeRingList(ringListState)
    )


disableAllRingListExceptThis = (ringListNum) !->
  controlRing = document.getElementById("control-ring")
  ringList = controlRing.children
  ringListLength = controlRing.childElementCount
  for i from 0 to ringListLength-1 by 1
    if i != ringListNum
      ringList[i].className = ringList[i].className.split("button")[0] + "button" + "unactive"

disableThisRingList = (ringListNum) !->
  controlRing = document.getElementById("control-ring")
  ringList = controlRing.children
  ringList[ringListNum].className = ringList[ringListNum].className.split("button")[0] + "button" + "unactive"

enableRingList = (ringListState) !->
  controlRing = document.getElementById("control-ring")
  ringList = controlRing.children;
  ringListLength = controlRing.childElementCount;
  for i from 0 to ringListLength-1 by 1
    if ringListState[i] == -1
      ringList[i].className = ringList[i].className.split("button")[0] + "button " + "active"

disableBitButtonNotChangeRingList = (ringListState) !->
  info_bar = document.getElementById("info-bar")
  info_bar.style.background = "gray"
  sum = 0
  sum = parseInt(sum)
  for i from 0 to ringListState.length-1 by 1
    sum += parseInt(ringListState[i])
  info_bar.innerHTML = "<br>" + sum.toString()

disableBitButton = (ringListState) !->
  disableBitButtonNotChangeRingList(ringListState)
  resetControlRing()

enableBitButton = !->
  info_bar = document.getElementById("info-bar")
  info_bar.style.background = "blue"

checkBigButton = (ringListState) ->
  for i from 0 to ringListState.length-1 by 1
    if ringListState[i] < 0
      return false
  enableBitButton()
  return true

resetControlRing = !->
  controlRing = document.getElementById("control-ring")
  ringList = controlRing.children
  ringListLength = controlRing.childElementCount
  for i from 0 to ringListLength-1 by 1
    ringList[i].innerHTML = deleteSpan(ringList[i].innerHTML)


resetBigButton = !->
  info_bar = document.getElementById("info-bar")
  info_bar.style.background = "gray"
  info_bar.innerHTML = ""
