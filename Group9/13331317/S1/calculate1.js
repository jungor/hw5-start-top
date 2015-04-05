window.onload = function() {
	activation();
	getNumbers();
}


function getRandomNumber(circle, flag) {
	var buttons = document.getElementsByTagName("ul");
	var lis = buttons[1].getElementsByTagName("li");
	var xmlHttpReg = null;
	xmlHttpReg = new XMLHttpRequest();
    if (xmlHttpReg != null) {
        xmlHttpReg.open("get", "/", true);
        xmlHttpReg.send();
        xmlHttpReg.onreadystatechange = function(){
        	if (xmlHttpReg.readyState==4 && xmlHttpReg.status == 200) {
            	circle.innerHTML=(xmlHttpReg.responseText);
            	for (var i = 0; i < 5; i++) {
            		flag[i] = 1;
            		lis[i].style.backgroundColor = "#234991";
            	}
            }
        };
    }
}

function getNumbers() {
	var buttons = document.getElementsByTagName("ul");
	var lis = buttons[1].getElementsByTagName("li");
	var ans = buttons[0].getElementsByTagName("li")[0];
	var flag = [];
	var isclicked = [];
	for (var i = 0; i < 5; i++) {
		lis[i].style.backgroundColor = "#234991";
		flag[i] = 1;
		isclicked[i] = 0;
	}
	for (var i = 0; i < 5; i++) {
			lis[i].onclick = function(i) {
				return function() {
					isclicked[i] = 1;
					if (flag[i]) {
						for (var j = 0; j < 5; j++) {
							if (j != i) {
								flag[j] = 0;
								lis[j].style.backgroundColor = "#7E7E7E";
							}
						}
						var circle = this.getElementsByTagName("span")[0];
						circle.style.display = "inline";
						circle.innerHTML = "...";
						getRandomNumber(circle, flag);
					}
				};
			}(i);
	}
	ans.onclick = function() {
		var sum = 0;
		var cansum = 1;
		var numbers = [];
		for (var i = 0; i < 5; i++) {
			if (isclicked[i] == 0) {
				cansum = 0;
			}
		}
		console.log(isclicked);
		if (cansum) {
			var tbuttons = document.getElementsByTagName("ul");
			var tlis = buttons[1].getElementsByTagName("li");
			var tsp = [];
			this.style.backgroundColor = "#234991";
			for (var i = 0; i < 5; i++) {
				tsp[i] = parseInt(tlis[i].getElementsByTagName("span")[0].innerHTML);
				sum += tsp[i];
			}
			buttons[0].getElementsByTagName("li")[0].getElementsByTagName("span")[0].innerHTML = sum;
			for (var i = 0; i < 5; i++) {
				isclicked[i] = 0;
			}
		}	
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