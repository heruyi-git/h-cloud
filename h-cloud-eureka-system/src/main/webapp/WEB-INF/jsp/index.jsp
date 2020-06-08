<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib uri="http://common.h.uyi.org/tree" prefix="tree"%>
<%@ taglib uri="http://common.h.uyi.org/fmt" prefix="fmt"%>
<%@ taglib uri="http://common.h.uyi.org/permission" prefix="permission"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>${title} - 首页</title>
<jsp:include page="/WEB-INF/jsp/include/theme.jsp"></jsp:include>

<script language="javascript" type="text/javascript" src="${path}/static/easyui/jquery-1.8.0.min.js"></script>
<script language="javascript" type="text/javascript" src="${path}/static/easyui/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="${path}/static/easyui/locale/easyui-lang-zh_CN.js"></script>
<script language="javascript" type="text/javascript" src="${path}/static/js/main.js"></script>
<script language="javascript" type="text/javascript" src="${path}/static/js/validate.js"></script>

<link rel="stylesheet" href="${path}/static/css/main.css" type="text/css"></link>
<link rel="stylesheet" href="${path}/static/css/frame.css" type="text/css"></link>
<link rel="stylesheet" type="text/css" href="${path}/static/css/form2.css" />
<link href="${path}/static/css/treemenu.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${path}/static/js/treemenu.js"></script>
	
<style type="text/css">
.selected11{background:"#fafafa"}
</style>
<script type="text/javascript">
try {
    document.execCommand('BackgroundImageCache', false, true);
} catch (e) {}
 
$(document).ready(function() {
	bindTabEvent();
	bindTabMenuEvent();
	// 主菜单
	$('#nav>li.nav-item').mouseover(function() {
		var o = $(this).offset();
		$(this).addClass('actived');
		$(this).find('>ul.nav-menu').css('left', o.left - 2 + 'px');
	}).mouseout(function() {
		$(this).removeClass('actived');
	});
	
	$('#top-link').click(function() {
		var top, element, step;
		element = document.documentElement.scrollTop? 
			'documentElement':
			'body';
		top = document[element].scrollTop;
		step = Math.ceil(top / 20);
		function toTop() {
			top -= step;
			if(top > -step) {
				document[element].scrollTop = top;
				setTimeout(toTop, 10);
			}
		}
		toTop();
	});

     $('.easyui-accordion li a').click(function () {
         $(this).addClass('selected');
         $('.easyui-accordion li a').not($(this)).removeClass('selected');
         var name = $(this).text();
         var url = $(this).attr("lang"); //href
         addTab($(this).attr("id"),name, url, $(this).attr("name"));
     }).hover(function () {
         //$(this).parent().addClass("hover");
     }, function () {
        // $(this).parent().removeClass("hover");
     });
});
</script>
<script type="text/javascript">
	function switchpanel(tit){
		$('#mainpp').accordion('select', tit);
	}
	function initpanel(){
		//close all tabs
		$('.tabs-inner span').each(function(i, n) {
	   if ($(this).parent().next().is('.tabs-close')) {
	    	var t = $(n).text();
	    	$('#centerTab').tabs('close', t);
	   }
	  });
	  switchpanel('个人工作台');
	}

	$(document).ready(function(){
		$('#a_logout').click(function() {
	        $.messager.confirm('系统提示', '您确定要退出本次登录吗?', function(r) {
	            if (r) {
	                location.href = '${path}/logout';
	            }
	        });
    	});
	});
</script>
</head>
<body class="easyui-layout" style="display: none;">
	<div id="topframe" data-options="region:'north',border:false" style="overflow:hidden;">
		<div id="head">
        <div id="head-main">
          <!-- --><div id="logo">&nbsp;</div> 
          <div class="site_link"> 
             <a href="#" class="font12red">${curUser.accountName}</a>，欢迎登录！&nbsp;|&nbsp; <a href="javascript:void(0);" onClick="$('#dlg').dialog('open');">修改密码</a>&nbsp;|&nbsp;          </div>
          <div id="login-status"> <a id="a_logout" href="javascript:void(0)"><img src="${path}/static/images/main-logout.gif" width="60" height="21" border="0" align="absmiddle"></a> </div>
        </div>
        <div id="head-nav">
          <ul id="nav">
            <li class="nav-sp-first"></li>
            <li class="nav-item"><a href="javascript:void(0)" onClick="javascript:initpanel()" class="current" title="首页"><span id="nav-home"> </span></a></li>
            <li class="nav-sp"></li>
            <li class="nav-item"><a href="javascript:void(0)" onClick="javascript:switchpanel('系统管理')"><span>系统管理</span></a></li>
            <li class="nav-sp"></li>
            <li class="nav-item"><a href="javascript:void(0)" onClick="javascript:switchpanel('权限管理')"><span>权限管理</span></a></li>
            <li class="nav-sp"></li>
            <li class="nav-item"><a href="javascript:void(0)" onClick="javascript:switchpanel('开发者DEMO')"><span>开发者DEMO</span></a></li>
            <li class="nav-sp"></li>
          </ul>
        </div>
		</div>
	</div>
	<!-- 正左边panel -->
	<div id="leftframe" data-options="region:'west',iconCls:'icon-search'" title="导航菜单" style="width:210px;">
		<div id="mainpp" class="easyui-accordion" data-options="fit:true,border:false,animate:false" style="width:210px;" >
			<c:forEach items="${menu}" var="m">
				<div title="${m.name}" style="overflow:auto;padding-left:6px;" data-options="iconCls:'${m.icon}'">
					<div>
						<tree:treemenu2 id="${m.value}" items="${m.childs}" styleClass="treemenu" showLinks="true" linkMethod="addTab"/>
						<script type="text/javascript">
							bindTreeMenu("${m.value}");
						</script>
					</div>
				</div>		
			</c:forEach>
		</div>
	</div>
	<div id="mainframe" data-options="region:'center'" style="overflow:hidden;">
		<div class="easyui-tabs" id="centerTab" data-options="fit:true,border:false">
		  <div title="欢迎您" style="padding:4px;">
			  <table width="99%" border="0" cellspacing="6" cellpadding="0">
              <tr>
                    <td width="50%" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="etb">
                      <tr>
                        <td colspan="2" class="topt">登录信息</td>
                      </tr>
                      <tr>
                        <th width="23%" nowrap>标题</th>
                        <th width="77%" nowrap>内容</th>
                      </tr>
                      <tr>
                        <td>用户信息</td>
                        <td>${roleName}&nbsp;${curUser.realName}</td>
                      </tr>
                      <tr>
                        <td>性别</td>
                        <td>男</td>
                      </tr>
                      <tr>
                        <td>注册时间</td>
                        <td><fmt:parseDate value="${curUser.addTime}" type="yyyy-MM-dd HH:mm:ss"></fmt:parseDate> </td>
                      </tr>
                      <tr>
                        <td>上次登录时间</td>
                        <td>${lastLoginTime}</td>
                      </tr>
                      <tr>
                        <td>联系方式</td>
                        <td>13911229921</td>
                      </tr>
                    </table></td>
                    <!-- 
                    <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="etb">
                      <tr>
                        <td colspan="2" class="topt">昨日新增</td>
                      </tr>
                      <tr>
                        <th width="23%" nowrap>标题</th>
                        <th width="77%" nowrap>数量</th>
                      </tr>
                      <tr>
                        <td>用户</td>
                        <td>100&nbsp;(人)</td>
                      </tr>
                      <tr>
                        <td>上行短信</td>
                        <td>10&nbsp;(条)</td>
                      </tr>
                      <tr>
                        <td>下行短信</td>
                        <td>120&nbsp;(条)</td>
                      </tr>
                      <tr>
                        <td>未审核</td>
                        <td>30&nbsp;(个)</td>
                      </tr>
                      <tr>
                        <td>通道数</td>
                        <td>40&nbsp;(个)</td>
                      </tr>
                    </table></td>
                     -->
                  </tr>
              </table>
		  </div>
		</div>
		<div id="tab_menu" class="easyui-menu" style="width:150px;">
			<div id="tab_menu-refresh">刷新</div>  
			<div class="menu-sep"></div>   
        	<div id="tab_menu-tabclose">关闭</div>  
     		<div id="tab_menu-tabcloseall">关闭全部</div>  
       		<div id="tab_menu-tabcloseother">关闭其他</div>  
   		</div>
	</div>
	<!-- 
	<div data-options="region:'east',split:true,collapsed:true,title:'East'" style="width:100px;padding:10px;">east region</div>
	 -->
	<permission:dom id="1583079999254002">
		<div data-options="region:'east',split:true,title:'消息管理',collapsible:true,collapsed:true" style="width:800px;">
			<jsp:include page="admin/common/chat/index.jsp"></jsp:include>
		</div>
	</permission:dom>

	 <div id="dlg" class="easyui-dialog" closed="true" title="修改密码" data-options="iconCls:'icon-save'" style="width:420px;height:215px;padding:10px;">
        <form action="${path}/common/doEditPwd.json" id="fm" method="post" novalidate class="bootstrap-frm">
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">*&nbsp;旧密码：</td>
						<td class="text_cloumn2">
							<input type="text" id="oldUserpwd" name="oldUserpwd" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入密码,长度为[3-20]"  data-options="required:true,validType:['length[3,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;新密码：</td>
						<td class="text_cloumn2">
							<input type="text" id="password" name="password" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入密码,长度为[3-20]"  data-options="required:true,validType:['length[3,20]']"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">*&nbsp;确认密码：</td>
						<td class="text_cloumn2">
							<input type="text" id="password2" name="password2" class="easyui-validatebox textbox" value="" autofocus="autofocus"
							autocomplete="off" placeholder="请输入密码,长度为[3-20]"  data-options="required:true,validType:['equalTo[\'#password\']']" invalidMessage="两次输入密码不匹配"/>
						</td>
					</tr>
				</table>
				<!-- 表单table end-->
			</form>
			<div style="padding: 10px 10px 10px 110px;">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-accept" onclick="doSave()">修改</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-no" onclick="javascript:$('#dlg').dialog('close')">取消</a>
			</div>
    </div>
    
    <script type="text/javascript">
	    function doSave(){
	    	$('#fm').form('submit',{
	    		url: $('#fm').action,
	    		onSubmit: function(){
	    			return $(this).form('validate');
	    		},
	    		success: function(msg){
	    			var result = eval('('+msg+')');
	    			if (result.msg){
	    				$.messager.show({
	    					title: '操作提示',
	    					msg: result.msg
	    				});
	    			} else {
	    				$.messager.show({
	    					title: '操作提示',
	    					msg: '操作失败'
	    				});
	    			}
	    			$('#fm').form('clear');
	    			$('#dlg').dialog('close');        // close the dialog
	    		}
	    	});
	    }

	    $('body').show();

	    
    </script>


</body>

</html>
