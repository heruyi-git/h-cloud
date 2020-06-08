package org.uyi.h.cloud.eureka.system;

import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.core.Ordered;
import org.springframework.http.MediaType;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.TransactionManagementConfigurer;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.view.ContentNegotiatingViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.uyi.h.dao.pool.EnvironmentPool;
import org.uyi.h.dao.pool.RoutingTransactionManager;
import org.uyi.h.dao.pool.RoutingTransactionManagerRegister;
import org.uyi.h.web.controller.mvc.viewResolver.*;
import org.uyi.h.web.controller.socket.ChatHandShake;
import org.uyi.h.web.controller.socket.ChatWebSocketHandler;
import org.uyi.h.web.controller.socket.LogHandShake;
import org.uyi.h.web.controller.socket.LogWebSocketHandler;
import org.uyi.h.web.model.constants.ExtensionConstant;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Configuration
@EnableWebMvc
@EnableTransactionManagement
@EnableWebSocket
@ServletComponentScan("org.uyi.h.web.servlet")
@ComponentScan(
		basePackages = { "org.uyi.h.web.controller", "org.uyi.h.dao.base.impl", "org.uyi.h.cloud.eureka.system" },
		excludeFilters = {
			@ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, classes = {DefaultPdfView.class,DefaultExcelView.class})
			//,@ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, classes = {LogWebSocketHandler.class, ChatWebSocketHandler.class})
		})
public class WebConfig implements WebMvcConfigurer, TransactionManagementConfigurer, WebSocketConfigurer {

	public static final String[] basePackages = new String[]{"org.uyi.h.common.vo.result","org.uyi.h.web.model.Page","org.uyi.h.cloud.eureka.system.dal.entity"};


	@Resource
	LogWebSocketHandler logWebSocketHandler;
	@Resource
	ChatWebSocketHandler chatWebSocketHandler;
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		// 日志socket
		LogHandShake logHandShake = new LogHandShake();
		registry.addHandler(logWebSocketHandler , "/ws").addInterceptors(logHandShake);
		registry.addHandler(logWebSocketHandler, "/ws/sockjs").addInterceptors(logHandShake).withSockJS();
		//  chat socket
		ChatHandShake chatHandShake = new ChatHandShake();
		registry.addHandler(chatWebSocketHandler , "/chat").addInterceptors(chatHandShake);
		registry.addHandler(chatWebSocketHandler, "/chat/sockjs").addInterceptors(chatHandShake).withSockJS();
	}

	@Bean
	public EnvironmentPool environmentPool() {
		return new EnvironmentPool();
	}


	@Bean
	public RoutingTransactionManagerRegister routingTransactionManagerRegister() {
		return new RoutingTransactionManagerRegister(environmentPool());
	}

	@Bean
	public PlatformTransactionManager annotationDrivenTransactionManager() {
		RoutingTransactionManager routingTransactionManager = new RoutingTransactionManager();
		routingTransactionManager.setTargetTransactionManagers(routingTransactionManagerRegister().getTargetTransactionManagers());
		return routingTransactionManager;
	}

	@Bean
	public ViewResolver extendViewResolver() {
		ExtensionViewResolver extensionViewResolver = new ExtensionViewResolver();
		HashMap<String, ViewResolver> map = new HashMap<>();
		map.put(ExtensionConstant.SUFFIX_HTML.name,jspViewResolver());
		// map.put(ExtensionConstant.SUFFIX_FTL.name,freeMarkerViewResolver());
		map.put(ExtensionConstant.SUFFIX_JSON.name,jsonViewResolver());
		map.put(ExtensionConstant.SUFFIX_XML.name,jaxb2MarshallingXmlViewResolver());
		extensionViewResolver.setResolvers(map);
		return extensionViewResolver;
	}


	@Bean
	public ViewResolver contentNegotiatingViewResolver(ContentNegotiationManager manager) {
		ContentNegotiatingViewResolver resolver = new ContentNegotiatingViewResolver();
		resolver.setContentNegotiationManager(manager);
		List<ViewResolver> resolvers = new ArrayList<ViewResolver>();
		resolvers.add(jspViewResolver());
		// resolvers.add(freeMarkerViewResolver());
		resolvers.add(jsonViewResolver());
		resolvers.add(jaxb2MarshallingXmlViewResolver());
		resolver.setViewResolvers(resolvers);
		resolver.setOrder(Ordered.LOWEST_PRECEDENCE - 8);
		return resolver;
	}

	@Bean
	public ViewResolver jspViewResolver() {
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		viewResolver.setViewClass(JstlView.class);
		viewResolver.setPrefix("/WEB-INF/jsp/");
		viewResolver.setSuffix(".jsp");
		viewResolver.setOrder(Ordered.LOWEST_PRECEDENCE - 6);
		return viewResolver;
	}

	@Bean
	public ViewResolver jsonViewResolver() {
		JsonViewResolver jsonViewResolver = new JsonViewResolver();
		jsonViewResolver.setOrder(Ordered.LOWEST_PRECEDENCE - 4);
		return jsonViewResolver;
	}

	@Bean
	public HandlerExceptionResolver exceptionViewResolver() {
		return new ExceptionViewResolver();
	}


	@Bean
	public ViewResolver jaxb2MarshallingXmlViewResolver() {
		Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
		marshaller.setPackagesToScan(basePackages);
		try {
			marshaller.afterPropertiesSet();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Jaxb2MarshallingXmlViewResolver(marshaller);
	}

	@Bean
	public MultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
		multipartResolver.setMaxUploadSize(-1);
		multipartResolver.setResolveLazily(true);
		return multipartResolver;
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/favicon.ico").addResourceLocations("classpath:/favicon.ico");
		registry.addResourceHandler("/static/**").addResourceLocations("classpath:/static/");
	}

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**")
				.allowedMethods("GET", "POST", "PUT", "DELETE","HEAD")
				.allowCredentials(false)  // 支持证书
				.maxAge(3600)
				.allowedHeaders("*");
	}

	@Override
	public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
		configurer.ignoreAcceptHeader(false)
				.favorPathExtension(true)
				.favorParameter(true)
				.parameterName("format")
				.defaultContentType(MediaType.APPLICATION_JSON);
	}

	// -------------------------- 选择性引入 ------------------------
	// @Bean
	// public FreeMarkerViewResolver freeMarkerViewResolver() {
	// 	FreeMarkerViewResolver viewResolver = new FreeMarkerViewResolver();
	// 	viewResolver.setCache(false);
	// 	viewResolver.setPrefix("");
	// 	viewResolver.setSuffix(".ftl");
	// 	viewResolver.setOrder(Ordered.LOWEST_PRECEDENCE - 5);
	// 	return viewResolver;
	// }

	@Bean
	public ServletRegistrationBean registerDruidStatViewServlet() {
		ServletRegistrationBean druidStatViewServlet = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");
		druidStatViewServlet.addInitParameter("loginUsername", "admin");
		druidStatViewServlet.addInitParameter("loginPassword", "123456");
		druidStatViewServlet.addInitParameter("allow", "127.0.0.1"); // IP白名单(没有配置或者为空，则允许所有访问)
		druidStatViewServlet.addInitParameter("deny", ""); // IP黑名单 (deny优先于allow)
		return druidStatViewServlet;
	}

	@Bean
	public FilterRegistrationBean registerDruidWebStatFilter() {
		FilterRegistrationBean druidWebStatFilter = new FilterRegistrationBean(new WebStatFilter());
		druidWebStatFilter.addUrlPatterns("/*");
		druidWebStatFilter.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.bmp,*.png,*.css,*.ico,/druid/*");
		druidWebStatFilter.setAsyncSupported(true);
		return druidWebStatFilter;
	}


}
