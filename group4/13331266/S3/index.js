window.onload = function(){
	var circle = document.getElementById("control-ring");
	var abcde = circle.children;
	for(var i = 0; i < abcde.length; i++){
		abcde[i].addEventListener("click",getNumber);
	}
  var atplus = document.getElementById("button");
  var icon = document.getElementById("icon");
  icon.addEventListener("click",s3);

};

function s3(){
  var icon = document.getElementById("icon");
  icon.removeEventListener("click",s3);
  var circle = document.getElementById("control-ring");
  var abcde = circle.children;
    for(var i = 0; i < abcde.length; i++){
    getNumber(abcde[i]);
  }
}

function makeDisable(me){
    me.removeEventListener("click",getNumber);
    me.style.backgroundColor="grey";
};

function makeEnable(me){
	  me.addEventListener("click",getNumber);
    me.style.backgroundColor="blue";
};

function getNumber(me){
    var rc = document.createElement('span');
    rc.innerText = "...";
    rc.className = "redcircle";
    rc.style.fontSize="5px";
    me.appendChild(rc);
    parent = me;
    var circle = document.getElementById("control-ring");
	var abcde = circle.children;
	for(var i = 0; i < abcde.length; i++){
			makeDisable(abcde[i]);	
	}
    var xmlhttp;
	if (window.XMLHttpRequest)
  		{// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  		} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  		}
  xmlhttp.onreadystatechange=function(){
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
     num=xmlhttp.responseText;
    rc.innerText=num;
    parent.style.backgroundColor="grey";
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
    }
}
xmlhttp.open("GET","/?randnum="+Math.random(),true);
xmlhttp.send();
};

function getResult(me){
    var circle = document.getElementById("control-ring");
    var abcde = circle.children;
    var sum = 0;
    for(var i = 0; i < abcde.length; i++){
      sum = sum +parseInt(abcde[i].lastChild.innerText);
    }
    if(!isNaN(sum)){
      me.innerHTML = sum;
    }
    result.style.backgroundColor = "grey";
}
