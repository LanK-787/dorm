package com.dorm.common.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;

/**
 * 邮件配置类
 * 
 * @author 王新瑜
 * @date 2025-09-08
 */
@Configuration
@ConditionalOnProperty(prefix = "spring.mail", name = "host")
public class MailConfig {
    
    // Spring Boot会自动配置JavaMailSender，只需要确保配置正确即可
    // 这个配置类主要用于启用邮件功能的条件检查
}