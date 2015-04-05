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
        xmlHttpReg.open("get", "/", true);
        xmlHttpReg.send(null);
        xmlHttpReg.onreadystatechange = function(){
            if(xmlHttpReg.readyState != 4) return;
            func(xmlHttpReg.responseText, item);
            item.style.background = 'grey';
            enableOther(item);
            bigBubbleHandler();
            if (flag) robotHandler();
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
    disableOther(item);
}
//灭活所有气泡
function disableOther(item) {
    bubblesHandler('grey', item, function(item_){
        return;
        });
}
//激活所有没数字的气泡
function enableOther(item) {
    bubblesHandler('blue',item, function(item_){clickHandler(item_)});
}
//遍历各个气泡，并对气泡执行func函数
function bubblesHandler(color, item, func) {
    var bubbles = document.getElementsByClassName('bubble');
    for (var i = 0; i < bubbles.length; i++) {
        if (bubbles[i].lastChild.style.display != 'none') continue;
        if (bubbles[i] != item) {
            bubbles[i].style.background = color;
            bubbles[i].onclick = function(){func(this);};
        }
    }
}
//判断是否还有正在获取数字
function ifGetNum() {
    var bubbles = document.getElementsByClassName('bubble');
    for (var i = 0; i < bubbles.length; i++) {
        if (bubbles[i].lastChild.innerHTML == '...') return true;
    }
    return false;
}
//离开@+后刷新页面
function clearAll() {
    location.reload();
}
function ifPush(data, q) {
    for (var i = 0; i < q.length; i++) {
        if(data == q[i]) return false;
    }
    return true;
}
function displayQueue() {
    x = '';
    for (var i = 0; i < 5; i++) x += chars[queue[i]];
    document.getElementById('text').innerHTML = x;
}
window.onload = function() {
    flag = 0;
    createClickBubble();
    chars = ["A", "B", "C", "D", "E"];
    queue = new Array();
    while(queue.length != 5) {
        var data = Math.floor(Math.random()*10)%5;
        if (ifPush(data, queue)) queue.push(data);
    }
    displayQueue();
    document.getElementById('at-plus-container').onmouseleave = function(){clearAll();};
    document.getElementsByClassName('icon')[0].onclick = function() {
        robotHandler();
    };
}
//执行仿真机器人之顺序
function robotHandler() {
    var bubbles = document.getElementsByClassName('bubble');
    for (var i = 0; i < bubbles.length; i++) {
        if (ifGetNum()) return;
        if (queue[flag] != i) continue;
        if (bubbles[i].lastChild.style.display != 'none') {
            continue;
        } else {
            bubbles[i].click();
            flag++;
            break;
        }
    }
    if (bigBubbleHandler()) document.getElementById('info-bar').click();
}