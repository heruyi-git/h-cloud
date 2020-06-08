<%@ page language="java" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<title>无标题文档</title>
	<link rel="stylesheet" type="text/css" href="${path}/static/js/upload/basic.min.css">
	<link rel="stylesheet" type="text/css" href="${path}/static/js/upload/dropzone.min.css">
	<script src="${path}/static/js/jquery.js"></script>
	<script src="${path}/static/js/upload/dropzone.min.js"></script>
	<style>
		.dropzone {
			border: 2px dashed #0087F7;
			border-radius: 5px;
			background: white;
		}

	</style>
</head>
<body>

<form action="upload.json" class="dropzone needsclick dz-clickable" id="demo-upload">
	<div class="dz-message needsclick">
		Drop files here or click to upload.<br>
		<span class="note needsclick">(This is just a demo dropzone. Selected files are <strong>not</strong> actually uploaded.)</span>
	</div>
	<button id="qr">上传</button>
</form>


<script>
	Dropzone.autoDiscover = false;
	$("#demo-upload").dropzone({
		url: "upload.json",
		maxFiles: 1,
		maxFilesize: 1024,
		acceptedFiles: ".jpg,.jpeg,.doc,.docx,.ppt,.pptx,.txt,.avi,.pdf,.mp3,.zip",
		autoProcessQueue: false,
		paramName: "file1",
		dictDefaultMessage: "拖入需要上传的文件",
		init: function () {
			var myDropzone = this, submitButton = document.querySelector("#qr"),
					cancelButton = document.querySelector("#cancel");
			myDropzone.on('addedfile', function (file) {
				//添加上传文件的过程，可再次弹出弹框，添加上传文件的信息
			});
			myDropzone.on('sending', function (data, xhr, formData) {
				//向后台发送该文件的参数 jQuery('#info').val()
				formData.append('uploadDir', "/com");
			});
			myDropzone.on('success', function (files, response) {
				//文件上传成功之后的操作
			});
			myDropzone.on('error', function (files, response) {
				//文件上传失败后的操作
			});
			myDropzone.on('totaluploadprogress', function (progress, byte, bytes) {
				//progress为进度百分比
				$("#pro").text("上传进度：" + parseInt(progress) + "%");
				//计算上传速度和剩余时间
				var mm = 0;
				var byte = 0;
				var tt = setInterval(function () {
					mm++;
					var byte2 = bytes;
					var remain;
					var speed;
					var byteKb = byte/1024;
					var bytesKb = bytes/1024;
					var byteMb = byte/1024/1024;
					var bytesMb = bytes/1024/1024;
					if(byteKb <= 1024){
						speed = (parseFloat(byte2 - byte)/(1024)/mm).toFixed(2) + " KB/s";
						remain = (byteKb - bytesKb)/parseFloat(speed);
					}else{
						speed = (parseFloat(byte2 - byte)/(1024*1024)/mm).toFixed(2) + " MB/s";
						remain = (byteMb - bytesMb)/parseFloat(speed);
					}
					$("#dropz #speed").text("上传速率：" + speed);
					$("#dropz #time").text("剩余时间"+arrive_timer_format(parseInt(remain)));
					if(bytes >= byte){
						clearInterval(tt);
						if(byteKb <= 1024){
							$("#dropz #speed").text("上传速率：0 KB/s");
						}else{
							$("#dropz #speed").text("上传速率：0 MB/s");
						}
						$("#dropz #time").text("剩余时间：0:00:00");
					}
				},1000);
			});
			submitButton.addEventListener('click', function () {
				//点击上传文件
				myDropzone.processQueue();
			});
			cancelButton.addEventListener('click', function () {
				//取消上传
				myDropzone.removeAllFiles();
			});
		}
	});
	//剩余时间格式转换：
	function arrive_timer_format(s) {
		var t;
		if(s > -1){
			var hour = Math.floor(s/3600);
			var min = Math.floor(s/60) % 60;
			var sec = s % 60;
			var day = parseInt(hour / 24);
			if (day > 0) {
				hour = hour - 24 * day;
				t = day + "day " + hour + ":";
			}
			else t = hour + ":";
			if(min < 10){t += "0";}
			t += min + ":";
			if(sec < 10){t += "0";}
			t += sec;
		}
		return t;
	}


</script>
</body>
</html>
