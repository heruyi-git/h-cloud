<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>图标管理</title>
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
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">上传</a>
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
				&nbsp;&nbsp;图标:
				<input name="iconPath" class="easyui-textbox" style="width: 100px"/>
				&nbsp;命名:
				<input name="iconName" class="easyui-textbox" style="width: 100px"/>
				&nbsp;描述:
				<input name="iconDesc" class="easyui-textbox" style="width: 100px"/>
				&nbsp;类型:
				<html:select name="iconType" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:122px;’ panelHeight='auto'">
					<html:options items="${iconType}" selectedValue="${en.iconType}" labelField="dataName" valueField="dataValue"/>
				</html:select>
				&nbsp;尺寸:
				<input name="iconSize" class="easyui-textbox" style="width: 100px"/>
				&nbsp;后缀:
				<input name="iconKey" class="easyui-textbox" style="width: 100px"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:692px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">“文件类型“的图标为单个上传，必须填写图标键对应的”后缀“去自动生成类型，否则无效</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm" enctype='multipart/form-data'>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;图标：</td>
						<td class="text_cloumn2" colspan="3">
							<input type="file" multiple="multiple" accept="image/gif, image/jpeg, image/png" id="iconPath" name="iconPath"  value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入路径,长度为[0-50]"  data-options="required:true,validType:['length[0,50]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;命名：</td>
						<td class="text_cloumn2">
							<input type="text" id="iconName" name="iconName" class="easyui-validatebox textbox" value="icon-" autofocus="autofocus"
							autocomplete="off" placeholder="请输入名称,长度为[0-20]"  data-options="required:true,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">&nbsp;描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="iconDesc" name="iconDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入描述,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;图标键：</td>
						<td class="text_cloumn2">
							<input type="text" id="iconKey" name="iconKey" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="(文件后缀，如:mp4),长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
						<td class="label_cloumn2">&nbsp;类型：</td>
						<td class="text_cloumn2">
							<html:select name="iconType" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:192px;’ panelHeight='auto'">
								<html:options items="${iconType}" labelField="dataName" valueField="dataValue" selectedValue=""/>
							</html:select>
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
		 title: '图标管理',
		 iconCls: 'icon-right',
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
		 sortOrder: 'desc',
		 sortName: 'iconName',
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ],
		 idField:'iconName',
		  columns: [[
			  { field: 'iconPath', title: '图标', width: 216, align: 'left', sortable: true,
				  formatter:function(value,row){
				  	  var pre = "<%=org.uyi.h.web.model.constants.ResourceConstant.icon_file_pre%>";
	                  var btn = '<img title="'+value+'" src="${path}/'+pre+value+'"/>&nbsp;'+value;
	                  return btn;
	              }
			  },
			  { field: 'iconName', title: '命名', width: 156, align: 'left', sortable: true },
			  { field: 'iconDesc', title: '描述', width: 156, align: 'left', sortable: true },
			  { field: 'iconType', title: '类型', width: 96, align: 'left', sortable: true,formatter:convert.getDataName },
			  { field: 'iconSize', title: '尺寸', width: 96, align: 'left', sortable: true },
			  { field: 'iconKey', title: '图标键(文件后缀)', width: 96, align: 'left', sortable: true },
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
		"iconPath":$("#qf").find("input[name='iconPath']").val(),
		"iconName":$("#qf").find("input[name='iconName']").val(),
		"iconDesc":$("#qf").find("input[name='iconDesc']").val(),
		"iconType":$("#qf").find("input[name='iconType']").val(),
		"iconSize":$("#qf").find("input[name='iconSize']").val(),
		"iconKey":$("#qf").find("input[name='iconKey']").val()
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
				strIds += selectRows[i].iconName + ",";
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
	//$('#fm').form('clear');
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

var uploading = false;
function doSave(){
	 //定义表单变量
    var file = document.getElementById('iconPath').files;
    if(file.length<1){
    	$.messager.alert("提示",'请选择文件','warn');
        return;
    }
    //新建一个FormData对象
    var formData = new FormData($('#fm')[0]);
    //追加文件数据
    var fileName = document.getElementById('iconPath').value;
    fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
    for(i=0;i<file.length;i++){
        if(file[i].name==fileName){
            continue;
        }
        formData.append("file["+i+"]", file[i]);
    }
    if(uploading){
		$.messager.alert("提示","文件正在上传中，请稍候...");
        return false;
    }
    $.ajax({
        url: url,
        type: 'POST',
        cache: false,
        data: formData,
        processData: false,
        contentType: false,
        dataType:"json",
        beforeSend: function(){
            uploading = true;
        },
        success : function(data) {
            if (data.status == 0) {
                msg = data.msg;
				if(data.data.length>0){
                	msg += '-('+data.data[0].iconPath+')';
				}
            	$.messager.show({
        			title: '操作提示',
        			msg: msg
        		});
            	$('#dg').datagrid('reload');    // reload the user data
            } else {
            	$.messager.alert("提示",data.msg,'error');
            }
            uploading = false;
            $('#dlg').dialog('close');        // close the dialog
        }
    });
}

$('#iconPath').change(function(){
	// 文件点击事件
	if(this.files.length>1){
		$('#iconName').attr('disabled',true);
		$('#iconDesc').attr('disabled',true);
		$('#iconType').attr('disabled',true);
		$('#iconKey').attr('disabled',true);
	}else{
		$('#iconName').attr('disabled',false);
		$('#iconDesc').attr('disabled',false);
		$('#iconType').attr('disabled',false);
		$('#iconKey').attr('disabled',false);
	}
});

</script>
	</body>
</html>
