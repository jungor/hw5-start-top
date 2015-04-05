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

function getRandomNumber(circle, anynum) {
	if (count != 5) {
		var buttons = document.getElementsByTagName("ul");
		var lis = buttons[1].getElementsByTagName("li");
		var xmlHttpReg = null;
		console.log(circle[anynum[count]]);
		circle[anynum[count]].style.display = "inline";
		circle[anynum[count]].innerHTML = "...";
		xmlHttpReg = new XMLHttpRequest();
	    if (xmlHttpReg != null) {
	        xmlHttpReg.open("get", "/", true);
	        xmlHttpReg.send();
	        xmlHttpReg.onreadystatechange = function(){
	        	if (xmlHttpReg.readyState==4 && xmlHttpReg.status == 200) {
	        			for (var i = 0; i < 5; i++) {
		            		if (i == anynum[count+1]) {
		            			lis[i].style.backgroundColor = "#234991";
		            		}
		            		else {
		            			lis[i].style.backgroundColor = "#7E7E7E"
		            		}
		            	}
		            	circle[anynum[count]].innerHTML=(xmlHttpReg.responseText);

		            	answ += parseInt(circle[anynum[count]].innerHTML);
		            	count++;
		            	getRandomNumber(circle, anynum);
	            }
	        };
	    }
	}
	if (count == 5) {
		var buttons = document.getElementsByTagName("ul");
		buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML += answ;
	}
}

function getNumbers() {
	var buttons = document.getElementsByTagName("ul");
	var lis = buttons[1].getElementsByTagName("li");
	var ans = buttons[0].getElementsByTagName("li")[0];
	var atplus = document.getElementById("button");
	var anynum = [];
	var sum = 0;
	atplus.onclick = function(){
		for (var i = 0; i < 5; i++) {
			lis[i].style.backgroundColor = "#234991";
		}
		var circle = [];
		for (var i = 0; i < 5; i++) {
				circle[i] = lis[i].getElementsByTagName("span")[0];
				anynum[i] = i;
		}
		anynum = anynum.sort(randomsort);
		var alpha = changeToAlpha(anynum);
		buttons[0].getElementsByTagName("li")[0].
		getElementsByTagName("span")[0].
		innerHTML = alpha+'\n'+'Answer:';
				getRandomNumber(circle, anynum);

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

function randomsort(a, b) {
        return Math.random()>.5 ? -1 : 1;
//用Math.random()函数生成0~1之间的随机数与0.5比较，返回-1或1
}

function changeToAlpha(array) {
	var alpha = "";
	for (var i = 0; i < array.length; i++) {
		if (array[i] == 0) {
			alpha += "A";
		}
		else if (array[i] == 1) {
			alpha += "B";
		}
		else if (array[i] == 2) {
			alpha += "C";
		}
		else if (array[i] == 3) {
			alpha += "D";
		}
		else if (array[i] == 4) {
			alpha += "E";
		}
	}
	return alpha;
}