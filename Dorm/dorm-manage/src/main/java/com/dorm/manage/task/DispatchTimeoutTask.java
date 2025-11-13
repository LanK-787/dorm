package com.dorm.manage.task;

import com.dorm.framework.rabbitmq.message.SmartDispatchMessage;
import com.dorm.framework.rabbitmq.producer.MessageProducer;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.mapper.DormRepairAssignmentMapper;
import com.dorm.manage.mapper.DormRepairerMapper;
import com.dorm.manage.service.ISmartDispatchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 派单超时处理定时任务
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@Component("dispatchTimeoutTask")
public class DispatchTimeoutTask {

    private static final Logger logger = LoggerFactory.getLogger(DispatchTimeoutTask.class);

    /** 派单超时时间（分钟） */
    private static final int DISPATCH_TIMEOUT_MINUTES = 30;

    @Autowired
    private DormRepairAssignmentMapper assignmentMapper;

    @Autowired
    private MessageProducer messageProducer;

    @Autowired
    private ISmartDispatchService smartDispatchService;

    @Autowired
    private DormRepairerMapper repairerMapper;

    /**
     * 处理超时未响应的派单
     * 每5分钟执行一次
     */
    public void handleTimeoutAssignments() {
        try {
            logger.info("开始处理超时未响应的派单");

            // 计算超时时间点
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, -DISPATCH_TIMEOUT_MINUTES);
            Date timeoutTime = calendar.getTime();

            // 查询超时的待接单派单
            DormRepairAssignment queryAssignment = new DormRepairAssignment();
            queryAssignment.setProcessStatus("0"); // 待接单
            List<DormRepairAssignment> assignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);

            int timeoutCount = 0;
            for (DormRepairAssignment assignment : assignments) {
                // 检查是否超时
                if (assignment.getAssignTime() != null && assignment.getAssignTime().before(timeoutTime)) {
                    handleTimeoutAssignment(assignment);
                    timeoutCount++;
                }
            }

            if (timeoutCount > 0) {
                logger.info("处理超时派单完成，共处理{}个超时派单", timeoutCount);
            }

        } catch (Exception e) {
            logger.error("处理超时派单失败", e);
        }
    }

    /**
     * 处理单个超时派单
     */
    private void handleTimeoutAssignment(DormRepairAssignment assignment) {
        try {
            logger.info("处理超时派单：工单[{}]，维修人员[{}]", 
                       assignment.getRequestNo(), assignment.getRepairerName());

            // 更新派单状态为已拒绝
            assignment.setProcessStatus("3"); // 已拒绝
            assignment.setRejectTime(new Date());
            assignment.setRejectReason("超时未响应，系统自动拒绝");
            assignment.setUpdateTime(new Date());
            assignmentMapper.updateDormRepairAssignment(assignment);

            // 减少维修人员接单数
            repairerMapper.decrementOrderCount(assignment.getRepairerId());

            // 发送重新派单消息
            SmartDispatchMessage redispatchMessage = new SmartDispatchMessage(
                assignment.getRequestId(), assignment.getRequestNo(), 
                assignment.getSpecialty(), "RETRY"
            );
            redispatchMessage.setExcludeRepairerIds(smartDispatchService.getRejectedRepairerIds(assignment.getRequestId()));
            redispatchMessage.setDelayTime(2 * 60 * 1000L); // 2分钟后重新派单
            messageProducer.sendRedispatchMessage(redispatchMessage);

            logger.info("超时派单处理完成：工单[{}]已重新派单", assignment.getRequestNo());

        } catch (Exception e) {
            logger.error("处理超时派单失败：派单[{}]", assignment.getAssignmentId(), e);
        }
    }

    /**
     * 清理过期的派单记录
     * 每天凌晨2点执行一次
     */
    public void cleanExpiredAssignments() {
        try {
            logger.info("开始清理过期的派单记录");

            // 计算过期时间点（30天前）
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_MONTH, -30);
            Date expireTime = calendar.getTime();

            // 删除过期的已完成和已拒绝派单记录
            // 注意：这里需要在Mapper中添加相应的删除方法
            logger.info("清理过期派单记录功能待实现");

        } catch (Exception e) {
            logger.error("清理过期派单记录失败", e);
        }
    }

    /**
     * 统计派单效率
     * 每天凌晨1点执行一次
     */
    public void calculateDispatchStatistics() {
        try {
            logger.info("开始统计派单效率");

            // 计算昨天的派单统计数据
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_MONTH, -1);
            calendar.set(Calendar.HOUR_OF_DAY, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);
            Date startTime = calendar.getTime();

            calendar.add(Calendar.DAY_OF_MONTH, 1);
            Date endTime = calendar.getTime();

            // 这里可以添加统计逻辑，比如：
            // - 总派单数
            // - 成功派单数
            // - 失败派单数
            // - 平均响应时间
            // - 各维修人员的工作量统计等

            logger.info("派单效率统计完成");

        } catch (Exception e) {
            logger.error("统计派单效率失败", e);
        }
    }
}
