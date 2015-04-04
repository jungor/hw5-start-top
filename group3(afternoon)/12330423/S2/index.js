var adders = [],
    disabled = [],
    randoms = [],
    tmpDoc;

window.onload = function () {
    tmpDoc = document.getElementsByTagName('body')[0].innerHTML;
    var IDs = ['A', 'B', 'C', 'D', 'E'];

    for (var i = 0; i < 5; i++) {
        adders[i] = document.getElementById(IDs[i]);
        adders[i].setAttribute('onclick', 'getRandomNumFromBackEnd(this, ' + i + ')');
    }

    var button = document.getElementById('at-plus-container');
    button.setAttribute('onmouseleave', 'resetCalculator()');


    // for S1
    document.getElementById('original-extend').setAttribute(
        'onclick', 'robotOneFinger()');
}

function resetCalculator() {
    setTimeout('location.replace(document.referrer)', 1500);
}

function getRandomNumFromBackEnd(li, i) {
    unread = adders[i].getElementsByTagName('strong')[0];
    unread.style.opacity = 1.0;
    unread.innerText = '。。。';
    disableClick(i, true);

    var req = new XMLHttpRequest();
    req.open('GET', '../getRandomNum', true);
    req.send();
    req.onreadystatechange = function (li) {
        if (req.readyState == 4 && req.status == 200) {
            randoms[i] = req.response;
            unread.innerText = randoms[i];

            disableClick(i, false);  // 激活其余按钮

            // 永久灭活该按钮
            disabled[i] = i;
            adders[i].style.backgroundColor = '#666';
            adders[i].setAttribute('onclick', '');

            // 检测是否所有按钮都已激活，是的话激活大气泡
            checkAll();
        }
    }
}

// 禁用或启用按钮，通过背景颜色和onclick属性，已经在disabled列表里的就不要考虑了
function disableClick(senderID, choice) {
    for (var i = 0; i < 5; i++) {
        if (i != senderID && !(i in disabled)) {
            if (choice) {
                adders[i].style.backgroundColor = '#666';
                adders[i].setAttribute('onclick', '');
            } else {
                adders[i].style.backgroundColor = '#2145A0';
                adders[i].setAttribute('onclick', 'getRandomNumFromBackEnd(this, ' + i + ')');
            }
        }
    }
}

function checkAll() {
    var allGetNumber = true,
        bigBubble = document.getElementById('SUM').parentNode.parentNode;

    for (var i = 0; i < 5; i++) {
        if (disabled[i] != i) {
            allGetNumber = false;
            break;
        }
    }

    if (allGetNumber) {  // 5个小气泡都拿到随机数了，激活大气泡
        bigBubble.style.backgroundColor = '#2145A0';
        bigBubble.setAttribute('onclick', 'showSum()');
    }
}

function showSum() {
    var sum = 0,
        bigBubble = document.getElementById('SUM').parentNode.parentNode;

    for (var i = 0; i < 5; i++) {
        sum += Number(randoms[i]);
    }

    sumObj = document.getElementById('SUM').firstChild;
    sumObj.innerText = sum;
    sumObj.style.opacity = 1.0;

    bigBubble.style.backgroundColor = '#666';
    bigBubble.setAttribute('onclick', '');
}

// 仿真机器人，顺序（一指禅）执行代码
function robotOneFinger() {
    autoClick(adders[0], 0);
}

// callback function for S1
function autoClick(li, i) {
    if (i == 5) {
        setTimeout('showSum()', 200);
        document.getElementById('original-extend').setAttribute(
            'onclick', '');
        return;
    }

    console.log(i);
    unread = adders[i].getElementsByTagName('strong')[0];
    unread.style.opacity = 1.0;
    unread.innerText = '。。。';
    disableClick(i, true);

    var req = new XMLHttpRequest();
    req.open('GET', '../getRandomNum', true);
    req.send();
    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {
            randoms[i] = req.response;
            unread.innerText = randoms[i];

            disableClick(i, false);  // 激活其余按钮

            // 永久灭活该按钮
            disabled[i] = i;
            adders[i].style.backgroundColor = '#666';
            adders[i].setAttribute('onclick', '');

            // 检测是否所有按钮都已激活，是的话激活大气泡
            checkAll();

            console.log(i + 1);
            autoClick(adders[i + 1], i + 1);
        }
    }
}