window.onload = !->
    boom-add-click()
    li-add-click()
    clear-all()
    auto-robot()
auto-robot = !->
    atplus = document.getElementsByClassName("apb")
    atplus[0].onclick = !->
        if atplus[0].success != "after"
            enable-at-plus()
            round-finger()
round-finger = !->
    lis = document.getElementsByTagName("li")
    lis[0].clickbyrobot = "true"
    lis[0].success = "after"
    li-get-number(lis[0])
enable-at-plus = !->
   atplus = document.getElementsByClassName("apb")
   atplus[0].success = "after"
   atplus[0].style.backgroundColor = "gray"
clear-all = !->
     document.getElementById('at-plus-container').onmouseleave = !->
        location.reload()
boom-add-click = !->
    icon_ = document.getElementById("info-bar")
    unread_ = document.getElementsByClassName("unread")
    sum = 0
    icon_.onclick = !->
        if (enable-boom-click())
            for item in unread_
                sum += Number(item.innerHTML)
            show = document.getElementsByClassName("data")
            show[0].innerHTML = String(sum)
            icon_.style.backgroundColor = "gray"
li-add-click = !->
    lis = document.getElementsByTagName("li")
    for i from 0 to lis.length-1 by 1
        item = lis[i]
        item.id = i
        item.onclick = !->
            enable-at-plus()
            if (@success != "after"&&@success != "false")
                @success = "after"
                li-get-number(this,@id)
li-get-number = (li,i)->
    disable-other-li()
    span = li.getElementsByTagName("span")
    span[0].innerHTML = "..."
    span[0].style.display = "block"
    xmlHttp = new XMLHttpRequest()
    xmlHttp.open("get", "/", true)
    if xmlHttp != null
        xmlHttp.send(null);
        xmlHttp.onreadystatechange = ->
            if xmlHttp.readyState is 4 and xmlHttp.status is 200
                callback(xmlHttp.responseText,li)
disable-other-li = !->
    lis = document.getElementsByTagName("li")
    for item in lis
        if (item.success != "after" && item.success != "false")
            item.style.backgroundColor = "gray"
            item.success = "false"
callback = (text,li)->
    span = li.getElementsByTagName("span")
    span[0].innerHTML = String(text)
    li.style.backgroundColor = "gray"
    enable-other-li()
    enable-boom-click()
    if li.clickbyrobot == "true"
        next-click(li)
next-click = (li)->
    lis = document.getElementsByTagName("li")
    i = Number(li.id)+1
    if (i < 5)
        lis[i].clickbyrobot = "true"
        lis[i].success = "after"
        li-get-number(lis[i],i)
    else
        unread_ = document.getElementsByClassName("unread")
        sum = 0
        for item in unread_
            sum += Number(item.innerHTML)
        show = document.getElementsByClassName("data")
        show[0].innerHTML = String(sum)
        icon_ = document.getElementById("info-bar")
        icon_.style.backgroundColor = "gray"
enable-boom-click = !->
    unreads = document.getElementsByClassName("unread")
    success = true
    for item in unreads
        if (item.innerHTML == "")
            success = false
    if success == true
        icon_ = document.getElementById("info-bar")
        icon_.style.backgroundColor = "#21479D"
        return true
    else return false



enable-other-li = !->
    lis = document.getElementsByTagName("li")
    for item in lis
        if (item.success != "after")
            item.success = "true"
            item.style.backgroundColor = "#21479D"
