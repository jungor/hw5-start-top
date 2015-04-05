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
	count = 0, judgy = 1;
	document.getElementsByClassName("user")[0].children[0].innerText = "";
	var buttons = document.body.getElementsByClassName("button");
	for (var i = 0; i < buttons.length; ++i) {
		buttons[i].onclick = getNumber;
		buttons[i].children[1].style.display = "none";
		buttons[i].style.backgroundColor = "blue";
	}
	t = setInterval(reset, 100);
}

var count = 0;

function getNumber() {
	var request = createRequest();
	var url = "/";
	if (request == null) {
    	alert("Unable to create request");
    	return;
  	}
  	var that = this;
  	var circle = that.children[1];
  	disableButton(this);
  	request.open("GET", url, true);
  	request.onreadystatechange = function() {
  		if (request.readyState == 4) {
	    	if (request.status == 200) {
	    		++count;
	    		if (count == 5) {
	    			enableSum();
	    		}
				circle.style.display = "inline";
				circle.innerText = request.responseText;
				enableButton(that);
				that.style.backgroundColor = "grey";
				if (!judgy) {
					initPage();
				}
			}
		}
  	};
  	request.send(null);
  	circle.style.display = "inline";
  	circle.innerText = "...";
  	disableButton(this);
}

function disableButton(t) {
	var buttons = document.body.getElementsByClassName("button");
	for (var i = 0; i < buttons.length; ++i) {
		if (buttons[i] != t) {
			buttons[i].onclick = "";
			buttons[i].style.backgroundColor = "grey";
		} else {
			buttons[i].onclick = "";
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

function enableSum() {
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
		initPage();
	}
}

