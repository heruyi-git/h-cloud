var websocket = {
    /**
     * 创建socket
     * @param uri      路径："ws://" + path + "/chat?uid="+uid  ->  uri = path+/chat
     * @param params   参数："ws://" + path + "/chat?uid="+uid  ->  params = (?uid=1&xx=1.. || {uid:1,xx:1,...})
     * @returns {WebSocket}
     */
    create : function(uri, params) {
        if (!!!uri || !!!params){
            return null;
        }
        var queryString;
        if (params instanceof Object) {
            var str = uri.search(/\?/) != -1 ? "&" : "";
            for (var j = 0;j < params.length; j++) {
                if (j > 0) {
                    str += "&";
                }
                str += j + "=" + params[j];
            }
            queryString = str.substring(0, str.length - 1);
        }else {
            queryString = params;
        }

        //console.log(uri + queryString);

        try {
            if ('WebSocket' in window) {
                websocket = new WebSocket("ws://" + uri + queryString);
            } else if ('MozWebSocket' in window) {
                websocket = new MozWebSocket("ws://" + uri + queryString); // firefox
            } else {
                websocket = new SockJS("http://" + uri + "/sockjs" + queryString);
            }
            return websocket;
        }catch (e) {
            console.log("创建socket连接失败"+e);
            return null;
        }
    }

}
