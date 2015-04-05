window.onload = function() {
	buttons = document.getElementsByClassName('button');
	infobar = document.getElementById('info-bar');
	for (var i = 0; i < buttons.length; i++) {
		addClass(buttons[i], 'enable');
		buttons[i].addEventListener('click', myenable);
	}
	addClass(infobar, 'enable');
	infobar.addEventListener('click', myenable);
	document.getElementById('at-plus-container').onmouseleave = reset;
	document.getElementsByClassName('apb')[0].onclick = machine;
	//random order

	numarr = [0, 1, 2, 3, 4];
	xmlhttp = new XMLHttpRequest();
};

function randomsort(a, b) {
	return Math.random() > .5 ? -1:1;
}

function machine() {
	index = 0;
	numarr.sort(randomsort);
	var s = "";
	for (var i = 0; i < numarr.length; i++) {
		s += String.fromCharCode(65+numarr[i]);
	}
	infobar.getElementsByClassName('item')[0].innerHTML = s;
	handle(buttons[numarr[index++]]);
}

function Load(url, cfunc) {
	xmlhttp.onreadystatechange = cfunc;
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
} 


function handle(that) {
	//show unread
	var count = document.createElement('span');
	count.className = 'unread';
	count.innerHTML = '...';
	that.appendChild(count);
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i] === that) continue;
		removeClass(buttons[i], 'enable');
	}


	Load("/", function(){
		if (xmlhttp.readyState == 4 && xmlhttp.status==200) {
			count.innerHTML = xmlhttp.responseText;
		
			for (var i = 0; i < buttons.length; i++) {
				if (buttons[i] === that) 
					removeClass(buttons[i], 'enable');
				else
					addClass(buttons[i], 'enable');
			}
			if (index != 0) {
				if (index < 5)
					handle(buttons[numarr[index++]]);
				else
					handleinfo(infobar);
			}
		}
	});
}

function handleinfo(that) {
	var sum = 0;
	var tmp; 
	var arr = document.getElementsByClassName('unread');
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].innerHTML!= '') {
			tmp = parseInt(arr[i].innerHTML);
			sum += tmp;
		}
	}
	sum = "" + sum;
	that.getElementsByClassName('unread')[0].innerHTML = sum;
	removeClass(that, 'enable');
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
	var tmp;
	for (var i = 0; i < buttons.length; i++) {
		addClass(buttons[i], 'enable');
		if (buttons[i].childNodes.length == 2) {
			tmp = buttons[i].childNodes[1];
			buttons[i].removeChild(tmp);
		}
	}
	infobar.getElementsByClassName('unread')[0].innerHTML = '';
	infobar.getElementsByClassName('item')[0].innerHTML = '';
	addClass(infobar, 'enable');
	index = 0;
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
