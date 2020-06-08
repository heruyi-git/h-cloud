package org.uyi.h.cloud.order.service;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.uyi.h.cloud.order.service.fallback.FeignHelloServiceHystric;

@FeignClient(value = "service-system"/*,fallback = FeignHelloServiceHystric.class*/)
public interface FeignHelloService {
    @RequestMapping(value = "/hi",method = RequestMethod.GET)
    String hi(@RequestParam("username") String username);
}
