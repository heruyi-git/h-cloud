<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="cn">
	<head>
		<title>chat主页</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


		<link rel="stylesheet" type="text/css" href="${path}/static/js/chat/css/main.css" />

		<script type="text/javascript" src="${path}/static/js/custom/constants.js"></script>
		<script type="text/javascript" src="${path}/static/js/sockjs-1.0.0.min.js"></script>
		<script type="text/javascript" src="${path}/static/js/websocket.util.js"></script>
		<script type="text/javascript">var path = "${path}";</script>

		<script>
			function audioPlay(text){
				var audio = "<audio autoplay=\"autoplay\">" + "<source src=\"http://tts.baidu.com/text2audio?lan=zh&ie=UTF-8&spd=4&text=" + text + "\" type=\"audio/mpeg\">" + "<embed height=\"0\" width=\"0\" src=\"http://tts.baidu.com/text2audio?text=" + text + "\">" + "</audio>";
				$('body').append(audio);
			}
		</script>
	</head>
	<body>
		<div id="chat"></div>
		<script src="${path}/static/js/vue.js"></script>
		<script src="${path}/static/js/chat/main.js"></script>
	</body>
</html>
