<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://common.h.uyi.org/page" prefix="hry"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="controls"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>分配权限</title>
<link rel="stylesheet" type="text/css" href="${path}/static/easyui/themes/default/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${path}/static/easyui/themes/icon.css"/>
<link rel="stylesheet" type="text/css" href="${path}/static/css/add2.css" />
<link rel="stylesheet" href="${path}/static/css/demo.css" type="text/css"/>
<link rel="stylesheet" href="${path}/static/js/zTree/zTreeStyle.css" type="text/css"/>
<script type="text/javascript" src="${path}/static/js/zTree/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${path}/static/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/js/zTree/jquery.ztree.all.min.js"></script>

<script type="text/javascript">
		var setting = {
			check: {
				enable: true
			},
			async: {
				enable: true,
				type: "post",
				url:getUrl,
				autoParam:["id"]
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
			}
		};

		function getUrl(treeId, treeNode) {
			return "${path}/admin/common/commonRole/loadRight.json?roleId=${role.id}";
		}
		
		
		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting);
		});
	</script>
</head>

<body>  
<div class="mainbody">
	  <form id="frm" method="get" action="${path}/admin/common/commonRole/doAssignRight.json">
		<input type="hidden" name="roleId" value="${role.id}"/>
		<input type="hidden" name="roleRightTree" id="roleRightTree"/>
		<div id="conmaina">
			<h1 align="left" style="text-align: left;">当前角色»${role.roleName}</h1>
	  	</div>
   		<ul id="treeDemo" class="ztree"></ul>
   		&nbsp;&nbsp;&nbsp;<input type="button" id="btnAdd" class="btn" value="确 定"/>
	 </form>
</div>


<!-- 验证表单 -->
<script type="text/javascript" src="${path}/static/js/ps2.1.js"></script>
<script type="text/javascript">
			$$_(document).ready(function(){
				$$.validate(function(){
					_('#frm').bind({
					elements:{
						btnAdd : function(flag){
							var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
				            nodes=treeObj.getCheckedNodes(true),
				            v="";
				            for(var i=0;i<nodes.length;i++){
					            v+=","+nodes[i].id;
				            }
				            if(flag==false)
				            if(v.length==0){
				            	alert("至少选择一个节点!");
				            	return;
				            }
				            v = v.substr(1);
				            _('roleRightTree').value = v;
				            if(flag==false){
				            	$.messager.progress();
					            $$.post(_('frm').action,_('#frm').serialize(),function(msg){
					            	$.messager.progress('close'); 
					            	var result = eval('('+msg+')');
					            	$.messager.confirm('操作提示', result.msg,function(r){
						            	if(r){
						            		parent.$('#w').window('close');
						            	}
						            });
	              			   	 });  
				            }
						}
					},messages:{
					}
              });
			});
			});
</script>
</body>
</html>
