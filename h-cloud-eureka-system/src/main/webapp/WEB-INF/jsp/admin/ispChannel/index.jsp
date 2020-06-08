<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>通道产品管理</title>
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
						<permission:dom id="1588655886924062">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588655886924064">
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
						<permission:dom id="1588655886924063">
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
				<permission:dom id="1588655886924061">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:784px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">通道产品信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;通道名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="channelName" name="channelName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入通道名称,长度为[1-20]"  data-options="required:true,validType:['length[1,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;通道描述：</td>
						<td class="text_cloumn2">
							<input type="text" id="channelDesc" name="channelDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入通道描述,长度为[0-65535]"  data-options="required:false,validType:['length[0,65535]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;通道URI：</td>
						<td class="text_cloumn2">
							<input type="text" id="channelUri" name="channelUri" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入通道URI,长度为[0-50]"  data-options="required:false,validType:['length[0,50]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;运营商：</td>
						<td class="text_cloumn2">
							<input type="text" id="isp" name="isp" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入运营商,长度为[0-5]"  data-options="required:false,validType:['length[0,5]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;适用范围：</td>
						<td class="text_cloumn2">
							<input type="text" id="useAreaId" name="useAreaId" class="easyui-validatebox textbox" value="0" autofocus="autofocus"
							autocomplete="off" placeholder="请输入适用范围,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;通道版本号：</td>
						<td class="text_cloumn2">
							<input type="text" id="channelVersion" name="channelVersion" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入通道版本号,长度为[0-3]"  data-options="required:false,validType:['length[0,3]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;成本价格：</td>
						<td class="text_cloumn2">
							<input type="text" id="costPrice" name="costPrice" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入成本价格,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;报价：</td>
						<td class="text_cloumn2">
							<input type="text" id="quotePrice" name="quotePrice" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入报价,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;单位：</td>
						<td class="text_cloumn2">
							<input type="text" id="unit" name="unit" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入单位,长度为[0-2]"  data-options="required:false,validType:['length[0,2]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;产品状态：</td>
						<td class="text_cloumn2">
							<html:select name="state" styleId="state" styleClass="easyui-combobox" defaultOption="请选择" otherAttributes="data-options='required:false,editable:false' style='width: 193px; height: 23px;' panelHeight='auto'">
								<html:options items="${state}" selectedValue="" labelField="dataName" valueField="dataValue"/>							</html:select>					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;添加时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
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
		 title: '通道产品管理',
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
			  { field: 'channelName', title: '通道名称', width: 106, align: 'left', sortable: true },
			  { field: 'channelDesc', title: '通道描述', width: 320, align: 'center', sortable: true,formatter:convert.appendTooltip },
			  { field: 'channelUri', title: '通道URI', width: 138, align: 'left', sortable: true },
			  { field: 'isp', title: '运营商', width: 76, align: 'left', sortable: true },
			  { field: 'useAreaId', title: '适用范围', width: 86, align: 'left', sortable: true },
			  { field: 'channelVersion', title: '通道版本号', width: 72, align: 'left', sortable: true },
			  { field: 'costPrice', title: '成本价格', width: 86, align: 'left', sortable: true },
			  { field: 'quotePrice', title: '报价', width: 86, align: 'left', sortable: true },
			  { field: 'unit', title: '单位', width: 70, align: 'left', sortable: true },
			  { field: 'state', title: '产品状态', width: 76, align: 'left', sortable: true,formatter:convert.getDataName },
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