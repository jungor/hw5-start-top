window.onload = initPage();

function createRequest() {
  try {
    request = new XMLHttpRequest();
  } catch (tryMS) {
    try {
      request = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (otherMS) {
      try {
        request = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (failed) {
        request = null;
      }
    }
  }	
  return request;
}

function initPage() {
	count = 0;
	document.getElementsByClassName("apb")[0].onclick = robot;
	document.getElementsByClassName("user")[0].children[0].innerText = "";

	var buttons = document.body.getElementsByClassName("button");
	for (var i = 0; i < buttons.length; ++i) {
		buttons[i].onclick = getNumber;
		buttons[i].children[1].style.display = "none";
		buttons[i].style.backgroundColor = "blue";
	}
	t = setInterval(reset, 100);
}

var count = 0, judgy = 1;

function getNumber(t, i) {
	var request = createRequest();
	var url = "/";
	if (request == null) {
    	alert("Unable to create request");
    	return;
  	}
  	if (i != undefined) {
  		var that = t[i];
  	} else {
  		var that = this;
  		judgy = 1;
  	}
  	var circle = that.children[1];
  	request.open("GET", url, true);
  	request.onreadystatechange = function() {
  		if (request.readyState == 4) {
	    	if (request.status == 200) {
	    		++count;
				circle.style.display = "inline";
				circle.innerText = request.responseText;
				that.style.backgroundColor = "grey";
				enableButton(that);
				if (judgy) {
					if (count != 5 && i != undefined) {
						getNumber(t, count);
					} else {
						if (count == 5)
							if (i != undefined) {
								enableSum1();
							} else {
							 	enableSum2();
							}
					}
				} else {
					initPage();
					request.abort();
				}
			}
		}
  	};
  	request.send(null);
  	circle.style.display = "inline";
  	circle.innerText = "...";
  	disableButton(that);
}

function disableButton(t) {
	var buttons = document.body.getElementsByClassName("button");
	for (var i = 0; i < buttons.length; ++i) {
		if (buttons[i] != t) {
			buttons[i].onclick = "";
			buttons[i].style.backgroundColor = "grey";
		}
	}
}

function enableButton(t) {
	var buttons = document.body.getElementsByClassName("button");
	for (var i = 0; i < buttons.length; ++i) {
		if (buttons[i] != t && buttons[i].children[1].style.display == "none") {
			buttons[i].onclick = getNumber;
			buttons[i].style.backgroundColor = "blue";
		}
	}
}

function enableSum1() {
	var button = document.getElementById("info-bar");
	button.style.backgroundColor = "blue";
	setTimeout(getSum, 1000);
}

function enableSum2() {
	var button = document.getElementById("info-bar");
	button.style.backgroundColor = "blue";
	button.onclick = getSum;
}

function getSum() {
	var buttons = document.body.getElementsByClassName("button");
	var user = document.getElementsByClassName("user");
	var button = document.getElementById("info-bar");
	var sum = 0;
	for (var i = 0; i < buttons.length; ++i) {
		sum += parseInt(buttons[i].children[1].innerText);
	}
	button.style.backgroundColor = "grey";
	button.onclick = "";
	user[0].children[0].innerText = sum;

}

function reset() {
	var image = document.getElementsByClassName("apb")[0];
	if (document.defaultView.getComputedStyle(image,null)["backgroundColor"] == "rgb(128, 128, 128)") {
		clearInterval(t);
		judgy = 0;
		var buttons = document.body.getElementsByClassName("button");
		var button = document.getElementById("info-bar");
		var aButton = document.getElementsByClassName("apb")[0]; 
		var whiteImage = document.getElementById("white");
		var greenImage = document.getElementById("green");
		count = 0;
		initPage();
	}
}

function robot() {
	judgy = 1;
	initPage();
	buttons = document.body.getElementsByClassName("button");
	document.getElementsByClassName("apb")[0].onclick = "";
	for (var i = 0; i < buttons.length; ++i) {
		buttons[i].style.backgroundColor = "blue";
	}
	getNumber(buttons , 0)
}

