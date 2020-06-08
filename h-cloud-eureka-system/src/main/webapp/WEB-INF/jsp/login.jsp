<%@page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>${title}登陆</title>
		<link href="${path}/static/css/login.css" rel="stylesheet"
			type="text/css" />
		<script type="text/javascript">
		if("${curUser}"==""){
			if (top.location !== self.location) {
			    top.location=self.location;
			}
		}
		</script>
	</head>
	<body>

		<div id="logindiv1">
			&nbsp;&nbsp;
		</div>
		<!-- <div id="loginCust"></div> -->
		<div id="loginMain">
			<div id="loginFrame">
				<form action="${path}/login" method="post">
					<div class="loginBox">
						<div class="loginBoxCenter">
							<p style="text-align: center;">
								智能卡管理平台
							</p>
							<p>
								<label for="username">
									用户名:
								</label>
							</p>
							<p>
								<input type="text" id="userName" name="userName"
									class="loginInput" autofocus="autofocus" required="required"
									autocomplete="off" placeholder="请输入用户名"
									value="${cookie.uname.value}" />
							</p>
							<p>
								<label for="password">
									密码：
								</label>
								<a class="forgetLink" href="javascript:alert('请联系系统管理员');">忘记密码?</a>
							</p>
							<p>
								<input type="password" id="userPwd" name="userPwd"
									class="loginInput" required="required" placeholder="请输入密码"
									value="${cookie.pword.value}" />
							</p>
							<span style="padding-left: 77px; color: red;">${result.msg}</span>
						</div>
						<div class="loginBoxButtons">
							<input id="remember" type="checkbox" name="remember" ${cookie.remember.value}/>
							<label for="remember">
								记住登录状态
							</label>
							<input type="submit" name="Submit" value="登 录"
								class="ButtonInput"
								onmouseover="this.className='ButtonInput2'"
								onmousedown="this.className='ButtonInput3'"
								onmouseout="this.className='ButtonInput'" tabindex='3' />
							<!-- <button class="loginBtn">登录</button> -->
							<p style="text-align: right;">
								<strong>杭州斯年网络科技 &copy; 2016</strong>
							</p>
						</div>
					</div>
				</form>

			</div>
		</div>
		<div id="loginTail"></div>
	</body>
</html>
