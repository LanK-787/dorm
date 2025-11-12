package com.dorm.manage.service.impl;

import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.utils.DateUtils;
import com.dorm.common.utils.StringUtils;
import com.dorm.framework.rabbitmq.message.DispatchStatusUpdateMessage;
import com.dorm.framework.rabbitmq.message.SmartDispatchMessage;
import com.dorm.framework.rabbitmq.producer.MessageProducer;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.mapper.DormRepairAssignmentMapper;
import com.dorm.manage.mapper.DormRepairRequestMapper;
import com.dorm.manage.mapper.DormRepairerMapper;
import com.dorm.manage.service.IRepairerAppService;
import com.dorm.manage.service.ISmartDispatchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 维修人员App端服务实现类
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@Service
public class RepairerAppServiceImpl implements IRepairerAppService {

    private static final Logger logger = LoggerFactory.getLogger(RepairerAppServiceImpl.class);

    @Autowired
    private DormRepairAssignmentMapper assignmentMapper;

    @Autowired
    private DormRepairRequestMapper repairRequestMapper;

    @Autowired
    private DormRepairerMapper repairerMapper;

    @Autowired
    private MessageProducer messageProducer;

    @Autowired
    private ISmartDispatchService smartDispatchService;

    /**
     * 获取待处理派单列表
     */
    @Override
    public List<DormRepairAssignment> getPendingAssignments(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        queryAssignment.setProcessStatus("0"); // 待接单
        return assignmentMapper.selectDormRepairAssignmentListWithDetails(queryAssignment);
    }

    /**
     * 获取处理中的派单列表
     */
    @Override
    public List<DormRepairAssignment> getProcessingAssignments(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        queryAssignment.setProcessStatus("1"); // 处理中
        return assignmentMapper.selectDormRepairAssignmentListWithDetails(queryAssignment);
    }

    /**
     * 获取已完成的派单列表
     */
    @Override
    public List<DormRepairAssignment> getCompletedAssignments(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        queryAssignment.setProcessStatus("2"); // 已完成
        return assignmentMapper.selectDormRepairAssignmentListWithDetails(queryAssignment);
    }

    /**
     * 获取已拒绝的派单列表
     */
    @Override
    public List<DormRepairAssignment> getRejectedAssignments(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        queryAssignment.setProcessStatus("3"); // 已拒绝
        return assignmentMapper.selectDormRepairAssignmentListWithDetails(queryAssignment);
    }

    /**
     * 获取所有派单列表
     */
    @Override
    public List<DormRepairAssignment> getAllAssignments(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        // 不设置processStatus，获取所有状态的派单
        return assignmentMapper.selectDormRepairAssignmentListWithDetails(queryAssignment);
    }

    /**
     * 获取派单详情
     */
    @Override
    public DormRepairAssignment getAssignmentDetail(Long assignmentId, Long repairerId) {
        // 使用关联查询获取派单详情
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setAssignmentId(assignmentId);
        queryAssignment.setRepairerId(repairerId);

        List<DormRepairAssignment> assignments = assignmentMapper.selectDormRepairAssignmentListWithDetails(queryAssignment);

        if (assignments.isEmpty()) {
            return null;
        }

        return assignments.get(0);
    }

    /**
     * 接受派单
     */
    @Override
    @Transactional
    public AjaxResult acceptAssignment(Long assignmentId, Long repairerId) {
        logger.info("维修人员[{}]开始接受派单[{}]", repairerId, assignmentId);

        // 获取派单信息
        DormRepairAssignment assignment = assignmentMapper.selectDormRepairAssignmentByAssignmentId(assignmentId);
        if (assignment == null) {
            logger.warn("派单不存在：assignmentId={}", assignmentId);
            return AjaxResult.error("派单不存在");
        }

        // 验证派单是否属于当前维修人员
        if (!repairerId.equals(assignment.getRepairerId())) {
            logger.warn("无权操作此派单：assignmentId={}, repairerId={}, assignmentRepairerId={}",
                       assignmentId, repairerId, assignment.getRepairerId());
            return AjaxResult.error("无权操作此派单");
        }

        // 验证派单状态
        if (!"0".equals(assignment.getProcessStatus())) {
            logger.warn("派单状态不正确：assignmentId={}, currentStatus={}", assignmentId, assignment.getProcessStatus());
            return AjaxResult.error("派单状态不正确，无法接受");
        }

        try {
            // 使用条件更新防止并发问题
            int assignmentUpdateResult = assignmentMapper.updateAssignmentStatusConditional(assignmentId, "1", "0");
            if (assignmentUpdateResult == 0) {
                logger.warn("派单状态更新失败，可能已被其他人处理：assignmentId={}", assignmentId);
                return AjaxResult.error("派单状态已变更，请刷新后重试");
            }

            logger.info("派单状态更新成功：assignmentId={}", assignmentId);

            // 更新工单状态
            DormRepairRequest repairRequest = new DormRepairRequest();
            repairRequest.setRequestId(assignment.getRequestId());
            repairRequest.setStatus("2"); // 维修中
            repairRequest.setUpdateTime(DateUtils.getNowDate());
            int requestUpdateResult = repairRequestMapper.updateDormRepairRequest(repairRequest);

            if (requestUpdateResult == 0) {
                logger.warn("工单状态更新失败：requestId={}", assignment.getRequestId());
                throw new RuntimeException("工单状态更新失败");
            }

            logger.info("工单状态更新成功：requestId={}", assignment.getRequestId());

            // 更新维修人员状态为出工
            try {
                int repairerUpdateResult = repairerMapper.updateDormRepairer(createRepairerStatusUpdate(repairerId, "0"));
                if (repairerUpdateResult == 0) {
                    logger.warn("维修人员状态更新失败：repairerId={}", repairerId);
                }
            } catch (Exception e) {
                logger.error("更新维修人员状态失败：repairerId={}", repairerId, e);
                // 维修人员状态更新失败不影响主流程
            }

            // 异步发送状态更新消息（失败不影响主流程）
            DispatchStatusUpdateMessage message = new DispatchStatusUpdateMessage(
                assignmentId, assignment.getRequestId(), assignment.getRequestNo(),
                repairerId, assignment.getRepairerName(), "ACCEPT"
            );
            boolean messageSent = messageProducer.sendDispatchStatusUpdateMessageSafely(message);
            if (messageSent) {
                logger.info("派单状态更新消息发送成功：assignmentId={}", assignmentId);
            } else {
                logger.warn("派单状态更新消息发送失败：assignmentId={}，但不影响主业务流程", assignmentId);
            }

            logger.info("维修人员[{}]成功接受派单[{}]", assignment.getRepairerName(), assignment.getRequestNo());
            return AjaxResult.success("接受派单成功");

        } catch (Exception e) {
            logger.error("接受派单失败：assignmentId={}, repairerId={}", assignmentId, repairerId, e);
            return AjaxResult.error("接受派单失败：" + e.getMessage());
        }
    }

    /**
     * 拒绝派单
     */
    @Override
    @Transactional
    public AjaxResult rejectAssignment(Long assignmentId, Long repairerId, String rejectReason) {
        // 获取派单信息
        DormRepairAssignment assignment = assignmentMapper.selectDormRepairAssignmentByAssignmentId(assignmentId);
        if (assignment == null) {
            return AjaxResult.error("派单不存在");
        }

        // 验证派单是否属于当前维修人员
        if (!repairerId.equals(assignment.getRepairerId())) {
            return AjaxResult.error("无权操作此派单");
        }

        // 验证派单状态
        if (!"0".equals(assignment.getProcessStatus())) {
            return AjaxResult.error("派单状态不正确，无法拒绝");
        }

        if (StringUtils.isEmpty(rejectReason)) {
            return AjaxResult.error("请填写拒绝原因");
        }

        try {
            // 更新派单状态
            assignment.setProcessStatus("3"); // 已拒绝
            assignment.setRejectTime(DateUtils.getNowDate());
            assignment.setRejectReason(rejectReason);
            assignment.setUpdateTime(DateUtils.getNowDate());
            int assignmentUpdateResult = assignmentMapper.updateDormRepairAssignment(assignment);

            if (assignmentUpdateResult == 0) {
                logger.warn("派单状态更新失败：assignmentId={}", assignmentId);
                return AjaxResult.error("派单状态更新失败");
            }

            logger.info("派单状态更新成功：assignmentId={}", assignmentId);

            // 更新工单状态为等待人工派单，以便重新分配
            DormRepairRequest repairRequest = new DormRepairRequest();
            repairRequest.setRequestId(assignment.getRequestId());
            repairRequest.setStatus("5"); // 等待人工派单
            repairRequest.setUpdateTime(DateUtils.getNowDate());
            int requestUpdateResult = repairRequestMapper.updateDormRepairRequest(repairRequest);

            if (requestUpdateResult == 0) {
                logger.warn("工单状态更新失败：requestId={}", assignment.getRequestId());
                return AjaxResult.error("工单状态更新失败");
            }

            logger.info("工单状态更新成功：requestId={}", assignment.getRequestId());

            logger.info("维修人员[{}]拒绝派单[{}]，原因：{} - 核心业务操作成功", assignment.getRepairerName(), assignment.getRequestNo(), rejectReason);

        } catch (Exception e) {
            logger.error("拒绝派单失败：派单[{}]", assignmentId, e);
            return AjaxResult.error("拒绝派单失败：" + e.getMessage());
        }

        // 异步发送状态更新消息（在事务外执行，失败不影响主流程）
        DispatchStatusUpdateMessage statusMessage = new DispatchStatusUpdateMessage(
            assignmentId, assignment.getRequestId(), assignment.getRequestNo(),
            repairerId, assignment.getRepairerName(), "REJECT"
        );
        statusMessage.setRejectReason(rejectReason);

        boolean statusMessageSent = messageProducer.sendDispatchStatusUpdateMessageSafely(statusMessage);
        if (statusMessageSent) {
            logger.info("拒绝派单状态更新消息发送成功：assignmentId={}", assignmentId);
        } else {
            logger.warn("拒绝派单状态更新消息发送失败：assignmentId={}，但不影响主业务流程", assignmentId);
        }

        // 异步发送重新派单消息（在事务外执行，失败不影响主流程）
        try {
            SmartDispatchMessage redispatchMessage = new SmartDispatchMessage(
                assignment.getRequestId(), assignment.getRequestNo(),
                assignment.getSpecialty(), "RETRY"
            );
            redispatchMessage.setExcludeRepairerIds(smartDispatchService.getRejectedRepairerIds(assignment.getRequestId()));
            redispatchMessage.setDelayTime(0L); // 立即重新派单

            boolean redispatchMessageSent = messageProducer.sendRedispatchMessageSafely(redispatchMessage);
            if (redispatchMessageSent) {
                logger.info("重新派单消息发送成功：requestId={}", assignment.getRequestId());
            } else {
                logger.warn("重新派单消息发送失败：requestId={}，但不影响主业务流程", assignment.getRequestId());
            }
        } catch (Exception e) {
            logger.error("获取拒绝维修人员列表或发送重新派单消息失败：requestId={}", assignment.getRequestId(), e);
            // 重新派单消息发送失败不影响主流程
        }

        return AjaxResult.success("拒绝派单成功，系统将自动重新派单");
    }

    /**
     * 完成维修
     */
    @Override
    @Transactional
    public AjaxResult completeAssignment(Long assignmentId, Long repairerId, String images, String processRemark) {
        // 获取派单信息
        DormRepairAssignment assignment = assignmentMapper.selectDormRepairAssignmentByAssignmentId(assignmentId);
        if (assignment == null) {
            return AjaxResult.error("派单不存在");
        }

        // 验证派单是否属于当前维修人员
        if (!repairerId.equals(assignment.getRepairerId())) {
            return AjaxResult.error("无权操作此派单");
        }

        // 验证派单状态
        if (!"1".equals(assignment.getProcessStatus())) {
            return AjaxResult.error("派单状态不正确，无法完成");
        }

        if (StringUtils.isEmpty(images)) {
            return AjaxResult.error("请上传完成照片");
        }

        try {
            // 更新派单状态
            assignment.setProcessStatus("2"); // 已完成
            assignment.setCompleteTime(DateUtils.getNowDate());
            assignment.setImages(images);
            assignment.setProcessRemark(processRemark);
            assignment.setUpdateTime(DateUtils.getNowDate());
            int assignmentUpdateResult = assignmentMapper.updateDormRepairAssignment(assignment);

            if (assignmentUpdateResult == 0) {
                logger.warn("派单状态更新失败：assignmentId={}", assignmentId);
                return AjaxResult.error("派单状态更新失败");
            }

            logger.info("派单状态更新成功：assignmentId={}", assignmentId);

            // 更新工单状态
            DormRepairRequest repairRequest = new DormRepairRequest();
            repairRequest.setRequestId(assignment.getRequestId());
            repairRequest.setStatus("3"); // 已完成
            repairRequest.setUpdateTime(DateUtils.getNowDate());
            int requestUpdateResult = repairRequestMapper.updateDormRepairRequest(repairRequest);

            if (requestUpdateResult == 0) {
                logger.warn("工单状态更新失败：requestId={}", assignment.getRequestId());
                return AjaxResult.error("工单状态更新失败");
            }

            logger.info("工单状态更新成功：requestId={}", assignment.getRequestId());

            // 更新维修人员状态为空闲（非关键操作）
            try {
                int repairerUpdateResult = repairerMapper.updateDormRepairer(createRepairerStatusUpdate(repairerId, "1"));
                if (repairerUpdateResult == 0) {
                    logger.warn("维修人员状态更新失败：repairerId={}", repairerId);
                } else {
                    logger.info("维修人员状态更新成功：repairerId={}", repairerId);
                }
            } catch (Exception e) {
                logger.error("更新维修人员状态失败：repairerId={}", repairerId, e);
                // 维修人员状态更新失败不影响主流程
            }

            // 增加维修人员完成工单数（非关键操作）
            try {
                repairerMapper.incrementOrderCount(repairerId);
                logger.info("维修人员完成工单数增加成功：repairerId={}", repairerId);
            } catch (Exception e) {
                logger.error("增加维修人员完成工单数失败：repairerId={}", repairerId, e);
                // 完成工单数更新失败不影响主流程
            }

            logger.info("维修人员[{}]完成维修[{}] - 核心业务操作成功", assignment.getRepairerName(), assignment.getRequestNo());

        } catch (Exception e) {
            logger.error("完成维修失败：派单[{}]", assignmentId, e);
            return AjaxResult.error("完成维修失败：" + e.getMessage());
        }

        // 异步发送状态更新消息（在事务外执行，失败不影响主流程）
        DispatchStatusUpdateMessage message = new DispatchStatusUpdateMessage(
            assignmentId, assignment.getRequestId(), assignment.getRequestNo(),
            repairerId, assignment.getRepairerName(), "COMPLETE"
        );
        message.setCompletionImages(images);
        message.setProcessRemark(processRemark);

        boolean messageSent = messageProducer.sendDispatchStatusUpdateMessageSafely(message);
        if (messageSent) {
            logger.info("完成维修状态更新消息发送成功：assignmentId={}", assignmentId);
        } else {
            logger.warn("完成维修状态更新消息发送失败：assignmentId={}，但不影响主业务流程", assignmentId);
        }

        return AjaxResult.success("维修完成");
    }

    /**
     * 获取未读派单数量
     */
    @Override
    public int getUnreadAssignmentCount(Long repairerId) {
        DormRepairAssignment queryAssignment = new DormRepairAssignment();
        queryAssignment.setRepairerId(repairerId);
        queryAssignment.setProcessStatus("0"); // 待接单
        List<DormRepairAssignment> assignments = assignmentMapper.selectDormRepairAssignmentList(queryAssignment);
        return assignments.size();
    }

    /**
     * 创建维修人员状态更新对象
     */
    private com.dorm.manage.domain.DormRepairer createRepairerStatusUpdate(Long repairerId, String status) {
        com.dorm.manage.domain.DormRepairer repairer = new com.dorm.manage.domain.DormRepairer();
        repairer.setRepairerId(repairerId);
        repairer.setStatus(status);
        repairer.setUpdateTime(DateUtils.getNowDate());
        return repairer;
    }
}
