// 定义XMLHttpRequest对象池，以便同时对所有请求进行处理。
var XMLHttp = {   
    XMLHttpRequestPool: [],   

    getInstance: function() {   
        for (var i = 0; i < this.XMLHttpRequestPool.length; i ++) {   
            if (this.XMLHttpRequestPool[i].readyState == 0 ||    
                this.XMLHttpRequestPool[i].readyState == 4) {   
                return this.XMLHttpRequestPool[i];   
            }   
        }   

        this.XMLHttpRequestPool[this.XMLHttpRequestPool.length] = new XMLHttpRequest();

        return this.XMLHttpRequestPool[this.XMLHttpRequestPool.length - 1];   
    },

    sendRequest: function(method, url, callback) { 
        var objXMLHttp = this.getInstance();
        with(objXMLHttp) {
            try {
                // 加随机数防止缓存
                if (url.indexOf('?') != -1) {
                    url += "&randnum=" + Math.random(); 
                } else {
                    url += "?randnum=" + Math.random(); 
                }
                onreadystatechange = function() {
                    if (objXMLHttp.readyState == 4 && objXMLHttp.status == 200) {
                        callback(objXMLHttp.responseText);
                    }
                }

                open(method, url, true);
                send();
            }
            catch(error) {
                alert(error);
            }
        }
    },

    abortALLRequest: function() {
        for (var i = 0; i < this.XMLHttpRequestPool.length; i ++) {
            this.XMLHttpRequestPool[i].abort();
        }   
    }
};