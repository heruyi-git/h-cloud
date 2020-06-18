//  ---------------------------------------- Date extend ----------------------------------------
Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}


//  ---------------------------------------- string extend ----------------------------------------
var dataMessage = {required:"*", regexp:"\u8f93\u5165\u4e0d\u7b26\u5408\u8981\u6c42", isURL:"\u9519\u8bef\u7684URL\u5730\u5740", isUrl:"\u975e\u6cd5\u5730\u5740", isSafe:"\u5bc6\u7801\u8fc7\u4e8e\u7b80\u5355", isLength:"\u8f93\u5165\u957f\u5ea6\u4e0d\u7b26\u5408\u8981\u6c42", isDigit:"\u4e0d\u80fd\u5305\u542b\u975e\u6570\u5b57\u5185\u5bb9", isIdCard:"\u8eab\u4efd\u8bc1\u683c\u5f0f\u4e0d\u5408\u6cd5", isTelephone:"\u7535\u8bdd\u53f7\u7801\u683c\u5f0f\u4e0d\u6b63\u786e", isMobilephone:"\u624b\u673a\u53f7\u7801\u683c\u5f0f\u4e0d\u6b63\u786e", isPostcode:"\u90ae\u653f\u7f16\u7801\u4e0d\u5408\u6cd5", isMoney:"\u5fc5\u987b\u4e3a\u94b1\u6570\u5b57", isAge:"\u5e74\u9f84\u8d85\u51fa\u6307\u5b9a\u8303\u56f4", isChinese:"\u4e0d\u662f\u5408\u6cd5de\u4e2d\u6587\u5b57fu", isNotChinese:"\u4e0d\u80fd\u5305\u542b\u4e2d\u6587\u5b57\u7b26", isUserName:"\u7528\u6237\u540d\u4e0d\u5408\u6cd5", isEmail:"Email\u683c\u5f0f\u4e0d\u6b63\u786e", isDateTime:"\u4e0d\u5408\u6cd5\u7684\u65e5\u671f\u683c\u5f0f"};

String.prototype.required = function () {
    return this.trim() != "" ? null : dataMessage.required;
}
String.prototype.regexp = function (str) {
    if (str != null) {
        var pattern = new RegExp(str);
        return pattern.exec(this) != null ? null : dataMessage.regexp;
    } else {
        return dataMessage.regexp;
    }
}
String.prototype.isDigit = function () {
    return (/^\d+$/).test(this) || this.trim() == "" ? null : dataMessage.isDigit;
}
String.prototype.isLength = function (i, j) {
    i = i.toString();
    i = i.substring(1, i.length - 1);
    var i_j = i.split(/\D/);
    i = parseInt(i_j[0]);
    if (i_j.length == 2) {
        j = parseInt(i_j[1]);
    }
    return ("number" == typeof i ? this.length >= i : true) && ("number" == typeof j ? this.length <= j : true) || this.trim() == "" ? null : dataMessage.isLength;
}
String.prototype.isIdCard = function () {
    return (/^\d{15}(\d{2}[\d|X|x])?$/).test(this) || this.trim() == "" ? null : dataMessage.isIdCard;
}
String.prototype.isTelephone = function () {
    return (/^(\d{4}[-]\d{7})$|^(\d{3}[-]\d{8})$|^(\d{7,8})$/).test(this) || this.trim() == "" ? null : dataMessage.isTelephone;
}
String.prototype.isMobilephone = function () {
    return (/^[1][3|5]\d{9}$/).test(this) || this.trim() == "" ? null : dataMessage.isMobilephone;
}
String.prototype.isPostcode = function () {
    return (/^\d{6}$/).test(this) || this.trim() == "" ? null : dataMessage.isPostcode;
}
String.prototype.isMoney = function () {
    return (/^\d+(([.]?\d{1,2}$)|(\d*$))/).test(this) || this.trim() == "" ? null : dataMessage.isMoney;
}
String.prototype.isAge = function () {
    return (/^[1-9][0-9]?$/).test(this) || this.trim() == "" ? null : dataMessage.isAge;
}
String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.isChinese = function (i, j) {
    return !(/[^\u4E00-\u9FA5]+/).test(this) && ("number" == typeof i ? this.length >= i : true) && ("number" == typeof j ? this.length <= j : true) ? null : dataMessage.isChinese;
}
String.prototype.isUserName = function (i, j) {
    return (/^[_|a-zA-Z]+\w*$/).test(this) && ("number" == typeof i ? this.length >= i : true) && ("number" == typeof j ? this.length <= j : true) || this.trim() == "" ? null : dataMessage.isUserName;
}
String.prototype.isEmail = function (regex) {
    return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(this) || this.trim() == "" ? null : dataMessage.isEmail;
}
String.prototype.isDateTime = function () {
    if (this.search(/[a-zA-Z]/g) != -1) {
        return dataMessage.isDateTime;
    }
    try {
        var arr = this.search(/\D/) ? this.split(/\D/) : [];
        arr[1] = arr[1] - 1;
        eval("var d=new Date(" + arr.join(",") + ")");
        if (arr.length < 5) {
            return (Number(arr[0]) == d.getFullYear() && Number(arr[1]) == d.getMonth() && Number(arr[2]) == d.getDate()) || this.trim() == "" ? null : dataMessage.isDateTime;
        } else {
            return (Number(arr[0]) == d.getFullYear() && Number(arr[1]) == d.getMonth() && Number(arr[2]) == d.getDate() && Number(arr[3]) == d.getHours() && Number(arr[4]) == d.getMinutes() && Number(arr[5]) == d.getSeconds()) || this.trim() == "" ? null : dataMessage.isDateTime;
        }
    }
    catch (e) {
        if (this.length > 0) {
            return dataMessage.isDateTime;
        }
    }
}
String.prototype.isUrl = function () {alert(111);
    return (/^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"])*$/).test(this) || this.trim() == "" ? null : dataMessage.isUrl;
}
String.prototype.isURL = function () {
    var strRegex = "^((https|http|ftp|rtsp|mms)?://)" + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" + "(([0-9]{1,3}.){3}[0-9]{1,3}" + "|" + "([0-9a-z_!~*'()-]+.)*" + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]." + "[a-z]{2,6})" + "(:[0-9]{1,4})?" + "((/?)|" + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
    var re = new RegExp(strRegex);
    return /^([a-zA-Z]){1}:(\\.+)*(\\)?$/.test(this) || re.test(this) || this.trim() == "" ? null : dataMessage.isURL;
}
String.prototype.isSafe = function () {
    return (/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/).test(this) || this.trim() == "" ? null : dataMessage.isUrl;
}
String.prototype.isNotChinese = function () {
    return !/[\u4E00-\u9FA5]+/.test(this) || this.trim() == "" ? null : dataMessage.isNotChinese;
}
String.prototype.endWith=function(s){
    if(s==null||s==""||this.length==0||s.length>this.length)
        return false;
    if(this.substring(this.length-s.length)==s)
        return true;
    else
        return false;
    return true;
}
String.prototype.startWith = function(s){
    if(s==null||s==""||this.length==0||s.length>this.length)
        return false;
    if(this.substr(0,s.length)==s)
        return true;
    else
        return false;
    return true;
}
String.prototype.len = function(){
    var l = this.length;
    var len = 0;
    for(var i=0; i< l; i++) {
        if ((this.charCodeAt(i) & 0xff00) != 0) {
            len ++;
        }
        len ++;
    }
    return len;
}
String.prototype.lenChinese = function(){
    var l = this.length;
    var len = 0;
    for(var i=0; i< l; i++) {
        if ((this.charCodeAt(i) & 0xff00) != 0) {
            len ++;
        }
    }
    return len;
}
String.prototype.substrChinese = function(begin, end){
    var isMix = false; // 是否混合字符,默认全中文
    var isIncludeEn = false;
    var len = 0;
    var i = 0;
    for(; i< end; i++) {
        if ((this.charCodeAt(i) & 0xff00) != 0) {
            len +=2;
        }else{
            len ++;
            isIncludeEn = true;
        }
        if (len > end){
            if (isIncludeEn){
                isMix = true;
            }
            len = i;
            break;
        }
    }
    if (end < 24) {
        if (end == len) {
            //console.log('全英文--' + this + '--' + this.len() + '--容纳:' + end + '==截取：' + len + '->' + i);
            //len-=1;
            len -= 3; // 全英文
        } else if (isMix) {
            // console.log('混合--' + this + '--' + this.len() + '--容纳:' + end + '==截取：' + len + '->' + i);
            // len+=2;
            // // var lastStr = this.charAt(i-3)+this.charAt(i-2)+this.charAt(i-1);
            // if (len % 2 > 0){
            //     return this.substr(begin,len);//.concat('..');
            // }
            len -= 1; // 混合
        } else {
            //console.log('全中文--' + this + '--' + this.len() + '--容纳:' + end + '==截取：' + len + '->' + i);
            // len+=3;
            len -= 1;  // 全中文
        }
    } else{
        if (end == len) {
            len -= 4;
        } else if (isMix) {
            len -= 1;
        }
    }
    return this.substr(begin,len);
}
