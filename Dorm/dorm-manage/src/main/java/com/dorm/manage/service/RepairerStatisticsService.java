package com.dorm.manage.service;

import com.dorm.framework.rabbitmq.message.RepairOrderMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 维修人员统计服务
 * 
 * @author 王新瑜
 */
@Service
public class RepairerStatisticsService {

    private static final Logger logger = LoggerFactory.getLogger(RepairerStatisticsService.class);

    @Autowired
    private IDormRepairerService dormRepairerService;

    /**
     * 处理维修工单分配，增加维修人员接单数量
     * 
     * @param message 维修工单消息
     */
    public void handleOrderAssigned(RepairOrderMessage message) {
        if (message.getRepairerId() != null) {
            try {
                int result = dormRepairerService.incrementOrderCount(message.getRepairerId());
                if (result > 0) {
                    logger.info("维修人员 {} 接单数量增加成功，工单号: {}", 
                            message.getRepairerName(), message.getOrderNo());
                } else {
                    logger.warn("维修人员 {} 接单数量增加失败，工单号: {}", 
                            message.getRepairerName(), message.getOrderNo());
                }
            } catch (Exception e) {
                logger.error("更新维修人员接单数量失败: 维修人员ID={}, 工单号={}, 错误信息: {}", 
                        message.getRepairerId(), message.getOrderNo(), e.getMessage(), e);
            }
        }
    }

    /**
     * 处理维修工单取消分配，减少维修人员接单数量
     * 
     * @param message 维修工单消息
     */
    public void handleOrderUnassigned(RepairOrderMessage message) {
        if (message.getRepairerId() != null) {
            try {
                int result = dormRepairerService.decrementOrderCount(message.getRepairerId());
                if (result > 0) {
                    logger.info("维修人员 {} 接单数量减少成功，工单号: {}", 
                            message.getRepairerName(), message.getOrderNo());
                } else {
                    logger.warn("维修人员 {} 接单数量减少失败，工单号: {}", 
                            message.getRepairerName(), message.getOrderNo());
                }
            } catch (Exception e) {
                logger.error("更新维修人员接单数量失败: 维修人员ID={}, 工单号={}, 错误信息: {}", 
                        message.getRepairerId(), message.getOrderNo(), e.getMessage(), e);
            }
        }
    }

    /**
     * 处理维修工单完成，可以选择是否减少接单数量
     * 根据业务需求，完成的工单可能仍然计入统计，或者从统计中移除
     * 
     * @param message 维修工单消息
     * @param shouldDecrementCount 是否减少接单数量
     */
    public void handleOrderCompleted(RepairOrderMessage message, boolean shouldDecrementCount) {
        if (message.getRepairerId() != null && shouldDecrementCount) {
            try {
                int result = dormRepairerService.decrementOrderCount(message.getRepairerId());
                if (result > 0) {
                    logger.info("维修人员 {} 完成工单，接单数量减少成功，工单号: {}", 
                            message.getRepairerName(), message.getOrderNo());
                } else {
                    logger.warn("维修人员 {} 完成工单，接单数量减少失败，工单号: {}", 
                            message.getRepairerName(), message.getOrderNo());
                }
            } catch (Exception e) {
                logger.error("更新维修人员接单数量失败: 维修人员ID={}, 工单号={}, 错误信息: {}", 
                        message.getRepairerId(), message.getOrderNo(), e.getMessage(), e);
            }
        } else {
            logger.info("维修人员 {} 完成工单，保持接单数量不变，工单号: {}", 
                    message.getRepairerName(), message.getOrderNo());
        }
    }

    /**
     * 直接增加维修人员接单数量
     * 
     * @param repairerId 维修人员ID
     * @param orderNo 工单编号（用于日志）
     * @return 更新结果
     */
    public boolean incrementRepairerOrderCount(Long repairerId, String orderNo) {
        try {
            int result = dormRepairerService.incrementOrderCount(repairerId);
            if (result > 0) {
                logger.info("维修人员 {} 接单数量增加成功，工单号: {}", repairerId, orderNo);
                return true;
            } else {
                logger.warn("维修人员 {} 接单数量增加失败，工单号: {}", repairerId, orderNo);
                return false;
            }
        } catch (Exception e) {
            logger.error("更新维修人员接单数量失败: 维修人员ID={}, 工单号={}, 错误信息: {}", 
                    repairerId, orderNo, e.getMessage(), e);
            return false;
        }
    }

    /**
     * 直接减少维修人员接单数量
     * 
     * @param repairerId 维修人员ID
     * @param orderNo 工单编号（用于日志）
     * @return 更新结果
     */
    public boolean decrementRepairerOrderCount(Long repairerId, String orderNo) {
        try {
            int result = dormRepairerService.decrementOrderCount(repairerId);
            if (result > 0) {
                logger.info("维修人员 {} 接单数量减少成功，工单号: {}", repairerId, orderNo);
                return true;
            } else {
                logger.warn("维修人员 {} 接单数量减少失败，工单号: {}", repairerId, orderNo);
                return false;
            }
        } catch (Exception e) {
            logger.error("更新维修人员接单数量失败: 维修人员ID={}, 工单号={}, 错误信息: {}", 
                    repairerId, orderNo, e.getMessage(), e);
            return false;
        }
    }
}
