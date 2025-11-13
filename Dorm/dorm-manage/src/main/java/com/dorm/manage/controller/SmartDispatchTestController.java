package com.dorm.manage.controller;

import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.SecurityUtils;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.IDormRepairAssignmentService;
import com.dorm.manage.service.ISmartDispatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 智能派单测试Controller
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/test/smart-dispatch")
public class SmartDispatchTestController extends BaseController
{
    @Autowired
    private IDormRepairRequestService repairRequestService;
    
    @Autowired
    private IDormRepairAssignmentService assignmentService;
    
    @Autowired
    private ISmartDispatchService smartDispatchService;

    /**
     * 创建测试报修工单并触发智能派单
     */
    @Log(title = "测试智能派单", businessType = BusinessType.INSERT)
    @PostMapping("/create-test-order")
    public AjaxResult createTestOrder(@RequestBody TestOrderRequest request)
    {
        try {
            // 创建测试工单
            DormRepairRequest repairRequest = new DormRepairRequest();
            repairRequest.setUserId(SecurityUtils.getUserId());
            repairRequest.setStudentId(request.getStudentId());
            repairRequest.setDormId(request.getDormId());
            repairRequest.setSpecialty(request.getSpecialty());
            repairRequest.setDescription(request.getDescription() != null ? request.getDescription() : "测试报修工单");
            repairRequest.setReporterName(request.getReporterName() != null ? request.getReporterName() : "测试用户");
            repairRequest.setContactPhone(request.getContactPhone() != null ? request.getContactPhone() : "13800138000");
            repairRequest.setImages(request.getImages());
            
            // 插入工单（会自动触发智能派单）
            int result = repairRequestService.insertDormRepairRequest(repairRequest);
            
            if (result > 0) {
                Map<String, Object> data = new HashMap<>();
                data.put("requestId", repairRequest.getRequestId());
                data.put("requestNo", repairRequest.getRequestNo());
                data.put("status", repairRequest.getStatus());
                
                return AjaxResult.success("测试工单创建成功，智能派单已触发", data);
            } else {
                return error("测试工单创建失败");
            }
        } catch (Exception e) {
            logger.error("创建测试工单失败", e);
            return error("创建测试工单失败：" + e.getMessage());
        }
    }

    /**
     * 手动触发智能派单
     */
    @Log(title = "手动触发智能派单", businessType = BusinessType.UPDATE)
    @PostMapping("/manual-dispatch/{requestId}")
    public AjaxResult manualDispatch(@PathVariable Long requestId)
    {
        try {
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(requestId);
            if (repairRequest == null) {
                return error("工单不存在");
            }
            
            ISmartDispatchService.SmartDispatchResult result = smartDispatchService.smartDispatch(repairRequest);
            
            Map<String, Object> data = new HashMap<>();
            data.put("success", result.isSuccess());
            data.put("candidateCount", result.getCandidateCount());
            data.put("dispatchType", result.getDispatchType());
            
            if (result.isSuccess()) {
                data.put("selectedRepairer", result.getSelectedRepairer().getName());
                data.put("repairerId", result.getSelectedRepairer().getRepairerId());
                return AjaxResult.success("智能派单成功", data);
            } else {
                data.put("failureReason", result.getFailureReason());
                return AjaxResult.error("智能派单失败", data);
            }
        } catch (Exception e) {
            logger.error("手动触发智能派单失败", e);
            return error("手动触发智能派单失败：" + e.getMessage());
        }
    }

    /**
     * 查询工单派单状态
     */
    @GetMapping("/dispatch-status/{requestId}")
    public AjaxResult getDispatchStatus(@PathVariable Long requestId)
    {
        try {
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(requestId);
            if (repairRequest == null) {
                return error("工单不存在");
            }
            
            // 查询派单记录
            DormRepairAssignment queryAssignment = new DormRepairAssignment();
            queryAssignment.setRequestId(requestId);
            List<DormRepairAssignment> assignments = assignmentService.selectDormRepairAssignmentList(queryAssignment);
            
            Map<String, Object> data = new HashMap<>();
            data.put("requestId", repairRequest.getRequestId());
            data.put("requestNo", repairRequest.getRequestNo());
            data.put("status", repairRequest.getStatus());
            data.put("statusText", getStatusText(repairRequest.getStatus()));
            data.put("specialty", repairRequest.getSpecialty());
            data.put("description", repairRequest.getDescription());
            data.put("createTime", repairRequest.getCreateTime());
            data.put("attemptCount", repairRequest.getAttemptCount());
            data.put("assignments", assignments);
            
            return AjaxResult.success("查询成功", data);
        } catch (Exception e) {
            logger.error("查询派单状态失败", e);
            return error("查询派单状态失败：" + e.getMessage());
        }
    }

    /**
     * 获取状态文本
     */
    private String getStatusText(String status) {
        switch (status) {
            case "0": return "待派单";
            case "1": return "已派单";
            case "2": return "维修中";
            case "3": return "已完成";
            case "4": return "已取消";
            case "5": return "等待人工派单";
            default: return "未知状态";
        }
    }

    /**
     * 测试工单请求对象
     */
    public static class TestOrderRequest {
        private Long studentId;
        private Long dormId;
        private String specialty;
        private String description;
        private String reporterName;
        private String contactPhone;
        private String images;

        // Getters and Setters
        public Long getStudentId() {
            return studentId;
        }

        public void setStudentId(Long studentId) {
            this.studentId = studentId;
        }

        public Long getDormId() {
            return dormId;
        }

        public void setDormId(Long dormId) {
            this.dormId = dormId;
        }

        public String getSpecialty() {
            return specialty;
        }

        public void setSpecialty(String specialty) {
            this.specialty = specialty;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getReporterName() {
            return reporterName;
        }

        public void setReporterName(String reporterName) {
            this.reporterName = reporterName;
        }

        public String getContactPhone() {
            return contactPhone;
        }

        public void setContactPhone(String contactPhone) {
            this.contactPhone = contactPhone;
        }

        public String getImages() {
            return images;
        }

        public void setImages(String images) {
            this.images = images;
        }
    }
}
