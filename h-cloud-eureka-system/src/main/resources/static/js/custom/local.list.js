/**
     var list = new LocalList('LocalList test');
     list.add('e1');
     for (var i = 0; i < list.size(); i++) {
        alert(list.get(i));
    }
 * @type {{init, add, get, clear, remove, size}}
 */
var LocalList = function (id) {

    if(this instanceof LocalList){

        var localKey = id;

        var storage=window.localStorage;
        if(!window.localStorage){
            alert("浏览器不支持localstorage");
            return false;
        }

        this.init = function(value){
            storage.setItem(localKey,value);
        };

        var item = storage.getItem(localKey);
        if (!!!item|| item == "undefined") {
            item = '[]';
            this.init(item);
        }
        var localData = JSON.parse(item);

        this.add = function(object){
            localData.push(object);
            storage.setItem(localKey,JSON.stringify(localData));
            return localData;
        };

        this.get = function(index){
            return localData[index];
        };

        this.remove = function(index){
            localData.splice(index, 1);
            storage.setItem(localKey,JSON.stringify(localData));
            return localData;
        };

        this.clear = function(){
            storage.removeItem(localKey);
        };

        this.size = function(){
            return localData.length;
        };
    }else{
        return new LocalList(id);
    }


};

