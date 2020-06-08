<%@ page pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>套餐管理</title>
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
						<permission:dom id="1588655886924022">
						<td>
							<a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true"  onclick="toAdd()">新增</a>
						</td>
						<td>
							<div class="datagrid-btn-separator"></div>
						</td>
						</permission:dom>
						<permission:dom id="1588655886924024">
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
						<permission:dom id="1588655886924023">
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
				<permission:dom id="1588655886924021">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doPage()">查询</a>
				</permission:dom>
			</div>
		</div>
		<!-- tb panel end -->

		<!-- dlg dialog start-->
		<div id="dlg" class="easyui-dialog" style="width:784px;height:'auto';padding:10px 20px"
			closed="true" buttons="#dlg-buttons" iconCls="icon-save" collapsible="true" maximizable="true">
			<div class="ftitle">套餐信息</div>
			<form id="fm" method="post" novalidate class="bootstrap-frm">
			<input type="hidden" name="id"/>
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;套餐名称：</td>
						<td class="text_cloumn2">
							<input type="text" id="packageName" name="packageName" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐名称,长度为[1-100]"  data-options="required:true,validType:['length[1,100]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;套餐图片：</td>
						<td class="text_cloumn2">
							<input type="text" id="imgFileId" name="imgFileId" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐图片,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;套餐说明：</td>
						<td class="text_cloumn2">
							<input type="text" id="packageDesc" name="packageDesc" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐说明,长度为[0-200]"  data-options="required:false,validType:['length[0,200]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;套餐资费：</td>
						<td class="text_cloumn2">
							<input type="text" id="totalPrice" name="totalPrice" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐资费,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;市场报价：</td>
						<td class="text_cloumn2">
							<input type="text" id="totalQuotePrice" name="totalQuotePrice" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入市场报价,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;套餐成本：</td>
						<td class="text_cloumn2">
							<input type="text" id="totalCostPrice" name="totalCostPrice" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐成本,长度为[0-10]"  data-options="required:false,validType:['length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;套餐类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="packageType" name="packageType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入套餐类型,长度为[0-5]"  data-options="required:false,validType:['length[0,5]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;是否锁定：</td>
						<td class="text_cloumn2">
							<input type="text" id="lock" name="lock" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入是否锁定,长度为[0-1]"  data-options="required:false,validType:['length[0,1]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;周期类型：</td>
						<td class="text_cloumn2">
							<input type="text" id="termType" name="termType" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入周期类型,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;有效期：</td>
						<td class="text_cloumn2">
							<input type="text" id="validityTerm" name="validityTerm" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入有效期,长度为[0-10]"  data-options="required:false,validType:['isDigit','length[0,10]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;套餐状态：</td>
						<td class="text_cloumn2">
							<html:select name="state" styleId="state" styleClass="easyui-combobox" defaultOption="请选择" otherAttributes="data-options='required:false,editable:false' style='width: 193px; height: 23px;' panelHeight='auto'">
								<html:options items="${state}" selectedValue="" labelField="dataName" valueField="dataValue"/>							</html:select>						<td class="label_cloumn2">*&nbsp;添加者：</td>
						<td class="text_cloumn2">
							<input type="text" id="addBy" name="addBy" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加者,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;添加时间：</td>
						<td class="text_cloumn2">
							<input type="text" id="addTime" name="addTime" class="easyui-datetimebox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入添加时间,长度为[0-20]"  data-options="width:192,required:false,validType:['length[0,20]']"/>
						</td>
						<td class="label_cloumn2">*&nbsp;更新者：</td>
						<td class="text_cloumn2">
							<input type="text" id="updateBy" name="updateBy" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入更新者,长度为[0-20]"  data-options="required:false,validType:['length[0,20]']"/>
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
		 title: '套餐管理',
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
			  { field: 'packageName', title: '套餐名称', width: 172, align: 'left', sortable: true },
			  { field: 'imgFileId', title: '套餐图片', width: 86, align: 'left', sortable: true },
			  { field: 'packageDesc', title: '套餐说明', width: 221, align: 'center', sortable: true,formatter:convert.appendTooltip },
			  { field: 'totalPrice', title: '套餐资费', width: 86, align: 'left', sortable: true },
			  { field: 'totalQuotePrice', title: '市场报价', width: 86, align: 'left', sortable: true },
			  { field: 'totalCostPrice', title: '套餐成本', width: 86, align: 'left', sortable: true },
			  { field: 'packageType', title: '套餐类型', width: 76, align: 'left', sortable: true },
			  { field: 'lock', title: '是否锁定', width: 68, align: 'left', sortable: true },
			  { field: 'termType', title: '周期类型', width: 86, align: 'left', sortable: true },
			  { field: 'validityTerm', title: '有效期', width: 86, align: 'left', sortable: true },
			  { field: 'state', title: '套餐状态', width: 76, align: 'left', sortable: true,formatter:convert.getDataName },
			  { field: 'addBy', title: '添加者', width: 106, align: 'left', sortable: true },
			  { field: 'addTime', title: '添加时间', width: 122, align: 'left', sortable: true },
			  { field: 'updateBy', title: '更新者', width: 106, align: 'left', sortable: true },
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