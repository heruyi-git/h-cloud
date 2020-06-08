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
	<script type="text/javascript" src="${path}/static/js/custom/extend.js"></script>
	<script type="text/javascript" src="${path}/static/js/custom/file.js"></script>



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
		.datagrid-row-selected {
			background: #d1e8fb; /*D1EEEE 99CCFA  eaf2ee */
			color: #000000;
		}
		#fm{
			padding: 0px;
			margin: 0px;
		}
	</style>

	<script type="text/javascript">
		var newNodeId; // 新增文件标识
		var newNodeId2;
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
				onRightClick: onRightClickFile
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
				//if (!!!newNodeId2) { // 焦点只有一个，当表格需要的时候优先表格焦点
				zTree.editName(focusNodes[0]);
				//}
			}

			// 选中当前节点赋值给文件表单
			//var obj = eval(msg);
			//var curNode = treeObj.getNodeByParam("id",obj[0].id, null);
			//$("#fileFrm").find("input[name='uploadDir']").val(curNode.id);
			// 初始化效验上传目录是否为空，控制按钮状态
			//updateUploadBtnStatus();
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

			// 同步地址栏，默认选中地址栏的节点
			var curNodeId = getCurFilePath();
			if (!!curNodeId) {
				var curNode = treeObj.getNodeByParam("id", curNodeId, null);
				if(!!curNode && !curNode.open) {
					zTree.selectNode(curNode);
				}
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
			//alert("上级目录"+baseDirs+"\n重命个名"+treeNode.id+"\n当前路径"+$("#filePath2").combobox('getText')+"\n"+newName);
			$.post(url,{baseDirs:baseDirs,srcPath:treeNode.id,destName:newName},function(msg){
				var result = msg;
				$.messager.progress('close');
				$.messager.show({
					title: '操作提示',
					height:'auto',
					msg: result.msg
				});
				if(result.code==0){

					var openPath = $("#filePath2").combobox('getText');
					if(treeNode.id.substr(0,openPath.length)==openPath&&treeNode.id.substr(openPath.length+1)==oldName){
						//alert('重命名节点如果为打开路径的下一级子节点，刷新打开路径目录文件夹'+openPath);
						if (!!!openPath){
							zTree.cancelSelectedNode(treeNode);
						}
						doQuery(openPath);//zTree.getNodeByParam("id",openPath)
					}else if(treeNode.id==openPath){
						//zTree.setting.callback.onClick();
						//alert('重命名节点如果为打开路径的当前节点,触发单击事件刷新'+result.data);
						util.combobox(
								"#filePath2",
								["value","label"],
								[{
									label: result.data,
									value: result.data
								}]
						);
						doQuery(result.data);
					}else if(openPath.startWith(treeNode.id)){
						var oldSubPath = openPath.substr(treeNode.id.length,openPath.length);
						var newOpenPath = result.data + oldSubPath;
						//alert('重命名节点如果为打开路径的上级节点,触发单击事件刷新'+newOpenPath);
						util.combobox(
								"#filePath2",
								["value","label"],
								[{
									label: newOpenPath,
									value: newOpenPath
								}]
						);
						doQuery(newOpenPath);
					}else{
						//alert('其它目录节点');
					}
					// 更新编辑的树节点
					treeNode.id = result.data;
					zTree.updateNode(treeNode);
					// 更新所有子节点
					zTree.reAsyncChildNodes(treeNode, "refresh");
				}else{
					treeNode.name = oldName;
					zTree.updateNode(treeNode);
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
					"#filePath2",
					["value","label"],
					[{
						label: nodeId,
						value: nodeId
					}]
			);

			//$("#qf").find("input[name='filePath']").val(nodeId);
			// updateUploadBtnStatus();
			onClickFile(nodes[0].type,nodeId);
		}


		function refreshZtree(id){
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

<!-------------------------------------------------------- 正左边panel overflow:hidden;----------------------------------------------->
<div id="leftPanel" data-options="region:'west',iconCls:'icon-base'" title="计算机" style="width:258px;overflow-x:hidden" lang="${fileRoot}">
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

	<!--tree右键菜单-->
	<div id="mm" class="easyui-menu" style="width:120px;">
		<div id="mm_div_open" onclick="javascript:doOpen(16)">打开</div>
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
		<div id="mm_div_compress" onclick="javascript:compress()">压缩备份</div>
		<div id="mm_div_refresh" data-options="iconCls:'icon-reload'" onclick="refresh()">刷新</div>
		<div id="mm_div_sendto" data-options="iconCls:'icon-print',disabled:true" onclick="sendto()">发送到</div>
		<div id="mm_div_cut" onclick="cut()">剪切</div>
		<div id="mm_div_copy" onclick="copy()">复制</div>
		<div id="mm_div_paste" onclick="paste()">粘贴</div>
		<div id="mm_div_doDel" onclick="javascript:doDel()">删除</div>
		<div id="mm_div_newFile">
			<span>新建</span>
			<div style="width:120px;">
				<div data-options="iconCls:'icon-folder'" onclick="newFile('folder')">文件夹</div>
				<div data-options="iconCls:'icon-document'" onclick="newFile('txt')">txt记事本</div>
				<div data-options="iconCls:'icon-file',href:'dialog.html'">快捷链接</div>
			</div>
		</div>
		<div id="mm_div_rename" onclick="javascript:rename()">重命名</div>
		<div class="menu-sep"></div>
		<div onclick="javascript:alert('new')">属性</div>
	</div>

</div>

<!---------------------------------------------------------- 中间panel --------------------------------------------------->
<div id="mainPanel" data-options="region:'center'" style="overflow:hidden;">
	<!-- data grid -->
	<table id="dg_file"></table>
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
						<a href="#" class="easyui-linkbutton" iconCls="icon-download" plain="true" onclick="downFile()">下载</a>
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
						<a href="#" class="easyui-linkbutton" iconCls="icon-move" plain="true" onclick="getCurFilePath()">移动到</a>
					</td>
				</tr>
			</table>
		</div>

		<div id="mm1" style="width:150px;">
			<input type="file" name="file" multiple="multiple" id="btn_file" style="display:none"/>
			<form id="fileFrm" method="post" enctype='multipart/form-data'>
				<input type="hidden" name="uploadDir"/>
				<input type="hidden" name="flag" value="true"/>
				<input type="hidden" name="clob0" value="clob0xxx"/>
				<input type="hidden" name="clob1" value="clob1www"/>
			</form>
			<div data-options="iconCls:'icon-file'"><a href="javascript:upload(1);">文件</a></div>
			<div data-options="iconCls:'icon-folder'">文件夹</div>
		</div>

		<div class="datagrid-toolbar" style="margin-bottom: 3px;"></div>
		<div id="qf">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="#" title="根目录" class="easyui-linkbutton" iconCls="icon-folder" plain="true" onclick="topUp()"></a>
			<a href="#" title="向上" class="easyui-linkbutton" iconCls="icon-folder_up" plain="true" onclick="up()"></a>
			<input id="filePath2" name="filePath" class="easyui-combobox" style="width: 300px;font-size: 16px;"/>

			<input name="fileName" id="fileName2" class="easyui-textbox" style="width: 155px" prompt="文件名"/>
			&nbsp;
			<input name="beginTime" class="easyui-datebox" style="width: 100px"/>
			-
			<input name="endTime" class="easyui-datebox" style="width: 100px"/>
			&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
		</div>
	</div>
	<!-- tb panel end -->

	<!-- dlg dialog start-->
	<div id="dlg" class="easyui-dialog" closed="true" style='overflow: hidden'>
        <!--
               <form id="fm" method="post" action="doEdit.json">
                   <input type="hidden" name="filePath"/>
                   <textarea id="content" name="content" class="editor" cols="22" rows="12"></textarea>
               </form>
         -->
              <iframe id="ifm" src="/static/js/trumbowyg/editor.html" frameborder="0" scrolling="no" width="100%" height="100%"></iframe>
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
	$('#dg_file').datagrid({
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
			{ field: 'fileName', title: '名称', width: 370, align: 'left', sortable: true,
				formatter: function(value,row,index){
					var tipMsg;
					if (row.fileType == 1){
						tipMsg = "创建日期:"+row.addTime + row.fileInfoStr;
					} else{
						tipMsg = "类型:"+row.fileTypeStr + row.fileInfoStr+"\n修改日期:"+row.addTime
					}
					return "<a class='editcls1' title='"+tipMsg+"' type='"+row.fileType+"' lang='"+row.filePath+"' rel='"+row.id+"' iconCls='"+row.fileIcon+"'>"+row.fileName+"</a>";
				},editor:'textbox'
			},
			{ field: 'addTime', title: '修改日期', width: 127, align: 'left', sortable: true ,formatter:convert.appendSpan},
			{ field: 'filePath', hidden:true },
			{ field: 'fileSize', hidden:true },
			{ field: 'fileType', hidden:true },
			{ field: 'fileTypeStr', title: '文件类型', width: 96, align: 'left', sortable: true ,formatter:convert.appendSpan},
			{ field: 'fileSizeStr', title: '大小', width: 100, align: 'center', sortable: true ,formatter:convert.appendSpan}
		]],
		toolbar: '#tb',
		pagination: true,
		onRowContextMenu: onRowContextMenu,  //右击菜单扩展方法
		onLoadSuccess : function(data) {
			// 文件名绑定双击事件
			$('.editcls1').linkbutton({plain: true}).bind('dblclick', function () {
				// 窗口文件或目录的左键双击事件
				var selectFilePath;// = $(this).attr("lang");
				var selectFileType = $(this).attr("type");
				var selectFileId = $(this).attr("rel");
				var fileRoot = $('#leftPanel').attr('lang');
				var idx = 0;
				if (!!fileRoot) {
					// 设置了文件根目录
					idx = fileRoot.length;
				}
				selectFilePath = selectFileId.substr(idx,selectFileId.length);
				onClickFile(selectFileType, selectFilePath);
			});

			// 填充行
			var dg_file = $(this);
			dg_file.datagrid("fillRows", 10);

			// 空白处右键菜单
			$('.datagrid-blank-row').bind('contextmenu', showBlankRightMenu);
			// 去掉边框
			var panel = $(this).datagrid('getPanel');
			var tr = panel.find('div.datagrid-body tr');
			tr.each(function () {
				var td = $(this).children('td');
				td.css({
					"border-width": "0"
				});
			});


			/*
			// 获得文件名单元格焦点进行重命名编辑
			var rows = dg_file.datagrid("getRows"); // 得到rows对象
			var newNodeRowIndex = null;
			if (!!newNodeId2) {
				$(rows).each(function (idx) {
					if (newNodeId2.endWith(rows[idx].fileName)) {
						newNodeRowIndex = idx;
						return false;
					}
				});
				newNodeId2 = null;
			}
			if (newNodeRowIndex != null) {
				//dg_file.datagrid('beginEdit', newNodeRowIndex);
				//var ed = dg_file.datagrid('getEditor', {index:newNodeRowIndex,field:'fileName'});//获取当前编辑器
				//$(ed.target).focus();//获取焦点-？无效
				//dg_file.datagrid('endEdit',newNodeRowIndex);
				//var rowdata2 = $(this).datagrid("getEditors",newNodeRowIndex);
				//var editormodel = rowdata2[0];//rowdata2[1];
				//editormodel.target.focus();//获取焦点
				//editormodel.target.textbox('setValue','xxx');
				//$(this).datagrid('refreshRow', newNodeRowIndex); //然后刷新该行即可
			}*/

			// 地址栏加载grid表格数据
			if (!!!getCurFilePath()){
				return;
			}
			var selectedValue = $("#filePath2").combobox('getValue');
			var selectedText = $("#filePath2").combobox('getText');
			var items = $('#dg_file').datagrid('getRows');
			var comboboxData = [];
			if(!!selectedValue){
				comboboxData.push({label: selectedText,value:selectedValue});
			}else{
				// 初始化空值，让下拉框默认为空，结合文件上传控制按钮
				// comboboxData.push({label: '',value:''});
			}

			for (var i = 0; i < items.length; i++)
			{
				var row = $('#dg_file').datagrid('getData').rows[i];
				comboboxData.push({label: row.filePath,value:row.filePath});//row.id
				if (selectedValue==row.filePath) {
					$('#dg_file').datagrid('selectRow', i);
					break;
				}
			}
			util.combobox(
					"#filePath2",
					["value","label"],
					comboboxData
			);

		},
		onClickRow:function(rowIndex,rowData){
			//var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
			//var node = treeObj.getNodeByParam("id", rowData.filePath);
			//treeObj.selectNode(node);
		},
	});
	//设置分页控件
	var p = $('#dg_file').datagrid('getPager');
	$(p).pagination({
		pageSize: 10,
		pageList: [10,15,30],
		beforePageText: '第',
		afterPageText: '页    共 {pages} 页',
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
	// 查询
	function doQuery(id,fileName) {
		if(!!!id){
			id = getCurFilePath();//$("#qf").find("input[name='filePath']").val();
		}
		if(!!!fileName){
			fileName = $("#fileName2").textbox('getValue');
		}
		$("#dg_file").datagrid("load", {
			"beginTime":$("#qf").find("input[name='beginTime']").val(),
			"endTime":$("#qf").find("input[name='endTime']").val(),
			"fileName":fileName,
			"filePath":id
		});
	}

	// 点击空白处处理，或重命名时点击保存
	$('.datagrid-view').click(function(){
		//获取选中行变更颜色淡 datagrid-row-selected
		//var rows = dg_file.datagrid('getSelected');
		if (editRenameRow.index != null && editRenameRow.oldName != null){
			var dg_file = $('#dg_file');
			var ed = dg_file.datagrid('getEditor', { index: editRenameRow.index, field: 'fileName' });
			if(ed){
				var url = "rename.json";
				var baseDirs = getCurFilePath()//getUpPath();
				var newName = ed.target.textbox('getValue');
				$.post(url,{baseDirs:baseDirs,srcPath:baseDirs+"\\"+editRenameRow.oldName,destName:newName},function(msg){
					if (msg.code==0){
						doQuery();
					}else{
						//ed.target.textbox('setValue',editRenameRow.oldName);
						//dg_file.datagrid("endEdit", editRenameRow.index);
						doQuery();
						$.messager.show({
							title: '操作提示',
							msg: msg.msg
						});
					}
				});
			}
			editRenameRow.index = null;
			editRenameRow.oldName = null;
		}
	});


	// ---- 一下无用 可删
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});

	var editIndex = undefined;
	function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#dg_file').datagrid('validateRow', editIndex)){
			$('#dg_file').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	function onClickCell(index, field){
		if (endEditing()){
			$('#dg_file').datagrid('selectRow', index)
					.datagrid('editCell', {index:index,field:field});
			editIndex = index;
		}
	}
</script>



</body>
</html>


