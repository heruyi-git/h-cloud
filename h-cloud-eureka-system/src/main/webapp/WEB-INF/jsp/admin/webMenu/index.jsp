<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>WEB_MENU管理</title>
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
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
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
						<td class="label_cloumn2">*&nbsp;上级ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="parentId" name="parentId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入??ID,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;菜单类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsType" name="funcsType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入????"  data-options="required:true,validType:['isDigit']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;菜单名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsName" name="funcsName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入????,长度为[1-32]"  data-options="required:true,validType:['length[1,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;URL：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsUrl" name="funcsUrl" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入????,长度为[0-256]"  data-options="required:false,validType:['length[0,256]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;是否隐藏：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsHide" name="funcsHide" class="easyui-validatebox textbox" value="0" autofocus="autofocus"
							autocomplete="off" placeholder="请输入????1??0??"  data-options="required:true,validType:['isDigit']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsDesc" name="funcsDesc" class="easyui-validatebox textbox" value="''" autofocus="autofocus"
							autocomplete="off" placeholder="请输入????,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;排序：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsSort" name="funcsSort" class="easyui-validatebox textbox" value="1" autofocus="autofocus"
							autocomplete="off" placeholder="请输入??"  data-options="required:false,validType:['isDigit']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;图标：</td>
						<td class="text_cloumn2">
							<input type="text" id="funcsIcon" name="funcsIcon" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入FUNCS_ICON,长度为[0-255]"  data-options="required:false,validType:['length[0,255]']"/>
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
		 url: 'page.json',
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
		 sortOrder: 'desc',
		 sortName: 'id',
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ], 
		 idField:'id', 
		  columns: [[ 
			  { field: 'id', title: 'ID', width: 126, align: 'left', sortable: true },
			  { field: 'parentId', title: '上级ID', width: 126, align: 'left', sortable: true },
			  { field: 'funcsType', title: '菜单类型', width: 66, align: 'left', sortable: true },
			  { field: 'funcsName', title: '菜单名称', width: 126, align: 'left', sortable: true },
			  { field: 'funcsUrl', title: 'URL', width: 225, align: 'center', sortable: true },
			  { field: 'funcsHide', title: '是否隐藏', width: 66, align: 'left', sortable: true },
			  { field: 'funcsDesc', title: '描述', width: 138, align: 'left', sortable: true },
			  { field: 'funcsSort', title: '排序', width: 66, align: 'left', sortable: true },
			  { field: 'funcsIcon', title: '图标', width: 225, align: 'center', sortable: true }
			  ]], 
		 toolbar: '#tb',
		 pagination: true,
		 pageSize: 10,
		 pageList: [10,15,20,30,50],
		 beforePageText: '第',
		 afterPageText: '页    共 {pages} 页',
		 displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',
		 view: datagridView,
		 emptyMsg: 'no records found',
		 loadFilter: util.loadFilter
	});
</script>
<script type="text/javascript">
// 分页查询
function doPage() {
	$("#dg").datagrid("load", {
		"beginTime":$("#qf").find("input[name='beginTime']").val(),
		"endTime":$("#qf").find("input[name='endTime']").val()
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
			$.post('del.json',{ids:strIds}, function (result) {
				if (result.code == constant.success) {
					$.messager.show({
						title: '操作提示',
						msg: result.msg
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
	url = 'add.json';
}

function toEdit(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('center').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		url = 'edit.json';
	}
}

function doSave(){
	$.ajax({
		type : 'post',
		data : $('#fm').serialize(),
		url : url,
		beforeSend:function(){
			return $('#fm').form('validate');
		},
		success: function(result){
			var retMsg;
			if (result.code == constant.success){
				retMsg = result.msg;
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
