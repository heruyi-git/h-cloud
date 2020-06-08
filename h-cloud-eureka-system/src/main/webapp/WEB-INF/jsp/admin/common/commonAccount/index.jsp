<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>账户管理</title>
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
							<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="doDel()">删除</a>
						</td>
					</tr>
				</table>
			</div>
			<div class="datagrid-toolbar" style="margin-bottom: 3px;"></div>
			<div id="qf">
				&nbsp;&nbsp;注册日期:
				<input name="beginTime" class="easyui-datebox" style="width: 100px"/>
				-
				<input name="endTime" class="easyui-datebox" style="width: 100px"/>
				&nbsp;&nbsp;账号:
				<input name="accountName" class="easyui-textbox" style="width: 120px; height: 22px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:1px 2px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<form id="fm" method="post" novalidate class="bootstrap-frm" enctype="multipart/form-data">
				<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;账号：</td>
						<td class="text_cloumn2">
							<input type="hidden" id="_accountName"/>
							<input type="text" id="accountName" name="accountName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入账号,长度为[3-20]"  data-options="required:true,validType:{length:[3,20],ajax:['${path}/common/checkAccountName','账号已存在','_accountName']}"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;密码：</td>
						<td class="text_cloumn2">
							<input type="text" id="accountPass" name="accountPass" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入密码,长度为[3-32]"  data-options="required:true,validType:['length[3,32]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;联系人：</td>
						<td class="text_cloumn2">
							<input type="text" id="realName" name="realName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入姓名,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;绑定IP：</td>
						<td class="text_cloumn2">
							<input type="text" id="loginBindIp" name="loginBindIp" class="easyui-validatebox textbox" value="NULL" autofocus="autofocus"
							autocomplete="off" placeholder="请输入绑定IP,长度为[0-100]"  data-options="required:false,validType:['length[0,100]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;所属客户：</td>
						<td class="text_cloumn2">
							<input name="departmentId" id="customId_q" class="easyui-validatebox textbox"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;状态：</td>
						<td class="text_cloumn2">
							<html:select name="state" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择状态' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
								<html:options items="{启用:1,停用:2}" selectedValue="${state}" separator="{}"/>
							</html:select>
						</td>
					</tr>
						<tr>
						<td class="label_cloumn2">*&nbsp;角色ID：</td>
						<td class="text_cloumn2">
							<html:select name="roleId" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择角色' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
								<html:options items="${roleList}" selectedValue="${roleId}" labelField="roleName" valueField="id"/>
							</html:select>
						</td>
					</tr>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;头像：</td>
						<td class="text_cloumn2">
							<input class="easyui-filebox" name="img" id="img" data-options="accept:'.jpg,.gif,.png',buttonText:'选择文件',required:false,buttonIcon:'icon-ok'" style="width:192px"/>
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
		 title: '账户管理',
		 iconCls: 'icon-user',
		 loadMsg: '数据加载中,请稍候...',
		 emptyMsg: 'no records found',
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
			  { field: 'id', title: 'ID', width: 36, align: 'left', sortable: true },
			  { field: 'imgStr', title: '头像', width: 25, align: 'left', sortable: true ,
				  formatter: function(value,row,index){
					  if (row.imgStr){
						  return "<img width='32' height='32' src='"+constant.imgSrcPrefix + row.imgStr+"'/>";
					  }
				  }
			  },
			  { field: 'accountName', title: '账号', width: 66, align: 'left', sortable: true },
			  { field: 'roleName', title: '角色', width: 76, align: 'left', sortable: true }, 
			  { field: 'realName', title: '联系人', width: 82, align: 'left', sortable: true },
			 // { field: 'departmentId', title: '所属客户', width: 86, align: 'left', sortable: true,formatter:convert.getCustomName },
			  { field: 'loginBindIp', title: '绑定IP', width: 126, align: 'left', sortable: true },
			  { field: 'state', title: '状态', width: 66, align: 'left', sortable: true ,
				  formatter: function(value,row,index){
						if (row.state){
							return row.state==1?"启用":"<font color='gray'>停用</font>";
						} 
					}
				}, 
			  { field: 'addTime', title: '注册时间', width: 127, align: 'left', sortable: true,formatter:convert.formatDateTime}, 
				{ field: 'lastLoginTime', title: '最后登录时间', width: 127, align: 'left', sortable: true,formatter:convert.formatDateTime}, 
			  { field: 'loginCount', title: '登录次数', width: 66, align: 'left', sortable: true }, 
			  { field: 'loginState', title: '在线状态', width: 66, align: 'center', sortable: true,
				    formatter: function(value,row,index){
						if (row.loginState==1){
							return "<a href='#' title='离开' class='easyui-tooltip'>离开</a>";
						} else if (row.loginState==2){
							return "<a href='#' title='离线' class='easyui-tooltip'>离线</a>";
						} else if (row.loginState==3){
							return "<a href='#' title='在线' class='easyui-tooltip'>在线</a>";
						} else {
							return "未激活";
						}
					}
				} 
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
		"accountName":$("#qf").find("input[name='accountName']").val()
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
	$('#accountName').attr("readOnly",false);
}

function toEdit(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		$('#dlg').dialog('open').dialog('center').dialog('setTitle','编辑');
		$('#fm').form('load',row);
		url = 'doEdit.json';
		$('#accountName').attr("readOnly",true);
		$('#_accountName').val(row.accountName);
	}
}

function doSave(){
	$.ajax({
		type: "POST",
		data: new FormData($('#fm')[0]), // $('#fm').serialize()
		url : url,
		contentType: false,
		processData: false, // 序列化数据
		beforeSend:function(){
			return $('#fm').form('validate');
		},
		success: function(result){
			var retMsg;
			if (result.code == 0){
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

//commbox init
$(document).ready(function(){
	// 所属客户
	//util.autoQuery('#customId_q','${path}/s/doQueryCustom.json',{},['id','customName'],25,192);
});

</script>
	</body>
</html>
