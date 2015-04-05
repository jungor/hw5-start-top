window.onload = function() {
	activation();
	getNumbers();
}

var pan = 0;
var count = 0;
var answ = 0;
var isclicking = [];
var isclicked = [];
for (var i = 0; i < 5; i++) {
	isclicked[i] = 0;
	isclicking[i] = 0;
}

function getRandomNumber(circle) {
	if (count != 5) {
		var buttons = document.getElementsByTagName("ul");
		var lis = buttons[1].getElementsByTagName("li");
		var xmlHttpReg = null;
		console.log(circle[count]);
		circle[count].style.display = "inline";
		circle[count].innerHTML = "...";
		xmlHttpReg = new XMLHttpRequest();
	    if (xmlHttpReg != null) {
	        xmlHttpReg.open("get", "/", true);
	        xmlHttpReg.send();
	        xmlHttpReg.onreadystatechange = function(){
	        	if (xmlHttpReg.readyState==4 && xmlHttpReg.status == 200) {
	        			for (var i = 0; i < 5; i++) {
		            		if (i == count+1) {
		            			lis[i].style.backgroundColor = "#234991";
		            		}
		            		else {
		            			lis[i].style.backgroundColor = "#7E7E7E"
		            		}
		            	}
		            	circle[count].innerHTML=(xmlHttpReg.responseText);

		            	answ += parseInt(circle[count].innerHTML);
		            	count++;
		            	getRandomNumber(circle);
	            }
	        };
	    }
	}
	if (count == 5) {
		var buttons = document.getElementsByTagName("ul");
		buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML = answ;
	}
}

function getNumbers() {
	var buttons = document.getElementsByTagName("ul");
	var lis = buttons[1].getElementsByTagName("li");
	var ans = buttons[0].getElementsByTagName("li")[0];
	var atplus = document.getElementById("button");
	var flag = [];
	var sum = 0;
	atplus.onclick = function(){
		for (var i = 0; i < 5; i++) {
			lis[i].style.backgroundColor = "#234991";
			flag[i] = 1;
		}
		var circle = [];
		for (var i = 0; i < 5; i++) {
				circle[i] = lis[i].getElementsByTagName("span")[0];
		}
				getRandomNumber(circle);
	};


}

function activation() {
	var buttons = document.getElementById("button");
	buttons.onmouseover = function() {
		document.getElementById("area").className = "at-plus-container-block";
		this.id = "button_hover";
	};
	var area = document.getElementById("area");
	area.onmouseleave = function() {
		location.reload();
	};
	var area = document.getElementById("area"); 
}