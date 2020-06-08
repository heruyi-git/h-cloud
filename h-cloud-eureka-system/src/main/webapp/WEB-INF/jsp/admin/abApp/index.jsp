<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>爱博应用管理</title>
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
						<permission:dom id="1588653676817002">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588653676817004">
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
						<permission:dom id="1588653676817003">
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
				<permission:dom id="1588653676817001">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:784px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">爱博应用信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="appId"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;用户ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="userId" name="userId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户ID,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;应用名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="appName" name="appName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用名称,长度为[1-20]"  data-options="required:true,validType:['length[1,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;应用图标：</td>
						<td class="text_cloumn2">
							<input type="text" id="appIcon" name="appIcon" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用图标,长度为[1-16777215]"  data-options="required:true,validType:['length[1,16777215]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;应用描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="appDesc" name="appDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用描述,长度为[1-256]"  data-options="required:true,validType:['length[1,256]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;应用类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="appType" name="appType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用类型,长度为[1-10]"  data-options="required:true,validType:['length[1,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;ios绑定ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="iosBundleId" name="iosBundleId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入ios绑定ID,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;安卓包名：</td>
						<td class="text_cloumn2">
							<input type="text" id="androidPacketName" name="androidPacketName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入安卓包名,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;安卓应用签名：</td>
						<td class="text_cloumn2">
							<input type="text" id="androidAppSign" name="androidAppSign" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入安卓应用签名,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;状态：</td>
						<td class="text_cloumn2">
							<input type="text" id="status" name="status" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入状态,长度为[0-5]"  data-options="required:false,validType:['length[0,5]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;添加时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;更新时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="updateTime" name="updateTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入更新时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">&nbsp;</td>
						<td class="text_cloumn2">&nbsp;</td>
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
		 title: '爱博应用管理',
		 iconCls: 'icon-right',
		 loadMsg: '数据加载中,请稍候...',
		 checkOnSelect: false,
		 selectOnCheck: false,
		 collapsible:true,
		 border: true,
		 nowrap: true,
		 fit: true,
		 fitColumns: false,
		 striped : true,
		 singleSelect: true,
		 rownumbers:true,
		 sortOrder: 'desc',
		 sortName: 'appId',
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ], 
		 idField:'appId', 
		  columns: [[ 
			  { field: 'appId', title: '应用ID', width: 104, align: 'left', sortable: true },
			  { field: 'userId', title: '用户ID', width: 86, align: 'left', sortable: true },
			  { field: 'appName', title: '应用名称', width: 106, align: 'left', sortable: true },
			  { field: 'appIcon', title: '应用图标', width: 320, align: 'center', sortable: true,formatter:convert.appendTooltip },
			  { field: 'appDesc', title: '应用描述', width: 225, align: 'center', sortable: true,formatter:convert.appendTooltip },
			  { field: 'appType', title: '应用类型', width: 86, align: 'left', sortable: true },
			  { field: 'iosBundleId', title: 'ios绑定ID', width: 172, align: 'left', sortable: true },
			  { field: 'androidPacketName', title: '安卓包名', width: 172, align: 'left', sortable: true },
			  { field: 'androidAppSign', title: '安卓应用签名', width: 138, align: 'left', sortable: true },
			  { field: 'status', title: '状态', width: 76, align: 'left', sortable: true },
			  { field: 'addTime', title: '添加时间', width: 122, align: 'left', sortable: true },
			  { field: 'updateTime', title: '更新时间', width: 122, align: 'left', sortable: true }
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