package com.dorm.framework.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.rabbit.listener.RabbitListenerContainerFactory;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RabbitMQ配置类
 * 
 * @author 王新瑜
 */
@Configuration
public class RabbitMQConfig {

    // ==================== 交换机定义 ====================
    
    /**
     * 宿舍管理系统主交换机
     */
    public static final String DORM_EXCHANGE = "dorm.exchange";
    
    /**
     * 死信交换机
     */
    public static final String DORM_DLX_EXCHANGE = "dorm.dlx.exchange";

    // ==================== 队列定义 ====================
    
    /**
     * 维修工单队列
     */
    public static final String REPAIR_ORDER_QUEUE = "dorm.repair.order.queue";
    
    /**
     * 用户注册队列
     */
    public static final String USER_REGISTER_QUEUE = "dorm.user.register.queue";
    
    /**
     * 系统日志队列
     */
    public static final String SYSTEM_LOG_QUEUE = "dorm.system.log.queue";
    
    /**
     * 通知消息队列
     */
    public static final String NOTIFICATION_QUEUE = "dorm.notification.queue";

    /**
     * 智能派单队列
     */
    public static final String SMART_DISPATCH_QUEUE = "dorm.smart.dispatch.queue";

    /**
     * 重新派单队列
     */
    public static final String REDISPATCH_QUEUE = "dorm.redispatch.queue";

    /**
     * 派单状态更新队列
     */
    public static final String DISPATCH_STATUS_UPDATE_QUEUE = "dorm.dispatch.status.update.queue";

    // ==================== 路由键定义 ====================
    
    /**
     * 维修工单路由键
     */
    public static final String REPAIR_ORDER_ROUTING_KEY = "dorm.repair.order";
    
    /**
     * 用户注册路由键
     */
    public static final String USER_REGISTER_ROUTING_KEY = "dorm.user.register";
    
    /**
     * 系统日志路由键
     */
    public static final String SYSTEM_LOG_ROUTING_KEY = "dorm.system.log";
    
    /**
     * 通知消息路由键
     */
    public static final String NOTIFICATION_ROUTING_KEY = "dorm.notification";

    /**
     * 智能派单路由键
     */
    public static final String SMART_DISPATCH_ROUTING_KEY = "dorm.smart.dispatch";

    /**
     * 重新派单路由键
     */
    public static final String REDISPATCH_ROUTING_KEY = "dorm.redispatch";

    /**
     * 派单状态更新路由键
     */
    public static final String DISPATCH_STATUS_UPDATE_ROUTING_KEY = "dorm.dispatch.status.update";

    // ==================== 交换机Bean ====================
    
    /**
     * 创建主交换机
     */
    @Bean
    public TopicExchange dormExchange() {
        return ExchangeBuilder
                .topicExchange(DORM_EXCHANGE)
                .durable(true)
                .build();
    }
    
    /**
     * 创建死信交换机
     */
    @Bean
    public TopicExchange dormDlxExchange() {
        return ExchangeBuilder
                .topicExchange(DORM_DLX_EXCHANGE)
                .durable(true)
                .build();
    }

    // ==================== 队列Bean ====================
    
    /**
     * 维修工单队列
     */
    @Bean
    public Queue repairOrderQueue() {
        return QueueBuilder
                .durable(REPAIR_ORDER_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + REPAIR_ORDER_ROUTING_KEY)
                .withArgument("x-message-ttl", 1800000) // 30分钟TTL
                .build();
    }
    
    /**
     * 用户注册队列
     */
    @Bean
    public Queue userRegisterQueue() {
        return QueueBuilder
                .durable(USER_REGISTER_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + USER_REGISTER_ROUTING_KEY)
                .build();
    }
    
    /**
     * 系统日志队列
     */
    @Bean
    public Queue systemLogQueue() {
        return QueueBuilder
                .durable(SYSTEM_LOG_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + SYSTEM_LOG_ROUTING_KEY)
                .build();
    }
    
    /**
     * 通知消息队列
     */
    @Bean
    public Queue notificationQueue() {
        return QueueBuilder
                .durable(NOTIFICATION_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + NOTIFICATION_ROUTING_KEY)
                .build();
    }

    /**
     * 智能派单队列
     */
    @Bean
    public Queue smartDispatchQueue() {
        return QueueBuilder
                .durable(SMART_DISPATCH_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + SMART_DISPATCH_ROUTING_KEY)
                .withArgument("x-message-ttl", 600000) // 10分钟TTL
                .build();
    }

    /**
     * 重新派单队列（延时队列）
     */
    @Bean
    public Queue redispatchQueue() {
        return QueueBuilder
                .durable(REDISPATCH_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + REDISPATCH_ROUTING_KEY)
                .withArgument("x-message-ttl", 300000) // 5分钟延时
                .build();
    }

    /**
     * 派单状态更新队列
     */
    @Bean
    public Queue dispatchStatusUpdateQueue() {
        return QueueBuilder
                .durable(DISPATCH_STATUS_UPDATE_QUEUE)
                .withArgument("x-dead-letter-exchange", DORM_DLX_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "dlx." + DISPATCH_STATUS_UPDATE_ROUTING_KEY)
                .build();
    }

    // ==================== 绑定关系 ====================
    
    /**
     * 绑定维修工单队列到交换机
     */
    @Bean
    public Binding repairOrderBinding() {
        return BindingBuilder
                .bind(repairOrderQueue())
                .to(dormExchange())
                .with(REPAIR_ORDER_ROUTING_KEY);
    }
    
    /**
     * 绑定用户注册队列到交换机
     */
    @Bean
    public Binding userRegisterBinding() {
        return BindingBuilder
                .bind(userRegisterQueue())
                .to(dormExchange())
                .with(USER_REGISTER_ROUTING_KEY);
    }
    
    /**
     * 绑定系统日志队列到交换机
     */
    @Bean
    public Binding systemLogBinding() {
        return BindingBuilder
                .bind(systemLogQueue())
                .to(dormExchange())
                .with(SYSTEM_LOG_ROUTING_KEY);
    }
    
    /**
     * 绑定通知消息队列到交换机
     */
    @Bean
    public Binding notificationBinding() {
        return BindingBuilder
                .bind(notificationQueue())
                .to(dormExchange())
                .with(NOTIFICATION_ROUTING_KEY);
    }

    /**
     * 绑定智能派单队列到交换机
     */
    @Bean
    public Binding smartDispatchBinding() {
        return BindingBuilder
                .bind(smartDispatchQueue())
                .to(dormExchange())
                .with(SMART_DISPATCH_ROUTING_KEY);
    }

    /**
     * 绑定重新派单队列到交换机
     */
    @Bean
    public Binding redispatchBinding() {
        return BindingBuilder
                .bind(redispatchQueue())
                .to(dormExchange())
                .with(REDISPATCH_ROUTING_KEY);
    }

    /**
     * 绑定派单状态更新队列到交换机
     */
    @Bean
    public Binding dispatchStatusUpdateBinding() {
        return BindingBuilder
                .bind(dispatchStatusUpdateQueue())
                .to(dormExchange())
                .with(DISPATCH_STATUS_UPDATE_ROUTING_KEY);
    }

    // ==================== 消息转换器 ====================
    
    /**
     * JSON消息转换器
     */
    @Bean
    public MessageConverter messageConverter() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        // 如果你想让 LocalDateTime 序列化成字符串（如 2025-11-11T01:01:00），而不是时间戳建议加下面一行：
        // objectMapper.disable(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return new Jackson2JsonMessageConverter(objectMapper);
    }
    
    /**
     * RabbitTemplate配置
     */
    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(messageConverter());
        
        // 开启发送确认
        rabbitTemplate.setConfirmCallback((correlationData, ack, cause) -> {
            if (ack) {
                System.out.println("消息发送成功: " + correlationData);
            } else {
                System.err.println("消息发送失败: " + cause);
            }
        });
        
        // 开启返回确认
        rabbitTemplate.setReturnsCallback(returned -> {
            System.err.println("消息未路由到队列: " + returned.getMessage());
        });
        
        return rabbitTemplate;
    }
    
    /**
     * 监听器容器工厂配置
     */
    @Bean
    public RabbitListenerContainerFactory<?> rabbitListenerContainerFactory(ConnectionFactory connectionFactory) {
        SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        factory.setMessageConverter(messageConverter());
        
        // 设置并发消费者数量
        factory.setConcurrentConsumers(3);
        factory.setMaxConcurrentConsumers(10);
        
        // 设置手动确认模式
        factory.setAcknowledgeMode(AcknowledgeMode.MANUAL);
        
        // 设置预取数量
        factory.setPrefetchCount(1);
        
        return factory;
    }
}
