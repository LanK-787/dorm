package com.dorm.framework.rabbitmq.consumer;

import com.dorm.framework.config.RabbitMQConfig;
import com.dorm.framework.rabbitmq.message.UserRegisterMessage;
import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 用户注册消息消费者
 * 
 * @author 王新瑜
 */
@Component
public class UserRegisterConsumer {

    private static final Logger logger = LoggerFactory.getLogger(UserRegisterConsumer.class);

    /**
     * 处理用户注册消息
     * 
     * @param userRegisterMessage 用户注册消息
     * @param message            原始消息
     * @param channel            通道
     */
    @RabbitListener(queues = RabbitMQConfig.USER_REGISTER_QUEUE)
    public void handleUserRegisterMessage(UserRegisterMessage userRegisterMessage, Message message, Channel channel) {
        long deliveryTag = message.getMessageProperties().getDeliveryTag();
        
        try {
            logger.info("接收到用户注册消息: {}", userRegisterMessage);
            
            // 处理消息逻辑
            processUserRegisterMessage(userRegisterMessage);
            
            // 手动确认消息
            channel.basicAck(deliveryTag, false);
            logger.info("用户注册消息处理成功: {}", userRegisterMessage.getMessageId());
            
        } catch (Exception e) {
            logger.error("用户注册消息处理失败: {}, 错误信息: {}", userRegisterMessage.getMessageId(), e.getMessage(), e);
            
            try {
                // 检查重试次数
                if (userRegisterMessage.isMaxRetryExceeded()) {
                    logger.error("用户注册消息重试次数超限，丢弃消息: {}", userRegisterMessage.getMessageId());
                    // 确认消息，不再重试
                    channel.basicAck(deliveryTag, false);
                } else {
                    // 增加重试次数并拒绝消息，重新入队
                    userRegisterMessage.incrementRetryCount();
                    logger.warn("用户注册消息处理失败，重新入队重试: {}, 当前重试次数: {}", 
                            userRegisterMessage.getMessageId(), userRegisterMessage.getRetryCount());
                    channel.basicNack(deliveryTag, false, true);
                }
            } catch (IOException ioException) {
                logger.error("消息确认失败: {}", ioException.getMessage(), ioException);
            }
        }
    }

    /**
     * 处理用户注册消息的具体业务逻辑
     * 
     * @param message 用户注册消息
     */
    private void processUserRegisterMessage(UserRegisterMessage message) {
        String operationType = message.getOperationType();
        
        switch (operationType) {
            case "REGISTER":
                handleUserRegister(message);
                break;
            case "UPDATE":
                handleUserUpdate(message);
                break;
            case "DELETE":
                handleUserDelete(message);
                break;
            default:
                logger.warn("未知的操作类型: {}", operationType);
        }
    }

    /**
     * 处理用户注册
     */
    private void handleUserRegister(UserRegisterMessage message) {
        logger.info("处理用户注册: 用户名={}, 用户类型={}, 注册IP={}", 
                message.getUserName(), message.getUserType(), message.getRegisterIp());
        
        // TODO: 实现用户注册的业务逻辑
        // 1. 发送欢迎邮件
        // 2. 初始化用户配置
        // 3. 记录注册日志
        // 4. 更新统计数据
        
        // 根据用户类型进行不同处理
        String userType = message.getUserType();
        switch (userType) {
            case "student":
                handleStudentRegister(message);
                break;
            case "repairer":
                handleRepairerRegister(message);
                break;
            case "admin":
                handleAdminRegister(message);
                break;
            default:
                logger.warn("未知的用户类型: {}", userType);
        }
        
        // 模拟处理时间
        try {
            Thread.sleep(200);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    /**
     * 处理学生注册
     */
    private void handleStudentRegister(UserRegisterMessage message) {
        logger.info("处理学生注册: {}", message.getUserName());
        
        // TODO: 学生注册特殊处理
        // 1. 分配默认宿舍（如果有）
        // 2. 发送学生手册
        // 3. 添加到学生群组
    }

    /**
     * 处理维修人员注册
     */
    private void handleRepairerRegister(UserRegisterMessage message) {
        logger.info("处理维修人员注册: {}", message.getUserName());
        
        // TODO: 维修人员注册特殊处理
        // 1. 分配工作区域
        // 2. 发送工作手册
        // 3. 添加到维修人员群组
    }

    /**
     * 处理管理员注册
     */
    private void handleAdminRegister(UserRegisterMessage message) {
        logger.info("处理管理员注册: {}", message.getUserName());
        
        // TODO: 管理员注册特殊处理
        // 1. 分配管理权限
        // 2. 发送管理手册
        // 3. 添加到管理员群组
    }

    /**
     * 处理用户信息更新
     */
    private void handleUserUpdate(UserRegisterMessage message) {
        logger.info("处理用户信息更新: 用户名={}", message.getUserName());
        
        // TODO: 实现用户信息更新的业务逻辑
        // 1. 同步更新相关系统
        // 2. 发送变更通知
        // 3. 记录操作日志
    }

    /**
     * 处理用户删除
     */
    private void handleUserDelete(UserRegisterMessage message) {
        logger.info("处理用户删除: 用户名={}", message.getUserName());
        
        // TODO: 实现用户删除的业务逻辑
        // 1. 清理用户数据
        // 2. 释放相关资源
        // 3. 发送删除通知
        // 4. 记录操作日志
    }
}
