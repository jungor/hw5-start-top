//显示随机出来的数
function displayNum(data, item)
{
    item.lastChild.innerHTML = String(data);
}
//调用ajax
function ajaxGet(item, func) {
    var xmlHttpReg = null;
    xmlHttpReg = new XMLHttpRequest();
    if (xmlHttpReg != null) {
        xmlHttpReg.open("get", "/"+String(Math.random()), true);
        xmlHttpReg.send(null);
        xmlHttpReg.onreadystatechange = function(){
        	func(xmlHttpReg.responseText, item);
            item.style.background = 'grey';
            if (bigBubbleHandler()) document.getElementById('info-bar').click();
            
        };
    }
}
//判断是否可以激活大气泡
function bigBubbleHandler() {
    var bubbles = document.getElementsByClassName('bubble'), i = 0;
    while (bubbles[i].style.background == "rgb(128, 128, 128)") {
        i = i+1;
        if (i == 5) break;
    }
    if (i == 5) {
        var bigBubble = document.getElementById('bigOne');
        bigBubble.parentNode.parentNode.style.background = 'blue';
        document.getElementById('info-bar').onclick = function() {
            sumBubble(bigBubble);
        };
        return true;
    }
}
//点击大气泡之后的加操作
function sumBubble(item) {
    var sum = 0, bubbles = document.getElementsByClassName('bubble');
    for (var i = 0; i < bubbles.length; i++){
        sum += Number(bubbles[i].lastChild.innerHTML);
    }
    item.innerHTML = String(sum);
    item.parentNode.parentNode.style.background = 'grey';
}
//创建每个小气泡点击事件
function createClickBubble() {
    var bubbles = document.getElementsByClassName('bubble');
    for (var i = 0; i < bubbles.length; i++) {
        bubbles[i].lastChild.style.display = 'none';
        bubbles[i].onclick = function() {clickHandler(this);};
    }
}
//点击某一小气泡之后运行的函数
function clickHandler(item) {
    item.lastChild.style.display = 'block';
    item.lastChild.innerHTML = '...';
    item.onclick = function(){};
    ajaxGet(item, displayNum);
    robotHandler();
}
//离开@+后刷新页面
function clearAll() {
    location.reload();
}
window.onload = function() {
    flag = 0;
    createClickBubble();
    document.getElementById('at-plus-container').onmouseleave = function(){clearAll();};
    document.getElementsByClassName('icon')[0].onclick = function() {
        robotHandler();
        flag = 1;
    };
}
//执行仿真机器人之顺序
function robotHandler() {
    var bubbles = document.getElementsByClassName('bubble');
    for (var i = 0; i < bubbles.length; i++) {
        if (bubbles[i].lastChild.style.display != 'none') {
            continue;
        } else {
            bubbles[i].click();
            break;
        }
    }
}