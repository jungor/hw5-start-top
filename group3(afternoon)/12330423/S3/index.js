var adders = [],
    disabled = [],
    randoms = [],
    tmpDoc;

window.onload = function () {
    tmpDoc = document.firstChild.innerHTML;
    var IDs = ['A', 'B', 'C', 'D', 'E'];

    for (var i = 0; i < 5; i++) {
        adders[i] = document.getElementById(IDs[i]);
        adders[i].setAttribute('onclick', 'getRandomNumFromBackEnd(this, ' + i + ')');
    }

    var button = document.getElementById('at-plus-container');
    button.setAttribute('onmouseleave', 'resetCalculator()');

    // for S3
    document.getElementById('original-extend').setAttribute('onclick', 'robotFiveFinger()');
}

function getRandomNumFromBackEnd(li, i) {
    var unread = adders[i].getElementsByTagName('strong')[0];
    unread.style.opacity = 1.0;
    unread.innerText = '。。。';
    // disableClick(i, true);

    var req = new XMLHttpRequest();
    req.open('GET', '../getRandomNum' + i, true);
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

function resetCalculator() {
    setTimeout('location.replace(document.referrer)', 1500);
}

// 禁用或启用按钮，通过背景颜色和onclick属性，已经在disabled列表里的就不要考虑了
function disableClick(senderID, choice) {
    console.log(senderID);
    for (var i = 0; i < 5; i++) {
        if (i != senderID && !(i in disabled)) {
            console.log(i in disabled);
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

    return allGetNumber;
}

// 在大气泡中显示结果, 并灭活大气泡
function showSum() {
    var sum = 0,
        bigBubble = document.getElementById('SUM').parentNode.parentNode;

    for (var i = 0; i < 5; i++) {
        sum += Number(randoms[i]);
    }

    console.log(sum);
    sumObj = document.getElementById('SUM').firstChild;
    sumObj.innerText = sum;
    sumObj.style.opacity = 1.0;

    bigBubble.style.backgroundColor = '#666';
    bigBubble.setAttribute('onclick', '');
}

// 仿真机器人，并行（五指金龙）执行代码
function robotFiveFinger() {
    for (var i = 0; i < 5; i++) {
         clickOneButton(i);
    }
}

function clickOneButton(i) {
    var unread = adders[i].getElementsByTagName('strong')[0];
    unread.style.opacity = 1.0;
    unread.innerText = '。。。';

    var req = new XMLHttpRequest();
    req.open('GET', '../getRandomNum' + i, true);
    req.send();
    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {
            randoms[i] = req.response;
            unread.innerText = randoms[i];

            // 永久灭活该按钮
            disabled[i] = i;
            adders[i].style.backgroundColor = '#666';
            adders[i].setAttribute('onclick', '');

            // 检测是否所有按钮都已激活，是的话激活大气泡
            if (checkAll()) {
                showSum();
            }
        }
    }
}