package org.uyi.h.cloud.eureka.system.configure;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.uyi.h.web.ProfilesCallBack;

import javax.servlet.ServletContext;

/**
 * @author hry
 */
public class AppLoader {


	private Log log = LogFactory.getLog(AppLoader.class);

	public AppLoader(ServletContext container, ProfilesCallBack<?> callBack){

		log.debug("AppLoader...");

		// 加载系统相关
		callBack.loadCommonData();
		callBack.loadLicense();

		// 加载自定义初始化

	}






}
