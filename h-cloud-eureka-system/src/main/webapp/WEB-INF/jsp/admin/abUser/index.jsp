<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>用户管理</title>
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
						<permission:dom id="1588650920967002">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588650920967004">
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
						<permission:dom id="1588650920967003">
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
				<permission:dom id="1588650920967001">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:784px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">用户信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;用户名：</td>
						<td class="text_cloumn2">
							<input type="text" id="userName" name="userName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户名,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;手机：</td>
						<td class="text_cloumn2">
							<input type="text" id="phone" name="phone" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入手机,长度为[0-11]"  data-options="required:false,validType:['length[0,11]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;邮箱：</td>
						<td class="text_cloumn2">
							<input type="text" id="email" name="email" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入邮箱,长度为[0-30]"  data-options="required:false,validType:['length[0,30]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;用户密码：</td>
						<td class="text_cloumn2">
							<input type="text" id="userPwd" name="userPwd" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户密码,长度为[1-20]"  data-options="required:true,validType:['length[1,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;支付密码：</td>
						<td class="text_cloumn2">
							<input type="text" id="payPwd" name="payPwd" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入支付密码,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;用户密钥：</td>
						<td class="text_cloumn2">
							<input type="text" id="userSecret" name="userSecret" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户密钥,长度为[0-32]"  data-options="required:false,validType:['length[0,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;余额：</td>
						<td class="text_cloumn2">
							<input type="text" id="balance" name="balance" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入余额,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;付款类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="payType" name="payType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入付款类型,长度为[0-5]"  data-options="required:false,validType:['length[0,5]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;公司名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="companyName" name="companyName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入公司名称,长度为[0-30]"  data-options="required:false,validType:['length[0,30]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;联系人：</td>
						<td class="text_cloumn2">
							<input type="text" id="liaison" name="liaison" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入联系人,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;用户类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="userType" name="userType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入用户类型,长度为[0-5]"  data-options="required:false,validType:['length[0,5]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;用户状态：</td>
						<td class="text_cloumn2">
							<html:select name="state" styleId="state" styleClass="easyui-combobox" defaultOption="请选择" otherAttributes="data-options='required:false,editable:false' style='width: 193px; height: 23px;' panelHeight='auto'">
								<html:options items="${state}" selectedValue="" labelField="dataName" valueField="dataValue"/>							</html:select>					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;注册时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入注册时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
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
		 title: '用户管理',
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
			  { field: 'id', title: 'id', width: 86, align: 'left', sortable: true },
			  { field: 'userName', title: '用户名', width: 106, align: 'left', sortable: true },
			  { field: 'phone', title: '手机', width: 88, align: 'left', sortable: true },
			  { field: 'email', title: '邮箱', width: 126, align: 'left', sortable: true },
			  { field: 'userPwd', title: '用户密码', width: 106, align: 'left', sortable: true },
			  { field: 'payPwd', title: '支付密码', width: 106, align: 'left', sortable: true },
			  { field: 'userSecret', title: '用户密钥', width: 126, align: 'left', sortable: true },
			  { field: 'balance', title: '余额', width: 86, align: 'left', sortable: true },
			  { field: 'payType', title: '付款类型', width: 76, align: 'left', sortable: true },
			  { field: 'companyName', title: '公司名称', width: 126, align: 'left', sortable: true },
			  { field: 'liaison', title: '联系人', width: 86, align: 'left', sortable: true },
			  { field: 'userType', title: '用户类型', width: 76, align: 'left', sortable: true },
			  { field: 'state', title: '用户状态', width: 76, align: 'left', sortable: true,formatter:convert.getDataName },
			  { field: 'addTime', title: '注册时间', width: 122, align: 'left', sortable: true }
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