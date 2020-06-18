var constant = {
    success : 0,
    imgSrcPrefix : 'data:image/gif;base64,'
};


// root path
var rootPath = null;
function getRootPath(){
    if(rootPath == null){
        var strFullPath=window.document.location.href;
        var strPath=window.document.location.pathname;
        var pos=strFullPath.indexOf(strPath);
        var prePath=strFullPath.substring(0,pos);
        var postPath=strPath.substring(0,strPath.substr(1).indexOf('/')+1);
        return (prePath+postPath);
    }
    return rootPath;
}




// 测试工具
function showMsg(obj,type,sp) {
    var str = "";
    if (!!!sp){
        sp = "\n";
    }
    for (a in obj) {
        if (!!!type){
            str+=a+sp;
        }else{
            str+=obj[a]+sp;
        }
    }
    return str;
}
