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
      ringListClickByRobot(ringList, ringListState, 0)

ringListClickByRobot = (ringList, ringListState, ringListNum) !->
  ringListSelected = ringList[ringListNum]
  if ringListState[ringListNum] != -1
    return
  for i from 0 to ringListState.length-1 by 1
    if ringListState[i] == -2
      return
  disableAllRingListExceptThis(ringListNum)
  ringListState[ringListNum] = -2
  ringListSelected.innerHTML = deleteSpan(ringListSelected.innerHTML)
  ringListSelected.innerHTML = addSpan(ringListSelected.innerHTML)
  _ajax = $.ajax({
      url:"http://localhost:3000",
      ataType:"jsonp"
  })
  _ajax.done (random_num) !~>
    if ringListState[ringListNum] == -3
      ringListState[ringListNum] = -1
      enableRingList(ringListState)
      return
    ringListSelected.innerHTML = deleteSpan(ringListSelected.innerHTML)
    ringListSelected.innerHTML = addSpanByNum(ringListSelected.innerHTML, random_num)
    ringListState[ringListNum] = random_num
    disableThisRingList(ringListNum)
    enableRingList(ringListState)
    checkBigButton(ringListState)
    if ringListNum < ringListState.length-1
      ringListClickByRobot(ringList, ringListState, ++ringListNum)
    else 
      disableBitButtonNotChangeRingList(ringListState)
  _ajax.fail (errData) !~>
      console.log("got an error", errData)


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
  sum = 0;
  sum = parseInt(sum);
  for i from 0 to ringListState.length-1 by 1
    sum += parseInt(ringListState[i])
  info_bar.innerHTML = "<br>" + sum.toString();

disableBitButton = (ringListState) !->
  info_bar = document.getElementById("info-bar")
  info_bar.style.background = "gray"
  sum = 0
  sum = parseInt(sum)
  for i from 0 to ringListState.length-1 by 1
    sum += parseInt(ringListState[i])
  info_bar.innerHTML = "<br>" + sum.toString()
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
