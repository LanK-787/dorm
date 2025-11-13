package com.dorm.manage.rabbitmq;

import com.dorm.framework.config.RabbitMQConfig;
import com.dorm.framework.rabbitmq.message.SmartDispatchMessage;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.ISmartDispatchService;
import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 智能派单消息消费者
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@Component
public class SmartDispatchConsumer {

    private static final Logger logger = LoggerFactory.getLogger(SmartDispatchConsumer.class);

    @Autowired
    private ISmartDispatchService smartDispatchService;

    @Autowired
    private IDormRepairRequestService repairRequestService;

    /**
     * 处理智能派单消息
     */
    @RabbitListener(queues = RabbitMQConfig.SMART_DISPATCH_QUEUE)
    public void handleSmartDispatch(SmartDispatchMessage message, Channel channel, Message amqpMessage) {
        try {
            logger.info("收到智能派单消息：{}", message);

            // 获取工单信息
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(message.getRequestId());
            if (repairRequest == null) {
                logger.warn("工单不存在：{}", message.getRequestId());
                channel.basicAck(amqpMessage.getMessageProperties().getDeliveryTag(), false);
                return;
            }

            // 检查工单状态（待派单或等待人工派单）
            if (!"0".equals(repairRequest.getStatus()) && !"5".equals(repairRequest.getStatus())) {
                logger.info("工单状态不允许派单，跳过处理：工单[{}]，状态[{}]",
                           repairRequest.getRequestNo(), repairRequest.getStatus());
                channel.basicAck(amqpMessage.getMessageProperties().getDeliveryTag(), false);
                return;
            }

            ISmartDispatchService.SmartDispatchResult result;
            
            // 根据派单类型执行不同的派单逻辑
            if ("RETRY".equals(message.getDispatchType())) {
                // 重新派单
                result = smartDispatchService.redispatch(message.getRequestId(), message.getExcludeRepairerIds());
            } else {
                // 自动派单
                result = smartDispatchService.smartDispatch(repairRequest);
            }

            if (result.isSuccess()) {
                logger.info("智能派单成功：工单[{}]派给维修人员[{}]", 
                           message.getRequestNo(), result.getSelectedRepairer().getName());
            } else {
                logger.warn("智能派单失败：工单[{}]，原因：{}", 
                           message.getRequestNo(), result.getFailureReason());
            }

            // 确认消息
            channel.basicAck(amqpMessage.getMessageProperties().getDeliveryTag(), false);

        } catch (Exception e) {
            logger.error("处理智能派单消息失败：{}", message, e);
            try {
                // 拒绝消息并重新入队
                channel.basicNack(amqpMessage.getMessageProperties().getDeliveryTag(), false, true);
            } catch (IOException ioException) {
                logger.error("拒绝消息失败", ioException);
            }
        }
    }

    /**
     * 处理重新派单消息
     */
    @RabbitListener(queues = RabbitMQConfig.REDISPATCH_QUEUE)
    public void handleRedispatch(SmartDispatchMessage message, Channel channel, Message amqpMessage) {
        try {
            logger.info("收到重新派单消息：{}", message);

            // 执行重新派单
            ISmartDispatchService.SmartDispatchResult result = 
                smartDispatchService.redispatch(message.getRequestId(), message.getExcludeRepairerIds());

            if (result.isSuccess()) {
                logger.info("重新派单成功：工单[{}]派给维修人员[{}]", 
                           message.getRequestNo(), result.getSelectedRepairer().getName());
            } else {
                logger.warn("重新派单失败：工单[{}]，原因：{}", 
                           message.getRequestNo(), result.getFailureReason());
            }

            // 确认消息
            channel.basicAck(amqpMessage.getMessageProperties().getDeliveryTag(), false);

        } catch (Exception e) {
            logger.error("处理重新派单消息失败：{}", message, e);
            try {
                // 拒绝消息并重新入队
                channel.basicNack(amqpMessage.getMessageProperties().getDeliveryTag(), false, true);
            } catch (IOException ioException) {
                logger.error("拒绝消息失败", ioException);
            }
        }
    }
}
