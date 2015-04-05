window.onload = function() {
	var buttons = document.getElementsByClassName('button');
	var infobar = document.getElementById('info-bar');
	for (var i = 0; i < buttons.length; i++) {
		addClass(buttons[i], 'enable');
		buttons[i].addEventListener('click', myenable);
	}
	addClass(infobar, 'enable');
	infobar.addEventListener('click', myenable);
	document.getElementById('at-plus-container').onmouseleave = reset;
	document.getElementsByClassName('apb')[0].onclick = machine;
};

function randomsort(a, b) {
	return Math.random() > .5 ? -1:1;
}

function machine() {
	var main = new Object();
	var numarr = [0, 1, 2, 3, 4];
	var buttons = document.getElementsByClassName('button');
	numarr.sort(randomsort);

	main.sum = 0;
	main.index = 0;
	main.buttons = buttons;
	main.infobar = document.getElementById('info-bar');
	main.xmlhttp = new XMLHttpRequest();
	main.arr = numarr;

	switch(numarr[main.index]) {
			case 0:
				ahandler(main);
				break;
			case 1:
				bhandler(main);
				break;
			case 2:
				chandler(main);
				break;
			case 3:
				dhandler(main);
				break;
			default:
				ehandler(main);
				break;
		}
}

function Load(url, cfunc, xmlhttp) {
	xmlhttp.onreadystatechange = cfunc;
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
} 


function ahandler(main) {
	//show unread
	var count = document.createElement('span');
	count.className = 'unread';
	count.innerHTML = '...';
	main.buttons[0].appendChild(count);

	for (var i = 0; i < main.buttons.length; i++) {
		if (i == 0) continue;
		removeClass(main.buttons[i], 'enable');
	}
	main.infobar.getElementsByClassName('item')[0].innerHTML = '这是个天大的秘密';

	//异步调用和处理异常
	try {
	Load("/", function(){
		if (main.xmlhttp.readyState == 4 && main.xmlhttp.status==200) {
			count.innerHTML = main.xmlhttp.responseText;
		
			for (var i = 0; i < main.buttons.length; i++) {
				if (i == 0) 
					removeClass(main.buttons[i], 'enable');
				else
					addClass(main.buttons[i], 'enable');
			}
			main.index++;
			//分布求和与参数传递
			main.sum += parseInt(main.xmlhttp.responseText);
			if (main.index == 5)
				bubblehandler(main);
			else 
			{
					switch(main.arr[main.index]) {
						case 1:
							bhandler(main);
							break;
						case 2:
							chandler(main);
							break;
						case 3:
							dhandler(main);
							break;
						default:
							ehandler(main);
							break;
					}
			}
		} else {
			var e = {'message':'这是个天大的秘密', 'currentsum': main.sum};
			throw e;
		}
	}, main.xmlhttp);
	}
	catch(e) {
		alert(e.message + e.currentsum);
	}
}

function bhandler(main) {
	//show unread
	var count = document.createElement('span');
	count.className = 'unread';
	count.innerHTML = '...';
	main.buttons[1].appendChild(count);

	for (var i = 0; i < main.buttons.length; i++) {
		if (i == 1) continue;
		removeClass(main.buttons[i], 'enable');
	}
	main.infobar.getElementsByClassName('item')[0].innerHTML = '我不知道';

	//异步调用和处理异常
	try {
	Load("/", function(){
		if (main.xmlhttp.readyState == 4 && main.xmlhttp.status==200) {
			count.innerHTML = main.xmlhttp.responseText;
		
			for (var i = 0; i < main.buttons.length; i++) {
				if (i == 0) 
					removeClass(main.buttons[i], 'enable');
				else
					addClass(main.buttons[i], 'enable');
			}
			main.index++;
			//分布求和与参数传递
			main.sum += parseInt(main.xmlhttp.responseText);
			if (main.index == 5)
				bubblehandler(main);
			else 
			{
					switch(main.arr[main.index]) {
						case 0:
							ahandler(main);
							break;
						case 2:
							chandler(main);
							break;
						case 3:
							dhandler(main);
							break;
						default:
							ehandler(main);
							break;
					}
			}
		} else {
			var e = {'message':'这是个天大的秘密', 'currentsum': main.sum};
			throw e;
		}
	}, main.xmlhttp);
	}
	catch(e) {
		alert(e.message + e.currentsum);
	}
}
function chandler(main) {
	//show unread
	var count = document.createElement('span');
	count.className = 'unread';
	count.innerHTML = '...';
	main.buttons[2].appendChild(count);

	for (var i = 0; i < main.buttons.length; i++) {
		if (i == 2) continue;
		removeClass(main.buttons[i], 'enable');
	}
	main.infobar.getElementsByClassName('item')[0].innerHTML = '你不知道';

	//异步调用和处理异常
	try {
	Load("/", function(){
		if (main.xmlhttp.readyState == 4 && main.xmlhttp.status==200) {
			count.innerHTML = main.xmlhttp.responseText;
		
			for (var i = 0; i < main.buttons.length; i++) {
				if (i == 2) 
					removeClass(main.buttons[i], 'enable');
				else
					addClass(main.buttons[i], 'enable');
			}
			main.index++;
			//分布求和与参数传递
			main.sum += parseInt(main.xmlhttp.responseText);
			if (main.index == 5)
				bubblehandler(main);
			else 
			{
					switch(main.arr[main.index]) {
						case 0:
							ahandler(main);
							break;
						case 1:
							bhandler(main);
							break;
						case 3:
							dhandler(main);
							break;
						default:
							ehandler(main);
							break;
					}
			}
		} else {
			var e = {'message':'这是个天大的秘密', 'currentsum': main.sum};
			throw e;
		}
	}, main.xmlhttp);
	}
	catch(e) {
		alert(e.message + e.currentsum);
	}
}

function dhandler(main) {
	//show unread
	var count = document.createElement('span');
	count.className = 'unread';
	count.innerHTML = '...';
	main.buttons[3].appendChild(count);

	for (var i = 0; i < main.buttons.length; i++) {
		if (i == 3) continue;
		removeClass(main.buttons[i], 'enable');
	}
	main.infobar.getElementsByClassName('item')[0].innerHTML = '他不知道';

	//异步调用和处理异常
	try {
	Load("/", function(){
		if (main.xmlhttp.readyState == 4 && main.xmlhttp.status==200) {
			count.innerHTML = main.xmlhttp.responseText;
		
			for (var i = 0; i < main.buttons.length; i++) {
				if (i == 3) 
					removeClass(main.buttons[i], 'enable');
				else
					addClass(main.buttons[i], 'enable');
			}
			main.index++;
			//分布求和与参数传递
			main.sum += parseInt(main.xmlhttp.responseText);
			if (main.index == 5)
				bubblehandler(main);
			else 
			{
					switch(main.arr[main.index]) {
						case 0:
							ahandler(main);
							break;
						case 1:
							bhandler(main);
							break;
						case 2:
							chandler(main);
							break;
						default:
							ehandler(main);
							break;
					}
			}
		} else {
			var e = {'message':'这是个天大的秘密', 'currentsum': main.sum};
			throw e;
		}
	}, main.xmlhttp);
	}
	catch(e) {
		alert(e.message + e.currentsum);
	}
}

function ehandler(main) {
	//show unread
	var count = document.createElement('span');
	count.className = 'unread';
	count.innerHTML = '...';
	main.buttons[4].appendChild(count);

	for (var i = 0; i < main.buttons.length; i++) {
		if (i == 4) continue;
		removeClass(main.buttons[i], 'enable');
	}
	main.infobar.getElementsByClassName('item')[0].innerHTML = '才怪';

	//异步调用和处理异常
	try {
	Load("/", function(){
		if (main.xmlhttp.readyState == 4 && main.xmlhttp.status==200) {
			count.innerHTML = main.xmlhttp.responseText;
		
			for (var i = 0; i < main.buttons.length; i++) {
				if (i == 4) 
					removeClass(main.buttons[i], 'enable');
				else
					addClass(main.buttons[i], 'enable');
			}
			main.index++;
			//分布求和与参数传递
			main.sum += parseInt(main.xmlhttp.responseText);
			if (main.index == 5)
				bubblehandler(main);
			else 
			{
					switch(main.arr[main.index]) {
						case 0:
							ahandler(main);
							break;
						case 1:
							bhandler(main);
							break;
						case 2:
							chandler(main);
							break;
						default:
							dhandler(main);
							break;
					}
			}
		} else {
			var e = {'message':'这是个天大的秘密', 'currentsum': main.sum};
			throw e;
		}
	}, main.xmlhttp);
	}
	catch(e) {
		alert(e.message + e.currentsum);
	}
}


function bubblehandler(main) {
	main.infobar.getElementsByClassName('item')[0].innerHTML = '楼主异步调用战斗力感人，目测不超过';
	main.infobar.getElementsByClassName('unread')[0].innerHTML = main.sum;
	removeClass(main.infobar, 'enable');
}

function myenable() {
	var that = this;
	if (hasClass(that, 'button')) {
		if (hasClass(that, 'enable'))
			handle(that);
	} else {
		if (hasClass(that, 'enable')) {
			var flag = true;
			for (var i = 0; i < buttons.length; i++) {
				if (parseInt(buttons[i].getElementsByClassName('unread')[0].innerHTML)==NaN)
					flag = false;
			}
			if (flag)
				handleinfo(that);
		}
	}
}

function reset() {
	buttons = document.getElementsByClassName('button');
	for (var i = 0; i < buttons.length; i++) {
		addClass(buttons[i], 'enable');
		if (buttons[i].childNodes.length == 2) {
			tmp = buttons[i].childNodes[1];
			buttons[i].removeChild(tmp);
		}
	}
	infobar = document.getElementById('info-bar');
	infobar.getElementsByClassName('unread')[0].innerHTML = '';
	infobar.getElementsByClassName('item')[0].innerHTML = '';
	addClass(infobar, 'enable');
}

function hasClass(element, className) {
	if (!element) return;  
    var elementClassName = element.className;  
    if (elementClassName.length == 0) return false;  
    //用正则表达式判断多个class之间是否存在真正的class（前后空格的处理）  
    if (elementClassName == className || elementClassName.match(new RegExp("(^|\\s)" + className + "(\\s|$)")))  
      return true;  
    return false; 
}
 
function addClass(element, className) {
	if (!this.hasClass(element, className))
	{
		element.className += " "+className;
	}
}
 
function removeClass(element, className) {
  	if (!element) return;  
    var elementClassName = element.className;  
    if (elementClassName.length == 0) return;  
    if(elementClassName == className)  
    {  
        element.className = "";  
        return;  
    }  
    if (elementClassName.match(new RegExp("(^|\\s)" + className + "(\\s|$)")))  
        element.className = elementClassName.replace((new RegExp("(^|\\s)" + className + "(\\s|$)"))," "); 
}
