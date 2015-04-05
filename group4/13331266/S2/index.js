window.onload = function(){
	var circle = document.getElementById("control-ring");
	var abcde = circle.children;
  var atplus = document.getElementById("button");
  var icon = document.getElementById("icon");
  icon.addEventListener("click",s2);
};

function s2(){
  var icon = document.getElementById("icon");
  icon.removeEventListener("click",s2);
  var circle = document.getElementById("control-ring");
  var abcde = circle.children;
  foo(abcde);
}

function makeDisable(me){
    me.style.backgroundColor="grey";
};

function makeEnable(me){
    me.style.backgroundColor="blue";
};

var count = 0;
function getNumber(me, f, rc){ 
  var xmlhttp;
	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
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
      f(me);//callback.
    }
  }
}
xmlhttp.open("GET","/",true);
xmlhttp.send();
};

function foo(me){//callback.
   var rc = document.createElement('span');
    rc.innerText = "...";
    rc.className = "redcircle";
    rc.style.fontSize="5px";
    me[count].appendChild(rc);
    parent = me[count];
    var circle = document.getElementById("control-ring");
  var abcde = circle.children;
  for(var i = 0; i < abcde.length; i++){
        makeDisable(abcde[i]);   
  }
    getNumber(me, foo, rc);
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
