package org.uyi.h.cloud.order;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.hystrix.EnableHystrix;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

@EnableHystrix
@EnableEurekaClient
@EnableFeignClients
@SpringBootApplication
public class HCloudOrderApplication {

	public static void main(String[] args) {
		SpringApplication.run(HCloudOrderApplication.class, args);
	}

	/**
	 * 通过@EnableDiscoveryClient向服务中心注册；并且向程序的ioc注入一个bean: restTemplate;
	 * 并通过@LoadBalanced注解表明这个restRemplate开启负载均衡的功能。
	 *
	 * @return
	 */
	@Bean
	@LoadBalanced
	RestTemplate restTemplate() {
		return new RestTemplate();
	}
}
