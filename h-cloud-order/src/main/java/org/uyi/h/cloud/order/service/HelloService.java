package org.uyi.h.cloud.order.service;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import javax.annotation.Resource;

/**
 * @author king.wyx@qq.com
 * @date 2018.09.24
 */
@Service
public class HelloService {
    @Autowired
    RestTemplate restTemplate;

    @Resource
    FeignHelloService feignHelloService;

	/**
	 * 熔断和负载均衡各有2种方式调用
	 * @param username
	 * @return
	 */
	@HystrixCommand(fallbackMethod = "fallbackMethodHi")
    public String hi(String username) {
        // 第一种方式调用
       // return restTemplate.getForObject("http://service-system/hi?username=" + username, String.class);
       // 第二种方式调用
        return feignHelloService.hi(username);
    }

    /**
     * 参数要一致
     * @param username
     * @return
     */
    public String fallbackMethodHi(String username) {
        return "Ribbon调用失败!!";
    }

}
