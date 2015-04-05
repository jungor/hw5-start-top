// const vars
var MAX_RINGS = 5;

// use a function to get all ring buttons
function getRingButtons() {
	return document.getElementsByClassName("button");
}

// main
window.onload = function() {
	// initialize the data and style of the whole Ring
	Initialization();
	var icon = document.getElementsByClassName("apb");
	
	var ringButtons = getRingButtons();
	/*
	// use clouser for the event onclick for each ring elements
	for (var i = 0; i < ringButton.length; i++) {
		ringButton[i].onclick = function(i) {
			return function() {
				// send a requeset to server to get a random number
				ServerRequest(ringButton[i].childNodes[1]);
			}
		}(i);
	}
	*/

	// set a event for the big ring(to sum up all the numbers)
	var BigRing = document.getElementById("info-bar");
	BigRing.onclick = function() {
		// to sum up all the numbers
		BigRingCount();
	}

	icon[0].onclick = function() {
		for(var i = 0; i < ringButtons.length; i++) {
			ServerRequest(ringButtons, i);
		}
	}

	icon[0].onmouseover = function() {
		// for each time the mouse leave the @+, do an initialization
		Initialization();
	}
}

// initial function, reset all the numbers of the ring and the sum of the big ring
function Initialization() {
	ringButton = getRingButtons();
	// refers to the big ring
	var BigRing = document.getElementById("info-bar");
	// refers to the big ring's content
	var BigRingContent = document.getElementsByClassName("sum");
	BigRingContent[0].innerHTML = "";

	for(var i = 0; i < ringButton.length; i++) {
		// no red circle beside the ring element
		ringButton[i].childNodes[1].style.display = "none";
		// the red circle is empty
		ringButton[i].childNodes[1].innerHTML = "";
		// all ring elements are available to click
		ringButton[i].setAttribute("disable", "");
		// the background color is reset
		ringButton[i].style.backgroundColor = "#1C499E";
	}
}


// this function is for handling Server Requests
function ServerRequest(RequestButtons, i) {
	theButton = RequestButtons[i].childNodes[1];
	var XMLhttp = new XMLHttpRequest();

	DisableRingButtons();

	theButton.style.display = "block";
	theButton.innerHTML = "...";

	XMLhttp.open("GET","http://localhost:3000/?query=" + i, true);
	XMLhttp.send(null);

	// callback function for ajax
	XMLhttp.onreadystatechange = function(i, theButton) {
		return function() {
			if ( XMLhttp.readyState == 4 &&  XMLhttp.status == 200) {
				// get result
				var result =  XMLhttp.responseText;
				// write result
				theButton.innerHTML = result;
				// when the last one is finished, it will sum up all the numbers in the big ring
				BigRingCount();
			}
		}
	}(i, theButton);
	
}

// disable ring Buttons
function DisableRingButtons() {
	var ringButton = getRingButtons();

	for (var i = 0; i < ringButton.length; i++) {
		if (ringButton[i].getAttribute("disable") != "Disable2") {
			ringButton[i].setAttribute("disable", "Disable");
		}
		ringButton[i].style.backgroundColor = "#999FD3";
	}
}

// Activate ring buttons
function ActivateRingButtons() {
	var ringButton = getRingButtons();

	for (var i = 0; i < ringButton.length; i++) {
		if (ringButton[i].getAttribute("disable") != "Disable2") {
			ringButton[i].setAttribute("disable", "");
			ringButton[i].style.backgroundColor = "#1C499E";
		}
	}
}

// count the numbers of all ring elements
function BigRingCount() {
	var BigRing = document.getElementsByClassName("sum");
	var sum = 0;
	var ringButtons = getRingButtons();

	for (var i = 0; i < ringButtons.length; i++) {
		if(ringButtons[i].childNodes[1].innerHTML == "" || ringButtons[i].childNodes[1].innerHTML == "...")
			return;
		sum +=  parseInt(ringButtons[i].childNodes[1].innerHTML);
	}

	BigRing[0].innerHTML = sum;
}