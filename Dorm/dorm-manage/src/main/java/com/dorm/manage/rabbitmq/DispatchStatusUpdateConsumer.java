package com.dorm.manage.rabbitmq;

import com.dorm.framework.config.RabbitMQConfig;
import com.dorm.framework.rabbitmq.message.DispatchStatusUpdateMessage;
import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 派单状态更新消息消费者
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@Component
public class DispatchStatusUpdateConsumer {

    private static final Logger logger = LoggerFactory.getLogger(DispatchStatusUpdateConsumer.class);

    /**
     * 处理派单状态更新消息
     */
    @RabbitListener(queues = RabbitMQConfig.DISPATCH_STATUS_UPDATE_QUEUE)
    public void handleDispatchStatusUpdate(DispatchStatusUpdateMessage message, Channel channel, Message amqpMessage) {
        try {
            logger.info("收到派单状态更新消息：{}", message);

            // 根据操作类型处理不同的业务逻辑
            switch (message.getOperationType()) {
                case "ACCEPT":
                    handleAcceptOperation(message);
                    break;
                case "REJECT":
                    handleRejectOperation(message);
                    break;
                case "COMPLETE":
                    handleCompleteOperation(message);
                    break;
                default:
                    logger.warn("未知的操作类型：{}", message.getOperationType());
            }

            // 确认消息
            channel.basicAck(amqpMessage.getMessageProperties().getDeliveryTag(), false);

        } catch (Exception e) {
            logger.error("处理派单状态更新消息失败：{}", message, e);
            try {
                // 拒绝消息并重新入队
                channel.basicNack(amqpMessage.getMessageProperties().getDeliveryTag(), false, true);
            } catch (IOException ioException) {
                logger.error("拒绝消息失败", ioException);
            }
        }
    }

    /**
     * 处理接受派单操作
     */
    private void handleAcceptOperation(DispatchStatusUpdateMessage message) {
        logger.info("维修人员[{}]接受了派单[{}]", message.getRepairerName(), message.getRequestNo());
        
        // 这里可以添加额外的业务逻辑，比如：
        // 1. 发送通知给报修人
        // 2. 更新统计数据
        // 3. 记录操作日志
        // 4. 触发其他业务流程
    }

    /**
     * 处理拒绝派单操作
     */
    private void handleRejectOperation(DispatchStatusUpdateMessage message) {
        logger.info("维修人员[{}]拒绝了派单[{}]，原因：{}", 
                   message.getRepairerName(), message.getRequestNo(), message.getRejectReason());
        
        // 这里可以添加额外的业务逻辑，比如：
        // 1. 记录拒绝原因统计
        // 2. 分析拒绝模式
        // 3. 优化派单算法
        // 4. 发送管理员通知
    }

    /**
     * 处理完成维修操作
     */
    private void handleCompleteOperation(DispatchStatusUpdateMessage message) {
        logger.info("维修人员[{}]完成了维修[{}]", message.getRepairerName(), message.getRequestNo());
        
        // 这里可以添加额外的业务逻辑，比如：
        // 1. 发送完成通知给报修人
        // 2. 更新维修统计
        // 3. 质量评估提醒
        // 4. 生成维修报告
        // 5. 更新设备维修历史
    }
}
