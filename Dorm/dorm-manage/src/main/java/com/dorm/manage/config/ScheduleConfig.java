package com.dorm.manage.config;

import com.dorm.manage.task.DispatchTimeoutTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

/**
 * 定时任务配置类
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@Configuration
@EnableScheduling
public class ScheduleConfig {
    
    @Autowired
    private DispatchTimeoutTask dispatchTimeoutTask;
    
    /**
     * 每5分钟检查超时派单
     */
    @Scheduled(fixedRate = 300000) // 5分钟 = 300000毫秒
    public void handleTimeoutAssignments() {
        dispatchTimeoutTask.handleTimeoutAssignments();
    }
    
    /**
     * 每天凌晨2点清理过期记录
     */
    @Scheduled(cron = "0 0 2 * * ?")
    public void cleanExpiredAssignments() {
        dispatchTimeoutTask.cleanExpiredAssignments();
    }
    
    /**
     * 每天凌晨1点统计派单效率
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void calculateDispatchStatistics() {
        dispatchTimeoutTask.calculateDispatchStatistics();
    }
}
