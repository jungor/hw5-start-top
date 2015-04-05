window.onload = function() {
	init();
}

var init = function() {
	buttons = document.getElementsByClassName('button');
	nums = []
	total = document.getElementsByClassName('total')[0];
	info = document.getElementById('info-bar');
	icon = document.getElementsByClassName('apb')[0];
	sum = 0;
	word = ["Button A say: 这是个天大的秘密", "Button B say: 我不知道", "Button C say: 你不知道", "Button D say: 他不知道", "Button E say: 才怪"];
	summary = "大气泡：楼主异步调用战斗力感人，目测不超过";
	for (var index = 0; index < buttons.length; index++) {
		nums[index] = buttons[index].getElementsByClassName('unread')[0];
	}
	for (var index = 0; index < buttons.length; index++) {
		addEventHandler(index);
	}
	info.addEventListener("click", function() {
		if (this.style.cursor == "pointer") {
			total.style.visibility = "visible";
			this.style.cursor = "auto";
			console.log("Sum of the 5 numbers is " + total.innerHTML);
		}
	})
	field = document.getElementById("bottom-positioner");
	field.addEventListener("mouseleave", function() { reset();});
	icon.addEventListener("click", function() {
		robot();
	})
}

var addEventHandler = function(index) {
	var button = buttons[index];
	button.addEventListener("click", function() {
		if (this.style.cursor != "auto") {
			setButtonsStatus(false, false);
			nums[index].style.visibility="visible";
			getRandomNumber(index);
			checkAll();
		}
	})
}

var checkAll = function() {
	var flag = true;
	var sum = 0;
	for (var index = 0; index < nums.length; index++) {
		if (nums[index].innerHTML.length == 0) {
			flag = false;
			break;
		}
		sum += parseInt(nums[index].innerHTML);
	}
	if (flag) {
		info.style.cursor = "pointer";
		total.innerHTML = sum.toString();
	} else {
		info.style.cursor = "auto";
	}
	return flag;
}

var getRandomNumber = function(index) {
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
			nums[index].innerHTML = xmlhttp.responseText;
			console.log("Value of " + ("No." + (index + 1)) + " is " + xmlhttp.responseText);
			setButtonsStatus(true, false);
			checkAll();
		}
	}
	xmlhttp.open('GET', '/', true);
	xmlhttp.send();
}

var setButtonsStatus = function(flag, all) {
	for (var index = 0; index < buttons.length; index++) {
		if (!all && (nums[index].innerHTML != "")) {
			continue;
		}
		buttons[index].style.cursor = flag ? "pointer" : "auto";
		buttons[index].style.backgroundColor = flag ? "blue" : "grey";
	}
}

var reset = function() {
	info.style.cursor = "auto";
	total.style.visibility = "hidden";
	for (var index = 0; index < nums.length; index++) {
		nums[index].style.visibility = "hidden";
		nums[index].innerHTML = "";
	}
	setButtonsStatus(true, true);
	console.log("Reset!");
}

var robot = function() {
	console.log("Robot operation.");
	clickFlag = []
	clickSeq = []
	for (var index = 0; index < buttons.length; index++) {
		clickFlag[index] = false;
	}
	for (var index = 0; index < buttons.length; index++) {
		var pos;
		do {
			pos = Math.floor(Math.random() * buttons.length);
		} while (clickFlag[pos]);
		clickFlag[pos] = true;
		clickSeq[index] = pos;
	}
	total.innerHTML = numToChar();
	total.style.visibility = "visible";
	getRandomNumberAuto(0);
}

var getRandomNumberAuto = function(pos) {
	var index = clickSeq[pos]
	nums[index].style.visibility = "visible";
	setButtonsStatus(false, false);
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState==4 && xmlhttp.status==200) {
			nums[index].innerHTML = xmlhttp.responseText;
			console.log(word[index]);
			if (pos < buttons.length - 1) {
				getRandomNumberAuto(pos + 1);
			} else {
				showSum();
			}
		}
	}
	xmlhttp.open('GET', '/', true);
	xmlhttp.send();
}

var showSum = function() {
	if (checkAllAuto()) {
		setButtonsStatus(false, true);
		console.log(summary + sum);
	} else {
		setButtonsStatus(true, false);
	}
}

var numToChar = function() {
	var character = ['A', 'B', 'C', 'D', 'E'];
	var str = "";
	for (var index in clickSeq) {
		str += character[clickSeq[index]];
	}
	return str;
}

var checkAllAuto = function() {
	var flag = true;
	sum = 0;
	for (var index = 0; index < nums.length; index++) {
		if (nums[index].innerHTML.length == 0) {
			flag = false;
			break;
		}
		sum += parseInt(nums[index].innerHTML);
	}
	if (flag) {
		info.style.cursor = "pointer";
	} else {
		info.style.cursor = "auto";
	}
	return flag;
}