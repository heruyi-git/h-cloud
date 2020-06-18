/**
 *
 * @type {{init, put, get, clear, remove, entrySet}}
 */
var LocalMap = function (id) {

    if(this instanceof LocalMap){

        var localKey = id;

        var storage=window.localStorage;
        if(!window.localStorage){
            alert("浏览器不支持localstorage");
            return false;
        }

        this.put = function(key,value){
            //存储
            var localData = storage.getItem(localKey);
            if(!localData){
                this.init();
                localData = storage.getItem(localKey);
            }
            localData = JSON.parse(localData);
            localData.data[key] = value;
            storage.setItem(localKey,JSON.stringify(localData));
            return localData.data;

        };

        this.get = function(key){
            var localData = storage.getItem(localKey);
            if(!localData){
                return false;
            }
            localData = JSON.parse(localData);

            return localData.data[key];
        };

        this.remove = function(key){
            var localData = storage.getItem(localKey);
            if(!localData){
                return false;
            }

            localData = JSON.parse(localData);
            delete localData.data[key];
            storage.setItem(localKey,JSON.stringify(localData));
            return localData.data;
        };

        this.clear = function(){
            storage.removeItem(localKey);
        };

        this.init = function(){
            storage.setItem(localKey,'{"data":{}}');
        };
    }else{
        return new LocalMap(id);
    }


};

