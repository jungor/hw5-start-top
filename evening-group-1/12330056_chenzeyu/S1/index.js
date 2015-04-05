window.onload = function() {
	init();
}

var init = function() {
	RESET = window.setTimeout(reset, 2000);
	buttons = document.getElementsByClassName('button');
	nums = []
	total = document.getElementsByClassName('total')[0];
	info = document.getElementById('info-bar');
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