@echo off
chcp 65001
title 8081系统服务

rem ======================================================================
rem windows startup script
rem
rem %JAVA_HOME%\bin\java.exe -server -Dfile.encoding=UTF-8 -Dloader.path=.,lib -Xmx1024m -Xms512m -jar api.jar --spring.config.location=../conf/
rem rem Open in a browser  start "" "http://localhost:333/login.html"

rem author: uyi
rem date: 2020-03-16
rem ======================================================================

set CLASSPATH=.;

@echo -Dhfast.pool.active=../conf/pool.xml



"%JAVA_HOME%\bin\java.exe" -server -Dfile.encoding=UTF-8 -Dloader.path=.,lib -Xmx512m -Xms512m -jar system.jar --spring.config.location=../conf/

pause;
