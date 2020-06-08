<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>数据字典</title>
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
				&nbsp;键:
				<input name="dataKey" class="easyui-textbox" style="width: 100px"/>
				&nbsp;值:
				<input name="dataValue" class="easyui-textbox" style="width: 100px"/>
				&nbsp;&nbsp;名称:
				<input name="dataName" class="easyui-textbox" style="width: 100px"/>
				&nbsp;描述:
				<input name="dataDesc" class="easyui-textbox" style="width: 100px"/>
				&nbsp;图标:
				<input name="dataIcon" class="easyui-textbox" style="width: 100px"/>
				&nbsp;排序:
				<input name="dataSort" class="easyui-textbox" style="width: 100px"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:392px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle"><span id="parentCode_span"></span></div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" id="id" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="dataName" name="dataName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入名称,长度为[0-20]"  data-options="required:true,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;键：</td>
						<td class="text_cloumn2">
							<input type="text" id="dataKey" name="dataKey" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入键,长度为[1-20]"  data-options="required:true,validType:['length[1,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;值：</td>
						<td class="text_cloumn2">
							<input type="text" class="easyui-numberspinner"  style="width:192px;margin-top: 3px;" id="dataValue" name="dataValue" 
							min="0" max="9999" value="1" autofocus="autofocus" autocomplete="off" placeholder="1"  data-options="increment:1,required:false,validType:['isDigit']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;图标：</td>
						<td class="text_cloumn2">
							<!-- 绑定图标库，模糊搜索 -->
							<input type="text" id="dataIcon" name="dataIcon" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入图标,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;排序：</td>
						<td class="text_cloumn2">
							<input type="text" class="easyui-numberspinner"  style="width:192px;margin-top: 3px;" id="dataSort" name="dataSort" 
							min="0" max="100" value="0" autofocus="autofocus" autocomplete="off" placeholder="1"  data-options="increment:1,required:false,validType:['isDigit']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="dataDesc" name="dataDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入描述,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
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
var path = "${path}"; 
	$('#dg').datagrid({
		 url: 'doQuery.json',
		 title: '数据字典管理',
		 iconCls: 'icon-book',
		 loadMsg: '数据加载中,请稍候...',
		 emptyMsg: 'no records found',
		 checkOnSelect: false,
		 selectOnCheck: false,
		 collapsible:true,
		 border: true,
		 nowrap: false,
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
			  { field: 'id', title: 'id', width: 56, align: 'left', sortable: true }, 
			  { field: 'dataName', title: '名称', width: 126, align: 'left', sortable: true }, 
			  { field: 'dataKey', title: '键', width: 96, align: 'left', sortable: true },
			  { field: 'dataValue', title: '值', width: 96, align: 'left', sortable: true},
			  { field: 'dataDesc', title: '描述', width: 216, align: 'left', sortable: true },
			  { field: 'dataIcon', title: '图标', width: 96, align: 'left', sortable: true },
			  { field: 'dataSort', title: '排序(数值大靠前)', width: 96, align: 'left', sortable: true }
			  ]], 
	  	rowStyler:function(index,row){
        	if(row.dataValue==null){
	           return 'font-weight:bold;';
	        }else{
	           return 'color:#6293BB;';
	        }
	    },
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
		"dataName":$("#qf").find("input[name='dataName']").val(),
		"dataDesc":$("#qf").find("input[name='dataDesc']").val(),
		"dataKey":$("#qf").find("input[name='dataKey']").val(),
		"dataValue":$("#qf").find("input[name='dataValue']").val(),
		"dataSort":$("#qf").find("input[name='dataSort']").val(),
		"dataIcon":$("#qf").find("input[name='dataIcon']").val()
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
	var row = $('#dg').datagrid('getSelected');
	$('#id').val('');
	if (row&&row.dataValue==null){
		$('#dataKey').val(row.dataKey);
		$('#parentCode_span').html("新增字典->"+row.dataKey+"-->");
		$('#dataSort').numberspinner('setValue', 0); 
		$.post("doQuery.json",{dataKey:row.dataKey,curPage:1,linkRecordCount:20},function(msg){
			$('#parentCode_span').append("<select id='sel'/>");
			if(!!msg){
				var data = msg.rows;
				var max = 0;
				$.each(data,function(idx,v){
					$("#sel").append("<option value='"+v.id+"'>"+v.dataName+"-"+v.dataValue+"</option>");
					if(max<v.dataValue){
						max = v.dataValue;
					} 
				});
				$('#dataValue').numberspinner('setValue', ++max); 
			}
		});
	}else{
		$('#dataKey').val('');
		$('#parentCode_span').html("新增字典->");
		$('#dataValue').numberspinner('setValue', ''); 
		$('#dataSort').numberspinner('setValue', 9); 
	}
	$('#dlg').dialog('open').dialog('center').dialog('setTitle','新增');
	//$('#fm').form('clear');
	$('#dataName').val("");
 	$('#dataDesc').val("");
 	$('#dataIcon').val("");
	url = 'doAdd.json';
}

function toEdit(){
	$('#parentCode_span').html("编辑字典");
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
</script>
	</body>
</html>
