var convert = {
		format : Date.prototype.format = function (format) {  
			    var o = {  
			        "M+": this.getMonth() + 1, // month  
			        "d+": this.getDate(), // day  
			        "h+": this.getHours(), // hour  
			        "m+": this.getMinutes(), // minute  
			        "s+": this.getSeconds(), // second  
			        "q+": Math.floor((this.getMonth() + 3) / 3), // quarter  
			        "S": this.getMilliseconds()  
			        // millisecond  
			    }  
			    if (/(y+)/.test(format))  
			        format = format.replace(RegExp.$1, (this.getFullYear() + "")  
			            .substr(4 - RegExp.$1.length));  
			    for (var k in o)  
			        if (new RegExp("(" + k + ")").test(format))  
			            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));  
			    return format;  
			},  
			formatDateMonth : function(value) {  
			    if (value == null || value == '') {  
			        return '';  
			    }  
			    var dt;  
			    if (value instanceof Date) {  
			        dt = value;  
			    } else {  
			        dt = new Date(value);  
			    }  
			  
			    return dt.format("yyyy-MM"); 
			} ,

			formatDateDay : function(value) {  
			    if (value == null || value == '') {  
			        return '';  
			    }  
			    var dt;  
			    if (value instanceof Date) {  
			        dt = value;  
			    } else {  
			        dt = new Date(value);  
			    }  
			  
			    return dt.format("yyyy-MM-dd");
			} ,

			formatDateTime : function(value) {  
			    if (value == null || value == '') {  
			        return '';  
			    }  
			    var dt;  
			    if (value instanceof Date) {  
			        dt = value;  
			    } else {  
			        dt = new Date(value);  
			    }  
			    return dt.format("yyyy-MM-dd hh:mm:ss"); 
			} ,
			formatPercent: function(value){
				if (value){
				  	var color = "#cc0000;";
				  	if(value=="100.00"){
				  		color="green;";
	    			}
			    	var s = '<div style="width:100%;border:1px solid #ccc">' +
			    			'<div style="width:' + value + '%;background:'+color+'color:#fff">' + value + '%' + '</div>'
			    			'</div>';
			    	return s;
		    	} else {
			    	return '';
		    	}
			},
			bytesToSize: function(value){
				var bytes = value;
				if (bytes === 0) return '0 B';
				var k = 1024;
				sizes = ['byte','k', 'M', 'G', 'T', 'P'];
				i = Math.floor(Math.log(bytes) / Math.log(k)); // 根据bytes取1024的指次数,即1024的N次方=bytes
				var num = bytes / Math.pow(k, i);
				if (num >= 1000){
					i++;
					num /= k;
					num = num.toPrecision(2); // 小于1保留两位小数
				}else if (num < 1000 && num >= 100){
					num = num.toPrecision(4); // 3位数保留一位小数
				}else{
					num = num.toPrecision(3); // 小于100,2位数保留一位小数
				}
				return num + ' ' + sizes[i];
				//return (bytes / Math.pow(k, i)) + ' ' + sizes[i];
			},
			millisecondToDate: function(value){
				var msd = value;
				var time = parseFloat(msd) / 1000;   //先将毫秒转化成秒
				if (time > 60 && time < 60 * 60) {
					var minute = parseInt(time/60);
					var second = (time%60).toPrecision(2);
					time = minute + "分钟" + second + "秒";
				}else if (time >= 3600 && time < 86400) {
					var hour = parseInt(time/3600);
					time = time%3600;
					var minute = parseInt(time/60);
					var second = (time%60).toPrecision(2);
					time = hour + "小时" + minute + "分钟" + second + "秒";
				}else if (time >= 86400) {
					var day =  parseInt(time/86400);
					time = time%86400;
					var hour = parseInt(time/3600);
					time = time%3600;
					var minute = parseInt(time/60);
					var second = (time%60).toPrecision(2);
					time = day + "天" + hour + "小时" + minute + "分钟" + second + "秒";
				}else {
					time = time.toPrecision(2) + "秒";
				}
				return time;
			},
			appendTooltip : function(value) {
				if (value == null || value == '') {
					return '';
				}
				var textEnWidth = Math.ceil(this.width/6.6) + 1;// - 2; // 可容纳英文长度
				var text = value;
				if (value.len() > textEnWidth) { // 当前总英文长度 大于 可容纳英文长度
					text = value.substrChinese(0,textEnWidth)+'...';
                    return '<span title="'+value+'" class="easyui-tooltip">'+text+'</span>';
				}
				return '<span>'+text+'</span>';
			} ,
			appendSpan : function(value) {
				if (value == null || value == '') {
					return '';
				}
				return '<span>'+value+'</span>';
			} ,
			appendSpanRed : function(value) {
				return '<span style="color: red">'+value+'</span>';
			},
			appendSpanGreen : function(value) {
				return '<span style="color: green">'+value+'</span>';
			},
			getDataName : function(value,row,idx) {
			    if (value == null || value == '') {
			        return '';  
			    }  
				var dataName;
				$.ajaxSetup({   
		            async : false  
		        });
				var key = this.field;
				if (!!this.dataField){
					key = this.dataField;
				}
				$.get(path + "/common/getData.json?key="+key+"&value="+value,function(msg){
					dataName =  msg.dataName;
				});
			    return dataName; 
			},
			getDataName2 : function(value,list) { 
			    if (value == null || value == '') {  
			        return '';  
			    }  
				for(var i in list)
			    {
				    if(value==list[i].dataValue){
					    return list[i].dataName;
				    }
			    }
			    return ''; 
			},
			getDataIcon : function(value) { 
			    if (value == null || value == '') {  
			        return '';  
			    }  
				var data;
				$.ajaxSetup({   
		            async : false  
		        });
				var key = this.field;
				if (!!this.dataField){
					key = this.dataField;
				}
				$.get(path +"/common/getData.json?key="+key+"&value="+value,function(msg){
					data =  msg;
				});
			    return '<span class="'+data.dataIcon+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';
			},
			getCustomName : function(value) { 
			    if (value == null || value == '') {  
			        return '';  
			    }  
				var dataName;
				$.ajaxSetup({   
		            async : false  
		        }); 
				$.get(path +"/s/getCustom.json?id="+value,function(msg){
					dataName =  msg.customName;
				});
			    return dataName; 
			}
 };

