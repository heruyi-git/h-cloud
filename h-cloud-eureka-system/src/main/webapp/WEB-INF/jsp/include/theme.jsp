<%@ page language="java" pageEncoding="UTF-8"%>
<%!
	String getTheme(HttpServletRequest request,HttpServletResponse response){
		String theme = "default";
		Cookie themeCookie = null;
		Cookie[] cookies = request.getCookies();
		if(cookies!=null){
	        for(Cookie ck : cookies){
	            if(ck.getName().equals("theme")){
	            	themeCookie = ck;
	            	theme = ck.getValue();
	            	break;
	            }
	        }
		}
	    if(themeCookie==null){
	    	themeCookie = new Cookie("theme", theme);
	    	themeCookie.setMaxAge(24*3600);
	    	themeCookie.setPath("/");
	    	response.addCookie(themeCookie);
	    }
		return theme;
	}
%>
<link id="easyuiTheme2" rel="stylesheet" type="text/css" href="${path}/static/css/themes/<%=getTheme(request,response) %>/form.css" />
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="${path}/static/easyui/themes/<%=getTheme(request,response) %>/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${path}/static/easyui/themes/icon.css"/>

