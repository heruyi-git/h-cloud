<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta content="text/html; charset=utf-8"/>
	<title>文件管理</title>
	<jsp:include page="/WEB-INF/jsp/include/easyui.jsp"></jsp:include>

	<link rel="stylesheet" href="${path}/static/js/zTree/zTreeStyle.css" type="text/css"/>
	<script type="text/javascript" src="${path}/static/js/zTree/jquery.ztree.all.min.js"></script>
	<style type="text/css">
		.panel-body{
			background:#f0f0f0;
		}
		.panel-header{
			background:#fff url('${path}/static/images/xp/panel_header_bg.gif') no-repeat top right;
		}
		.panel-tool-collapse{
			background:url('${path}/static/images/xp/arrow_up.gif') no-repeat 0px -3px;
		}
		.panel-tool-expand{
			background:url('${path}/static/images/xp/arrow_down.gif') no-repeat 0px -3px;
		}
	</style>

	<script type="text/javascript">
		var newNodeId;
		var fileStore = {srcPath:'',opMode:0,key:null};
		var local_setting = {
			view: {
				selectedMulti: false,
				nameIsHTML: true
			},
			/****/
			edit: {
				enable: true,
				showRenameBtn: false,
				showRemoveBtn: false
			},
			async: {
				enable: true,
				autoParam:["id","fileName"],
				url:"${path}/admin/common/commonFile/loadTree.json"
			},
			callback: {
				onClick: onClick_local,
				beforeRemove: beforeRemove,
				beforeRename: beforeRename,
				onAsyncSuccess:onAsyncSuccess,
				onRightClick: OnRightClick
			}
		};


		function onAsyncSuccess(event, treeId, treeNode, msg) {
			if(msg.toString().substring(0,2)!="[{"&&msg.toString().substring(0,2)!="[]"){
				//parent.window.location.href="${pageContext.request.contextPath}/login.jsp";
			}
			var treeObj = $.fn.zTree.getZTreeObj("local_tree");
			var nodes = treeObj.getNodes();
			if(!!treeNode&&!!newNodeId){
				// 获得焦点
				var focusNodes = zTree.getNodesByParam("id", newNodeId, null);
				zTree.selectNode(focusNodes[0]);
				newNodeId = null;
				// 获得编辑状态
				zTree.editName(focusNodes[0]);
			}
			// 自动展开
			if(!!treeNode&&treeNode.siteLevel>0&&treeNode.siteLevel<6){
				var obj = eval(msg);
				$(obj).each(function(index) {
					var val = obj[index];
					var curNode = treeObj.getNodeByParam("id", val.id, null);
					if(curNode.expand)
						treeObj.expandNode(curNode, true);
				});
			}
		}

		/*--------------------------------------------------*/
		var log, className = "dark";
		function beforeRemove(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			var zTree = $.fn.zTree.getZTreeObj("local_tree");
			zTree.selectNode(treeNode);
			$.messager.confirm('操作提示','确认删除  ' + treeNode.name + ' 吗？',function(action){
				if(action){
					var url = "${path}/admin/camera/delDevice";
					$.post(url,{id:treeNode.id},function(msg){
						if(!!msg){
							$.messager.show({
								title: '操作提示',
								msg: '操作成功！'
							});
						}else{
							$.messager.show({
								title: '操作提示',
								msg: '操作失败！'
							});
						}
					});
					return true;
				}
			});
			return false;
		}
		function onRemove(e, treeId, treeNode) {
			$.messager.alert("操作提示","remove"+treeNode.id,"info");
		}
		function beforeRename(treeId, treeNode, newName, isCancel) {
			if (newName.length == 0) {
				$.messager.alert("文件系统","节点名称不能为空！");
				setTimeout(function(){zTree.editName(treeNode)}, 10);
				return false;
			}
			if(treeNode.name==newName){
				return;
			}
			var parentNode = zTree.getNodeByTId(treeNode.parentTId);
			var baseDirs = "";
			if(!!parentNode){
				baseDirs = parentNode.id;
			}
			var oldName = treeNode.name;
			var url = "rename.json";
			$.messager.progress();
			alert("上级目录"+baseDirs+"\n重命个名"+treeNode.id+"\n当前路径"+$("#filePath2").combobox('getText')+"\n"+newName);
			$.post(url,{baseDirs:baseDirs,srcPath:treeNode.id,destName:newName},function(msg){
				var result = msg;
				$.messager.progress('close');
				$.messager.show({
					title: '操作提示',
					height:'auto',
					msg: result.msg
				});
				if(result.status==0){
					var openPath = $("#filePath2").combobox('getText');
					if(treeNode.id.substr(0,openPath.length)==openPath&&treeNode.id.substr(openPath.length+1)==oldName){
						// 重命名节点如果为打开路径的下一级子节点，刷新打开路径目录文件夹
						doQuery(openPath);//zTree.getNodeByParam("id",openPath)
					}else if(treeNode.id==openPath){
						// 重命名节点如果为打开路径的当前节点,触发单击事件刷新
						//zTree.setting.callback.onClick();
						doQuery(result.data);
					}else if(treeNode.id==openPath){
						// 重命名节点如果为打开路径的上级节点,触发单击事件刷新
						util.combobox(
								"filePath2",
								["value","label"],
								[{
									label: id,
									value: id
								}]
						);
					}else{
						// 其它目录节点
					}
					// 更新编辑的树节点
					treeNode.id = result.data;
					zTree.updateNode(treeNode);
					// 更新所有子节点

				}else{
					refresh('local_tree');
					return false;
				}
			}, 'json').error(function(msg) {
				$.messager.progress('close');
				$.messager.alert('提示', '操作失败请刷新后重试！','error');
				return false;
			});
			return true;
		}


		function onClick_local(event, treeId, treeNode, clickFlag) {
			var nodes = zTree.getSelectedNodes();
			var nodeId = nodes[0].id;

			util.combobox(
					"filePath2",
					["value","label"],
					[{
						label: nodeId,
						value: nodeId
					}]
			);

			//$("#qf").find("input[name='filePath']").val(nodeId);

			$("#fileFrm").find("input[name='filePath']").val(nodeId);
			if(!nodes[0].isParent){
				$('#btn_file').attr("disabled",true);
				$('#a_file').menubutton({
					iconCls: 'icon-upload_gray'
				});
			}else{
				$('#btn_file').attr("disabled",false);
				$('#a_file').menubutton({
					iconCls: 'icon-upload'
				});
				doQuery(nodeId);
			}
		}

		function OnRightClick(event, treeId, treeNode) {
			if(treeNode) {
				zTree.selectNode(treeNode);
				if(treeNode.isParent){
					// session取复制或剪切数据
					if(!!fileStore.key){
						$('#mm').menu('enableItem', $('#mm_div_paste'));
					}else{
						$('#mm').menu('disableItem', $('#mm_div_paste'));
					}
					$('#mm_div_paste').show();
					//
					$('#mm_div_open').html('<div class="menu-text">展开</div>');
					//$('#mm_div_open').remove();
					$('#mm_div_openmode').hide();
					$('#mm_div_newFile').show();
				}else{
					$('#mm_div_open').html('<div class="menu-text">打开</div>');
					$('#mm_div_openmode').show();
					$('#mm_div_newFile').hide();
					$('#mm_div_paste').hide();
				}
				$('#mm').menu('show', {
					left: event.pageX,
					top: event.pageY
				});
			}
		}

		function refresh(id){
			var nodes = zTree.getSelectedNodes();
			//alert(nodes.length+"~"+$("#fm_newFolder").find("input[name='baseDirs']").val());
			if (nodes.length>0) {
				zTree.reAsyncChildNodes(nodes[0], "refresh");
				//
			}else{
				initTree();
				//var parentNode = treeObj.getNodeByTId(nodes[0].parentTId);
				//选中父节点节点
				// treeObj.selectNode(parentNode);
				//treeObj.reAsyncChildNodes(parentNode, "refresh", false);
			}
		}

		function reload(treeId){
			var treeObj = $.fn.zTree.getZTreeObj(treeId);
			treeObj.reAsyncChildNodes(null, "refresh");
		}

		function initTree(){
			$.fn.zTree.init($("#local_tree"), local_setting);
			zTree = $.fn.zTree.getZTreeObj("local_tree");
		}

		var zTree;
		$(document).ready(function(){
			initTree();
			$('.icon-base').css("cursor","pointer").click(function(){reload('local_tree');});
		});

		$(document).ready(function(){$("#common_folders").panel("collapse");});
	</script>

</head>


<body class="easyui-layout">

<!-- 正左边panel overflow:hidden;-->
<div id="leftPanel" data-options="region:'west',iconCls:'icon-base'" title="计算机" style="width:258px;overflow-x:hidden">
	<div class="zTreeDemoBackground left" >
		<div style="width:250px;height:auto;background:#7190E0;padding:3px;">
			<div class="easyui-panel" id="common_folders" title="Common folders" collapsible="true" style="width:250px;height:auto;padding:10px 10px 10px 10px;">
				<ul class="easyui-tree">
					<li><a herf="javascript:void(0);" onClick="javascript:addTab('28','Desktop','changginfo/xt_yhlst.html');">Desktop</a></li>
					<li><a herf="javascript:void(0);" onClick="javascript:addTab('29','视频','changginfo/xt_yhlst.html');">视频</a></li>
					<li><a herf="javascript:void(0);" onClick="javascript:addTab('9','图片','changginfo/xt_yhlst.html');">图片</a></li>
					<li><a herf="javascript:void(0);" onClick="javascript:addTab('10','文档','changginfo/xt_sjlst.html');">文档</a></li>
					<li><a herf="javascript:void(0);" onClick="javascript:addTab('11','下载','changginfo/xt_dqlst.html');">下载</a></li>
				</ul>
			</div>
			<br/>
			<div class="easyui-panel" title="File and Folder Tasks" collapsible="true" style="width:250px;height:auto;padding:10px;">
				<ul id="local_tree" class="ztree"></ul>
			</div>
			<br/>
			<div class="easyui-panel" title="Details" collapsible="true" style="width:250px;height:auto;padding:10px;">
				My documents<br/>
				<a href="#" class="easyui-linkbutton" iconCls="icon-reclaim_bin" plain="true"  onclick="reclaimBin()">回收站</a>
				<br/>
				Date modified: Oct.3rd 2010
			</div>
		</div>
	</div>

	<div id="mm" class="easyui-menu" style="width:120px;">
		<div id="mm_div_open" onclick="javascript:doOpen('txt')">打开</div>
		<div id="mm_div_openmode">
			<span>打开方式</span>
			<div style="width:150px;">
				<div><b>Word</b></div>
				<div>Excel</div>
				<div>PowerPoint</div>
				<div>
					<span>M1</span>
					<div style="width:120px;">
						<div>sub1</div>
						<div>sub2</div>
						<div>
							<span>Sub</span>
							<div style="width:80px;">
								<div onclick="javascript:alert('sub21')">sub21</div>
								<div>sub22</div>
								<div>sub23</div>
							</div>
						</div>
						<div>sub3</div>
					</div>
				</div>
				<div>
					<span>Window Demos</span>
					<div style="width:120px;">
						<div data-options="href:'window.html'">Window</div>
						<div data-options="href:'dialog.html'">Dialog</div>
						<div><a href="http://www.jeasyui.com" target="_blank">EasyUI</a></div>
					</div>
				</div>
			</div>
		</div>
		<div onclick="javascript:compress()">压缩备份</div>
		<div data-options="iconCls:'icon-reload'" onclick="refresh()">刷新</div>
		<div data-options="iconCls:'icon-print',disabled:true">发送到</div>
		<div onclick="cut()">剪切</div>
		<div onclick="copy()">复制</div>
		<div id="mm_div_paste" onclick="paste()">粘贴</div>
		<div onclick="javascript:doDel()">删除</div>
		<div onclick="javascript:rename()">重命名</div>
		<div id="mm_div_newFile">
			<span>新建</span>
			<div style="width:120px;">
				<div data-options="iconCls:'icon-folder'" onclick="newFile('folder')">文件夹</div>
				<div data-options="iconCls:'icon-document'" onclick="newFile('txt')">txt记事本</div>
				<div data-options="iconCls:'icon-file',href:'dialog.html'">快捷链接</div>
			</div>
		</div>
		<div class="menu-sep"></div>
		<div onclick="javascript:alert('new')">属性</div>
	</div>

</div>

<!-- 中间panel -->
<div id="mainPanel" data-options="region:'center'" style="overflow:hidden;">
	<!-- data grid -->
	<table id="dg"></table>
	<!-- tb panel start -->
	<div id="tb" style="padding: 2px;">
		<div style="margin-bottom:2px">
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<a href="#" class="easyui-menubutton" id="a_file" data-options="menu:'#mm1',iconCls:'icon-upload'" plain="true"  onclick="upload(1)">上传</a>
					</td>
					<td>
						<div class="datagrid-btn-separator"></div>
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" iconCls="icon-folderadd" plain="true"  onclick="newFile('folder')">新建文件夹</a>
					</td>
					<td>
						<div class="datagrid-btn-separator"></div>
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" iconCls="icon-download" plain="true" onclick="toEdit()">下载</a>
					</td>
					<td>
						<div class="datagrid-btn-separator"></div>
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="doDel()">删除</a>
					</td>
					<td>
						<div class="datagrid-btn-separator"></div>
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" iconCls="icon-rename" plain="true" onclick="doSave()">重命名</a>
					</td>
					<td>
						<div class="datagrid-btn-separator"></div>
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" iconCls="icon-copy" plain="true" onclick="doSave()">复制到</a>
					</td>
					<td>
						<div class="datagrid-btn-separator"></div>
					</td>
					<td>
						<a href="#" class="easyui-linkbutton" iconCls="icon-move" plain="true" onclick="doSave()">移动到</a>
					</td>
				</tr>
			</table>
		</div>

		<div id="mm1" style="width:150px;">
			<input type="file" name="file" multiple="multiple" id="btn_file" style="display:none"/>
			<form id="fileFrm" method="post" enctype='multipart/form-data'>
				<input type="hidden" name="filePath"/>
			</form>
			<div data-options="iconCls:'icon-file'"><a href="javascript:upload(1);">文件</a></div>
			<div data-options="iconCls:'icon-folder'">文件夹</div>
		</div>

		<div class="datagrid-toolbar" style="margin-bottom: 3px;"></div>
		<div id="qf">
			&nbsp;&nbsp;查询日期:
			<input name="beginTime" class="easyui-datebox" style="width: 100px"/>
			-
			<input name="endTime" class="easyui-datebox" style="width: 100px"/>
			&nbsp;
			<a href="#" class="easyui-linkbutton" iconCls="icon-folder_up" plain="true" onclick="up()"></a>
			<input id="filePath2" name="filePath" class="easyui-combobox" style="width: 322px;font-size: 16px;"/>
			文件名:
			<input name="fileName" class="easyui-textbox" style="width: 120px"/>
			&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
		</div>
	</div>
	<!-- tb panel end -->

	<!-- dlg dialog start-->
	<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
		 closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
		<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
			<!-- 表单table start-->
			<table width="100%"  border="0" id="table_add">
				<tr>
					<td class="label_cloumn2">*&nbsp;文件描述：</td>
					<td class="text_cloumn2">
						<textarea rows="3" style="width:400px;" id="v_content" name="v_content" class="easyui-validatebox" data-options="required:true,validType:'length[1,1000000]'" invalidMessage="最大长度不能超过1000000""></textarea>
					</td>
				</tr>
			</table>
			<!-- 表单table end-->
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="doSave()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
	</div>
	<!-- dlg dialog end -->

	<div id="dlg_newFolder" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
		 closed="true" buttons="#dlg_newFolder-buttons" iconCls="icon-save" collapsible="false" maximizable="false">
		<form id="fm_newFolder" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="baseDirs" id="baseDirs"/>
			<!-- 表单table start-->
			<table width="100%"  border="0">
				<tr>
					<td class="text_cloumn2">
						<input type="text" id="dirs" name="dirs" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							   autocomplete="off" placeholder="请输入文件夹名称,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']" style="width:280px"/>
					</td>
				</tr>
			</table>
			<!-- 表单table end-->
		</form>
	</div>
	<div id="dlg_newFolder-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="doNewFolder()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg_newFolder').dialog('close')">取消</a>
	</div>

	<!-- progress bar -->
	<div id="dlg_progress" class="easyui-dialog" style="width:420px;height:'auto';padding:10px 15px" closed="true">
		<div id="progressFileName" style="float: left;padding-right:10px;"></div>
		<div id="progressBar" class="easyui-progressbar" style="height:16px;width :370px;float: left;"></div>
		<div id="progressTip" style="float: left;padding-left:10px;">
			<div class="readSizeTitle" id="readSizeTitle">
				已上传/总大小：<span id="readSizeText"></span>
				&nbsp;速度：<span id="speedText">0KB</span>/s
				&nbsp;耗时：<span id="useTimeText">0s</span>
				&nbsp;剩余时间：<span id="expectCompleteTimeText">0s</span>
				&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" id="btn_pause">取消</a>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$('#dg').datagrid({
		url: 'doQuery.json',
		title: '文件管理',
		iconCls: 'icon-right',
		loadMsg: '数据加载中,请稍候...',
		checkOnSelect: false,
		selectOnCheck: false,
		collapsible:true,
		border: true,
		nowrap: true,
		fit: true,
		fitColumns: true,
		striped : true,
		singleSelect: true,
		rownumbers:true,
		sortOrder: 'asc',
		sortName: 'fileName',
		frozenColumns : [ [ {
			field : 'ck',
			checkbox : true
		} ] ],
		idField:'id',
		columns: [[
			{ field: 'id', title: 'ID', width: 66, align: 'left', sortable: true,hidden:true },
			{ field: 'fileName', title: '名称', width: 380, align: 'left', sortable: true,
				formatter: function(value,row,index){
					return "<a class='editcls1' iconCls='"+row.fileIcon+"'>"+row.fileName+"</a>";
				}
			},
			{ field: 'addTime', title: '修改日期', width: 127, align: 'left', sortable: true },
			{ field: 'filePath', title: '文件路径', width: 380, align: 'center', sortable: true,hidden:true },
			{ field: 'fileTypeStr', title: '文件类型', width: 96, align: 'left', sortable: true },
			{ field: 'fileSizeStr', title: '大小', width: 100, align: 'center', sortable: true }
		]],
		toolbar: '#tb',
		pagination: true,
		"onLoadSuccess":function(data){
			$('.editcls1').linkbutton({plain:true}); //
			var selectedValue = $("#filePath2").combobox('getValue');
			var selectedText = $("#filePath2").combobox('getText');
			var items = $('#dg').datagrid('getRows');
			var comboboxData = [];
			if(!!selectedValue){
				comboboxData.push({label: selectedText,value:selectedValue});
			}
			for (var i = 0; i < items.length; i++)
			{
				var row = $('#dg').datagrid('getData').rows[i];
				comboboxData.push({label: row.id,value:row.id});
				if (selectedValue==row.filePath) {
					$('#dg').datagrid('selectRow', i);
					return;
				}
			}
			util.combobox(
					"filePath2",
					["value","label"],
					comboboxData
			);


		},
		onClickRow:function(rowIndex,rowData){
			//var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
			//var node = treeObj.getNodeByParam("id", rowData.filePath);
			//treeObj.selectNode(node);
		}

	});
	//设置分页控件
	var p = $('#dg').datagrid('getPager');
	$(p).pagination({
		pageSize: 10,
		pageList: [10,20,30],
		beforePageText: '第',
		afterPageText: '页    共 {pages} 页',
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
	// 查询
	function doQuery(id) {
		if(!!!id){
			id = $("#qf").find("input[name='filePath']").val();
		}
		$("#dg").datagrid("load", {
			"beginTime":$("#qf").find("input[name='beginTime']").val(),
			"endTime":$("#qf").find("input[name='endTime']").val(),
			"fileName":$("#qf").find("input[name='fileName']").val(),
			"filePath":id
		});
	}

	function doDel() {
		// 获取当前操作的元素
		//获取选中行的数据
		var selectRows = $('#dg').datagrid('getChecked');
		if (selectRows.length < 1) {
			$.messager.alert("提示消息", "请选择要删除的记录！", 'info');
			return;
		}
		$.messager.confirm("确认消息", "确定要删除所选记录吗？", function (r) {
			if (r) {
				var strIds = "";
				for (var i = 0; i < selectRows.length; i++) {
					strIds += selectRows[i].id + ",";
				}
				strIds = strIds.substr(0, strIds.length - 1);
				$.post('doDel.json',{ids:strIds}, function (msg) {
					if (msg.msg) {
						$.messager.show({
							title: '操作提示',
							msg: msg.msg
						});
						refresh('local_tree');
						$('#dg').datagrid('clearSelections').datagrid('clearChecked');
						$('#dg').datagrid('reload');
					}
				}, 'json').error(function(msg) {
					$.messager.alert('提示', '操作失败请刷新后重试！','error');
				});
			}
		});
	}

	// open add and edit window
	var url;
	function doOpen(openMode){
		var nodes = zTree.getSelectedNodes();
		$.post("openFile.json",{filePath:nodes[0].id,openMode:openMode},function(result){
			eval("result="+result);
			if(!!result){
				// 激活粘贴menu
				alert(result.data);
			}
			$.messager.show({
				title: '操作提示',
				msg: result.msg
			});
		});
		$('#dlg').dialog('open').dialog('center').dialog('setTitle',nodes[0].id+'文件编辑窗口');
		url = 'doAdd.json';
	}

	function toEdit(){
		$('#parentCode_span').html("编辑菜单");
		var row = $('#dg').datagrid('getSelected');
		if (row){
			$('#dlg').dialog('open').dialog('center').dialog('setTitle','编辑');
			$('#fm').form('load',row);
			url = 'doEdit.json';
		}
	}

	function doSave(){
		$('#fm').form('submit',{
			url: url,
			onSubmit: function(){
				return $(this).form('validate');
			},
			success: function(msg){
				var result = eval('('+msg+')');
				if (result.msg){
					$.messager.show({
						title: '操作提示',
						msg: result.msg
					});
					refresh('treeDemo');
					$('#dg').datagrid('reload');    // reload the user data
				} else {
					$.messager.show({
						title: '操作提示',
						msg: '操作失败'
					});
				}
				$('#dlg').dialog('close');        // close the dialog
			}
		});
	}

	function upload(t){
		if(t==1){
			//上传文件
			document.getElementById("btn_file").click();
		}else{
			//上传文件夹
			$.messager.alert("提示","暂未开放...");
		}
	}

	$(document).ready(function(){
		// 绑定上传文件提交事件
		var uploading = false;
		$('#btn_file').change(function(){
			if(uploading){
				$.messager.alert("提示","文件正在上传中，请稍候...");
				return false;
			}
			//定义表单变量
			var file = this.files;
			if(file.length<1){
				return;
			}
			//新建一个FormData对象
			var formData = new FormData($('#fileFrm')[0]);
			//追加文件数据
			for(i=0;i<file.length;i++){
				formData.append("file["+i+"]", file[i]);
			}
			$('#dlg_progress').dialog({
				title:'文件上传进度',
				align:'center',
				closed: false,
				draggable: true,
				resizable: false,
				border:false,
				//noheader:true,
				closable:false,
				modal: true
			});

			var ajax = $.ajax({
				url: "upload.json",
				type: 'POST',
				dataType:"json",
				data: formData,
				cache: false,
				processData: false,
				contentType: false,
				beforeSend: function(){
					uploading = true;
					$('#progressBar').progressbar('setValue', 0);// 初始化进度条
				},
				complete: function () {
					uploading = false;
					$('#dlg_progress').dialog('close');
				},
				xhr: function(){ //获取ajaxSettings中的xhr对象。
					var xhr = $.ajaxSettings.xhr();
					if (xhr.upload) {
						var previousPer = 0;
						var previousReadBytes = 0;
						var previousTime = new Date().getTime();
						var useTime = 0;  // 耗时ms
						var totalSize = null;
						xhr.upload.addEventListener("progress", function (e) {
							var now = new Date().getTime();
							var interval = now-previousTime;
							useTime += interval;
							var loaded = e.loaded;//已经上传大小情况
							var tot = e.total;//附件总大小
							var per = Math.round((loaded / tot) * 100); //已经上传的百分比
							var speed = (loaded-previousReadBytes)/(interval);  // 上传速率MS
							if (totalSize == null){
								totalSize = bytesToSize(tot);
							}
							$('#progressBar').progressbar('setValue', per);
							$('#readSizeText').text(bytesToSize(loaded)+"/"+totalSize);
							$('#speedText').text(bytesToSize(speed*1000));
							$('#useTimeText').text(millisecondToDate(useTime));
							if (previousPer != per ) {
								var expectCompleteTime = (tot - loaded) / speed;
								$('#expectCompleteTimeText').text(millisecondToDate(expectCompleteTime));
							}
							//console.log(previousTime+"~"+now);
							//console.log(loaded+"/"+tot);
							previousReadBytes = loaded;
							previousTime = now;
							previousPer = per;
						}, false);
						return xhr;
					}
				},
				success : function(data) {
					if (data.code == 0) {
						$.messager.show({
							title: '操作提示',
							msg: data.msg
						});
						doQuery();
						refresh('local_tree');
					} else{
						if (data.code == 408){
							$.messager.confirm(data.msg, '是否重新登录?', function(r){
								if (r){
									window.location.href = data.data;
								}
							});
						}else{
							$.messager.alert("提示",data.msg,'error');
						}
					}
					//uploading = false;
					//$('#dlg_progress').dialog('close');
				},error : function(data){
					$.messager.alert("提示","服务器上传异常或文件超出最大限制,请参见浏览器控制台相关信息",'error');
				}
			});
			/* 开启进度条
             $('#progressFileName').text($('#btn_file').val().substr(12));
                setTimeout('start()',200);*/

			// 中断上传
			$("#btn_pause").on('click',function () {
				ajax.abort();
			});

			function bytesToSize(bytes) {
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
			}

			function millisecondToDate(msd) {
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
			}
		});

		// 后台轮询上传进度条显示,暂时没用
		function start(){
			var interval = 200;
			var value = $('#progressBar').progressbar('getValue');
			//console.log(value);
			if (value < 100){
				$.post('${path}/common/uploadProgress',{interval:interval},function(ret){
					if(!!ret){
						//eval("ret="+ data);
						value = ret.percent;
						//console.log("->"+value);
						$('#progressBar').progressbar('setValue', value);
						$('#readSizeText').text(ret.readSize+"/"+ret.totalSize);
						$('#speedText').text(ret.speed);
						setTimeout('start()', interval);
					}else{
						$('#dlg_progress').dialog('close');
					}
				});
			}
		}

		// 绑定回车事件
		util.bindDOMEnterEvent('qf', 'input', doQuery);
		//
		//util.bindComboboxEnterEvent('filePath2',doQuery);

		// 绑定改变事件--反向联动tree
		$('#filePath2').combobox({
			onChange:function(newValue,oldValue){
				var nodes = zTree.getNodesByParam("id", newValue, null);
				if(nodes.length>0){
					zTree.selectNode(nodes[0]);
					//doQuery(newValue);
				}
			}
		});

		// 绑定回车事件--反向联动tree
		var target = $('#filePath2').combobox('textbox');
		$(target).unbind("keydown");
		$(target).keydown(function (event) {
			if (event.keyCode == 13) {
				$.messager.show({
					title: '操作提示',
					msg: $("#filePath2").combobox('getText')+"~"+$("#filePath2").combobox('getValue')
				});
				//if(selectedValue)
			}
		});

	});

	function newFolder(){
		//$('#dlg_newFolder').dialog('open').dialog('center').dialog('setTitle','新建文件夹');
		// ztree addnode
		var nodes = zTree.getSelectedNodes();
		var parentNode = nodes[0];
		var newNode = {id:parentNode.id+"/新建文件夹",name:"新建文件夹",isParent:true};
		newNode = zTree.addNodes(parentNode, newNode);
	}


	function newFile(resource){
		var nodes = zTree.getSelectedNodes();
		var parentNode = null;
		var id = "";
		if(nodes.length>0){
			parentNode = nodes[0];
			id = parentNode.id;
		}
		///console.log(id);
		var fileName;
		if(resource=="folder"){
			fileName = "新建文件夹";
			$.post("newFolder.json",{baseDirs:id,dirs:fileName},function(result){
				if(!!result){
					//fileName = result.data;
					//var newNode = {id:id+"/"+fileName,name:fileName,isParent:true};
					//newNode = zTree.addNodes(parentNode, newNode);
					// 直接刷新节点-保存新建节点ID以便获得焦点
					newNodeId = result.data;//result.data.replace(/\\/g,'/');
					refresh('load_tree');
					// 同步列表
					doQuery();
				}
				$.messager.show({
					title: '操作提示',
					msg: result.msg
				});
			});
			//alert(document.activeElement.tagName);
		}else if(resource=="txt"){
			fileName = "新建文本文档.txt";
			$.post("newFile.json",{baseDirs:id,fileName:fileName},function(result){
				if(!!result){
					fileName = result.data;
					//var newNode = {id:id+"/"+fileName,name:fileName};
					//newNode = zTree.addNodes(parentNode, newNode);
					// 直接刷新节点-保存新建节点ID以便获得焦点
					newNodeId = result.data;//result.data.replace(/\\/g,'/');
					refresh('load_tree');
					// 同步列表
					doQuery();
				}
				$.messager.show({
					title: '操作提示',
					msg: result.msg
				});
			});
			//util.newDialog("dlg_newFile","http://www.qq.com","新建"+resource, 400, 300,'icon-file');
		}
		//


	}

	function doNewFolder(){
		$("#fm_newFolder").find("input[name='baseDirs']").val($("#filePath2").combobox('getText'));
		$('#fm_newFolder').form('submit',{
			url: "newFolder.json",
			onSubmit: function(){
				return $(this).form('validate');
			},
			success: function(msg){
				var result = eval('('+msg+')');
				if (result.msg){
					$.messager.show({
						title: '操作提示',
						msg: result.msg
					});
					refresh('local_tree');
					$('#dg').datagrid('reload');    // reload the user data
				} else {
					$.messager.show({
						title: '操作提示',
						msg: '操作失败'
					});
				}
				$('#dlg_newFolder').dialog('close');        // close the dialog
			}
		});
	}

	function rename(){
		var nodes = zTree.getSelectedNodes();
		treeNode = nodes[0];
		zTree.editName(treeNode);
	}

	function up(){
		var filePath = $("#filePath2").combobox('getText');
		if(!!filePath){
			var nodes = zTree.getNodesByParam("id", filePath, null);
			if (nodes.length>0) {
				// 选中节点
				var parentNode = zTree.getNodeByTId(nodes[0].parentTId);
				zTree.selectNode(parentNode);
				// 改变路径
				if(!!parentNode){
					util.combobox("filePath2",["value","label"],
							[{label: parentNode.id,value: parentNode.id}]
					);
				}
				// 重新加载数据
				doQuery();
			}
		}
	}

	//copy
	function copy(){
		var nodes = zTree.getSelectedNodes();
		$.post("copy.json",{srcId:'common.commonFile.index',srcPath:nodes[0].id},function(result){
			eval("result="+result);
			if(!!result){
				// 激活粘贴menu
				fileStore.srcPath = nodes[0].id;
				fileStore.opMode = 1;
				fileStore.key = result.data;
			}
			$.messager.show({
				title: '操作提示',
				msg: result.msg
			});
		});
	}

	//cut
	function cut(){
		var nodes = zTree.getSelectedNodes();
		$.post("cut.json",{srcId:'common.commonFile.index',srcPath:nodes[0].id},function(result){
			eval("result="+result);
			if(!!result){
				// 激活粘贴menu
				fileStore.srcPath = nodes[0].id;
				fileStore.opMode = 2;
				fileStore.key = result.data;
			}
			$.messager.show({
				title: '操作提示',
				msg: result.msg
			});
		});
	}

	//paste
	function paste(){
		if(fileStore.key==null){
			return;
		}
		var nodes = zTree.getSelectedNodes();
		$.post("paste.json",{srcId:'common.commonFile.index',destDir:nodes[0].id},function(result){
			eval("result="+result);
			if(!!result){
				// 粘贴重置数据--刷新节点
				if(fileStore.opMode==2){
					// 剪切时删除原节点
					var srcNodes = zTree.getNodesByParam('id',fileStore.srcPath,null);
					zTree.removeNode(srcNodes[0]);
				}
				fileStore.srcPath = '';
				fileStore.key = null;
				fileStore.opMode = 0;
				// 刷新目标节点
				refresh();
			}
			$.messager.show({
				title: '操作提示',
				msg: result.msg
			});
		});
	}

</script>
</body>
</html>


