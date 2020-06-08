<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>应用SDK日志管理</title>
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
						<permission:dom id="1588669922972000">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588669922972002">
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
						<permission:dom id="1588669922972001">
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
				<permission:dom id="1588655886924006">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:784px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">应用SDK日志信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;应用ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="appId" name="appId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用ID,长度为[0-19]"  data-options="required:false,validType:['isDigit','length[0,19]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;应用密钥：</td>
						<td class="text_cloumn2">
							<input type="text" id="appSecret" name="appSecret" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用密钥,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;运营商：</td>
						<td class="text_cloumn2">
							<input type="text" id="isp" name="isp" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入运营商,长度为[0-5]"  data-options="required:false,validType:['length[0,5]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;IP地址：</td>
						<td class="text_cloumn2">
							<input type="text" id="ipAddr" name="ipAddr" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入IP地址,长度为[0-15]"  data-options="required:false,validType:['length[0,15]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;MAC地址：</td>
						<td class="text_cloumn2">
							<input type="text" id="macAddr" name="macAddr" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入MAC地址,长度为[0-30]"  data-options="required:false,validType:['length[0,30]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;IMEI：</td>
						<td class="text_cloumn2">
							<input type="text" id="imei" name="imei" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入IMEI,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;手机型号：</td>
						<td class="text_cloumn2">
							<input type="text" id="phoneModel" name="phoneModel" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入手机型号,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;系统类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="systemType" name="systemType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入系统类型,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;系统版本：</td>
						<td class="text_cloumn2">
							<input type="text" id="systemVersion" name="systemVersion" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入系统版本,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;网络环境：</td>
						<td class="text_cloumn2">
							<input type="text" id="netEnv" name="netEnv" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入网络环境,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;SDK版本：</td>
						<td class="text_cloumn2">
							<input type="text" id="sdkVersion" name="sdkVersion" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入SDK版本,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;添加时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
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
		 title: '应用SDK日志管理',
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
		 sortName: 'id',
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ], 
		 idField:'id', 
		  columns: [[ 
			  { field: 'id', title: 'id', width: 104, align: 'left', sortable: true },
			  { field: 'appId', title: '应用ID', width: 104, align: 'left', sortable: true },
			  { field: 'appSecret', title: '应用密钥', width: 126, align: 'left', sortable: true },
			  { field: 'isp', title: '运营商', width: 76, align: 'left', sortable: true },
			  { field: 'ipAddr', title: 'IP地址', width: 96, align: 'left', sortable: true },
			  { field: 'macAddr', title: 'MAC地址', width: 126, align: 'left', sortable: true },
			  { field: 'imei', title: 'IMEI', width: 126, align: 'left', sortable: true },
			  { field: 'phoneModel', title: '手机型号', width: 106, align: 'left', sortable: true },
			  { field: 'systemType', title: '系统类型', width: 106, align: 'left', sortable: true },
			  { field: 'systemVersion', title: '系统版本', width: 106, align: 'left', sortable: true },
			  { field: 'netEnv', title: '网络环境', width: 106, align: 'left', sortable: true },
			  { field: 'sdkVersion', title: 'SDK版本', width: 86, align: 'left', sortable: true },
			  { field: 'addTime', title: '添加时间', width: 122, align: 'left', sortable: true }
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