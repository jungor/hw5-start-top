window.onload = function() {
    var aLi = document.getElementById("control-ring").getElementsByTagName('li');
    var message = ['A：这是个天大的秘密','B：我不知道','C：你不知道','D：他不知道', 'E：才怪'];
    for (var i = 0; i < aLi.length; i++) {
        AddMessage(aLi[i], message[i]);
        AddHandler(aLi[i]);
        util.addClass(aLi[i], 'unvisit');
    }
    
    var info = document.getElementById("info");
    AddMessage(info, "大气泡：楼主异步调用战斗力感人，目测不超过");
    util.addClass(info, 'visit');
    info.handler = function(currentSum) {
        util.removeClass(this, 'unvisit');
        util.addClass(this, 'visited');
        var messageBox = document.getElementById('message-box');
        messageBox.innerHTML = this.message + currentSum.sum;
        this.innerHTML = currentSum.sum;
        var aLi = document.getElementById('control-ring').getElementsByTagName('li');
        for (var i = 0; i < aLi.length; i++) {
            util.removeClass(aLi[i], 'visited');
            util.addClass(aLi[i], 'unvisit');
        }
    }

    var oButton = document.getElementById("button");
    oButton.onclick = function() {
        var randomNumber = (parseInt(Math.random()*1000)%5);
        var sort = document.getElementById('sort');
        sort.innerHTML = String.fromCharCode(randomNumber+65) + " ";
        var currentSum = new CurrentSum();
        aLi[randomNumber].handler(currentSum);
    }
}

var CurrentSum = function() {
    this.sum = 0;
}

function AddMessage(oLi, msg) {
    // console.log(oLi,"---",msg);
    oLi.message = msg;
}

function AddHandler(oLi) {
    oLi.handler = function(currentSum) {
        var that = this;
        // console.log(that);
        var unread = that.getElementsByTagName('span')[0];
        util.addClass(unread, 'visiable');
        unread.innerHTML = '...';
        ajax("http://localhost:3000", function(that, currentSum) {
            return function(number) {
                // 加数
                currentSum.sum += parseInt(number);
                // 显示信息
                var unread = that.getElementsByTagName('span')[0];
                unread.innerHTML = number;
                ShowMessage(that);
                // 给当前状态标识为已执行（灰色） --- 未执行（蓝色）
                util.removeClass(that, 'unvisit');
                util.addClass(that, "visited");
                // 检查是否所有状态已执行
                // var aLi = document.getElementById("control-ring").getElementsByTagName("li");
                var aLi = that.parentNode.getElementsByTagName('li');
                var hasleft = false;
                for (var i = 0; i < aLi.length; i++) {
                    if (util.hasClass(aLi[i], 'unvisit')) {
                        hasleft = true;
                        break;
                    }
                }

                if (hasleft == true) {
                    // 若不是，随机生成一个数，知道该数对应的位置没有执行，调用handler
                    var randomNumber;
                    while (true) {
                        randomNumber = (parseInt(Math.random()*1000))%5;
                        if (util.hasClass(aLi[randomNumber], 'unvisit')) {
                            break;
                        }
                    }
                    var sort = document.getElementById('sort');
                    sort.innerHTML += String.fromCharCode(randomNumber+65) + " ";
                    aLi[randomNumber].handler(currentSum);
                } else {
                    // 若是，执行info的handler
                    var info = document.getElementById('info');
                    util.removeClass(info, 'visited');
                    util.addClass(info, 'unvisit');

                    info.handler(currentSum);
                }
            }
        }(that, currentSum), function(info) {
            // 失败信息
        });
    }
}

function ShowMessage(that) {
    // 获取信息栏
    var messageBox = document.getElementById("message-box");
    // 设置成that.message;
    messageBox.innerHTML = that.message;
}

// 工具箱
var util = (function() {
    function hasClass(element, className) {
        var regExp = new RegExp('(\\s|^)'+className+'(\\s|$)');
        return !!element.className.match(regExp);
    }

    function addClass(element, className) {
        if (!hasClass(element, className)) {
            element.className += " " + className;
        }
    }

    function removeClass(element, className) {
        if (hasClass(element, className)) {
            var regExp = new RegExp('(\\s|^)'+className+'(\\s|$)');
            element.className = element.className.replace(regExp, ' ');
        }
    }

    return {
        hasClass : hasClass,
        addClass : addClass,
        removeClass : removeClass
    }
})();

function ajax(url, successfunction, failfunction) {
    var oAjax;
    // 创建Ajax对象
    if (window.XMLHttpRequest) {
        oAjax = new XMLHttpRequest();
    } else {
        oAjax = new ActiveXObject("Microsoft.XMLHTTP");
    }
    // 连接服务器
    oAjax.open("GET", url, true);
    // 发送请求
    oAjax.send();
    // 接受返回
    oAjax.onreadystatechange = function () {
        if (oAjax.readyState == 4 && oAjax.status == 200) {
            successfunction(oAjax.responseText);
        } else {
            // failfunction();
        }
    }
}