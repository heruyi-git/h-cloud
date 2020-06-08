<%@ page language="java" pageEncoding="UTF-8"%>
<script>!window.jQuery && document.write('<script src="${pageContext.request.contextPath}/static/js/jquery.js"><\/script>');</script>
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
<style type="text/css">
.sucMsg {
	color: #363;
	background-color: #cec;
	border-color: #393;
	text-align: center;
	font-size: 15px;
}

.sucMsg, .errMsg {
	text-align: center;
	border: 2px solid;
	padding: 10px;
	margin: 5px;
}

.errMsg {
	color: #e33;
	background-color: #fcc;
	border-color: #f66;
}

.messages {
	line-height: 50px;
}
</style>

<div class="messages">
	<div class="errMsg">This is a error exception page:${ex}</div>
	<script type="text/javascript">
		$(document).ready(function() {
			$(".sucMsg").css({
				position : "absolute",
				top : "1px",
				left : "120px",
				width : "58%"
			}).fadeOut(5000);
			$(".errMsg").css({
				position : "absolute",
				top : "1px",
				left : "120px",
				width : "58%"
			}).fadeOut(5000);
			//setTimeout(function(){window.history.go(-1);},3000);//  window.location.href='${path}/sms/index?groupId=0';},3000);
		});
	</script>
</div>
