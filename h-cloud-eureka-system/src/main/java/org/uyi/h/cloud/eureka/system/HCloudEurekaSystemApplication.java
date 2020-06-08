package org.uyi.h.cloud.eureka.system;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.uyi.h.dao.model.constants.CommandConstant;

@EnableEurekaClient
@SpringBootApplication
public class HCloudEurekaSystemApplication {

	public static void main(String[] args) {
		CommandConstant.setArgs(args);
		SpringApplication.run(HCloudEurekaSystemApplication.class, args);
	}

}
