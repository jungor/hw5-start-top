// const vars
var MAX_RINGS = 5;
var RANDOM = [0,1,2,3,4];

// a function for randomsorting
function randomsort(a, b) {  
        return Math.random()>.5 ? -1 : 1;  
}  

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
		RANDOM.sort(randomsort);
		ServerRequest(ringButtons, 0);
	}

	icon[0].onmouseover = function() {
		// for each time the mouse leave the @+, do an initialization
		Initialization();
	}
}

// initial function, reset all the numbers of the ring and the sum of the big ring
function Initialization() {
	RANDOM.sort(randomsort);
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
	var current = RANDOM[i];

	theButton = RequestButtons[current].childNodes[1];
	var XMLhttp = new XMLHttpRequest();

	DisableRingButtons();

	theButton.style.display = "block";
	RequestButtons[current].style.backgroundColor = "#1C499E";
	theButton.innerHTML = "...";

	XMLhttp.open("GET","http://localhost:3000/",true);
	XMLhttp.send(null);

	// callback function for ajax
	XMLhttp.onreadystatechange = function() {
		if ( XMLhttp.readyState == 4 &&  XMLhttp.status == 200) {
			// get result
			var result =  XMLhttp.responseText;
			// write result
			theButton.innerHTML = result;
			ActivateRingButtons();
			RequestButtons[current].style.backgroundColor = "#999FD3";
			// disable thr current button forever
			RequestButtons[current].setAttribute("disable", "Disable2")

			// robot will continously call it again
			if (i < MAX_RINGS-1) {
				ServerRequest(RequestButtons, i+1);
			} else {
				BigRingCount();
			}
		}
	}
	
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
		if(ringButtons[i].childNodes[1].innerHTML == "")
			return;
		sum +=  parseInt(ringButtons[i].childNodes[1].innerHTML);
	}

	BigRing[0].innerHTML = sum;
}