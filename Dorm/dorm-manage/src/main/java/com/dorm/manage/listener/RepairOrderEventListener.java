package com.dorm.manage.listener;

import com.dorm.framework.event.RepairOrderEvent;
import com.dorm.manage.service.RepairerStatisticsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

/**
 * 维修工单事件监听器
 * 
 * @author dorm
 */
@Component
public class RepairOrderEventListener {

    private static final Logger logger = LoggerFactory.getLogger(RepairOrderEventListener.class);

    @Autowired
    private RepairerStatisticsService repairerStatisticsService;

    /**
     * 处理维修工单事件
     * 
     * @param event 维修工单事件
     */
    @EventListener
    @Async
    public void handleRepairOrderEvent(RepairOrderEvent event) {
        try {
            logger.info("接收到维修工单事件: 类型={}, 工单号={}", 
                    event.getEventType(), event.getRepairOrderMessage().getOrderNo());

            switch (event.getEventType()) {
                case ASSIGNED:
                    repairerStatisticsService.handleOrderAssigned(event.getRepairOrderMessage());
                    break;
                case UNASSIGNED:
                    repairerStatisticsService.handleOrderUnassigned(event.getRepairOrderMessage());
                    break;
                case COMPLETED:
                    repairerStatisticsService.handleOrderCompleted(event.getRepairOrderMessage(), event.isShouldDecrementCount());
                    break;
                default:
                    logger.warn("未知的事件类型: {}", event.getEventType());
            }

        } catch (Exception e) {
            logger.error("处理维修工单事件失败: {}, 错误信息: {}", event, e.getMessage(), e);
        }
    }
}
