package com.dorm.manage.task;

import com.dorm.manage.service.ISmartDispatchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 智能派单定时任务
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
@Component
public class SmartDispatchScheduledTask {

    private static final Logger logger = LoggerFactory.getLogger(SmartDispatchScheduledTask.class);

    @Autowired
    private ISmartDispatchService smartDispatchService;

    /**
     * 定期检查等待人工派单的工单并尝试重新派单
     * 每10分钟执行一次
     */
    @Scheduled(fixedRate = 10 * 60 * 1000) // 10分钟
    public void checkPendingDispatchOrders() {
        try {
            logger.debug("开始执行定期检查等待派单工单任务");
            
            ISmartDispatchService.PendingDispatchCheckResult result = 
                smartDispatchService.checkAndRedispatchPendingOrders();
            
            if (result.getTotalChecked() > 0) {
                logger.info("定期检查等待派单工单完成：检查{}个，成功{}个，失败{}个", 
                           result.getTotalChecked(), result.getSuccessCount(), result.getFailureCount());
                
                if (result.getSuccessCount() > 0) {
                    logger.info("成功重新派单的工单详情：{}", result.getDetails());
                }
            }
            
        } catch (Exception e) {
            logger.error("定期检查等待派单工单任务执行失败", e);
        }
    }

    /**
     * 每小时检查一次系统派单状态
     * 用于监控和统计
     */
    @Scheduled(fixedRate = 60 * 60 * 1000) // 1小时
    public void monitorDispatchStatus() {
        try {
            logger.info("开始执行派单状态监控任务");
            
            // 这里可以添加更多的监控逻辑
            // 比如统计各种状态的工单数量、派单成功率等
            
            logger.debug("派单状态监控任务执行完成");
            
        } catch (Exception e) {
            logger.error("派单状态监控任务执行失败", e);
        }
    }

    /**
     * 每天凌晨2点清理过期的派单锁和缓存
     */
    @Scheduled(cron = "0 0 2 * * ?")
    public void cleanupExpiredData() {
        try {
            logger.info("开始执行派单系统数据清理任务");
            
            // 这里可以添加清理逻辑
            // 比如清理过期的Redis锁、清理历史数据等
            
            logger.info("派单系统数据清理任务执行完成");
            
        } catch (Exception e) {
            logger.error("派单系统数据清理任务执行失败", e);
        }
    }
}
