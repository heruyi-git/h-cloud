对应模块
h-cloud-config-server

如下配置绑定远程git服务器，参见该模块的application.yml配置（uri直接引用该h-cloud-config-repo下的目录，git下还有一些常用参数配置如：basedir、search-paths）
spring:
  application:
    name: config-server
  cloud:
    config:
      label: master
      server:
        git:
          uri: https://gitee.com/abletele/config-repo  # 远程git仓库的地址
          username: heruyipapa@163.com  # 以及相应的账户名,公开库可不填写
          password: heruyi.git123  # 和密码


客户端引用时取name：config-server
参见模块h-cloud-eureka-system的bootstrap.yml配置
spring:
  cloud:
    config:
      name: system
      label: master
      profile: prod
      discovery:
        enabled: true
        service-id: config-server
