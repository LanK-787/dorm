package com.dorm.framework.web.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 设备状态定时任务
 * 用于定期检查和更新设备的在线/离线状态
 * 
 * @author dorm
 * @since 2025-09-07
 */
@Component
public class DeviceStatusTask {
    
    private static final Logger log = LoggerFactory.getLogger(DeviceStatusTask.class);
    
    @Autowired
    private ApplicationContext applicationContext;
    
    /**
     * 定期检查设备离线状态
     * 每5分钟执行一次，将超过30分钟未更新的设备标记为离线
     */
    @Scheduled(fixedRate = 5 * 60 * 1000) // 5分钟执行一次
    public void checkOfflineDevices() {
        try {
            // 动态获取设备服务Bean，避免循环依赖
            Object deviceService = applicationContext.getBean("dormAlarmDeviceServiceImpl");
            if (deviceService == null) {
                log.warn("设备服务Bean未找到，跳过离线状态检查");
                return;
            }
            
            // 使用反射调用更新离线设备的方法
            java.lang.reflect.Method method = deviceService.getClass().getMethod("updateOfflineDevices", int.class);
            int updatedCount = (int) method.invoke(deviceService, 30); // 30分钟超时
            
            if (updatedCount > 0) {
                log.info("设备离线状态检查完成，更新了 {} 个设备为离线状态", updatedCount);
            } else {
                log.debug("设备离线状态检查完成，无设备需要更新");
            }
        } catch (Exception e) {
            log.error("检查设备离线状态失败: {}", e.getMessage(), e);
        }
    }
    
    /**
     * 每日设备状态统计
     * 每天凌晨2点执行
     */
    @Scheduled(cron = "0 0 2 * * ?")
    public void dailyDeviceStatusStatistics() {
        try {
            // 动态获取设备服务Bean
            Object deviceService = applicationContext.getBean("dormAlarmDeviceServiceImpl");
            if (deviceService == null) {
                log.warn("设备服务Bean未找到，跳过每日统计");
                return;
            }
            
            // 可以在这里添加设备状态的统计逻辑
            log.info("每日设备状态统计任务开始执行");
            
            // 这里可以调用具体的统计方法
            // 例如：统计在线/离线设备数量，生成报表等
            
            log.info("每日设备状态统计任务执行完成");
        } catch (Exception e) {
            log.error("每日设备状态统计失败: {}", e.getMessage(), e);
        }
    }
}