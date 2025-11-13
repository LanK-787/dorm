package com.dorm.framework.rabbitmq.producer;

import com.dorm.framework.config.RabbitMQConfig;
import com.dorm.framework.rabbitmq.message.BaseMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.MessageProperties;
import org.springframework.amqp.rabbit.connection.CorrelationData;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * 消息生产者服务
 * 
 * @author 王新瑜
 */
@Service
public class MessageProducer {

    private static final Logger logger = LoggerFactory.getLogger(MessageProducer.class);

    @Autowired
    private RabbitTemplate rabbitTemplate;

    /**
     * 发送维修工单消息
     * 
     * @param message 消息内容
     */
    public void sendRepairOrderMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.REPAIR_ORDER_ROUTING_KEY, message);
    }

    /**
     * 发送用户注册消息
     * 
     * @param message 消息内容
     */
    public void sendUserRegisterMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.USER_REGISTER_ROUTING_KEY, message);
    }

    /**
     * 发送系统日志消息
     * 
     * @param message 消息内容
     */
    public void sendSystemLogMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.SYSTEM_LOG_ROUTING_KEY, message);
    }

    /**
     * 发送通知消息
     *
     * @param message 消息内容
     */
    public void sendNotificationMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.NOTIFICATION_ROUTING_KEY, message);
    }

    /**
     * 发送智能派单消息
     *
     * @param message 消息内容
     */
    public void sendSmartDispatchMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.SMART_DISPATCH_ROUTING_KEY, message);
    }

    /**
     * 发送重新派单消息
     *
     * @param message 消息内容
     */
    public void sendRedispatchMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.REDISPATCH_ROUTING_KEY, message);
    }

    /**
     * 安全发送重新派单消息（不抛异常）
     *
     * @param message 消息内容
     * @return 发送是否成功
     */
    public boolean sendRedispatchMessageSafely(BaseMessage message) {
        return sendMessageSafely(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.REDISPATCH_ROUTING_KEY, message);
    }

    /**
     * 发送派单状态更新消息
     *
     * @param message 消息内容
     */
    public void sendDispatchStatusUpdateMessage(BaseMessage message) {
        sendMessage(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.DISPATCH_STATUS_UPDATE_ROUTING_KEY, message);
    }

    /**
     * 安全发送派单状态更新消息（不抛异常）
     *
     * @param message 消息内容
     * @return 发送是否成功
     */
    public boolean sendDispatchStatusUpdateMessageSafely(BaseMessage message) {
        return sendMessageSafely(RabbitMQConfig.DORM_EXCHANGE, RabbitMQConfig.DISPATCH_STATUS_UPDATE_ROUTING_KEY, message);
    }

    /**
     * 发送消息到指定交换机和路由键
     *
     * @param exchange   交换机
     * @param routingKey 路由键
     * @param message    消息内容
     */
    public void sendMessage(String exchange, String routingKey, BaseMessage message) {
        try {
            // 创建关联数据，用于消息确认
            CorrelationData correlationData = new CorrelationData(UUID.randomUUID().toString());

            logger.info("发送消息到交换机: {}, 路由键: {}, 消息ID: {}, 消息类型: {}",
                    exchange, routingKey, message.getMessageId(), message.getMessageType());

            // 发送消息
            rabbitTemplate.convertAndSend(exchange, routingKey, message, correlationData);

            logger.info("消息发送成功: {}", message.getMessageId());

        } catch (Exception e) {
            logger.error("消息发送失败: {}, 错误信息: {}", message.getMessageId(), e.getMessage(), e);
            throw new RuntimeException("消息发送失败", e);
        }
    }

    /**
     * 安全发送消息到指定交换机和路由键（不抛异常）
     *
     * @param exchange   交换机
     * @param routingKey 路由键
     * @param message    消息内容
     * @return 发送是否成功
     */
    public boolean sendMessageSafely(String exchange, String routingKey, BaseMessage message) {
        try {
            // 创建关联数据，用于消息确认
            CorrelationData correlationData = new CorrelationData(UUID.randomUUID().toString());

            logger.info("安全发送消息到交换机: {}, 路由键: {}, 消息ID: {}, 消息类型: {}",
                    exchange, routingKey, message.getMessageId(), message.getMessageType());

            // 发送消息
            rabbitTemplate.convertAndSend(exchange, routingKey, message, correlationData);

            logger.info("安全消息发送成功: {}", message.getMessageId());
            return true;

        } catch (Exception e) {
            logger.error("安全消息发送失败: {}, 错误信息: {}", message.getMessageId(), e.getMessage(), e);
            return false;
        }
    }

    /**
     * 发送延迟消息
     * 
     * @param exchange   交换机
     * @param routingKey 路由键
     * @param message    消息内容
     * @param delayTime  延迟时间（毫秒）
     */
    public void sendDelayMessage(String exchange, String routingKey, BaseMessage message, long delayTime) {
        try {
            CorrelationData correlationData = new CorrelationData(UUID.randomUUID().toString());
            
            logger.info("发送延迟消息到交换机: {}, 路由键: {}, 消息ID: {}, 延迟时间: {}ms", 
                    exchange, routingKey, message.getMessageId(), delayTime);
            
            // 发送延迟消息
            rabbitTemplate.convertAndSend(exchange, routingKey, message, msg -> {
                MessageProperties properties = msg.getMessageProperties();
                properties.setDelay((int) delayTime);
                return msg;
            }, correlationData);
            
            logger.info("延迟消息发送成功: {}", message.getMessageId());
            
        } catch (Exception e) {
            logger.error("延迟消息发送失败: {}, 错误信息: {}", message.getMessageId(), e.getMessage(), e);
            throw new RuntimeException("延迟消息发送失败", e);
        }
    }

    /**
     * 发送优先级消息
     * 
     * @param exchange   交换机
     * @param routingKey 路由键
     * @param message    消息内容
     * @param priority   优先级（0-255）
     */
    public void sendPriorityMessage(String exchange, String routingKey, BaseMessage message, int priority) {
        try {
            CorrelationData correlationData = new CorrelationData(UUID.randomUUID().toString());
            
            logger.info("发送优先级消息到交换机: {}, 路由键: {}, 消息ID: {}, 优先级: {}", 
                    exchange, routingKey, message.getMessageId(), priority);
            
            // 发送优先级消息
            rabbitTemplate.convertAndSend(exchange, routingKey, message, msg -> {
                MessageProperties properties = msg.getMessageProperties();
                properties.setPriority(priority);
                return msg;
            }, correlationData);
            
            logger.info("优先级消息发送成功: {}", message.getMessageId());
            
        } catch (Exception e) {
            logger.error("优先级消息发送失败: {}, 错误信息: {}", message.getMessageId(), e.getMessage(), e);
            throw new RuntimeException("优先级消息发送失败", e);
        }
    }

    /**
     * 批量发送消息
     * 
     * @param exchange   交换机
     * @param routingKey 路由键
     * @param messages   消息列表
     */
    public void sendBatchMessages(String exchange, String routingKey, BaseMessage... messages) {
        for (BaseMessage message : messages) {
            sendMessage(exchange, routingKey, message);
        }
    }
}
