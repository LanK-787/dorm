package com.dorm.manage.controller;

import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.SecurityUtils;
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
import java.util.List;
import java.util.Map;

/**
 * 维修派单诊断Controller
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/diagnostic/repair-assignment")
public class RepairAssignmentDiagnosticController extends BaseController
{
    @Autowired
    private IDormRepairAssignmentService assignmentService;
    
    @Autowired
    private IDormRepairRequestService repairRequestService;
    
    @Autowired
    private IDormRepairerService repairerService;
    
    @Autowired
    private IRepairerAppService repairerAppService;

    /**
     * 诊断派单状态
     */
    @GetMapping("/diagnose/{assignmentId}")
    public AjaxResult diagnoseAssignment(@PathVariable Long assignmentId)
    {
        Map<String, Object> diagnosis = new HashMap<>();
        
        try {
            // 获取当前用户信息
            Long userId = SecurityUtils.getUserId();
            DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
            
            diagnosis.put("currentUserId", userId);
            diagnosis.put("currentUsername", SecurityUtils.getUsername());
            diagnosis.put("repairerInfo", repairer);
            
            // 获取派单信息
            DormRepairAssignment assignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            diagnosis.put("assignmentExists", assignment != null);
            
            if (assignment != null) {
                diagnosis.put("assignmentInfo", assignment);
                diagnosis.put("assignmentStatus", assignment.getProcessStatus());
                diagnosis.put("assignedRepairerId", assignment.getRepairerId());
                diagnosis.put("isAssignedToCurrentUser", repairer != null && repairer.getRepairerId().equals(assignment.getRepairerId()));
                
                // 获取关联的工单信息
                DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(assignment.getRequestId());
                diagnosis.put("repairRequestInfo", repairRequest);
                
                // 检查状态一致性
                if (repairRequest != null) {
                    diagnosis.put("statusConsistency", checkStatusConsistency(assignment, repairRequest));
                }
            }
            
            return AjaxResult.success("诊断完成", diagnosis);
            
        } catch (Exception e) {
            logger.error("诊断派单状态失败", e);
            diagnosis.put("error", e.getMessage());
            return AjaxResult.error("诊断失败", diagnosis);
        }
    }

    /**
     * 测试接受派单
     */
    @Log(title = "测试接受派单", businessType = BusinessType.UPDATE)
    @PostMapping("/test-accept/{assignmentId}")
    public AjaxResult testAcceptAssignment(@PathVariable Long assignmentId)
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
            
            // 获取派单前状态
            DormRepairAssignment beforeAssignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            result.put("beforeStatus", beforeAssignment != null ? beforeAssignment.getProcessStatus() : null);
            
            // 执行接受操作
            AjaxResult acceptResult = repairerAppService.acceptAssignment(assignmentId, repairer.getRepairerId());
            result.put("acceptResult", acceptResult);
            
            // 获取派单后状态
            DormRepairAssignment afterAssignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            result.put("afterStatus", afterAssignment != null ? afterAssignment.getProcessStatus() : null);
            
            // 检查状态是否发生变化
            if (beforeAssignment != null && afterAssignment != null) {
                boolean statusChanged = !beforeAssignment.getProcessStatus().equals(afterAssignment.getProcessStatus());
                result.put("statusChanged", statusChanged);

                // 检查是否存在状态更新但返回错误的不一致情况
                Integer resultCode = (Integer) acceptResult.get("code");
                if (statusChanged && (resultCode == null || resultCode != 200)) {
                    result.put("inconsistency", "状态已更新但返回错误码");
                    result.put("actualResultCode", resultCode);
                }
            }
            
            return AjaxResult.success("测试完成", result);
            
        } catch (Exception e) {
            logger.error("测试接受派单失败", e);
            result.put("error", e.getMessage());
            return AjaxResult.error("测试失败", result);
        }
    }

    /**
     * 获取维修人员的所有派单
     */
    @GetMapping("/repairer-assignments")
    public AjaxResult getRepairerAssignments()
    {
        try {
            Long userId = SecurityUtils.getUserId();
            DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
            
            if (repairer == null) {
                return AjaxResult.error("维修人员信息不存在");
            }
            
            DormRepairAssignment queryAssignment = new DormRepairAssignment();
            queryAssignment.setRepairerId(repairer.getRepairerId());
            
            List<DormRepairAssignment> assignments = assignmentService.selectDormRepairAssignmentList(queryAssignment);
            
            Map<String, Object> result = new HashMap<>();
            result.put("repairerId", repairer.getRepairerId());
            result.put("repairerName", repairer.getName());
            result.put("totalAssignments", assignments.size());
            result.put("assignments", assignments);
            
            // 按状态分组统计
            Map<String, Long> statusCount = new HashMap<>();
            for (DormRepairAssignment assignment : assignments) {
                String status = assignment.getProcessStatus();
                statusCount.put(status, statusCount.getOrDefault(status, 0L) + 1);
            }
            result.put("statusCount", statusCount);
            
            return AjaxResult.success("查询成功", result);
            
        } catch (Exception e) {
            logger.error("获取维修人员派单失败", e);
            return AjaxResult.error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 强制刷新派单状态
     */
    @Log(title = "强制刷新派单状态", businessType = BusinessType.UPDATE)
    @PostMapping("/force-refresh/{assignmentId}")
    public AjaxResult forceRefreshAssignment(@PathVariable Long assignmentId)
    {
        try {
            DormRepairAssignment assignment = assignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId);
            if (assignment == null) {
                return AjaxResult.error("派单不存在");
            }
            
            // 获取关联的工单状态
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(assignment.getRequestId());
            if (repairRequest == null) {
                return AjaxResult.error("关联工单不存在");
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("assignmentId", assignmentId);
            result.put("beforeAssignmentStatus", assignment.getProcessStatus());
            result.put("beforeRequestStatus", repairRequest.getStatus());
            
            // 根据工单状态同步派单状态
            String expectedAssignmentStatus = getExpectedAssignmentStatus(repairRequest.getStatus());
            if (!expectedAssignmentStatus.equals(assignment.getProcessStatus())) {
                assignment.setProcessStatus(expectedAssignmentStatus);
                assignmentService.updateDormRepairAssignment(assignment);
                result.put("statusSynced", true);
                result.put("afterAssignmentStatus", expectedAssignmentStatus);
            } else {
                result.put("statusSynced", false);
                result.put("message", "状态已同步，无需更新");
            }
            
            return AjaxResult.success("刷新完成", result);
            
        } catch (Exception e) {
            logger.error("强制刷新派单状态失败", e);
            return AjaxResult.error("刷新失败：" + e.getMessage());
        }
    }

    /**
     * 检查状态一致性
     */
    private Map<String, Object> checkStatusConsistency(DormRepairAssignment assignment, DormRepairRequest repairRequest) {
        Map<String, Object> consistency = new HashMap<>();
        
        String assignmentStatus = assignment.getProcessStatus();
        String requestStatus = repairRequest.getStatus();
        
        consistency.put("assignmentStatus", assignmentStatus);
        consistency.put("requestStatus", requestStatus);
        
        // 检查状态是否一致
        boolean isConsistent = false;
        String expectedAssignmentStatus = getExpectedAssignmentStatus(requestStatus);
        
        isConsistent = expectedAssignmentStatus.equals(assignmentStatus);
        
        consistency.put("isConsistent", isConsistent);
        consistency.put("expectedAssignmentStatus", expectedAssignmentStatus);
        
        if (!isConsistent) {
            consistency.put("inconsistencyReason", 
                String.format("工单状态[%s]对应的派单状态应为[%s]，但实际为[%s]", 
                    requestStatus, expectedAssignmentStatus, assignmentStatus));
        }
        
        return consistency;
    }

    /**
     * 根据工单状态获取期望的派单状态
     */
    private String getExpectedAssignmentStatus(String requestStatus) {
        switch (requestStatus) {
            case "0": // 待派单
            case "1": // 已派单
                return "0"; // 待接单
            case "2": // 维修中
                return "1"; // 处理中
            case "3": // 已完成
                return "2"; // 已完成
            case "4": // 已取消
                return "3"; // 已拒绝
            default:
                return "0";
        }
    }
}
