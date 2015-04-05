window.onload = !->
    boom-add-click()
    li-add-click()
    clear-all()
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
            icon_.style.backgroundColor = "gray"
            show[0].innerHTML = String(sum)
li-add-click = !->
    lis = document.getElementsByTagName("li")
    for item in lis
        item.onclick = !->
            if (@success != "after"&&@success != "false")
                @success = "after"
                li-get-number(this)
li-get-number = (li)->
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
