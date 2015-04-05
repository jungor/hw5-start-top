window.onload=function () {
	makeAllButtonFunctional(getAllButtons());
	makeButtonClearable(getContainer());
}

function getContainer() {
	return document.getElementById("button");
}

function getAllButtons() {
	return document.getElementsByClassName("button");;
}

function getBubble() {
	return document.getElementsByClassName("info")[0];
}

function makeButtonClearable(container) {
	container.onmouseout = function() {
		var x=event.clientX;
       	var y=event.clientY;  
       	var divx1 = this.offsetLeft;  
       	var divy1 = this.offsetTop;  
       	var divx2 = this.offsetLeft + this.offsetWidth;  
       	var divy2 = this.offsetTop + this.offsetHeight;
       	if (x < divx1 || x > divx2 || y < divy1 || y > divy2) {  
			clearAndAbleAllButtons();
			clearButtle();
		}
	};
}

function makeAllButtonFunctional(buttons) {
	for (var i = 0; i < buttons.length; i++) {
		makeButtonFunctional(buttons[i]);
	};
}

function makeButtonFunctional(button) {
	button.onclick = function(button) {
		return function() {
			requestRamdomNumber(button);
			disableOtherButtons(button);
		}
	}(button);
}

function requestRamdomNumber(button) {
	button.getElementsByTagName("span")[0].style.opacity = 1;

	xmlhttp=null;
	if (window.XMLHttpRequest) {  // code for IE7, Firefox, Opera, etc.
		xmlhttp=new XMLHttpRequest();
	}
	else if (window.ActiveXObject) {  // code for IE6, IE5
	  	xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	if (xmlhttp!=null) {
	  	xmlhttp.onreadystatechange = function(button) {
	  		return function() {
	  			getRamdomNumber(button);
	  		}
	  	}(button);
	  	xmlhttp.open("GET","/",true);
	  	xmlhttp.send(null);
	}
	else {
	  alert("Your browser does not support XMLHTTP.");
	}
}

function getRamdomNumber(button) {
	if (xmlhttp.readyState == 4) {  // 4 = "loaded"
  		if (xmlhttp.status==200) {  // 200 = "OK"
    		button.getElementsByTagName("span")[0].innerHTML=xmlhttp.responseText;
    		ableOtherButtons(button);

    		if (AllButtonsDisabled(getAllButtons())) {
    			makeBubbleFunctional(getBubble());
    		}

    	} else {
    		alert("Problem retrieving XML data:" + xmlhttp.statusText);
    	}
  	}	
}

function disableOtherButtons(thisButton) {
	var buttons = getAllButtons();
	for (var i = 0; i < buttons.length; i++) {
		if (!buttons[i].isSameNode(thisButton)) {
			buttons[i].onclick = null;
			buttons[i].style.backgroundColor = 'grey';
		}
	};
}

function ableOtherButtons(thisButton) {
	var buttons = getAllButtons();
	for (var i = 0; i < buttons.length; i++) {
		if (!buttons[i].isSameNode(thisButton)) {
			if (buttons[i].getElementsByTagName('span')[0].innerHTML == '...') {
				buttons[i].onclick = function(button) {
					return function() {
						requestRamdomNumber(button);
						disableOtherButtons(button);
					}
				}(buttons[i]);
				buttons[i].style.backgroundColor = 'rgba(48, 63, 159, 1)';
			}
		}
	};
	thisButton.onclick = null;
	thisButton.style.backgroundColor = 'grey';
}

function clearAndAbleAllButtons() {
	var buttons = getAllButtons();
	for (var i = 0; i < buttons.length; i++) {
		buttons[i].getElementsByTagName("span")[0].innerHTML = '...';
		buttons[i].getElementsByTagName("span")[0].style.opacity = 0;
		buttons[i].style.backgroundColor = 'rgba(48, 63, 159, 1)';
		buttons[i].onclick = function(button) {
			return function() {
				requestRamdomNumber(button);
				disableOtherButtons(button);
			}
		}(buttons[i]);
	}
}

function AllButtonsDisabled(buttons) {
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getElementsByTagName('span')[0].innerHTML == '...') {
			return false;
		}
	};
	return true;
}

function clearButtle() {
	var bubble = getBubble();
	bubble.getElementsByTagName("span")[0].innerHTML = '';
	bubble.getElementsByTagName("span")[0].style.opacity = 0;
}

function makeBubbleFunctional(bubble) {
	bubble.style.backgroundColor = 'rgba(48, 63, 159, 1)';
	bubble.onclick = function() {
		var sum = 0;
		var buttons = getAllButtons();
		for (var i = 0; i < buttons.length; i++) {
			sum += parseInt(buttons[i].getElementsByTagName('span')[0].innerHTML);
		};
		bubble.getElementsByTagName("span")[0].innerHTML = sum;
		bubble.getElementsByTagName("span")[0].style.opacity = 1;
		bubble.style.backgroundColor = 'grey';
		bubble.onclick = null;
	}
}