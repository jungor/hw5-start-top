function robot(index, aBubbles) {

  // 生成随机序列
  var randomList = [0, 1, 2, 3, 4];
  randomList.sort(function() {
    return Math.random()-0.5;
  });

  showRandomList(randomList);
  robotClickOnBubble(randomList, 0, aBubbles);
}

// 显示随机序列
function showRandomList(randomList) {
  var oList = document.getElementById('list');
  for (var i = 0; i < randomList.length; i++) {
    switch(randomList[i]) {
      case 0:
        oList.innerHTML += 'A&nbsp';
        break;
      case 1:
        oList.innerHTML += 'B&nbsp';
        break;
      case 2:
        oList.innerHTML += 'C&nbsp';
        break;
      case 3:
        oList.innerHTML += 'D&nbsp';
        break;
      case 4:
        oList.innerHTML += 'E&nbsp';
        break;
    }
  }
}

function robotClickOnBubble(randomList, index, aBubbles) {
  var oBar = document.getElementById('info-bar');
  if (index < aBubbles.length) {
    clickOnBubble(aBubbles[randomList[index]], aBubbles);
    var that = aBubbles[randomList[index]];
    ajax('http://localhost:3000?randnum=' + Math.random(), function(number) {
      if (that.state == 'unclicked' || hasClass(that, 'disable')) {
        return;
      } 
      showNumber(that, number);
      changeState(aBubbles);
      allNumbersGot(aBubbles);
      robotClickOnBubble(randomList, index+1, aBubbles);
    });
  } else {
    addUp(oBar, aBubbles);
  }
}