function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      oldonload();
      func();
    }
  }
}

function insertAfter(newElement,targetElement) {
  var parent = targetElement.parentNode;
  if (parent.lastChild == targetElement) {
    parent.appendChild(newElement);
  } else {
    parent.insertBefore(newElement,targetElement.nextSibling);
  }
}

function addClass(element,value) {
  if (!element.className) {
    element.className = value;
  } else {
    newClassName = element.className;
    newClassName+= " ";
    newClassName+= value;
    element.className = newClassName;
  }
}

function hasClass(elem, cls){
    cls = cls || '';
    if(cls.replace(/\s/g, '').length == 0) return false;
    return new RegExp(' ' + cls + ' ').test(' ' + elem.className + ' ');
}

function removeClass(elem, cls){
    if(hasClass(elem, cls)){
        var newClass = ' ' + elem.className.replace(/[\t\r\n]/g, '') + ' ';
        while(newClass.indexOf(' ' + cls + ' ') >= 0){
            newClass = newClass.replace(' ' + cls + ' ', ' ');
        }
        elem.className = newClass.replace(/^\s+|\s+$/g, '');
    }
}

function getHTTPObject() {
  if (typeof XMLHttpRequest == "undefined")
    XMLHttpRequest = function () {
      try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); }
        catch (e) {}
      try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); }
        catch (e) {}
      try { return new ActiveXObject("Msxml2.XMLHTTP"); }
        catch (e) {}
      return false;
  }
  return new XMLHttpRequest();
}

function addEvent( obj, event, handler ) { 
  if ( obj.attachEvent ) { 
    obj['e'+event+handler] = handler; 
    obj[event+handler] = function() {
      obj['e'+event+handler]( window.event );
    } 
    obj.attachEvent( 'on'+event, obj[event+handler] ); 
  } else 
    obj.addEventListener( event, handler, false ); 
} 

function removeEvent( obj, event, handler ) { 
  if ( obj.detachEvent ) { 
    obj.detachEvent( 'on'+event, obj[event+handler] ); 
    obj[event+handler] = null; 
  } else 
    obj.removeEventListener( event, handler, false ); 
}

function removeChildElementByClass(childNodes, className) {
  for (var i = 0; i < childNodes.length; i++) {
    if (hasClass(childNodes[i], className)) {
      removeChild(childNodes[i]);
    }
  }
}

function removeChild(element) {
  return element.parentNode.removeChild(element);
}