window.onload = function(){
	var circle = document.getElementById("control-ring");
	var abcde = circle.children;
	for(var i = 0; i < abcde.length; i++){
		//abcde[i].onclick="getNumber()";
		abcde[i].addEventListener("click",getNumber);
	}
  var atplus = document.getElementById("button");
  atplus.onmouseleave = reborn;

};

function reborn(){
  var circle = document.getElementById("control-ring");
  var abcde = circle.children;
  for(var i = 0; i < abcde.length; i++){
    if(abcde[i].childNodes.length == 2){
       abcde[i].removeChild(abcde[i].childNodes[1]);
    }
    makeEnable(abcde[i]);
  }
  result = document.getElementById("info");
  result.removeEventListener("click", getResult);
  result.style.backgroundColor = "grey";
  result.innerHTML="";
}

function makeDisable(me){
    me.removeEventListener("click",getNumber);
    me.style.backgroundColor="grey";
};

function makeEnable(me){
	  me.addEventListener("click",getNumber);
    me.style.backgroundColor="blue";
};

function getNumber(){
    var rc = document.createElement('span');
    rc.innerText = "...";
    rc.className = "redcircle";
    rc.style.fontSize="5px";
    this.appendChild(rc);
    parent = this;
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
xmlhttp.onreadystatechange=function()
  {
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
      result.addEventListener("click", getResult);
      result.style.backgroundColor = "blue";
    } 
    }
}
xmlhttp.open("GET","/",true);
xmlhttp.send();
};

function getResult(){
    var circle = document.getElementById("control-ring");
    var abcde = circle.children;
    var sum = 0;
    for(var i = 0; i < abcde.length; i++){
      sum = sum +parseInt(abcde[i].lastChild.innerText);
    }
    this.innerHTML = sum;
    this.removeEventListener("click", getResult)
    result.style.backgroundColor = "grey";
}
