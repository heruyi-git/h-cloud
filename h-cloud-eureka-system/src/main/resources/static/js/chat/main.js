/**
 * 创建socket
 * 后台加载当前用户、用户列表(sessionList)、用户列表对应的空session聊天记录
 * 从本地缓存取出用户列表对应的聊天记录数据填充
 * 用户下线删除用户列表对应的用户
 * 用户上线通知并刷新所有的用户列表数据以及对应的聊天记录
 */
!function(e) {
    function t(r) {
        if (s[r])
            return s[r].exports;
        var i = s[r] = {
            exports: {},
            id: r,
            loaded: !1
        };
        return e[r].call(i.exports, i, i.exports, t),
            i.loaded = !0,
            i.exports
    }
    var s = {};
    return t.m = e,
        t.c = s,
        t.p = "/dist/",
        t(0)
}([function(e, t, s) {
    "use strict";
    function r(e) {
        return e && e.__esModule ? e : {
            "default": e
        }
    }
    var i = s(32)
        , o = r(i);
    Vue.config.debug = !0,
        new Vue(o["default"])
}
    , function(e, t) {
        e.exports = function() {
            var e = [];
            return e.toString = function() {
                for (var e = [], t = 0; t < this.length; t++) {
                    var s = this[t];
                    s[2] ? e.push("@media " + s[2] + "{" + s[1] + "}") : e.push(s[1])
                }
                return e.join("")
            }
                ,
                e.i = function(t, s) {
                    "string" == typeof t && (t = [[null, t, ""]]);
                    for (var r = {}, i = 0; i < this.length; i++) {
                        var o = this[i][0];
                        "number" == typeof o && (r[o] = !0)
                    }
                    for (i = 0; i < t.length; i++) {
                        var n = t[i];
                        "number" == typeof n[0] && r[n[0]] || (s && !n[2] ? n[2] = s : s && (n[2] = "(" + n[2] + ") and (" + s + ")"),
                            e.push(n))
                    }
                }
                ,
                e
        }
    }
    , function(e, t, s) {
        function r(e, t) {
            for (var s = 0; s < e.length; s++) {
                var r = e[s]
                    , i = d[r.id];
                if (i) {
                    i.refs++;
                    for (var o = 0; o < i.parts.length; o++)
                        i.parts[o](r.parts[o]);
                    for (; o < r.parts.length; o++)
                        i.parts.push(a(r.parts[o], t))
                } else {
                    for (var n = [], o = 0; o < r.parts.length; o++)
                        n.push(a(r.parts[o], t));
                    d[r.id] = {
                        id: r.id,
                        refs: 1,
                        parts: n
                    }
                }
            }
        }
        function i(e) {
            for (var t = [], s = {}, r = 0; r < e.length; r++) {
                var i = e[r]
                    , o = i[0]
                    , n = i[1]
                    , a = i[2]
                    , l = i[3]
                    , c = {
                    css: n,
                    media: a,
                    sourceMap: l
                };
                s[o] ? s[o].parts.push(c) : t.push(s[o] = {
                    id: o,
                    parts: [c]
                })
            }
            return t
        }
        function o() {
            var e = document.createElement("style")
                , t = m();
            return e.type = "text/css",
                t.appendChild(e),
                e
        }
        function n() {
            var e = document.createElement("link")
                , t = m();
            return e.rel = "stylesheet",
                t.appendChild(e),
                e
        }
        function a(e, t) {
            var s, r, i;
            if (t.singleton) {
                var a = x++;
                s = h || (h = o()),
                    r = l.bind(null, s, a, !1),
                    i = l.bind(null, s, a, !0)
            } else
                e.sourceMap && "function" == typeof URL && "function" == typeof URL.createObjectURL && "function" == typeof URL.revokeObjectURL && "function" == typeof Blob && "function" == typeof btoa ? (s = n(),
                        r = u.bind(null, s),
                        i = function() {
                            s.parentNode.removeChild(s),
                            s.href && URL.revokeObjectURL(s.href)
                        }
                ) : (s = o(),
                        r = c.bind(null, s),
                        i = function() {
                            s.parentNode.removeChild(s)
                        }
                );
            return r(e),
                function(t) {
                    if (t) {
                        if (t.css === e.css && t.media === e.media && t.sourceMap === e.sourceMap)
                            return;
                        r(e = t)
                    } else
                        i()
                }
        }
        function l(e, t, s, r) {
            var i = s ? "" : r.css;
            if (e.styleSheet)
                e.styleSheet.cssText = g(t, i);
            else {
                var o = document.createTextNode(i)
                    , n = e.childNodes;
                n[t] && e.removeChild(n[t]),
                    n.length ? e.insertBefore(o, n[t]) : e.appendChild(o)
            }
        }
        function c(e, t) {
            var s = t.css
                , r = t.media;
            t.sourceMap;
            if (r && e.setAttribute("media", r),
                e.styleSheet)
                e.styleSheet.cssText = s;
            else {
                for (; e.firstChild; )
                    e.removeChild(e.firstChild);
                e.appendChild(document.createTextNode(s))
            }
        }
        function u(e, t) {
            var s = t.css
                , r = (t.media,
                t.sourceMap);
            r && (s += "\n/*# sourceMappingURL=data:application/json;base64," + btoa(unescape(encodeURIComponent(JSON.stringify(r)))) + " */");
            var i = new Blob([s],{
                type: "text/css"
            })
                , o = e.href;
            e.href = URL.createObjectURL(i),
            o && URL.revokeObjectURL(o)
        }
        var d = {}
            , p = function(e) {
            var t;
            return function() {
                return "undefined" == typeof t && (t = e.apply(this, arguments)),
                    t
            }
        }
            , f = p(function() {
            return /msie [6-9]\b/.test(window.navigator.userAgent.toLowerCase())
        })
            , m = p(function() {
            return document.head || document.getElementsByTagName("head")[0]
        })
            , h = null
            , x = 0;
        e.exports = function(e, t) {
            t = t || {},
            "undefined" == typeof t.singleton && (t.singleton = f());
            var s = i(e);
            return r(s, t),
                function(e) {
                    for (var o = [], n = 0; n < s.length; n++) {
                        var a = s[n]
                            , l = d[a.id];
                        l.refs--,
                            o.push(l)
                    }
                    if (e) {
                        var c = i(e);
                        r(c, t)
                    }
                    for (var n = 0; n < o.length; n++) {
                        var l = o[n];
                        if (0 === l.refs) {
                            for (var u = 0; u < l.parts.length; u++)
                                l.parts[u]();
                            delete d[l.id]
                        }
                    }
                }
        }
        ;
        var g = function() {
            var e = [];
            return function(t, s) {
                return e[t] = s,
                    e.filter(Boolean).join("\n")
            }
        }()
    }
    , , , , , , function(e, t, s) {
        "use strict";
        function r(e) {
            return e && e.__esModule ? e : {
                "default": e
            }
        }
        Object.defineProperty(t, "__esModule", {
            value: !0
        });
        var i = s(13)
            , o = r(i)
            , n = s(33)
            , a = r(n)
            , l = s(34)
            , c = r(l)
            , u = s(36)
            , d = r(u)
            , p = s(35)
            , f = r(p);
        t["default"] = {
            el: "#chat",
            data: function() {
                //localStorage.clear();
                var e = o["default"].fetch();
                // 建立ws连接,load user
                var socket = this.connect();
                if (e.user == null){
                    console.log('user is null');
                    e.user = {};
                }
                if (e.userList == null){
                    console.log('e.userList is null');
                    e.userList = [];
                }
                if (e.sessionList == null){
                    console.log('e.sessionList is null');
                    e.sessionList = [];
                }
                return {
                    socket : socket,
                    user: e.user,
                    userList: e.userList,
                    sessionList: e.sessionList,
                    // user: {
                    //     id: '1',
                    //     name: 'ad',
                    //     img: constant.imgSrcPrefix + 'xx'
                    // },//e.user,
                    // userList: [{
                    //     id: '2',
                    //     name: 'ac',
                    //     img: constant.imgSrcPrefix + 'xx'
                    // }],//e.userList,
                    // sessionList: [{
                    //     userId: 2,
                    //     messages: []
                    // }],//e.sessionList,
                    search: "",
                    sessionIndex: 0
                }
            },
            computed: {
                session: function() {
                    this.onMessage();
                    return this.sessionList[this.sessionIndex];
                }
            },
            watch: {
                sessionList: {
                    deep: !0,
                    handler: function() {
                        o["default"].save({
                            user: this.user,
                            userList: this.userList,
                            sessionList: this.sessionList
                        })
                    }
                },
                userList: {
                    deep: !0,
                    handler: function() {
                        o["default"].save({
                            user: this.user,
                            userList: this.userList,
                            sessionList: this.sessionList
                        })
                    }
                }
            },
            components: {
                card: a["default"],
                list: c["default"],
                text: d["default"],
                message: f["default"]
            },
            methods: {
                // 连接socket
                connect : function(){
                    return websocket.create(document.location.host + path + '/chat',{token:null});
                },
                onMessage : function(){
                    var vm = this;
                    this.socket.onopen = function(event) {
                        console.log("WebSocket:已连接");
                        console.log(event);
                    };
                    this.socket.onclose = function(event) {
                        console.log("WebSocket:已关闭");
                        console.log(event);
                    }
                    this.socket.onmessage = function(event) {
                        var data=JSON.parse(event.data);
                        console.log("WebSocket:收到一条消息",data);
                        if (data.messageType == 'ptp') {
                            vm.ptp(data);
                        }
                        else if (data.messageType == 'refreshOnline') {
                            vm.refreshOnline(data);
                        }
                        else if (data.messageType == 'refreshOffline') {
                            vm.refreshOffline(data);
                        }
                        else if (data.messageType == 'broadcast') {
                            vm.broadcast(data);
                        }
                        else{
                            console.log("不支持的消息类型："+ data.messageType);
                            return;
                        }
                    };
                    this.socket.onerror = function(event) {
                        console.log("WebSocket:发生错误 ");
                        console.log(event);
                    };
                },
                ptp : function(data){
                    var vm = this;
                    vm.sessionList[vm.sessionIndex].messages.push({
                        text: data.data,
                        date: data.date,
                        self: 0
                    });
                    audioPlay(data.fromName + "对您说：" + data.data);
                },
                broadcast : function (data) {

                },
                refreshOffline : function (data) {
                    var vm = this;
                    for(var i=0;i<vm.userList.length;i++){
                        if (vm.userList[i].id == data.data.user.id){
                            audioPlay("您的伙伴下线了！"+ vm.userList[i].name);
                            // 用户列表移除下线用户
                            vm.userList.splice(i,1);
                            // 移除session
                        }
                    }
                },
                refreshOnline : function (data) {
                    var vm = this;
                    var newOnlineUser = data.data.user;
                    vm.userList.push(newOnlineUser);
                    // 加载sessionList数据
                    var n = "VUE-CHAT-v3";
                    var newOnlineUserMessages = [];
                    var cacheSessionList = JSON.parse(localStorage.getItem(n));
                    var key = newOnlineUser.id;
                    if (cacheSessionList != null) {
                        for (var k = 0; k < cacheSessionList.length; k++) {
                            var key2 = cacheSessionList[k].userId;
                            if (key == key2) {
                                newOnlineUserMessages = cacheSessionList[k].messages;
                            }
                        }
                    }
                    var sessionSize = vm.sessionList.length;
                    if (sessionSize > 0) {
                        for (var j = 0; j < sessionSize; j++) {
                            var key2 = vm.sessionList[j].userId;
                            if (key == key2) {
                                vm.sessionList[j].messages = newOnlineUserMessages;
                            }
                        }
                    }else{
                        vm.sessionList.push({
                            userId: newOnlineUser.id,
                            messages: newOnlineUserMessages
                        });
                    }

                    audioPlay("您有新的伙伴上线了！"+ newOnlineUser.name);
                    // this.userList.push({
                    //     id : 5,
                    //     name : 'xx',
                    //     img : ''
                    // });
                    // this.sessionList.push({
                    //     userId: 5,
                    //     messages: []
                    // });
                }
            }
        }
    }
    , function(e, t) {
        "use strict";
        Object.defineProperty(t, "__esModule", {
            value: !0
        }),
            t["default"] = {
                props: ["user", "search"]
            }
    }
    , function(e, t) {
        "use strict";
        Object.defineProperty(t, "__esModule", {
            value: !0
        }),
            t["default"] = {
                props: ["userList", "sessionIndex", "session", "search"],
                methods: {
                    select: function(e) {
                        this.sessionIndex = this.userList.indexOf(e)
                    }
                },
                filters: {
                    search: function(e) {
                        var t = this;
                        return e.filter(function(e) {
                            return e.name.indexOf(t.search) > -1
                        })
                    }
                }
            }
    }
    , function(e, t) {
        "use strict";
        Object.defineProperty(t, "__esModule", {
            value: !0
        }),
            t["default"] = {
                props: ["session", "user", "userList"],
                computed: {
                    sessionUser: function() {
                        var e = this
                            , t = this.userList.filter(function(t) {
                            return t.id === e.session.userId
                        });
                        return t[0]
                    }
                },
                filters: {
                    avatar: function(e) {
                        var t = e.self ? this.user : this.sessionUser;
                        return t && t.img
                    },
                    time: function(e) {
                        return "string" == typeof e && (e = new Date(e)),
                        e.getHours() + ":" + e.getMinutes()
                    }
                },
                directives: {
                    "scroll-bottom": function() {
                        var e = this;
                        Vue.nextTick(function() {
                            e.el.scrollTop = e.el.scrollHeight - e.el.clientHeight
                        })
                    }
                }
            }
    }
    , function(e, t) {
        "use strict";
        Object.defineProperty(t, "__esModule", {
            value: !0
        }),
            t["default"] = {
                props: ["session"],
                data: function() {
                    return {
                        text: ""
                    }
                },
                methods: {
                    inputing: function(e) {
                        if ( e.ctrlKey && 13 === e.keyCode ){
                            this.send();
                        }
                    },
                    send : function () {
                        if (this.session == null){
                            alert('请指定用户发送');
                            return;
                        }
                        var data={};
                        data["fromId"] = this.$parent.user.id;
                        data["fromName"] = this.$parent.user.name;
                        data["toId"] = this.session.userId;
                        data["data"] = this.text;
                        this.$parent.socket.send(JSON.stringify(data));
                        this.text.length && (this.session.messages.push({
                            text: this.text,
                            date: new Date,
                            self: !0
                        }),
                            this.text = "")
                    }
                }
            }
    }
    , function(e, t, s) {
        "use strict";
        function r(e) {
            return e && e.__esModule ? e : {
                "default": e
            }
        }
        Object.defineProperty(t, "__esModule", {
            value: !0
        });
        // 加载数据
        function loadUserData() {
            var chatData;
            $.ajax({
                type : "post",
                url : path + "/admin/common/chat/userList.json",
                data : {},
                async : false,
                success : function(result){
                    if (result.code == 0){
                        var data = result.data;
                        chatData =  {
                            user: data.user,
                            userList: data.userList,
                            sessionList: data.sessionList
                        };
                    }
                }
            });
            return chatData;
        }
        var i = s(14)
            , o = r(i)
            , n = "VUE-CHAT-v3";
        // 缓存所有数据包括用户列表和聊天记录
        // var ln = localStorage.getItem(n);
        // alert(ln);
        // if (!ln || ln == "undefined") {
        //     var l = loadUserData();
        //     localStorage.setItem(n, (0, o["default"])(l));
        // }
        // 拉取在线数据，改为只缓存用户聊天记录 ，---》后续缓存所有数据和在线数据对比更新在线状态标识
        var l = loadUserData();
        var ln = localStorage.getItem(n);
        //alert(ln);
        if (!!!ln || ln == "undefined") {
            var cacheData = l.sessionList;
            localStorage.setItem(n, (0, o["default"])(cacheData));
        }
        t["default"] = {
            fetch: function() {
                //l.sessionList = JSON.parse(localStorage.getItem(n));
                // 加载缓存历史数据填充覆盖新的空sessionMessages
                var cacheSessionList = JSON.parse(localStorage.getItem(n));
                if (l.sessionList != null) {
                    for (var j = 0; j < l.sessionList.length; j++) {
                        var key = l.sessionList[j].userId;
                        for (var k = 0; k < cacheSessionList.length; k++) {
                            var key2 = cacheSessionList[k].userId;
                            if (key == key2) {
                                l.sessionList[j].messages = cacheSessionList[k].messages;
                                break;
                            }
                        }
                    }
                }
                return l;
                // 缓存加载的数据需要调用服务器刷新在线状态--
                // return JSON.parse(localStorage.getItem(n));
            },
            save: function(e) {
                localStorage.setItem(n, (0,o["default"])(e.sessionList));
                //
            },
            remove : function (e) {
               // localStorage.removeItem("a");
            }
        }
    }
    , function(e, t, s) {
        e.exports = {
            "default": s(15),
            __esModule: !0
        }
    }
    , function(e, t, s) {
        var r = s(16);
        e.exports = function(e) {
            return (r.JSON && r.JSON.stringify || JSON.stringify).apply(JSON, arguments)
        }
    }
    , function(e, t) {
        var s = e.exports = {
            version: "1.2.6"
        };
        "number" == typeof __e && (__e = s)
    }
    , function(e, t, s) {
        t = e.exports = s(1)(),
            t.push([e.id, ".m-text{height:10pc;border-top:1px solid #ddd;background:#FFFFFF}.m-text textarea{padding:10px 10px 1px 10px;height:80%;width:100%;border:none;outline:0;font-family:Micrsofot Yahei;resize:none}     .input_box textarea{width:calc(100% - 56px);height:calc(100% - 42px);border: none;outline: 0;background:#f5f5f5;resize:none;margin-left: 28px;font-size: 14px;line-height: 20px;}  #send{border:1px solid #e5e5e5;background:#f5f5f5;color: #666;padding:0 8px;outline: 0; height: 26px;float: right;margin-top: 0px;margin-right:8px;} #send:hover{background:#09bb07;color: #fff; border:1px solid #09bb07;}", ""])
    }
    , function(e, t, s) {
        t = e.exports = s(1)(),
            t.push([e.id, "#chat{overflow:hidden;border-radius:3px}#chat .main,#chat .sidebar{height:100%}#chat .sidebar{float:right;width:200px;color:#f4f4f4;background-color:#2e3238}#chat .main{position:relative;overflow:hidden;background-color:#eee}#chat .m-text{position:absolute;width:100%;bottom:0;left:0}#chat .m-message{height:calc(100% - 10pc)}", ""])
    }
    , function(e, t, s) {
        t = e.exports = s(1)(),
            t.push([e.id, ".m-card{padding:9pt;border-bottom:1px solid #24272c}.m-card footer{margin-top:10px}.m-card .avatar,.m-card .name{vertical-align:middle}.m-card .avatar{border-radius:2px}.m-card .name{display:inline-block;margin:0 0 0 15px;font-size:1pc}.m-card .search{padding:0 10px;width:100%;font-size:9pt;color:#fff;height:30px;line-height:30px;border:1px solid #3a3a3a;border-radius:4px;outline:0;background-color:#26292e}", ""])
    }
    , function(e, t, s) {
        t = e.exports = s(1)(),
            t.push([e.id, ".m-list li{padding:9pt 15px;border-bottom:1px solid #292c33;cursor:pointer;-webkit-transition:background-color .1s;transition:background-color .1s}.m-list li:hover{background-color:hsla(0,0%,100%,.03)}.m-list li.active{background-color:hsla(0,0%,100%,.1)}.m-list .avatar,.m-list .name{vertical-align:middle}.m-list .avatar{border-radius:2px}.m-list .name{display:inline-block;margin:0 0 0 15px}", ""])
    }
    , function(e, t, s) {
        t = e.exports = s(1)(),
            t.push([e.id, '.m-message{padding:10px 15px;overflow-y:scroll}.m-message li{margin-bottom:15px}.m-message .time{margin:7px 0;text-align:center}.m-message .time>span{display:inline-block;padding:0 18px;font-size:9pt;color:#fff;border-radius:2px;background-color:#dcdcdc}.m-message .avatar{float:left;margin:0 10px 0 0;border-radius:3px}.m-message .text{display:inline-block;position:relative;padding:0 10px;max-width:calc(100% - 40px);min-height:30px;line-height:2.5;font-size:9pt;text-align:left;word-break:break-all;background-color:#fafafa;border-radius:4px}.m-message .text:before{content:" ";position:absolute;top:9px;right:100%;border:6px solid transparent;border-right-color:#fafafa}.m-message .self{text-align:right}.m-message .self .avatar{float:right;margin:0 0 0 10px}.m-message .self .text{background-color:#b2e281}.m-message .self .text:before{right:inherit;left:100%;border-right-color:transparent;border-left-color:#b2e281}', ""])
    }
    , function(e, t, s) {
        var r = s(17);
        "string" == typeof r && (r = [[e.id, r, ""]]);
        s(2)(r, {});
        r.locals && (e.exports = r.locals)
    }
    , function(e, t, s) {
        var r = s(18);
        "string" == typeof r && (r = [[e.id, r, ""]]);
        s(2)(r, {});
        r.locals && (e.exports = r.locals)
    }
    , function(e, t, s) {
        var r = s(19);
        "string" == typeof r && (r = [[e.id, r, ""]]);
        s(2)(r, {});
        r.locals && (e.exports = r.locals)
    }
    , function(e, t, s) {
        var r = s(20);
        "string" == typeof r && (r = [[e.id, r, ""]]);
        s(2)(r, {});
        r.locals && (e.exports = r.locals)
    }
    , function(e, t, s) {
        var r = s(21);
        "string" == typeof r && (r = [[e.id, r, ""]]);
        s(2)(r, {});
        r.locals && (e.exports = r.locals)
    }
    , function(e, t) {
        e.exports = "<div><div class=sidebar><card :user=user :search.sync=search></card><list :user-list=userList :session=session :session-index.sync=sessionIndex :search=search></list></div><div class=main><message :session=session :user=user :user-list=userList></message><text :session=session></text></div></div>"
    }
    , function(e, t) {
        e.exports = '<div class=m-card><header><img class=avatar width=40 height=40 :alt=user.name :src=user.img><p class=name>{{user.name}}</p></header><footer><input class=search placeholder="search user..." v-model=search></footer></div>'
    }
    , function(e, t) {
        e.exports = '<div class=m-list><ul><li v-for="item in userList | search" v-if="session != null" :class="{ active: session.userId === item.id }" @click=select(item)><img class=avatar width=30 height=30 :alt=item.name :src=item.img><p class=name>{{item.name}}</p></li></ul></div>'
    }
    , function(e, t) {
        e.exports = '<div class=m-message v-if="session != null" v-scroll-bottom=session.messages><ul><li v-for="item in session.messages"><p class=time><span>{{item.date | time}}</span></p><div class=chatmain :class="{ self: item.self }"><img class=avatar width=30 height=30 :src="item | avatar"><div class=text>{{item.text}}</div></div></li></ul></div>'
    }
    , function(e, t) {
        e.exports = '<div class=m-text><textarea class="input_box" placeholder="按 Ctrl + Enter 发送" v-model=text @keyup=inputing></textarea><button id="send" @click=send>发送（Ctrl + Enter）</button></div>'
    }
    , function(e, t, s) {
        s(23),
            e.exports = s(8),
        e.exports.__esModule && (e.exports = e.exports["default"]),
            ("function" == typeof e.exports ? e.exports.options : e.exports).template = s(27)
    }
    , function(e, t, s) {
        s(24),
            e.exports = s(9),
        e.exports.__esModule && (e.exports = e.exports["default"]),
            ("function" == typeof e.exports ? e.exports.options : e.exports).template = s(28)
    }
    , function(e, t, s) {
        s(25),
            e.exports = s(10),
        e.exports.__esModule && (e.exports = e.exports["default"]),
            ("function" == typeof e.exports ? e.exports.options : e.exports).template = s(29)
    }
    , function(e, t, s) {
        s(26),
            e.exports = s(11),
        e.exports.__esModule && (e.exports = e.exports["default"]),
            ("function" == typeof e.exports ? e.exports.options : e.exports).template = s(30)
    }
    , function(e, t, s) {
        s(22),
            e.exports = s(12),
        e.exports.__esModule && (e.exports = e.exports["default"]),
            ("function" == typeof e.exports ? e.exports.options : e.exports).template = s(31)
    }
]);
