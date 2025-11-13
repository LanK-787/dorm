package com.dorm.framework.rabbitmq.consumer;

import com.dorm.framework.config.RabbitMQConfig;
import com.dorm.framework.rabbitmq.message.SystemLogMessage;
import com.rabbitmq.client.Channel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 系统日志消息消费者
 * 
 * @author 王新瑜
 */
@Component
public class SystemLogConsumer {

    private static final Logger logger = LoggerFactory.getLogger(SystemLogConsumer.class);

    /**
     * 处理系统日志消息
     * 
     * @param systemLogMessage 系统日志消息
     * @param message         原始消息
     * @param channel         通道
     */
    @RabbitListener(queues = RabbitMQConfig.SYSTEM_LOG_QUEUE)
    public void handleSystemLogMessage(SystemLogMessage systemLogMessage, Message message, Channel channel) {
        long deliveryTag = message.getMessageProperties().getDeliveryTag();
        
        try {
            logger.info("接收到系统日志消息: {}", systemLogMessage.getMessageId());
            
            // 处理消息逻辑
            processSystemLogMessage(systemLogMessage);
            
            // 手动确认消息
            channel.basicAck(deliveryTag, false);
            logger.debug("系统日志消息处理成功: {}", systemLogMessage.getMessageId());
            
        } catch (Exception e) {
            logger.error("系统日志消息处理失败: {}, 错误信息: {}", systemLogMessage.getMessageId(), e.getMessage(), e);
            
            try {
                // 检查重试次数
                if (systemLogMessage.isMaxRetryExceeded()) {
                    logger.error("系统日志消息重试次数超限，丢弃消息: {}", systemLogMessage.getMessageId());
                    // 确认消息，不再重试
                    channel.basicAck(deliveryTag, false);
                } else {
                    // 增加重试次数并拒绝消息，重新入队
                    systemLogMessage.incrementRetryCount();
                    logger.warn("系统日志消息处理失败，重新入队重试: {}, 当前重试次数: {}", 
                            systemLogMessage.getMessageId(), systemLogMessage.getRetryCount());
                    channel.basicNack(deliveryTag, false, true);
                }
            } catch (IOException ioException) {
                logger.error("消息确认失败: {}", ioException.getMessage(), ioException);
            }
        }
    }

    /**
     * 处理系统日志消息的具体业务逻辑
     *
     * @param message 系统日志消息
     */
    private void processSystemLogMessage(SystemLogMessage message) {
        // 实现系统日志处理的业务逻辑
        // 1. 将日志写入数据库
        // 2. 进行日志分析
        // 3. 异常日志告警
        // 4. 统计分析
        
        // 根据操作类型进行不同处理
        Integer operType = message.getOperType();
        switch (operType) {
            case 1: // 新增
                handleInsertLog(message);
                break;
            case 2: // 修改
                handleUpdateLog(message);
                break;
            case 3: // 删除
                handleDeleteLog(message);
                break;
            case 4: // 授权
                handleAuthLog(message);
                break;
            case 5: // 导出
                handleExportLog(message);
                break;
            case 6: // 导入
                handleImportLog(message);
                break;
            case 7: // 强退
                handleForceLogoutLog(message);
                break;
            case 8: // 生成代码
                handleGenerateCodeLog(message);
                break;
            case 9: // 清空数据
                handleClearDataLog(message);
                break;
            default: // 其他
                handleOtherLog(message);
        }
        
        // 检查是否为异常日志
        if (message.getStatus() == 1) {
            handleErrorLog(message);
        }
    }

    /**
     * 处理新增操作日志
     */
    private void handleInsertLog(SystemLogMessage message) {
        logger.debug("处理新增操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // 新增操作特殊处理
    }

    /**
     * 处理修改操作日志
     */
    private void handleUpdateLog(SystemLogMessage message) {
        logger.debug("处理修改操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // 修改操作特殊处理
    }

    /**
     * 处理删除操作日志
     */
    private void handleDeleteLog(SystemLogMessage message) {
        logger.debug("处理删除操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // 删除操作特殊处理，可能需要特别关注
    }

    /**
     * 处理授权操作日志
     */
    private void handleAuthLog(SystemLogMessage message) {
        logger.debug("处理授权操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // TODO: 授权操作特殊处理，安全相关
    }

    /**
     * 处理导出操作日志
     */
    private void handleExportLog(SystemLogMessage message) {
        logger.debug("处理导出操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // TODO: 导出操作特殊处理，数据安全相关
    }

    /**
     * 处理导入操作日志
     */
    private void handleImportLog(SystemLogMessage message) {
        logger.debug("处理导入操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // TODO: 导入操作特殊处理
    }

    /**
     * 处理强退操作日志
     */
    private void handleForceLogoutLog(SystemLogMessage message) {
        logger.debug("处理强退操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // TODO: 强退操作特殊处理，安全相关
    }

    /**
     * 处理生成代码操作日志
     */
    private void handleGenerateCodeLog(SystemLogMessage message) {
        logger.debug("处理生成代码操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // 生成代码操作特殊处理
    }

    /**
     * 处理清空数据操作日志
     */
    private void handleClearDataLog(SystemLogMessage message) {
        logger.warn("处理清空数据操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // 清空数据操作特殊处理，高风险操作
    }

    /**
     * 处理其他操作日志
     */
    private void handleOtherLog(SystemLogMessage message) {
        logger.debug("处理其他操作日志: 模块={}, 操作人={}", message.getModule(), message.getOperName());
        // 其他操作特殊处理
    }

    /**
     * 处理异常日志
     */
    private void handleErrorLog(SystemLogMessage message) {
        logger.warn("处理异常日志: 模块={}, 操作人={}, 错误信息={}", 
                message.getModule(), message.getOperName(), message.getErrorMsg());
        
        // TODO: 异常日志特殊处理
        // 1. 发送告警通知
        // 2. 记录到异常日志表
        // 3. 统计异常频率
    }
}
