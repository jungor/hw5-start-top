window.onload = function() {
	total = 0;
	index = 0;
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
	//create xml arr
	xmlhttp = new Array();
	for (var i = 0; i < buttons.length; i++) {
		xmlhttp.push(new XMLHttpRequest());
	}
};

function machine() {
	for (var i = 0; i < buttons.length; i++) {
		var count = document.createElement('span');
		count.className = 'unread';
		count.innerHTML = '...';
		buttons[i].appendChild(count);
	}
	handle(buttons[index], xmlhttp[index++]);
}

function Load(url, cfunc, xml) {
	xml.onreadystatechange = cfunc;
	xml.open("GET", url, true);
	xml.send();
} 


function handle(that, xml) {
	var tmp = that.getElementsByClassName('unread')[0];
	Load("/"+(index-1), function(){
		if (xml.readyState == 4 && xml.status==200) {
			tmp.innerHTML = xml.responseText;
			total++;
			if (total == 5)
				handleinfo(infobar);
		}
	}, xml);

	if (index < 5)
		handle(buttons[index], xmlhttp[index++]);
	else
		return;
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
			handle(that, xmlhttp[0]);
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
	addClass(infobar, 'enable');
	index = 0;
	total = 0;
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
