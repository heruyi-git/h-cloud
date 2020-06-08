package org.uyi.h.cloud.order.service.fallback;

import org.springframework.stereotype.Component;
import org.uyi.h.cloud.order.service.FeignHelloService;

/**
 * @author king.wyx@qq.com
 * @date 2018.09.24
 */
@Component
public class FeignHelloServiceHystric implements FeignHelloService {
    @Override
    public String hi(String username) {
        return "Feign调用失败";
    }
}
