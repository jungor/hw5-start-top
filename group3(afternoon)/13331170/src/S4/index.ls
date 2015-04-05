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
      clearRandomListNum()
  main_container.onclick = !->
      for i from 0 to ringListState.length-1 by 1
        if ringListState[i] == -1 || ringListState[i] == -3
          continue
        return
      randomList = [0, 1, 2, 3, 4];
      randomList.sort( !->
        return Math.random()-0.5)
      setRandomListNum(randomList)
      ringListClickByRobot(ringList, ringListState, 0, randomList)
  

ringListClickByRobot = (ringList, ringListState, ringListNum, randomList) !->
  ringListSelectedNum = randomList[ringListNum]
  ringListSelected = ringList[ringListSelectedNum]
  if ringListState[ringListSelectedNum] != -1
    return
  for i from 0 to ringListState.length-1 by 1
    if ringListState[i] == -2
      return
  disableAllRingListExceptThis(ringListSelectedNum)
  ringListState[ringListSelectedNum] = -2
  ringListSelected.innerHTML = deleteSpan(ringListSelected.innerHTML)
  ringListSelected.innerHTML = addSpan(ringListSelected.innerHTML)
  _ajax = $.ajax({
      url:"http://localhost:3000",
      ataType:"jsonp"
  })
  _ajax.done (random_num) !~>
    if ringListState[ringListSelectedNum] == -3
      ringListState[ringListSelectedNum] = -1
      enableRingList(ringListState)
      return
    ringListSelected.innerHTML = deleteSpan(ringListSelected.innerHTML)
    ringListSelected.innerHTML = addSpanByNum(ringListSelected.innerHTML, random_num)
    ringListState[ringListSelectedNum] = random_num
    disableThisRingList(ringListSelectedNum)
    enableRingList(ringListState)
    checkBigButton(ringListState)
    if ringListNum < ringListState.length-1
      ringListClickByRobot(ringList, ringListState, ++ringListNum, randomList)
    else 
      disableBitButtonNotChangeRingList(ringListState, randomList)
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

clearRandomListNum = !->
  ringListNumStr = document.getElementById("randomListNum")
  ringListNumStr.textContent = ""

setRandomListNum = (randomList) !->
  ringListNumStr = document.getElementById("randomListNum")
  strTemp = ""
  for i from 0 to randomList.length-1 by 1
    if randomList[i] == 0
      strTemp += 'A '
      continue
    if randomList[i] == 1
      strTemp += 'B '
      continue
    if randomList[i] == 2
      strTemp += 'C '
      continue
    if randomList[i] == 3
      strTemp += 'D '
      continue
    if randomList[i] == 4
      strTemp += 'E '
      continue
  ringListNumStr.textContent = strTemp;
