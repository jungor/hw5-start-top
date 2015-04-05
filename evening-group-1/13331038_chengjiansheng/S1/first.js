// auxiliary functions
var hasClass = function(ele, name) {
    if (ele.className.indexOf(name) == -1) return false;
    else return true;
}

var addClass = function(ele, name) {
    if (!hasClass(ele, name)) {
        ele.className += ' ';
        ele.className += name;
    }
}

var delClass = function(ele, name) {
    if (hasClass(ele, name)) {
        var tmp = ' '+name;
        if (ele.className.indexOf(tmp) != -1) name = tmp;
        ele.className = ele.className.replace(name, '');        
    }
}

var allReset = function(thArr) {
    for (var i = 0; i < thArr.length; i++) {
        delClass(thArr[i],  'hidden');
    }
}


// for hw4 step1
window.onload = function() {
    var menubar = new smartMenu({
            btns: getAllBtns(),
            bubble: getBubble(),
            container: getContainer(),
            atPlus: getIcon(),
        });
};

var getAllBtns = function() {
    return document.getElementById('control-ring').getElementsByTagName('li');
}

var getBubble = function() {
    return document.getElementById('info-bar');
}

var getContainer = function() {
    return document.getElementById('bottom-positioner');
}

var getIcon = function() {
    return document.getElementsByClassName('icon')[0];
}

var smartMenu = function(dict) {
    this.dict = dict;
    this.btns = [];
    for (var i = 0, len = dict.btns.length; i < len; i++) {
        this.btns.push({
            btn: dict.btns[i],
            redDot: dict.btns[i].getElementsByTagName('span')[0],
            text: dict.btns[i].getElementsByTagName('h2')[0]
        });
    }
    this.addHandler();
};

smartMenu.prototype = {
    addHandler : function() {
        var that = this;
        for (var i = 0, len = this.btns.length; i < len; i++) {
            this.btns[i].btn.addEventListener('click', this.getNum(i), false);
        }
        this.dict.container.addEventListener('mouseleave', this.allReset(), false);
        this.dict.bubble.addEventListener('click', this.sumNum(), false);
    },

    allReset: function() {
        var that = this;
            return function() {

                that.dict.bubble.innerHTML = '';

                for (var i = 0, len = that.btns.length; i < len; i++) {
                    delClass(that.btns[i].btn, 'disabled');
                    delClass(that.btns[i].redDot, 'appear');
                }
            };
    },

    getNum : function(index) {
        var that = this;
        var i = index;
        return function() {
            var btn = that.btns[i].btn;
            var text = that.btns[i].text;
            var redDot = that.btns[i].redDot;
            if (!hasClass(btn, 'disabled')) {
                addClass(btn, 'disabled');
                that.disableAll(i);
                var xmlhttp = new XMLHttpRequest();
                redDot.textContent = '...';
                addClass(redDot, 'appear');
                xmlhttp.onreadystatechange = function() {
                    if (xmlhttp.readyState==4 && xmlhttp.status==200) {                        
                        redDot.textContent = xmlhttp.responseText;                       
                        that.enableAll();
                    }
                }
                xmlhttp.open('get', '/', true);
                xmlhttp.send();
            }
        }
    },

    disableAll : function(exp) {
        for (var i = 0, len = this.btns.length; i < len; i++) {
            if (i !== exp) addClass(this.btns[i].btn, 'disabled');
        }
    },

    enableAll : function() {
        var count = 0;
        for (var i = 0, len = this.btns.length; i < len; i++) {
            console.log('enter');
            if (!hasClass(this.btns[i].redDot, 'appear')) {
                delClass(this.btns[i].btn, 'disabled');
                count++;
            }
        }
        if (count == 0) this.dict.bubble.style.backgroundColor = 'rgba(48,63,159,1)';
    },

    sumNum : function() {
        var that = this;
        return function() {
            var sum = 0;
            
            for (var i = 0, len = that.btns.length; i < len; i++) {
                if (!hasClass(that.btns[i].btn, 'disabled')) return;
                var num = that.btns[i].redDot.textContent;
                sum += (+num);
            }
            that.dict.bubble.innerHTML = sum;
            that.dict.bubble.style.backgroundColor = 'rgba(0,0,10,.4)';
        }
    }
};

