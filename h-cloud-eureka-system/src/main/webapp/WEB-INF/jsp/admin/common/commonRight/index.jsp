<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>菜单管理</title>
		<jsp:include page="/WEB-INF/jsp/include/easyui.jsp"></jsp:include>
		<link rel="stylesheet" href="${path}/static/js/zTree/zTreeStyle.css" type="text/css"/>
		<script type="text/javascript" src="${path}/static/js/zTree/jquery.ztree.all.min.js"></script>
	 	
	 	<script type="text/javascript">
	 	var setting = {
				edit: {
					drag: {
						autoExpandTrigger: true,
						prev: dropPrev,
						inner: dropInner,
						next: dropNext
					},
					enable: true,
					showRemoveBtn: false,
					showRenameBtn: false
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				async: {
					enable: true,
					url:"getRightTree.json",
					autoParam:["id"]
				},
				callback: {
					beforeDrag: beforeDrag,
					//beforeDrop: beforeDrop,
					//beforeDragOpen: beforeDragOpen,
					onDrag: onDrag,
					onDrop: onDrop,
					onExpand: onExpand,
					onClick:onClick
				}
			};

			var zNodes =[
				{ id:1, pId:0, name:"随意拖拽 1", open:true},
				{ id:11, pId:1, name:"随意拖拽 1-1"},
				{ id:12, pId:1, name:"随意拖拽 1-2"},
				{ id:121, pId:12, name:"随意拖拽 1-2-1"},
				{ id:122, pId:12, name:"随意拖拽 1-2-2"},
				{ id:123, pId:12, name:"随意拖拽 1-2-3"},
				{ id:13, pId:1, name:"禁止拖拽 1-3", open:true, drag:false},
				{ id:131, pId:13, name:"禁止拖拽 1-3-1", drag:false},
				{ id:132, pId:13, name:"禁止拖拽 1-3-2", drag:false},
				{ id:132, pId:13, name:"禁止拖拽 1-3-3", drag:false},
				{ id:2, pId:0, name:"禁止子节点移走 2", open:true, childOuter:false},
				{ id:21, pId:2, name:"我不想成为父节点 2-1", dropInner:false},
				{ id:22, pId:2, name:"我不要成为根节点 2-2", dropRoot:false},
				{ id:23, pId:2, name:"拖拽试试看 2-3"},
				{ id:3, pId:0, name:"禁止子节点排序/增加 3", open:true, childOrder:false, dropInner:false},
				{ id:31, pId:3, name:"随意拖拽 3-1"},
				{ id:32, pId:3, name:"随意拖拽 3-2"},
				{ id:33, pId:3, name:"随意拖拽 3-3"}
			];


			function onClick(event, treeId, treeNode, clickFlag) {
				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
				var nodes = treeObj.getSelectedNodes();
				//$.post("${path}/admin/sys/setSiteList2",{treeStr2:nodes[0].id,type:nodes[0].type},function(msg){
				//});
				doQuery(nodes[0].id);
				if(nodes[0].type == "1"){
					//document.getElementById("contentiframe").src="sys/zdgl.jsp";
				}
			}
			
			function dropPrev(treeId, nodes, targetNode) {
				var pNode = targetNode.getParentNode();
				if (pNode && pNode.dropInner === false) {
					return false;
				} else {
					for (var i=0,l=curDragNodes.length; i<l; i++) {
						var curPNode = curDragNodes[i].getParentNode();
						if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
							return false;
						}
					}
				}
				return true;
			}
			function dropInner(treeId, nodes, targetNode) {
				if (targetNode && targetNode.dropInner === false) {
					return false;
				} else {
					for (var i=0,l=curDragNodes.length; i<l; i++) {
						if (!targetNode && curDragNodes[i].dropRoot === false) {
							return false;
						} else if (curDragNodes[i].parentTId && curDragNodes[i].getParentNode() !== targetNode && curDragNodes[i].getParentNode().childOuter === false) {
							return false;
						}
					}
				}
				return true;
			}
			function dropNext(treeId, nodes, targetNode) {
				var pNode = targetNode.getParentNode();
				if (pNode && pNode.dropInner === false) {
					return false;
				} else {
					for (var i=0,l=curDragNodes.length; i<l; i++) {
						var curPNode = curDragNodes[i].getParentNode();
						if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
							return false;
						}
					}
				}
				return true;
			}

			var log, className = "dark", curDragNodes, autoExpandNode;
			function beforeDrag(treeId, treeNodes) {
				className = (className === "dark" ? "":"dark");
				showLog("[ "+getTime()+" beforeDrag ]&nbsp;&nbsp;&nbsp;&nbsp; drag: " + treeNodes.length + " nodes." );
				for (var i=0,l=treeNodes.length; i<l; i++) {
					if (treeNodes[i].drag === false) {
						curDragNodes = null;
						return false;
					} else if (treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag === false) {
						curDragNodes = null;
						return false;
					}
				}
				curDragNodes = treeNodes;
				return true;
			}
			function beforeDragOpen(treeId, treeNode) {
				autoExpandNode = treeNode;
				return true;
			}
			function beforeDrop(treeId, treeNodes, targetNode, moveType, isCopy) {
				className = (className === "dark" ? "":"dark");
				showLog("[ "+getTime()+" beforeDrop ]&nbsp;&nbsp;&nbsp;&nbsp; moveType:" + moveType);
				showLog("target: " + (targetNode ? targetNode.name : "root") + "  -- is "+ (isCopy==null? "cancel" : isCopy ? "copy" : "move"));
				return true;
			}
			function onDrag(event, treeId, treeNodes) {
				className = (className === "dark" ? "":"dark");
				showLog("[ "+getTime()+" onDrag ]&nbsp;&nbsp;&nbsp;&nbsp; drag: " + treeNodes.length + " nodes." );
			}
			function onDrop(event, treeId, treeNodes, targetNode, moveType, isCopy) {
				className = (className === "dark" ? "":"dark");
				showLog("[ "+getTime()+" onDrop ]&nbsp;&nbsp;&nbsp;&nbsp; moveType:" + moveType);
				showLog("target: " + (targetNode ? targetNode.name : "root") + "  -- is "+ (isCopy==null? "cancel" : isCopy ? "copy" : "move"))
			}
			function onExpand(event, treeId, treeNode) {
				if (treeNode === autoExpandNode) {
					className = (className === "dark" ? "":"dark");
					showLog("[ "+getTime()+" onExpand ]&nbsp;&nbsp;&nbsp;&nbsp;" + treeNode.name);
				}
			}

			function showLog(str) {
				if (!log) log = $("#log");
				log.append("<li class='"+className+"'>"+str+"</li>");
				if(log.children("li").length > 8) {
					log.get(0).removeChild(log.children("li")[0]);
				}
			}
			function getTime() {
				var now= new Date(),
				h=now.getHours(),
				m=now.getMinutes(),
				s=now.getSeconds(),
				ms=now.getMilliseconds();
				return (h+":"+m+":"+s+ " " +ms);
			}

			function setTrigger() {
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
			}

			 // 刷新并定位到选中节点
			 function refresh(id){
				 $.fn.zTree.init($("#treeDemo"), setting);
				 //var treeObj = $.fn.zTree.getZTreeObj(id);
					//var nodes = treeObj.getSelectedNodes();
					//treeObj.reAsyncChildNodes(nodes[0], "refresh");
					//var curNode = treeObj.getNodeByParam("id", nodes[0].id, null);
	                //treeObj.expandNode(curNode, true); 
			 }
			 
			$(document).ready(function(){
				$.fn.zTree.init($("#treeDemo"), setting);
				$("#callbackTrigger").bind("change", {}, setTrigger);
			});
	</script>
	
	</head>

	<body class="easyui-layout">
	
	<!-- 正左边panel -->
	<div id="leftPanel" data-options="region:'west',iconCls:'icon-user'" title="系统菜单" style="width:220px;">
		<div class="zTreeDemoBackground left">
			<ul id="treeDemo" class="ztree"></ul>
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
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="toEdit()">编辑</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="doDel()">删除</a>
						</td>
					</tr>
				</table>
			</div>
			<div class="datagrid-toolbar" style="margin-bottom: 3px;"></div>
			<div id="qf">
				&nbsp;&nbsp;名称:
				<input name="funcsName" class="easyui-textbox" style="width: 120px"/>
				地址:
				<input name="funcsUrl" class="easyui-textbox" style="width: 120px"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle"><span id="parentCode_span"></span></div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsName" name="funcsName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入名称,长度为[1-32]"  data-options="required:true,validType:['length[1,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;编码：</td>
						<td class="text_cloumn2">
							<input type="text" id="id" name="id" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入菜单编码,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;上级编码：</td>
						<td class="text_cloumn2">
							<input type="text" id="parentId" name="parentId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入上级编码,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;类型：</td>
						<td class="text_cloumn2">
							<html:select name="funcsType" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
								<html:options items="${funcsType}" selectedValue="${en.funcsType}" labelField="dataName" valueField="dataValue"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;地址：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsUrl" name="funcsUrl" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入地址,长度为[0-256]"  data-options="required:false,validType:['length[0,256]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;是否隐藏：</td>
						<td class="text_cloumn2">
							<html:select name="funcsHide" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
								<html:options items="${funcsHide}" selectedValue="${en.funcsHide}" labelField="dataName" valueField="dataValue"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;排序：</td>
						<td class="text_cloumn2">
							<input type="text" class="easyui-numberspinner"  style="width:192px;margin-top: 3px;" id="funcsSort" name="funcsSort" 
							min="1" max="100" value="1" autofocus="autofocus" autocomplete="off" placeholder="1"  data-options="increment:1,required:false,validType:['isDigit']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;图标：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsIcon" name="funcsIcon" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入图标,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsDesc" name="funcsDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入描述,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
						</td>
					</tr>
				</table>
				<!-- 表单table end-->
			</form>
			
			
			<select id="cc" style="width:150px"></select>
	<div id="sp">
		<div style="color:#99BBE8;background:#fafafa;padding:5px;">
			<html:select name="funcsHide" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
				<html:options items="${funcsHide}" selectedValue="${en.funcsHide}" labelField="dataName" valueField="dataValue"/>
			</html:select>
		</div>
		<div style="padding:10px">
			<img src="" alt="" /> <img src="" alt="" /> <img src="" alt="" /> <img src="" alt="" /> <img src="" alt="" /> 
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			$('#cc').combo({
				required:true,
				editable:false
			});
			$('#sp').appendTo($('#cc').combo('panel'));
			$('#sp input').click(function(){
				var v = $(this).val();
				var s = $(this).next('span').text();
				//$('#cc').combo('setValue', v).combo('setText', s).combo('hidePanel');
			});
		});
	</script>
	
	
		</div>
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="doSave()">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
		</div>
		<!-- dlg dialog end -->
	</div>
<script type="text/javascript">
	$('#dg').datagrid({
		 url: 'doQuery.json',
		 title: '菜单管理',
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
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ], 
		 idField:'id', 
		  columns: [[ 
			  { field: 'id', title: 'ID', width: 182, align: 'left', sortable: true }, 
			  { field: 'parentId', title: '上级编码', width: 182, align: 'left', sortable: true }, 
			  { field: 'funcsType', title: '类型', width: 60, align: 'left', sortable: true,
				  formatter: function(value,row,index){
					if (row.funcsType==1){
						return "<a href='#' class='easyui-tooltip'>模块</a>";
					} else if (row.funcsType==2){
						return "页面";
					}else{
						return "操作";
					}
				}
			 }, 
			  { field: 'funcsName', title: '名称', width: 132, align: 'left', sortable: true }, 
			  { field: 'funcsUrl', title: '地址', width: 350, align: 'center', sortable: true }, 
			  { field: 'funcsHide', title: '是否隐藏', width: 100, align: 'left', sortable: true ,
				  formatter: function(value,row,index){
						if (row.funcsHide==1){
							return "<a href='#' class='easyui-tooltip'>显示</a>";
						} else {
							return "隐藏";
						}
					}
				}, 
			  { field: 'funcsSort', title: '排序', width: 50, align: 'left', sortable: true }, 
			  { field: 'funcsIcon', title: '图标', width: 100, align: 'left', sortable: true }, 
			  { field: 'funcsDesc', title: '描述', width: 156, align: 'left', sortable: true }
			  ]], 
		 toolbar: '#tb',
		 pagination: true
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
</script>
<script type="text/javascript">
// 查询
function doQuery(id) {
	$("#dg").datagrid("load", {
		"funcsName":$("#qf").find("input[name='funcsName']").val(),
		"funcsUrl":$("#qf").find("input[name='funcsUrl']").val(),
		"id":id
	 });
}

function doDel() {
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
					refresh('treeDemo');
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
function toAdd(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#parentId').val(row.id);
		$('#parentCode_span').html("上级菜单->"+row.funcsName);
	}
	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
 	var selectedNode = treeObj.getSelectedNodes(); 
 	if(!!selectedNode[0]){
 		$('#parentId').val(selectedNode[0].id);
 		$('#parentCode_span').html("上级菜单->"+selectedNode[0].name);
 	} 
 	$('#id').val("");
 	$('#funcsName').val("");
	$('#dlg').dialog('open').dialog('center').dialog('setTitle','新增');
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
	$.ajax({
		type: "POST",
		data:$('#fm').serialize(),
		url : url,
		beforeSend:function(){
			return $('#fm').form('validate');
		},
		success: function(result){
			var retMsg;
			if (result.code == 0){
				retMsg = result.msg;
				refresh('treeDemo');
				$('#dg').datagrid('reload');
			}else{
				retMsg = "<div style='color: #880000;'>响应码"+result.code+"</div>"+result.msg;
			}
			$.messager.show({
				title: '操作提示',
				msg: retMsg
			});
			$('#dlg').dialog('close');
		}
	});
}

</script>
	</body>
</html>
