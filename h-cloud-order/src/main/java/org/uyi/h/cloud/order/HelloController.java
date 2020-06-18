package org.uyi.h.cloud.order;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.uyi.h.cloud.order.service.HelloService;

@RestController
@RefreshScope
public class HelloController {

    @Autowired
    HelloService helloService;

    @Value("${spring.cloud.config.profile}")
    private String active;

    // http://localhost:8181|8182/hi?username=a1
    @GetMapping("/hi")
    public String hi(String username) {
        return helloService.hi(username+":"+active);
    }

}
