package com.dorm.framework.rabbitmq.consumer;

import com.dorm.framework.config.RabbitMQConfig;
import com.dorm.framework.event.RepairOrderEvent;
import com.dorm.framework.rabbitmq.message.RepairOrderMessage;
import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 维修工单消息消费者
 * 
 * @author dorm
 */
@Component
public class RepairOrderConsumer {

    private static final Logger logger = LoggerFactory.getLogger(RepairOrderConsumer.class);

    @Autowired
    private ApplicationEventPublisher eventPublisher;

    /**
     * 处理维修工单消息
     * 
     * @param repairOrderMessage 维修工单消息
     * @param message           原始消息
     * @param channel           通道
     */
    @RabbitListener(queues = RabbitMQConfig.REPAIR_ORDER_QUEUE)
    public void handleRepairOrderMessage(RepairOrderMessage repairOrderMessage, Message message, Channel channel) {
        long deliveryTag = message.getMessageProperties().getDeliveryTag();
        
        try {
            logger.info("接收到维修工单消息: {}", repairOrderMessage);
            
            // 处理消息逻辑
            processRepairOrderMessage(repairOrderMessage);
            
            // 手动确认消息
            channel.basicAck(deliveryTag, false);
            logger.info("维修工单消息处理成功: {}", repairOrderMessage.getMessageId());
            
        } catch (Exception e) {
            logger.error("维修工单消息处理失败: {}, 错误信息: {}", repairOrderMessage.getMessageId(), e.getMessage(), e);
            
            try {
                // 检查重试次数
                if (repairOrderMessage.isMaxRetryExceeded()) {
                    logger.error("维修工单消息重试次数超限，丢弃消息: {}", repairOrderMessage.getMessageId());
                    // 确认消息，不再重试
                    channel.basicAck(deliveryTag, false);
                } else {
                    // 增加重试次数并拒绝消息，重新入队
                    repairOrderMessage.incrementRetryCount();
                    logger.warn("维修工单消息处理失败，重新入队重试: {}, 当前重试次数: {}", 
                            repairOrderMessage.getMessageId(), repairOrderMessage.getRetryCount());
                    channel.basicNack(deliveryTag, false, true);
                }
            } catch (IOException ioException) {
                logger.error("消息确认失败: {}", ioException.getMessage(), ioException);
            }
        }
    }

    /**
     * 处理维修工单消息的具体业务逻辑
     * 
     * @param message 维修工单消息
     */
    private void processRepairOrderMessage(RepairOrderMessage message) {
        String operationType = message.getOperationType();
        
        switch (operationType) {
            case "CREATE":
                handleCreateOrder(message);
                break;
            case "UPDATE":
                handleUpdateOrder(message);
                break;
            case "ASSIGN":
                handleAssignOrder(message);
                break;
            case "COMPLETE":
                handleCompleteOrder(message);
                break;
            case "CANCEL":
                handleCancelOrder(message);
                break;
            default:
                logger.warn("未知的操作类型: {}", operationType);
        }
    }

    /**
     * 处理创建工单
     */
    private void handleCreateOrder(RepairOrderMessage message) {
        logger.info("处理创建工单: 工单号={}, 申请人={}, 宿舍号={}",
                message.getOrderNo(), message.getApplicantName(), message.getDormNo());

        // 实现创建工单的业务逻辑
        // 1. 发送通知给管理员
        // 2. 记录操作日志
        // 3. 更新统计数据

        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    /**
     * 处理更新工单
     */
    private void handleUpdateOrder(RepairOrderMessage message) {
        logger.info("处理更新工单: 工单号={}, 状态={}", message.getOrderNo(), message.getOrderStatus());

        // 实现更新工单的业务逻辑
        // 1. 发送状态变更通知
        // 2. 记录操作日志
    }

    /**
     * 处理分配工单
     */
    private void handleAssignOrder(RepairOrderMessage message) {
        logger.info("处理分配工单: 工单号={}, 维修人员={}", message.getOrderNo(), message.getRepairerName());

        // TODO: 实现分配工单的业务逻辑
        // 1. 发送通知给维修人员
        // 2. 发送通知给申请人
        // 3. 记录操作日志

        // 4. 发布工单分配事件，更新维修人员接单统计
        eventPublisher.publishEvent(new RepairOrderEvent(this, RepairOrderEvent.EventType.ASSIGNED, message));
    }

    /**
     * 处理完成工单
     */
    private void handleCompleteOrder(RepairOrderMessage message) {
        logger.info("处理完成工单: 工单号={}, 维修人员={}", message.getOrderNo(), message.getRepairerName());

        // TODO: 实现完成工单的业务逻辑
        // 1. 发送完成通知给申请人
        // 2. 更新维修人员工作统计
        // 3. 记录操作日志

        // 4. 发布工单完成事件（根据业务需求决定是否减少计数）
        // 这里设置为false，表示完成的工单仍然计入统计
        eventPublisher.publishEvent(new RepairOrderEvent(this, RepairOrderEvent.EventType.COMPLETED, message, false));
    }

    /**
     * 处理取消工单
     */
    private void handleCancelOrder(RepairOrderMessage message) {
        logger.info("处理取消工单: 工单号={}, 原因={}", message.getOrderNo(), message.getRemark());

        // TODO: 实现取消工单的业务逻辑
        // 1. 发送取消通知
        // 2. 释放维修人员资源
        // 3. 记录操作日志

        // 4. 如果工单已分配给维修人员，发布取消分配事件
        if (message.getRepairerId() != null) {
            eventPublisher.publishEvent(new RepairOrderEvent(this, RepairOrderEvent.EventType.UNASSIGNED, message));
        }
    }
}
