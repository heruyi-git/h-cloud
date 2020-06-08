<%@ page language="java" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/jsp/include/theme.jsp"></jsp:include>

<link rel="stylesheet" type="text/css" href="${path}/static/css/add2.css" />

<script type="text/javascript" src="${path}/static/easyui/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${path}/static/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/static/easyui/locale/easyui-lang-zh_CN.js"></script> 
	
<script type="text/javascript" src="${path}/static/js/validate.js"></script>
<script type="text/javascript" src="${path}/static/js/convert.js"></script>
<script type="text/javascript" src="${path}/static/js/easyui.util.js"></script>
<script type="text/javascript">
(function(){
	var loading = "<div id='loading' style='position:absolute;left:0;width:100%;height:"+(window.screen.height-230)+"px;top:0;background:#E0ECCC;opacity:0.8;filter:alpha(opacity=80);'></div>";  
	window.onload = function(){   
	   var mark = document.getElementById('loading');   
	   mark.parentNode.removeChild(mark);   
	}   
	document.write(loading); 
})();
</script>