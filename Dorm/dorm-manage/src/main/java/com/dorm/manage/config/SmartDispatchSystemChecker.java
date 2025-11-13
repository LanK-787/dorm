package com.dorm.manage.config;

import com.dorm.manage.service.IDispatchMonitorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

/**
 * 智能派单系统启动检查器
 * 在系统启动时检查各个组件是否正常工作
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@Component
public class SmartDispatchSystemChecker implements ApplicationRunner {

    private static final Logger logger = LoggerFactory.getLogger(SmartDispatchSystemChecker.class);

    @Autowired
    private IDispatchMonitorService dispatchMonitorService;

    @Autowired
    private RedisTemplate<Object, Object> redisTemplate;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        logger.info("=== 智能派单系统启动检查开始 ===");

        try {
            // 检查系统健康状态
            checkSystemHealth();

            // 检查Redis连接
            checkRedisConnection();

            // 检查RabbitMQ连接（通过尝试发送测试消息）
            checkRabbitMQConnection();

            // 显示系统状态
            displaySystemStatus();

            logger.info("=== 智能派单系统启动检查完成 ===");

        } catch (Exception e) {
            logger.error("=== 智能派单系统启动检查失败 ===", e);
            throw e;
        }
    }

    /**
     * 检查系统健康状态
     */
    private void checkSystemHealth() {
        try {
            IDispatchMonitorService.SystemHealthStatus healthStatus = dispatchMonitorService.checkSystemHealth();
            logger.info("系统健康状态: {}", healthStatus.getStatus());

            if ("ERROR".equals(healthStatus.getStatus())) {
                logger.error("系统健康检查发现错误: {}", healthStatus.getErrors());
            } else if ("WARNING".equals(healthStatus.getStatus())) {
                logger.warn("系统健康检查发现警告: {}", healthStatus.getWarnings());
            } else {
                logger.info("系统健康状态正常");
            }

        } catch (Exception e) {
            logger.error("系统健康检查失败", e);
            throw new RuntimeException("系统健康检查失败", e);
        }
    }

    /**
     * 检查Redis连接
     */
    private void checkRedisConnection() {
        try {
            String testKey = "smart_dispatch_system_check";
            String testValue = "test_" + System.currentTimeMillis();

            // 测试写入
            redisTemplate.opsForValue().set(testKey, testValue);

            // 测试读取
            String retrievedValue = (String) redisTemplate.opsForValue().get(testKey);

            if (testValue.equals(retrievedValue)) {
                logger.info("Redis连接检查: 正常");
                // 清理测试数据
                redisTemplate.delete(testKey);
            } else {
                throw new RuntimeException("Redis读写测试失败");
            }

        } catch (Exception e) {
            logger.error("Redis连接检查失败", e);
            throw new RuntimeException("Redis连接检查失败", e);
        }
    }

    /**
     * 检查RabbitMQ连接
     */
    private void checkRabbitMQConnection() {
        try {
            // 这里可以通过尝试获取队列信息或发送测试消息来检查RabbitMQ连接
            // 由于我们没有直接的RabbitMQ管理API，这里简单记录日志
            logger.info("RabbitMQ连接检查: 跳过（需要在实际运行时通过消息发送测试）");

        } catch (Exception e) {
            logger.error("RabbitMQ连接检查失败", e);
            throw new RuntimeException("RabbitMQ连接检查失败", e);
        }
    }

    /**
     * 显示系统状态
     */
    private void displaySystemStatus() {
        try {
            IDispatchMonitorService.RealTimeDispatchStatus status = dispatchMonitorService.getRealTimeDispatchStatus();

            logger.info("=== 智能派单系统实时状态 ===");
            logger.info("待派单工单数量: {}", status.getPendingDispatchCount());
            logger.info("处理中工单数量: {}", status.getProcessingCount());
            logger.info("等待人工派单数量: {}", status.getManualDispatchCount());
            logger.info("空闲维修人员数量: {}", status.getAvailableRepairerCount());
            logger.info("出工维修人员数量: {}", status.getWorkingRepairerCount());

            // 如果有待派单的工单，给出提示
            if (status.getPendingDispatchCount() > 0) {
                logger.warn("发现 {} 个待派单工单，系统将自动处理", status.getPendingDispatchCount());
            }

            if (status.getManualDispatchCount() > 0) {
                logger.warn("发现 {} 个等待人工派单的工单，请及时处理", status.getManualDispatchCount());
            }

            if (status.getAvailableRepairerCount() == 0) {
                logger.warn("当前没有空闲的维修人员，可能影响派单效果");
            }

        } catch (Exception e) {
            logger.error("获取系统状态失败", e);
            // 这里不抛出异常，因为系统状态显示失败不应该阻止系统启动
        }
    }
}
