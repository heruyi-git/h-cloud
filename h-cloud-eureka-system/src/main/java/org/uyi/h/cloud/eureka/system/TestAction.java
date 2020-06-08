/*
 * generate java source by Hfast
 * Create time in $date Wed May 06 02:26:56 CST 2020
 * Copyright 2020-2026 org.uyi organization.
 */
package org.uyi.h.cloud.eureka.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.uyi.h.common.utils.DateUtils;

@RestController

public class TestAction {


	@Autowired
	ServerProperties serverProperties;
	/**
	 * @ignore
	 */
	@RequestMapping("/test")
	public ModelAndView test()
	{
		return new ModelAndView("test","a",serverProperties.getPort());
	}

	@GetMapping("/hi")
	public String hi(String username)
	{
		return serverProperties.getPort()+":"+ DateUtils.getNow()+ ":"+username;
	}


}
