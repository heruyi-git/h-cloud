/**
 * easyui util + extend
 *
 * Copyright (c) 2016 org.uyi
 *
 */
var util = {

	/**
	 * 统一结果效验
	 * @param result
	 * @returns {boolean}
	 */
	validateResult : function (result) {
		if (!!!result){
			return false;
		}
		if (result.code == 408) {
			$.messager.confirm(result.msg, '是否重新登录?', function (r) {
				if (r) {
					window.location.href = result.data;
				}
			});
		}
		return result.code == constant.success;
	},
	/**
	 * 提示
	 * @param msg			提示信息
	 * @param isAlert		是否弹出（默认show）
	 * @param alertLevel	弹出级别 (默认info)
	 */
	alertShow : function (msg, isAlert, alertLevel) {
		if (!!isAlert) {
			var al = 'info';
			if (!!alertLevel) {
				al = alertLevel;
			}
			$.messager.alert("操作提示", msg, al);
		}else {
			$.messager.show({title: '操作提示',msg: msg});
		}
	},
	/**
	 * 绑定指定元素的回车事件
	 * @param selector 主元素id
	 * @param element 子元素类型 (input/select/radio/...)
	 * @param callMethod 回车后要执行的函数
	 * @param eventName 键盘事件 (keyup/keydown/keypress...)
	 */
	bindDOMEnterEvent:function(selector, element, callMethod, eventName) {
		if(!eventName){
			eventName = "keyup";
		}
		$(selector + " " + element).bind(eventName, function(event) {
			if (event.keyCode == '13') {
				callMethod();
			}
		});
	},
	bindComboboxEnterEvent:function(selector, callMethod) {
		$(selector).textbox('textbox').bind('keydown',function (event) {
			if (event.keyCode == 13) {
				callMethod();
			}
		});
	},

	/**
	 * 过滤dataGrid数据格式
	 * @param result
	 */
	loadFilter: function(result) {
		var gridData = {};
		if (result.code == 0) {
			gridData.total = result.data.total;
			gridData.rows = result.data.rows;
		}else{
			gridData.total = 0;
			gridData.rows = [];
		}
		return gridData;
	},
	loadSuccess: function(){
		$(".easyui-tooltip").tooltip({
			onShow: function () {
				$(this).tooltip('tip').css({
					borderColor: '#000'
				});
			}
		});
	},
	/**
	 *
	 * 自动完成查询
	 * id 控件ID
	 * remoteUrl 远程地址
	 * params 参数{}
	 * fields 字段[valueField,textField]
	 */
	autoQuery:function(selector,remoteUrl,params,fields,height,width,defaultV) {// height if null
		if(!!!height){
			height = 21;
		}
		if(!!!width){
			width = 123;
		}
		$(selector).combobox({
			mode:'remote',
			url:remoteUrl,
			valueField:fields[0],
			textField:fields[1],
			//editable:true,
			//hasDownArrow:false,
			height:height,
			width:width,
			onBeforeLoad: function(param){
				if(!!param){
					$.each(params, function(k, v) {
						param[k] = v;
					});
					if(!!param.q){
						param[fields[1]] = param.q.trim();
						return true;
					}else{
						var text = $(this).combobox('getText');
						if(text){
							param[fields[0]] = text;
							return true;
						}
					}
				}
			},
			filter: function (q, row) {
				var ret = false;
				if (row[$(this).combobox('options').textField].indexOf(q) >= 0) {
					ret = true;
				}
				return ret;
			},
			onLoadSuccess: function () {
				//var data = $(this).combobox("getData");
				//$(data).each(function(i,val) {
				//});
				//$(this).combobox("select", data[0]['id']);
			}
			//,formatter:function(data){
			//return '<img class="item-img" src="'+data.url+'"/><span class="item-text">'+data.text+'</span>';
			// }
		});
	},

	/**
	 * id,fields,data,defaultV,height,width
	 */
	combobox:function(selector,fields,data,defaultV,height,width) {
		if(!!!height){
			height = 21;
		}
		if(!!!width){
			width = 123;
		}
		$(selector).combobox({
			valueField:fields[0],
			textField:fields[1],
			data: data,
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) >= 0;
			},
			onLoadSuccess: function () {
				var data = $(this).combobox("getData");
				// $(data).each(function(i,val) {
				//});
				if (!!defaultV){
					$(this).combobox("select", defaultV);
				} else {
					if (!!data && data.length > 0)
						$(this).combobox("select", data[0][fields[1]]);
				}
			},
			panelHeight:'auto'
			//,onChange:function(newValue,oldValue){
			//}
		});
	},

	comboboxLoad: function(selector,url,addAllOption,allText){
		if(addAllOption){
			var comboboxData;
			$.ajax({
				type : 'get',
				url : url,
				dataType : 'json',
				async : false,
				beforeSend : function(XMLHttpRequest){
				},
				success : function(result){
					if (result.code == 0) {
						comboboxData = result.data;
					}
				}
			});
			if (allText){
				if (!!comboboxData) {
					comboboxData.unshift({id: '', text: allText});
				}
			}
			//添加ALL选项到顶端，列表查询需要
			// var text_ = 'ALL';
			// if(allText){
			// 	text_ = allText;
			// }
			// comboboxData.unshift({id:'',text:allText});
			$(selector).combobox({
				data : comboboxData,
				method: 'get',
				valueField:'id',
				textField:'text',
				editable:false,
				onLoadSuccess:function(){
					var data = $(this).combobox('getData');//获取所有下拉框数据
					if (data.length > 0) {
						//如果有数据的话默认选中第一条数据
						$(this).combobox('select',data[0].id);
					}
				}
			});
		}else{
			$(selector).combobox({
				url:url,
				method: 'get',
				valueField:'id',
				textField:'text',
				editable:false,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				},
				onLoadSuccess:function(){
					var data = $(this).combobox('getData');//获取所有下拉框数据
					if (data.length > 0) {
						//如果有数据的话默认选中第一条数据
						$(this).combobox('select',data[0].id);
					}
				}
			});
		}
	},

	/**
	 * 带默认值的下拉框
	 * @param selector
	 * @param url
	 * @param defaultText
	 */
	comboboxLoadDefault:function (selector,url,defaultText){

		$(selector).combobox({
			url:url,
			method: 'get',
			valueField:'id',
			textField:'text',
			loadFilter: function(result) {
				return result.code == 0 ? result.data : null;
			},
			onLoadSuccess: function (data) {
				if (data) {
					$(selector).combobox('setValue', defaultText);
				}
			}
		});
	},


	comboboxGroupLoad:function (selector,url,addAllOption,allText){
		if(addAllOption){
			var comboboxData;
			$.ajax({
				type : 'get',
				url : url,
				dataType : 'json',
				async : false,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				},
				success : function(data){
					comboboxData = data;
				}
			});
			$(selector).combobox({
				data : comboboxData,
				method: 'get',
				valueField:'id',
				textField:'text',
				groupField: 'group'
			});
		}else{
			$(selector).combobox({
				url:url,
				method: 'get',
				valueField:'id',
				textField:'text',
				groupField: 'group',
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				}
			});
		}
	},

	/**
	 *
	 * @param selector 选择器
	 * @param url
	 * @param addAllOption 是否添加all
	 * @param onSelect onSelect函数
	 * @param isDefault 是否支持默认选中  为空时默认选中设置的参数，不为空时选中ALL
	 * @param onLoadFunc 树加载成功时需要调用的函数
	 */
	combotreeGroupLoad:function (selector,url,addAllOption,onSelect,isDefault,onLoadFunc){
		if(addAllOption){
			$(selector).combotree({
				url: url,
				method:'get',
				required: false,
				onSelect:onSelect,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				},
				onLoadSuccess:function () {
					$(".tree-icon.tree-folder.tree-folder-open").remove();
					$(".tree-hit.tree-expanded").remove();
					$(".tree-icon.tree-file").prev().remove();
					$(".tree-icon.tree-file").remove();

					if(isDefault){
						var node = $(selector).combotree('tree').tree('find',-1);
						if(node){
							$(selector).combotree("setValue",-1)
						}else{
							$(selector).combotree("setValue",1)
						}
					}else{
						$(selector).combotree("setValue",1)
					}
					if(onLoadFunc){
						onLoadFunc();
					}
				}
			});



		}else{
			$(selector).combotree({
				url: url,
				method:'get',
				required: false,
				onSelect: onSelect,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				}
			});
		}
	},


	comboboxLoadMultiple:function (selector,url,addAllOption,allText){
		if(addAllOption){
			var comboboxData;
			$.ajax({
				type : 'get',
				url : url,
				dataType : 'json',
				async : false,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				},
				success : function(data){
					comboboxData = data;
				}
			});
			if (allText){
				comboboxData.unshift({id:'',text:allText});
			}
			$(selector).combobox({
				data : comboboxData,
				method: 'get',
				valueField:'id',
				textField:'text',
				multiple: true
			});
		}else{
			$(selector).combobox({
				url:url,
				method: 'get',
				valueField:'id',
				textField:'text',
				multiple: true,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				}
			});
		}
	},



	comboboxGroupLoadMultiple : function(selector,url,addAllOption){
		if(addAllOption){
			var comboboxData;
			$.ajax({
				type : 'get',
				url : url,
				dataType : 'json',
				async : false,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				},
				success : function(data){
					comboboxData = data;
				}
			});
			$(selector).combobox({
				data : comboboxData,
				method: 'get',
				valueField:'id',
				textField:'text',
				groupField: 'group',
				multiple: true
			});
		}else{
			$(selector).combobox({
				url:url,
				method: 'get',
				valueField:'id',
				textField:'text',
				groupField: 'group',
				multiple: true,
				loadFilter: function(result) {
					return result.code == 0 ? result.data : null;
				}
			});
		}
	},
	// 根据已存在的元素创建window
	newWindow:function(selector,title,formSelector,minWidth,minHeight,dataGridId,func){
		if (!!selector) {
			$(selector).dialog('open').dialog({
				title: title,
				closed: false,
				draggable: true,
				resizable: false,
				modal: true,
				buttons:[
					{text: '保存',iconCls : 'icon-ok', handler: function() {
							util.submit(formSelector,selector,dataGridId);
						}},
					{text: '取消',iconCls : 'icon-cancel', handler: function() {
							$(selector).dialog('close');
						}}
				],
				onBeforeClose:function() {
					if ($.isFunction(func)) {
						func();
					}
				}
			});
			var flag = $(selector).data("flag");
			if (!!flag) {
				return;
			}
			$(window).on("resize", function () {
				try {
					var win_h = $(window).height();
					var win_w = $(window).width();
					var height = Math.floor(win_h * 0.66);
					var width = Math.floor(win_w * 0.8);

					height = height - minHeight > 0 ? height : minHeight||200;
					width = width - minWidth > 0 ? width : minWidth||200;

					var top = Math.floor((win_h - height) * 0.5)
					var left = Math.floor((win_w - width) * 0.5)

					var options = $(selector).dialog('options');
					if (options != null) {
						$(selector).dialog({
							width: width,
							height: height,
							top: top,
							left: left
						});
						//或
						/* $(obj).dialog({
                              width: width,
                              height: height
                          }).dialog("center");
                          */
						$(selector).data("flag", true);
					}
				} catch (e) {
					return false;
				}
			}).trigger("resize");
		}
	},
	// 动态创建dialog
	newDialog:function(selector, url, title, width, height, icon,collapsible,maximizable,minimizable,resizable,modal,shadow,scroll,func){
		$(selector).remove();
		$(selector).dialog('destroy');
		if (!scroll){
			scroll = 'auto';
		}
		$("body").append("<div id='"+selector.substr(1)+"' style='overflow: "+scroll+"' class='easyui-window'></div>");
		if (!width){
			width = 800;
		}
		if (!height){
			height = 500;
		}
		if(!icon){
			icon = 'icon-right';
		}
		if (typeof(collapsible) == "undefined") {
			collapsible = false;
		}
		if (typeof(maximizable) == "undefined") {
			maximizable = true;
		}
		if (typeof(minimizable) == "undefined") {
			minimizable = false;
		}
		if (typeof(resizable) == "undefined") {
			resizable = false;
		}
		if (typeof(modal) == "undefined") {
			//alert(modal);
			modal = true;
		}
		if (typeof(shadow) == "undefined") {
			shadow = false;
		}
		$(selector).dialog({
			title: title,
			width: width,
			height: height,
			cache: false,
			iconCls: icon,
			href: url,
			collapsible: collapsible,
			maximizable: maximizable,
			minimizable:minimizable,
			resizable: resizable,
			modal: modal,
			shadow: shadow,
			closed: true,
			onBeforeClose:function(){
				if($.isFunction(func)){
					func();
				}
			}
		});
		$(selector).dialog('open');
	},
	post : function(url,data,callFunc){
		$.messager.progress();
		$.post(url,data,function(msg) {
			var result = msg;
			$.messager.progress('close');
			$.messager.show({
				title: '操作提示',
				height: 'auto',
				msg: result.msg
			});
			if (!!callFunc && callFunc instanceof Function) {
				callFunc(result);
			}
		}, 'json').error(function(msg) {
			$.messager.progress('close');
			$.messager.alert('提示', '操作失败请刷新后重试！','error');
		});
	},
	submit : function(formSelector,windowSelector,dataGridId){
		$(formSelector).form('submit',{
			url: $(this).action,
			onSubmit: function(){
				//alert(showMsg( $(formSelector),null,"==>"));
				var flag = true;//$(formSelector).form('validate');
				if(flag){
					$.messager.progress();
				}
				return flag;
			},
			success: function(msg){
				var result;
				if (!msg.match("^\{(.+:.+,*){1,}\}$")){
					result = {msg:msg};
				}
				else{
					//result = $.parseJSON(msg);
					result = eval('('+msg+')');
				}
				if (result.msg){
					$.messager.show({
						title: '操作提示',
						height:'auto',
						msg: result.msg
					});
					if(!!dataGridId){
						$('#'+dataGridId).datagrid('reload');    // reload the user data
					}
				}
				$.messager.progress('close');
				if(!!windowSelector){
					$(windowSelector).dialog('close');        // close the dialog
				}
			}
		});
	},

	/**
	 * 表单保存数据
	 * @param formSelector			表单选择器 -- #fm  .fm			*
	 * @param url													*
	 * @param method				提交方法 -- get  post  ...		*
	 * @param dialogSelector		弹出窗体选择器	#dlg  .dlg
	 * @param datagridSelector		数据网格选择器	#dg	...
	 * @param isAlert				是否弹出警告（默认show）
	 * @param callSuccessResult		成功时回调函数
	 */
	doSave : function (formSelector,url,method,dialogSelector,datagridSelector,isAlert,callSuccessResult) {
		var self = this;
		$.ajax({
			type : method,
			url : url,
			data: new FormData($(formSelector)[0]), // $(formSelector).serialize(),
			contentType: false,
			processData: false, // 处理带文件元素,不序列化数据
			beforeSend:function(){
				var isPass = $(formSelector).form('validate');
				if (isPass) {
					$.messager.progress();
				}
				return isPass;
			},
			success: function(result){
				$.messager.progress('close');
				if (!!callSuccessResult && $.isFunction(callSuccessResult)) {
					callSuccessResult(result);
				}else {
					var retMsg;
					if (self.validateResult) {
						retMsg = result.msg;
						if (!!datagridSelector) {
							$(datagridSelector).datagrid('reload');
						}
					} else {
						retMsg = "<div style='color: #880000;'>响应码" + result.code + "</div>" + result.msg;
					}
					self.alertShow(retMsg, isAlert);
					if (!!dialogSelector) {
						$(dialogSelector).dialog('close');
					}
				}
			}
			,error: function (msg) {
				self.alertShow(msg, isAlert , 'error');
				if (!!dialogSelector) {
					$(dialogSelector).dialog('close');
				}
				$.messager.progress('close');
			}
		});
	},

	/**
	 * dataGrid删除数据
	 * @param datagridSelector		数据网格选择器	#dg	...
	 * @param url
	 */
	doDel : function (datagridSelector, url) {
		var self = this;
		var dg = $(datagridSelector);
		//获取选中行的数据
		var selectRows = dg.datagrid('getChecked');
		if (selectRows.length < 1) {
			$.messager.alert("提示消息", "请选择要删除的记录！", 'info');
			return;
		}
		$.messager.confirm("确认消息", "确定要删除所选记录吗？", function (r) {
			if (r) {
				$.messager.progress();
				var strIds = "";
				for (var i = 0; i < selectRows.length; i++) {
					strIds += selectRows[i].id + ",";
				}
				strIds = strIds.substr(0, strIds.length - 1);
				$.post(url,{ids:strIds}, function (result) {
					$.messager.progress('close');
					if (self.validateResult(result)) {
						dg.datagrid('clearSelections').datagrid('clearChecked');
						dg.datagrid('reload');
					}
					self.alertShow(result.msg, false);
				}, 'json').error(function(msg) {
					$.messager.progress('close');
					self.alertShow('操作失败请刷新后重试！' + msg, true , 'error');
				});
			}
		});
	},

	/**
	 * 保存表单数据带文件上传
	 * @param fromSelector			表单选择器
	 * @param fileIdName			文件元素ID （ID和name保持一致）
	 * @param url
	 * @param method				提交方式	  默认post
	 * @param dialogSelector		表单窗体选择器
	 * @returns {boolean}
	 */
	doSaveWithFile : function (fromSelector,fileIdName,url,method,dialogSelector,btnSelector){
		var self = this;
		var $file = $("#"+fileIdName);
		var $fm = $(fromSelector);

		if ($file.val() == "") {
			$.messager.alert("操作提示", "请选择文件!", "info");
			return false;
		}

		// 禁用按钮
		if (!!btnSelector) {
			$(btnSelector).linkbutton("disable");
		}

		// 绑定上传文件提交事件
		var uploading = false;
		if (uploading) {
			$.messager.alert("提示", "文件正在上传中，请稍候...");
			return false;
		}
		//定义表单变量
		var file = $file[0].files;
		if (file.length < 1) {
			return;
		}
		//新建一个FormData对象
		var formData = new FormData($fm[0]);
		//追加文件数据
		for (var i = 0; i < file.length; i++) {
			var fn = i > 0 ? i : '';
			formData.append(fileIdName + fn, file[i]);
		}

		var ajax = $.ajax({
			url: url,
			type: method,
			dataType: "json",
			data: formData,
			cache: false,
			processData: false,
			contentType: false,
			beforeSend: function () {
				var isPass = $fm.form('validate');
				if (isPass) {
					uploading = true;
					$('#dlg_progress').dialog({
						title: '文件上传进度',
						align: 'center',
						closed: false,
						draggable: true,
						resizable: false,
						border: false,
						//noheader:true,
						closable: false,
						modal: true
					});
					$('#progressBar').progressbar('setValue', 0);// 初始化进度条
					if (!!dialogSelector) {
						$(dialogSelector).dialog('close');
					}
				}else{
					if (!!btnSelector) {
						$(btnSelector).linkbutton("enable");
					}
				}
				return isPass;
			},
			complete: function () {
				uploading = false;
				$('#dlg_progress').dialog('close');
				$(btnSelector).linkbutton("enable");
			},
			xhr: function () { //获取ajaxSettings中的xhr对象。
				var xhr = $.ajaxSettings.xhr();
				if (xhr.upload) {
					var previousPer = 0;
					var previousReadBytes = 0;
					var previousTime = new Date().getTime();
					var useTime = 0;  // 耗时ms
					var totalSize = null;
					xhr.upload.addEventListener("progress", function (e) {
						var now = new Date().getTime();
						var interval = now - previousTime;
						useTime += interval;
						var loaded = e.loaded;//已经上传大小情况
						var tot = e.total;//附件总大小
						var per = Math.round((loaded / tot) * 100); //已经上传的百分比
						var speed = (loaded - previousReadBytes) / (interval);  // 上传速率MS
						if (totalSize == null) {
							totalSize = convert.bytesToSize(tot);
						}
						$('#progressBar').progressbar('setValue', per);
						$('#readSizeText').text(convert.bytesToSize(loaded) + "/" + totalSize);
						$('#speedText').text(convert.bytesToSize(speed * 1000));
						$('#useTimeText').text(convert.millisecondToDate(useTime));
						if (previousPer != per) {
							var expectCompleteTime = (tot - loaded) / speed;
							$('#expectCompleteTimeText').text(convert.millisecondToDate(expectCompleteTime));
						}
						previousReadBytes = loaded;
						previousTime = now;
						previousPer = per;
					}, false);
					return xhr;
				}
			},
			success: function (result) {
				if (self.validateResult) {
					self.alertShow(result.msg, false);
				} else {
					self.alertShow(result.msg, true,'warn');
				}
			}, error: function (msg) {
				self.alertShow("服务器上传异常或文件超出最大限制,请参见浏览器控制台相关信息"+ msg, true,'error');
			}
		});

		// 中断上传
		$("#btn_pause").on('click', function () {
			ajax.abort();
			$(btnSelector).linkbutton("enable");
		});
	}
}


var datagridView = $.extend({},$.fn.datagrid.defaults.view,{
	onAfterRender:function(target){
		$.fn.datagrid.defaults.view.onAfterRender.call(this,target);
		var opts = $(target).datagrid('options');
		var vc = $(target).datagrid('getPanel').children('div.datagrid-view');
		vc.children('div.datagrid-empty').remove();
		if (!$(target).datagrid('getRows').length){
			var d = $('<div class="datagrid-empty"></div>').html(opts.emptyMsg || 'no records').appendTo(vc);
			d.css({
				position:'absolute',
				left:0,
				top:50,
				width:'100%',
				textAlign:'center'
			});
		}
	}
});
