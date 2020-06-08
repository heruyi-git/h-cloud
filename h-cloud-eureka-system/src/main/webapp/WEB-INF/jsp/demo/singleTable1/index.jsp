<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>单表1管理</title>
		<jsp:include page="/WEB-INF/jsp/include/easyui.jsp"></jsp:include>
	</head>

	<body>
	
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
							<a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="doSave()">保存</a>
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
				&nbsp;&nbsp;查询日期:
				<input name="beginTime" class="easyui-datebox" style="width: 100px"/>
				-
				<input name="endTime" class="easyui-datebox" style="width: 100px"/>
				&nbsp;&nbsp;表名:
				<input name="tableName" value="${en.tableName}" class="easyui-textbox" style="width: 120px;"/>
				&nbsp;&nbsp;描述:
				<input name="tableDesc" class="easyui-textbox" style="width: 120px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">单表1信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;表名：</td>
						<td class="text_cloumn2">
							<input type="text" id="tableName" name="tableName" class="easyui-numberbox" autofocus="autofocus"
							autocomplete="off" placeholder="请输入表名,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="tableDesc" name="tableDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入描述,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;添加时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加时间,长度为[0-22]"  data-options="required:false,validType:['length[0,22]']"/>
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

<script type="text/javascript">
	$('#dg').datagrid({
		 url: 'doQuery.json',
		 title: '单表1管理',
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
		 sortName: 'id',
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ], 
		 idField:'id', 
		  columns: [[ 
			  { field: 'id', title: 'ID', width: 66, align: 'left', sortable: true },
			  { field: 'tableName', title: '表名', width: 126, align: 'left', sortable: true },
			  { field: 'tableDesc', title: '描述', width: 220, align: 'center', sortable: true },
			  { field: 'addTime', title: '添加时间', width: 87, align: 'left', sortable: true }
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
function doQuery() {
	$("#dg").datagrid("load", {
		"beginTime":$("#qf").find("input[name='beginTime']").val(),
		"endTime":$("#qf").find("input[name='endTime']").val(),
		"tableName":$("#qf").find("input[name='tableName']").val(),
		"tableDesc":$("#qf").find("input[name='tableDesc']").val()
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
	$('#dlg').dialog('open').dialog('center').dialog('setTitle','新增');
	$('#fm').form('clear');
	url = 'doAdd.json';
}

function toEdit(){
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

</script>
	</body>
</html>