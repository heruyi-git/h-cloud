<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>套餐产品项管理</title>
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
						<permission:dom id="1588655886924042">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588655886924044">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="toEdit()">编辑</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-excel" plain="true" onclick="location.href='perfectQuery.xls'">导出</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						<permission:dom id="1588655886924043">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="util.doDel('#dg','del.json')">删除</a>
						</td>
						</permission:dom>
					</tr>
				</table>
			</div>
			<div class="datagrid-toolbar" style="margin-bottom: 3px;"></div>
			<div id="qf">
				&nbsp;&nbsp;查询日期:
				<input name="beginTime" class="easyui-datebox" style="width: 100px"/>
				-
				<input name="endTime" class="easyui-datebox" style="width: 100px"/>
				<permission:dom id="1588655886924041">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">套餐产品项信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;套餐ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="packageId" name="packageId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐ID,长度为[1-10]"  data-options="required:true,validType:['isDigit','length[1,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;产品ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="productId" name="productId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入产品ID,长度为[1-10]"  data-options="required:true,validType:['isDigit','length[1,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;单价：</td>
						<td class="text_cloumn2">
							<input type="text" id="price" name="price" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入单价,长度为[1-10]"  data-options="required:true,validType:['length[1,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;数量：</td>
						<td class="text_cloumn2">
							<input type="text" id="quantity" name="quantity" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入数量,长度为[1-10]"  data-options="required:true,validType:['isDigit','length[1,10]']"/>
						</td>
					</tr>
				</table>
				<!-- 表单table end-->
			</form>
		</div>
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="util.doSave('#fm', url, 'post','#dlg','#dg');">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
		</div>
		<!-- dlg dialog end -->

<script type="text/javascript">
	$('#dg').datagrid({
		 url: 'page.json',
		 title: '套餐产品项管理',
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
			  { field: 'id', title: 'id', width: 86, align: 'left', sortable: true },
			  { field: 'packageId', title: '套餐ID', width: 86, align: 'left', sortable: true },
			  { field: 'productId', title: '产品ID', width: 86, align: 'left', sortable: true },
			  { field: 'price', title: '单价', width: 86, align: 'left', sortable: true },
			  { field: 'quantity', title: '数量', width: 86, align: 'left', sortable: true }
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
		 onLoadSuccess : util.loadSuccess,
		 loadFilter: util.loadFilter
	});

	// 分页查询
	function doPage() {
		$("#dg").datagrid("load", {
			"beginTime":$("#qf").find("input[name='beginTime']").val(),
			"endTime":$("#qf").find("input[name='endTime']").val()
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

</script>
	</body>
</html>