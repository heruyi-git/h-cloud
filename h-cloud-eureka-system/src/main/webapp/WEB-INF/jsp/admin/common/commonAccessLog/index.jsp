<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@taglib uri="http://common.h.uyi.org/permission" prefix="p"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>日志监控</title>
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
							<p:dom id="1468474353574005">
								<a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="doDel()">删除</a>
							</p:dom>
							<a href="#" class="easyui-linkbutton" iconCls="icon-right" plain="true" onclick="doRealTimeSysLog()">控制台</a>
						</td>
					</tr>
				</table>
			</div>
			<div class="datagrid-toolbar" style="margin-bottom: 3px;"></div>
			<div id="qf">
				&nbsp;&nbsp;查询日期:
				<input name="beginTime" class="easyui-datebox" style="width: 100px"/>
				-
				<input name="endTime" class="easyui-datebox" style="width: 100px"/>
				&nbsp;&nbsp;账号:
				<input name="accountName" class="easyui-textbox" style="width: 100px;"/>
				&nbsp;&nbsp;IP:
				<input name="accessIp" class="easyui-textbox" style="width: 100px;"/>
				&nbsp;&nbsp;地址:
				<input name="pageAddr" class="easyui-textbox" style="width: 100px;"/>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" onclick="doQuery()">查询</a>
			</div>
		</div>
		<!-- tb panel end -->
		

<script type="text/javascript">
	$('#dg').datagrid({
		 url: 'doQuery.json',
		 title: '日志监控',
		 iconCls: 'icon-monitor',
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
		 pageSize: 15,
		 pageList: [15,30,45,60],
		 frozenColumns : [ [ {
			 field : 'ck',
			 checkbox : true
		 } ] ], 
		 idField:'id', 
		  columns: [[ 
			  { field: 'id', title: '编号', width: 86, align: 'left', sortable: true }, 
			  { field: 'accountName', title: '账号', width: 70, align: 'left', sortable: true }, 
			  { field: 'pageAddr', title: '地址', width: 312, align: 'center', sortable: true,hidden:false }, 
			  { field: 'postData', title: 'post数据', width: 200, align: 'center', sortable: true,hidden:false },
			  { field: 'sessionId', title: '模块', width: 112, align: 'center', sortable: true } ,
			  { field: 'userAgent', title: '浏览器', width: 110, align: 'center', sortable: true,
				  formatter: function(value,row,index){
				  		if(row.userAgent){
					  		var str=row.userAgent;
						  	if(str.indexOf('MSIE 11.0')!=-1){
								return "MSIE 11.0";
							}else if(str.indexOf('MSIE 10.0')!=-1){
								return "MSIE 10.0";
							}else if(str.indexOf('MSIE 9.0')!=-1){
								return "MSIE 9.0";
							}else if(str.indexOf('MSIE 6.0')!=-1){
								return "MSIE 6.0";
							}else if(str.indexOf('MSIE 7.0')!=-1){
								return "MSIE 7.0";
							}else if(str.indexOf('MSIE 8.0')!=-1){
								return "MSIE 8.0";
							}else if(str.indexOf('Chrome')!=-1){
								return "Chrome";
							}else if(str.indexOf('Firefox')!=-1){
								return "Firefox";
							}else if(str.indexOf('Safari')!=-1){
								return "Safari";
							}else if(str.indexOf('360se')!=-1){
								return "360se";
							}else if(str.indexOf('Google')!=-1){
								return "Google";
							}else if(str.indexOf('Opera')!=-1){
								return "Opera";
							}else if(str.indexOf('Camino')!=-1){
								return "Camino";
							}else if(str.indexOf('Sogou')!=-1){
								return "Sogou";
							}else if(str.indexOf('MSIE 10.0')!=-1){
								return "MSIE 10.0";
							}else if(str.indexOf('Baiduspider')!=-1){
								return "Baiduspider";
							}else if(str.indexOf('msnbot')!=-1){
								return "msnbot";
							}else if(str.indexOf('Yahoo')!=-1){
								return "Yahoo";
							}else if(str.indexOf('Sosospider')!=-1){
								return "Sosospider";
							}else if(str.indexOf('AhrefsBot')!=-1){
								return "AhrefsBot";
							}else{
								return "其它";
							}     
				  		} 
					}
				}, 
			  { field: 'accessIp', title: '访问IP', width: 116, align: 'center', sortable: true }, 
			  { field: 'addTime', title: '时间', width: 137, align: 'left', sortable: true,formatter:convert.formatDateTime }
			  ]], 
		 toolbar: '#tb',
		 pagination: true
	});
	//设置分页控件 
	var p = $('#dg').datagrid('getPager');  
	$(p).pagination({ 
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
		"accountName":$("#qf").find("input[name='accountName']").val(),
		"accessIp":$("#qf").find("input[name='accessIp']").val(),
		"pageAddr":$("#qf").find("input[name='pageAddr']").val()
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


function doRealTimeSysLog(){
	util.newDialog('#SysLog', 'sysLog', '&nbsp;控制台', 669,477,'icon-monitor',false,true,true,true,true,false,'hidden',function(){
        $.post('${path}/admin/common/commonAccessLog/closeSysLog.json',null,function(msg){
           location.reload();
        	//top.delTab($('#tab_menu').data("currtab"));
        });
	});
}

</script>
	</body>
</html>
