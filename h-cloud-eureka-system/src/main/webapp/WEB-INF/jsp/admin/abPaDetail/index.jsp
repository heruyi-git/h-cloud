<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>免密调用明细管理</title>
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
						<permission:dom id="1588655886924012">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588655886924014">
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
						<permission:dom id="1588655886924013">
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
				<permission:dom id="1588655886924011">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:784px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">免密调用明细信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;流水号：</td>
						<td class="text_cloumn2">
							<input type="text" id="seqNo" name="seqNo" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入流水号,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;套餐订单项ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="orderItemId" name="orderItemId" class="easyui-validatebox textbox" value="0" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐订单项ID,长度为[0-19]"  data-options="required:false,validType:['isDigit','length[0,19]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;用户ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="userId" name="userId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户ID,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;用户名：</td>
						<td class="text_cloumn2">
							<input type="text" id="userName" name="userName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户名,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;应用ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="appId" name="appId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用ID,长度为[0-19]"  data-options="required:false,validType:['isDigit','length[0,19]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;应用名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="appName" name="appName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入应用名称,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;产品ID：</td>
						<td class="text_cloumn2">
							<input type="text" id="productId" name="productId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入产品ID,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;产品名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="productName" name="productName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入产品名称,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;产品版本号：</td>
						<td class="text_cloumn2">
							<input type="text" id="productVersion" name="productVersion" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入产品版本号,长度为[1-3]"  data-options="required:true,validType:['length[1,3]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;IP地址：</td>
						<td class="text_cloumn2">
							<input type="text" id="ipAddr" name="ipAddr" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入IP地址,长度为[0-15]"  data-options="required:false,validType:['length[0,15]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;时间戳：</td>
						<td class="text_cloumn2">
							<input type="text" id="timestamp" name="timestamp" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入时间戳,长度为[1-19]"  data-options="required:true,validType:['isDigit','length[1,19]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;签名类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="signType" name="signType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入签名类型,长度为[0-3]"  data-options="required:false,validType:['length[0,3]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;签名：</td>
						<td class="text_cloumn2">
							<input type="text" id="sign" name="sign" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入签名,长度为[1-32]"  data-options="required:true,validType:['length[1,32]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;TOKEN：</td>
						<td class="text_cloumn2">
							<input type="text" id="token" name="token" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入TOKEN,长度为[1-32]"  data-options="required:true,validType:['length[1,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;H5重定向地址：</td>
						<td class="text_cloumn2">
							<input type="text" id="h5RedirectUrl" name="h5RedirectUrl" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入H5重定向地址,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;状态：</td>
						<td class="text_cloumn2">
							<html:select name="state" styleId="state" styleClass="easyui-combobox" defaultOption="请选择" otherAttributes="data-options='required:false,editable:false' style='width: 193px; height: 23px;' panelHeight='auto'">
								<html:options items="${state}" selectedValue="" labelField="dataName" valueField="dataValue"/>							</html:select>					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;状态信息：</td>
						<td class="text_cloumn2">
							<input type="text" id="msg" name="msg" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入状态信息,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;返回数据：</td>
						<td class="text_cloumn2">
							<input type="text" id="data" name="data" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入返回数据,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;添加时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;更新时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="updateTime" name="updateTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入更新时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
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
		 title: '免密调用明细管理',
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
			  { field: 'seqNo', title: '流水号', width: 126, align: 'left', sortable: true },
			  { field: 'orderItemId', title: '套餐订单项ID', width: 104, align: 'left', sortable: true },
			  { field: 'userId', title: '用户ID', width: 86, align: 'left', sortable: true },
			  { field: 'userName', title: '用户名', width: 106, align: 'left', sortable: true },
			  { field: 'appId', title: '应用ID', width: 104, align: 'left', sortable: true },
			  { field: 'appName', title: '应用名称', width: 106, align: 'left', sortable: true },
			  { field: 'productId', title: '产品ID', width: 86, align: 'left', sortable: true },
			  { field: 'productName', title: '产品名称', width: 106, align: 'left', sortable: true },
			  { field: 'productVersion', title: '产品版本号', width: 72, align: 'left', sortable: true },
			  { field: 'ipAddr', title: 'IP地址', width: 96, align: 'left', sortable: true },
			  { field: 'timestamp', title: '时间戳', width: 104, align: 'left', sortable: true },
			  { field: 'signType', title: '签名类型', width: 72, align: 'left', sortable: true },
			  { field: 'sign', title: '签名', width: 126, align: 'left', sortable: true },
			  { field: 'token', title: 'TOKEN', width: 126, align: 'left', sortable: true },
			  { field: 'h5RedirectUrl', title: 'H5重定向地址', width: 172, align: 'left', sortable: true },
			  { field: 'state', title: '状态', width: 76, align: 'left', sortable: true,formatter:convert.getDataName },
			  { field: 'msg', title: '状态信息', width: 172, align: 'left', sortable: true },
			  { field: 'data', title: '返回数据', width: 126, align: 'left', sortable: true },
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