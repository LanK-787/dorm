package com.dorm.manage.controller;

import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.core.page.TableDataInfo;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.SecurityUtils;
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.service.IDormRepairAssignmentService;
import com.dorm.manage.service.IDormRepairerService;
import com.dorm.manage.service.IRepairerAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Collections;

/**
 * 维修人员App端Controller
 * 
 * @author AI助手
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/app/repairer")
public class RepairerAppController extends BaseController
{
    @Autowired
    private IRepairerAppService repairerAppService;

    @Autowired
    private IDormRepairerService repairerService;

    @Autowired
    private IDormRepairAssignmentService assignmentService;

    /**
     * 获取当前维修人员信息
     */
    @GetMapping("/profile")
    public AjaxResult getProfile()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return AjaxResult.error("维修人员信息不存在，请联系管理员");
        }
        return AjaxResult.success(repairer);
    }

    /**
     * 获取待处理派单列表
     */
    @GetMapping("/assignments/pending")
    public TableDataInfo getPendingAssignments()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return getDataTable(Collections.emptyList());
        }

        startPage();
        List<DormRepairAssignment> list = repairerAppService.getPendingAssignments(repairer.getRepairerId());
        return getDataTable(list);
    }

    /**
     * 获取处理中的派单列表
     */
    @GetMapping("/assignments/processing")
    public TableDataInfo getProcessingAssignments()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return getDataTable(Collections.emptyList());
        }

        startPage();
        List<DormRepairAssignment> list = repairerAppService.getProcessingAssignments(repairer.getRepairerId());
        return getDataTable(list);
    }

    /**
     * 获取已完成的派单列表
     */
    @GetMapping("/assignments/completed")
    public TableDataInfo getCompletedAssignments()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return getDataTable(Collections.emptyList());
        }

        startPage();
        List<DormRepairAssignment> list = repairerAppService.getCompletedAssignments(repairer.getRepairerId());
        return getDataTable(list);
    }

    /**
     * 获取已拒绝的派单列表
     */
    @GetMapping("/assignments/rejected")
    public TableDataInfo getRejectedAssignments()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return getDataTable(Collections.emptyList());
        }

        startPage();
        List<DormRepairAssignment> list = repairerAppService.getRejectedAssignments(repairer.getRepairerId());
        return getDataTable(list);
    }

    /**
     * 获取所有派单列表
     */
    @GetMapping("/assignments/all")
    public TableDataInfo getAllAssignments()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return getDataTable(Collections.emptyList());
        }

        startPage();
        List<DormRepairAssignment> list = repairerAppService.getAllAssignments(repairer.getRepairerId());
        return getDataTable(list);
    }

    /**
     * 获取派单详情
     */
    @GetMapping("/assignments/{assignmentId}")
    public AjaxResult getAssignmentDetail(@PathVariable Long assignmentId)
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return error("维修人员信息不存在");
        }

        DormRepairAssignment assignment = repairerAppService.getAssignmentDetail(assignmentId, repairer.getRepairerId());
        if (assignment == null) {
            return error("工单不存在或无权限访问");
        }

        return success(assignment);
    }

    /**
     * 接受派单
     */
    @Log(title = "维修人员接受派单", businessType = BusinessType.UPDATE)
    @PostMapping("/assignments/{assignmentId}/accept")
    public AjaxResult acceptAssignment(@PathVariable Long assignmentId)
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return AjaxResult.error("维修人员信息不存在");
        }

        return repairerAppService.acceptAssignment(assignmentId, repairer.getRepairerId());
    }

    /**
     * 拒绝派单
     */
    @Log(title = "维修人员拒绝派单", businessType = BusinessType.UPDATE)
    @PostMapping("/assignments/{assignmentId}/reject")
    public AjaxResult rejectAssignment(@PathVariable Long assignmentId, @RequestBody RejectRequest request)
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return AjaxResult.error("维修人员信息不存在");
        }

        return repairerAppService.rejectAssignment(assignmentId, repairer.getRepairerId(), request.getRejectReason());
    }

    /**
     * 完成维修
     */
    @Log(title = "维修人员完成维修", businessType = BusinessType.UPDATE)
    @PostMapping("/assignments/{assignmentId}/complete")
    public AjaxResult completeAssignment(@PathVariable Long assignmentId, @RequestBody CompleteRequest request)
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return AjaxResult.error("维修人员信息不存在");
        }

        return repairerAppService.completeAssignment(assignmentId, repairer.getRepairerId(), 
                                                   request.getImages(), request.getProcessRemark());
    }

    /**
     * 获取未读派单数量
     */
    @GetMapping("/assignments/unread-count")
    public AjaxResult getUnreadCount()
    {
        Long userId = SecurityUtils.getUserId();
        DormRepairer repairer = repairerService.selectDormRepairerByUserId(userId);
        if (repairer == null) {
            return AjaxResult.success(0);
        }

        int count = repairerAppService.getUnreadAssignmentCount(repairer.getRepairerId());
        return AjaxResult.success(count);
    }

    /**
     * 拒绝派单请求类
     */
    public static class RejectRequest {
        private String rejectReason;

        public String getRejectReason() {
            return rejectReason;
        }

        public void setRejectReason(String rejectReason) {
            this.rejectReason = rejectReason;
        }
    }

    /**
     * 完成维修请求类
     */
    public static class CompleteRequest {
        private String images;
        private String processRemark;

        public String getImages() {
            return images;
        }

        public void setImages(String images) {
            this.images = images;
        }

        public String getProcessRemark() {
            return processRemark;
        }

        public void setProcessRemark(String processRemark) {
            this.processRemark = processRemark;
        }
    }
}
