window.onload = function(){
	var circle = document.getElementById("control-ring");
	var abcde = circle.children;
  var atplus = document.getElementById("button");
  var icon = document.getElementById("icon");
  icon.addEventListener("click",s4);

};

function s4(){
  var icon = document.getElementById("icon");
  icon.removeEventListener("click",s4);
  var circle = document.getElementById("control-ring");
  var abcde = circle.children;
  var order = getOrder();
  foo(abcde, order);
}

function getOrder(){ //get a random order.
  var hash=[];
  var order;
  var str = "";
  for(var i = 0; i < 5; i++){
    hash[i] = 0;
  }
  var n = 0;
  while(n < 5){
    var random = Math.floor(Math.random() * 5);
    if(hash[random] == 0){
      n++;
      hash[random]=1;
      str = str+random.toString();
    }
  }
  var order = "";
  for(var i = 0; i < 5; i++){
    if(str[i] == "0")
      order = order+'A';
    else if(str[i] == '1')
      order = order+'B';
    else if(str[i] == '2')
      order = order+'C';
    else if(str[i] == '3')
      order = order+'D';
    else if(str[i] == '4')
      order = order+'E';
  }//turn number into letters
  result = document.getElementById("info");
  result.style.fontSize="32px";
  result.innerHTML = order;
  return str;
}

function makeDisable(me){
    me.style.backgroundColor="grey";
};

function makeEnable(me){
    me.style.backgroundColor="blue";
};

var count = 0;
function getNumber(me, f, rc, order){ 
  var xmlhttp;
	if (window.XMLHttpRequest)
  		{// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  		} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  		}
  xmlhttp.onreadystatechange=function(){
  if (xmlhttp.readyState==4 && xmlhttp.status==200){
    abcde = me;
     num=xmlhttp.responseText;
    rc.innerText=num;
    parent.style.backgroundColor="grey";
    rc.style.display = "";
    var flag = 1;
    for(var i = 0; i < abcde.length; i++){
      if(abcde[i].childNodes.length == 1){
        makeEnable(abcde[i]);  
        flag = 0; // the big circle is not enable.        
      }
    }
    if(flag == 1){
      result = document.getElementById("info");
      getResult(result);
    } 
    if(count < 4){
      count++;
      f(me, order);
    }
  }
}
xmlhttp.open("GET","/",true);
xmlhttp.send();
};

function foo(me, order){ // used to callback.
   var rc = document.createElement('span');
    rc.innerText = "...";
    rc.className = "redcircle";
    rc.style.fontSize="5px";
    num = parseInt(order[count]);
    me[num].appendChild(rc);
    parent = me[num];
    var circle = document.getElementById("control-ring");
  var abcde = circle.children;
  for(var i = 0; i < abcde.length; i++){
    makeDisable(abcde[i]);   
  }
    getNumber(me, foo, rc, order);
};

function getResult(me){
    var circle = document.getElementById("control-ring");
    var abcde = circle.children;
    var sum = 0;
    for(var i = 0; i < abcde.length; i++){
      sum = sum +parseInt(abcde[i].lastChild.innerText);
    }
    me.innerHTML = sum;
    me.removeEventListener("click", getResult)
    me.style.backgroundColor = "grey";
}
