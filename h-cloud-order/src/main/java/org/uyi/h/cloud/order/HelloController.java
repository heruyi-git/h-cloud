package org.uyi.h.cloud.order;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.uyi.h.cloud.order.service.HelloService;

@RestController
public class HelloController {

    @Autowired
    HelloService helloService;

    @GetMapping("/hi")
    public String hi(String username) {
        return helloService.hi(username);
    }

}
