<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@ taglib uri="http://common.h.uyi.org/el" prefix="el" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>角色管理</title>
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
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">角色信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;角色名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="roleName" name="roleName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入角色名称,长度为[1-20]"  data-options="required:true,validType:['length[1,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;角色状态：</td>
						<td class="text_cloumn2">
							<html:select name="roleState" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
								<html:options items="${roleState}" selectedValue="${state}" labelField="dataName" valueField="dataValue"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;&nbsp;角色描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="roleDesc" name="roleDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入角色描述,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
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
		
		<div id="w">
			<iframe id="ifrm" src="" width="99%" height="95%"></iframe>
		</div>

<script type="text/javascript">
	$('#dg').datagrid({
		 url: 'doQuery.json',
		 title: '角色管理',
		 iconCls: 'icon-role',
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
			  { field: 'id', title: 'ID', width: 120, align: 'left', sortable: true }, 
			  { field: 'roleName', title: '角色名称', width: 126, align: 'left', sortable: true }, 
			  { field: 'roleState', title: '角色状态', width: 180, align: 'left', sortable: true,
				  		formatter:convert.getDataName
				  /**
				  		formatter:function(value){return convert.getDataName2(value,${el:toJson(roleState)});}
				 	 	formatter:function(value){if(self.roleState==null){self.roleState = ${el:toJson(roleState)};}return convert.getDataName2(value,self.roleState);}
					*/
			  }, 
			  { field: 'roleDesc', title: '角色描述1', width: 216, align: 'left', sortable: true }, 
			  { field: 'op', title: '操作', width: 225, align: 'center',
		          	formatter:function(value,row){  
		                  var btn = '<a class="editcls1" href="javascript:toAssignRight(1,\''+row.id+'\')">权限分配</a>'; 
		                  btn += '&nbsp;<a class="editcls2" href="javascript:doClear(2,\''+row.id+'\')">刷新缓存</a>';
		                  return btn; 
		              }
		          }
			  ]], 
		 toolbar: '#tb',
		 pagination: true,
		 rowStyler:function(index,row){
		        if(row.state==12){
		           // return 'background-color:#6293BB;color:#fff;font-weight:bold;';
		        }
		    },
		    onLoadSuccess: function(data){//加载完毕后获取所有的checkbox遍历
		        if (data.rows.length > 0) {
		            //循环判断操作为新增的不能选择
		            for (var i = 0; i < data.rows.length; i++) {
		                //根据isFinanceExamine让某些行不可选
		                if (data.rows[i].state == 1||data.rows[i].state == 2) {
		                  //  $("input[type='checkbox']")[i + 1].disabled = true;
		                }
		            }
		            $('.editcls1').linkbutton({text:'权限分配',plain:true,iconCls:'icon-permission-set'});  
				    $('.editcls2').linkbutton({text:'刷新缓存',plain:true,iconCls:'icon-reload'}); 
		        }
		    },
		    onClickRow: function(rowIndex, rowData){
		        //加载完毕后获取所有的checkbox遍历
		        $("input[type='checkbox']").each(function(index, el){
		            //如果当前的复选框不可选，则不让其选中
		            if (el.disabled == true) {
		                //$('#dg').datagrid('unselectRow', index - 1);
		                $("input[type='checkbox']")[index - 1].checked = false;
		            }
		        })
		    }
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


function toAssignRight(t,c){
	$("#ifrm")[0].src = "${path}/admin/common/commonRole/toAssignRight?id="+c;
	var $win;
	$win = $('#w').window({
	    title: '权限分配操作',
	    width: 620,
	    height: 450,
	    shadow: true,
	    modal: true,
	    iconCls: 'icon-appkey',
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false
	});
	$win.window('open');
}

function doAssignRight(t,c){
   	   $.post("doAssignRight.json",{roleId:c},function(result){
   			$.messager.show({
   				title: '操作提示',
   				msg: result.msg
   			});
 		});  
}

function doClear(t,c){
	   $.post("${path}/doClear",{id:c},function(result){
			$.messager.show({
				title: '操作提示',
				msg: result
			});
		});  
}
</script>
	</body>
</html>
