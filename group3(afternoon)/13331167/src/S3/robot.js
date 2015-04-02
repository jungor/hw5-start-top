function robot(aBubbles) {
  var oBar = document.getElementById('info-bar');
  for(var i = 0; i < aBubbles.length; i++) {
    removeClass(aBubbles[i], 'enable');
    addClass(aBubbles[i], 'disable'); 
  
    clickOnBubble(aBubbles[i], aBubbles);
    var count = 0;

    ajax('http://localhost:3000?randnum=' + Math.random(), function(number, index) {
      showNumber(aBubbles[index], number);
      changeState(aBubbles);
      if (count == aBubbles.length-1) {
        allNumbersGot(aBubbles);
        addUp(oBar, aBubbles);
      }
      count++;
    }, i); 
  }
}