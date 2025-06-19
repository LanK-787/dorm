package com.dorm.manage.controller;

import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.SecurityUtils;
import com.dorm.framework.rabbitmq.message.DispatchStatusUpdateMessage;
import com.dorm.framework.rabbitmq.producer.MessageProducer;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.service.IDormRepairAssignmentService;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.IDormRepairerService;
import com.dorm.manage.service.IRepairerAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 完成维修测试Controller
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/test/complete-repair")
public class CompleteRepairTestController extends BaseController
{
    @Autowired
    private IDormRepairAssignmentService assignmentService;
    
    @Autowired
    private IDormRepairRequestService repairRequestService;
    
    @Autowired
    private IDormRepairerService repairerService;
    
    @Autowired
    private IRepairerAppService repairerAppService;
    
    @Autowired
    private MessageProducer messageProducer;

    /**
     * 测试消息发送功能
     */
    @PostMapping("/test-message/{assignmentId}")
    public AjaxResult testMessageSending(@PathVariable Long assignmentId)
    {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 获取派单信息
            DormRepairAssignment assignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            if (assignment == null) {
                return AjaxResult.error("派单不存在");
            }
            
            result.put("assignmentInfo", assignment);
            
            // 测试普通消息发送
            try {
                DispatchStatusUpdateMessage normalMessage = new DispatchStatusUpdateMessage(
                    assignmentId, assignment.getRequestId(), assignment.getRequestNo(),
                    assignment.getRepairerId(), assignment.getRepairerName(), "TEST_NORMAL"
                );
                messageProducer.sendDispatchStatusUpdateMessage(normalMessage);
                result.put("normalMessageSent", true);
                result.put("normalMessageId", normalMessage.getMessageId());
            } catch (Exception e) {
                result.put("normalMessageSent", false);
                result.put("normalMessageError", e.getMessage());
            }
            
            // 测试安全消息发送
            DispatchStatusUpdateMessage safeMessage = new DispatchStatusUpdateMessage(
                assignmentId, assignment.getRequestId(), assignment.getRequestNo(),
                assignment.getRepairerId(), assignment.getRepairerName(), "TEST_SAFE"
            );
            boolean safeSent = messageProducer.sendDispatchStatusUpdateMessageSafely(safeMessage);
            result.put("safeMessageSent", safeSent);
            result.put("safeMessageId", safeMessage.getMessageId());
            
            return AjaxResult.success("消息发送测试完成", result);
            
        } catch (Exception e) {
            logger.error("测试消息发送失败", e);
            result.put("error", e.getMessage());
            return AjaxResult.error("测试失败", result);
        }
    }

    /**
     * 模拟完成维修流程
     */
    @Log(title = "模拟完成维修", businessType = BusinessType.UPDATE)
    @PostMapping("/simulate-complete/{assignmentId}")
    public AjaxResult simulateComplete(@PathVariable Long assignmentId,
                                     @RequestParam(defaultValue = "test-image1.jpg,test-image2.jpg") String images,
                                     @RequestParam(defaultValue = "测试维修说明") String processRemark)
    {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 获取当前用户信息
            Long userId = SecurityUtils.getUserId();
            DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
            
            if (repairer == null) {
                return AjaxResult.error("维修人员信息不存在");
            }
            
            result.put("repairerId", repairer.getRepairerId());
            result.put("repairerName", repairer.getName());
            
            // 获取完成前状态
            DormRepairAssignment beforeAssignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            DormRepairRequest beforeRequest = null;
            if (beforeAssignment != null) {
                beforeRequest = repairRequestService.selectDormRepairRequestByRequestId(beforeAssignment.getRequestId());
            }
            
            result.put("beforeAssignmentStatus", beforeAssignment != null ? beforeAssignment.getProcessStatus() : null);
            result.put("beforeRequestStatus", beforeRequest != null ? beforeRequest.getStatus() : null);
            
            // 执行完成操作
            AjaxResult completeResult = repairerAppService.completeAssignment(assignmentId, repairer.getRepairerId(), images, processRemark);
            result.put("completeResult", completeResult);
            
            // 获取完成后状态
            DormRepairAssignment afterAssignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            DormRepairRequest afterRequest = null;
            if (afterAssignment != null) {
                afterRequest = repairRequestService.selectDormRepairRequestByRequestId(afterAssignment.getRequestId());
            }
            
            result.put("afterAssignmentStatus", afterAssignment != null ? afterAssignment.getProcessStatus() : null);
            result.put("afterRequestStatus", afterRequest != null ? afterRequest.getStatus() : null);
            
            // 检查状态变化
            if (beforeAssignment != null && afterAssignment != null) {
                boolean assignmentStatusChanged = !beforeAssignment.getProcessStatus().equals(afterAssignment.getProcessStatus());
                result.put("assignmentStatusChanged", assignmentStatusChanged);
            }
            
            if (beforeRequest != null && afterRequest != null) {
                boolean requestStatusChanged = !beforeRequest.getStatus().equals(afterRequest.getStatus());
                result.put("requestStatusChanged", requestStatusChanged);
            }
            
            // 检查结果一致性
            Integer resultCode = (Integer) completeResult.get("code");
            boolean isSuccess = resultCode != null && resultCode == 200;
            result.put("resultSuccess", isSuccess);
            
            if (afterAssignment != null && afterRequest != null) {
                boolean dataUpdated = "2".equals(afterAssignment.getProcessStatus()) && "3".equals(afterRequest.getStatus());
                result.put("dataUpdated", dataUpdated);
                
                if (dataUpdated && !isSuccess) {
                    result.put("inconsistency", "数据已更新但返回失败状态");
                } else if (!dataUpdated && isSuccess) {
                    result.put("inconsistency", "返回成功但数据未更新");
                } else {
                    result.put("consistency", "结果与数据状态一致");
                }
            }
            
            return AjaxResult.success("模拟完成", result);
            
        } catch (Exception e) {
            logger.error("模拟完成维修失败", e);
            result.put("error", e.getMessage());
            return AjaxResult.error("模拟失败", result);
        }
    }

    /**
     * 检查RabbitMQ连接状态
     */
    @GetMapping("/check-rabbitmq")
    public AjaxResult checkRabbitMQ()
    {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 创建测试消息
            DispatchStatusUpdateMessage testMessage = new DispatchStatusUpdateMessage();
            testMessage.setAssignmentId(-1L);
            testMessage.setRequestId(-1L);
            testMessage.setRequestNo("TEST-" + System.currentTimeMillis());
            testMessage.setRepairerId(-1L);
            testMessage.setRepairerName("测试用户");
            testMessage.setOperationType("TEST");
            
            // 测试普通发送
            try {
                messageProducer.sendDispatchStatusUpdateMessage(testMessage);
                result.put("normalSendSuccess", true);
            } catch (Exception e) {
                result.put("normalSendSuccess", false);
                result.put("normalSendError", e.getMessage());
            }
            
            // 测试安全发送
            boolean safeSendResult = messageProducer.sendDispatchStatusUpdateMessageSafely(testMessage);
            result.put("safeSendSuccess", safeSendResult);
            
            result.put("testMessageId", testMessage.getMessageId());
            
            return AjaxResult.success("RabbitMQ检查完成", result);
            
        } catch (Exception e) {
            logger.error("检查RabbitMQ失败", e);
            result.put("error", e.getMessage());
            return AjaxResult.error("检查失败", result);
        }
    }

    /**
     * 获取派单详细信息
     */
    @GetMapping("/assignment-detail/{assignmentId}")
    public AjaxResult getAssignmentDetail(@PathVariable Long assignmentId)
    {
        try {
            DormRepairAssignment assignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            if (assignment == null) {
                return AjaxResult.error("派单不存在");
            }
            
            DormRepairRequest request = repairRequestService.selectDormRepairRequestByRequestId(assignment.getRequestId());
            
            Map<String, Object> result = new HashMap<>();
            result.put("assignment", assignment);
            result.put("request", request);
            result.put("canComplete", "1".equals(assignment.getProcessStatus()));
            
            return AjaxResult.success("查询成功", result);
            
        } catch (Exception e) {
            logger.error("获取派单详情失败", e);
            return AjaxResult.error("查询失败：" + e.getMessage());
        }
    }
}
