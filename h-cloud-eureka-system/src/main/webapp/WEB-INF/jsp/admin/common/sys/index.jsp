<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://common.h.uyi.org/html" prefix="html"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta content="text/html; charset=utf-8"/>
		<title>全局配置</title>
		<jsp:include page="/WEB-INF/jsp/include/easyui.jsp"></jsp:include>
		
		<style>
			.mwui-switch-btn{
				width:72px;  
				display:block;
				padding:1px;
				background:#3B75FD;
				overflow:hidden;
				margin-bottom:0px;
				border:1px solid #2E58C1;
				border-radius:16px;
				cursor: pointer;
			}
			.mwui-switch-btn span{
				width:28px;
				font-size:14px;
				height:16px;
				padding:0px 5px 3px 5px;
				display:block; 
				filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#f6f6f6,endColorstr=#eeeeee,grandientType=1);
				background:-webkit-gradient(linear, 0 0, 0 100%, from(#f6f6f6), to(#eeeeee));
				background:-moz-linear-gradient(top, #f6f6f6, #eeeeee);
				border-radius:16px;
				float:left;
				color:#3B75FD;
				text-align:center; 
				background:#fff;
			} 
			.mwui-switch-btn:hover span{
				background:#fff;
			}
			.mwui-switch-btn span.off{float:right;}
		</style>
	</head>

	<body>

		<script type="text/javascript">

			function doSave(){
				$.messager.confirm("确认消息", "确定要保存操作吗？", function (r) {
					if(r){
						util.post('${path}/admin/common/sys/config.json',$('#fm1').serialize());
					}
				});
			}

			$(document).ready(function(){
				util.combobox(
						"#theme",
						["value","label"],
						[{
							label: 'default',
							value: 'default'
						},{
							label: 'black',
							value: 'black'
						},{
							label: 'gray',
							value: 'gray'
						},{
							label: 'metro',
							value: 'metro'
						},{
							label: 'bootstrap',
							value: 'bootstrap'
						}],
						"${cookie.theme.value}"
				);

				$('#theme').combobox({editable:false,onChange: function (n,o) {
					if(!!!o&&!!"${cookie.theme.value}"){
						o = "${cookie.theme.value}";
						$('#theme').combobox('setValue',o);
						return;
					}
					if(!!!o){
						return;
					}
					var href = $("#easyuiTheme").attr("href").replace(o, n);
			        $("#easyuiTheme").attr("href", href);
			        var href2 = $("#easyuiTheme2").attr("href").replace(o, n);
			        $("#easyuiTheme2").attr("href", href2);

			        //$(window.parent.frames[0].document).find('#easyuiTheme').attr('href',href);
				}});
			});


			$(function() {
				var cache = "${cache}";
				$('.mwui-switch-btn').each(function() {
					var btn1 = $(this).find("span");
					var btnHtml;
					btn1.attr("class",cache.toLocaleLowerCase());
					if(cache == 'OFF') {
						btn1.attr("change", '开');
						btnHtml = "关";
					}else{
						btn1.attr("change", '关');
						btnHtml = "开";
					}
					$(this).find("input").val(cache);
					btn1.html(btnHtml);
					$(this).bind("click", function() {
						var btn = $(this).find("span");
						var change = btn.attr("change");
						if(btn.attr("class") == 'off') {
							btn.attr("class",'on');
							$(this).find("input").val("ON");
						} else {
							btn.attr("class",'off');
							$(this).find("input").val("OFF");
						}
						btn.attr("change", btn.html());
						btn.html(change);
						return false;
					});
				});

			});
		</script>
		
		<div id="p" class="easyui-panel" title="系统设置" style="width:100%;height:260px;padding:10px;">
			<form id="fm1" method="post">
				<!-- 表单table start-->
				<table width="100%"  border="0" id="table_add">
					<tr>
						<td class="label_cloumn2">&nbsp;皮肤：</td>
						<td class="text_cloumn2">
							<input id="theme" name="theme"/>
						</td>
						<td class="label_cloumn2">&nbsp;标题：</td>
						<td class="text_cloumn2">
							<input type="text" name="title" class="easyui-validatebox textbox" value="${title}" autofocus="autofocus"
							autocomplete="off" placeholder="请输入平台标题，长度为[2-20]"  data-options="required:true,validType:{length:[2,20]}"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;缓存${cache}：</td>
						<td class="text_cloumn2">
							<button class="mwui-switch-btn"><span change="关">开</span><input type="hidden" name="cache" value="ON" /></button>
						</td>
						<td class="label_cloumn2">&nbsp;菜单类型：</td>
						<td class="text_cloumn2">
							<input type="text" name="menu" class="easyui-validatebox textbox" value="${menu}"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;数据字典：</td>
						<td class="text_cloumn2" colspan="1">
							<html:select name="dataDictionaryParentTag" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:146px;’ panelHeight='auto'">
								<html:options items="{隐藏默认项:0,显示默认项:1}" selectedValue="${dataDictionaryParentTag}" separator="{}"/>
							</html:select>
						</td>
						<td class="label_cloumn2">&nbsp;开启日志：</td>
						<td class="text_cloumn2" colspan="1">
							<html:select name="saveSysLogTag" styleClass="easyui-combobox" otherAttributes="editable='false' missingMessage='请选择' data-options='required:true' style=‘height:23px;width:193px;’ panelHeight='auto'">
								<html:options items="{关闭:0,开启:1}" selectedValue="${saveSysLogTag}" separator="{}"/>
							</html:select>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2">&nbsp;文件路径：</td>
						<td class="text_cloumn2" colspan="3">
							<input type="text" name="fileRoot" class="easyui-validatebox textbox" value="${fileRoot}" style="width: 770px;"/>
						</td>
					</tr>
					<tr>
						<td class="label_cloumn2"></td>
						<td class="label_cloumn2" colspan="3" height="50"><a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="doSave()">保存设置</a></td>
					</tr>
				</table>
				<!-- 表单table end-->
			</form>
		</div>
		
		<div>${sysLog}</div>
		
	    </body>
	    </html>
