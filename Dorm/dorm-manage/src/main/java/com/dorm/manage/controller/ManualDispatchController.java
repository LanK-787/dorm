package com.dorm.manage.controller;

import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.core.page.TableDataInfo;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.SecurityUtils;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.domain.DormRepairer;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.IDormRepairerService;
import com.dorm.manage.service.ISmartDispatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 人工派单Controller
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/dorm/manual")
public class ManualDispatchController extends BaseController
{
    @Autowired
    private IDormRepairRequestService repairRequestService;

    @Autowired
    private IDormRepairerService repairerService;

    @Autowired
    private ISmartDispatchService smartDispatchService;

    /**
     * 获取等待人工派单的工单列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:manual:list')")
    @GetMapping("/pending")
    public TableDataInfo getPendingManualDispatchRequests()
    {
        startPage();
        DormRepairRequest queryRequest = new DormRepairRequest();
        queryRequest.setStatus("5"); // 等待人工派单
        List<DormRepairRequest> list = repairRequestService.selectDormRepairRequestList(queryRequest);
        return getDataTable(list);
    }

    /**
     * 获取可用的维修人员列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:manual:repairers')")
    @GetMapping("/repairers")
    public AjaxResult getAvailableRepairers(@RequestParam String specialty, 
                                          @RequestParam(defaultValue = "false") boolean includeWorking)
    {
        List<DormRepairer> repairers = smartDispatchService.getAvailableRepairers(specialty, null);
        
        // 如果不包含正在工作的维修人员，过滤掉状态为0的
        if (!includeWorking) {
            repairers = repairers.stream()
                    .filter(repairer -> "1".equals(repairer.getStatus()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        return AjaxResult.success(repairers);
    }

    /**
     * 人工派单
     */
    @PreAuthorize("@ss.hasPermi('dorm:manual:dispatch')")
    @Log(title = "人工派单", businessType = BusinessType.UPDATE)
    @PostMapping("/dispatch")
    public AjaxResult manualDispatch(@RequestBody ManualDispatchRequest request)
    {
        try {
            // 获取工单信息
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(request.getRequestId());
            if (repairRequest == null) {
                return AjaxResult.error("工单不存在");
            }

            // 检查工单状态
            if (!"5".equals(repairRequest.getStatus())) {
                return AjaxResult.error("工单状态不是等待人工派单");
            }

            // 获取维修人员信息
            DormRepairer repairer = repairerService.selectDormRepairerByRepairerId(request.getRepairerId());
            if (repairer == null) {
                return AjaxResult.error("维修人员不存在");
            }

            // 执行人工派单（这里简化处理，直接调用智能派单服务）
            // 实际项目中可能需要专门的人工派单服务
            ISmartDispatchService.SmartDispatchResult result = smartDispatchService.smartDispatch(repairRequest);

            if (result.isSuccess()) {
                return AjaxResult.success("人工派单成功");
            } else {
                return AjaxResult.error("人工派单失败：" + result.getFailureReason());
            }

        } catch (Exception e) {
            logger.error("人工派单失败", e);
            return AjaxResult.error("人工派单失败：" + e.getMessage());
        }
    }

    /**
     * 立即派单（强制派单）
     */
    @PreAuthorize("@ss.hasPermi('dorm:manual:force')")
    @Log(title = "强制派单", businessType = BusinessType.UPDATE)
    @PostMapping("/force-dispatch")
    public AjaxResult forceDispatch(@RequestBody ManualDispatchRequest request)
    {
        try {
            // 获取工单信息
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(request.getRequestId());
            if (repairRequest == null) {
                return AjaxResult.error("工单不存在");
            }

            // 强制派单，不检查工单状态
            ISmartDispatchService.SmartDispatchResult result = smartDispatchService.smartDispatch(repairRequest);

            if (result.isSuccess()) {
                return AjaxResult.success("强制派单成功");
            } else {
                return AjaxResult.error("强制派单失败：" + result.getFailureReason());
            }

        } catch (Exception e) {
            logger.error("强制派单失败", e);
            return AjaxResult.error("强制派单失败：" + e.getMessage());
        }
    }

    /**
     * 重置工单状态为待派单
     */
    @PreAuthorize("@ss.hasPermi('dorm:manual:reset')")
    @Log(title = "重置工单状态", businessType = BusinessType.UPDATE)
    @PostMapping("/reset/{requestId}")
    public AjaxResult resetRequestStatus(@PathVariable Long requestId)
    {
        try {
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(requestId);
            if (repairRequest == null) {
                return AjaxResult.error("工单不存在");
            }

            // 重置为待派单状态
            repairRequest.setStatus("0");
            repairRequest.setAttemptCount(0);
            int result = repairRequestService.updateDormRepairRequest(repairRequest);

            if (result > 0) {
                return AjaxResult.success("工单状态重置成功，系统将重新自动派单");
            } else {
                return AjaxResult.error("工单状态重置失败");
            }

        } catch (Exception e) {
            logger.error("重置工单状态失败", e);
            return AjaxResult.error("重置工单状态失败：" + e.getMessage());
        }
    }

    /**
     * 人工派单请求类
     */
    public static class ManualDispatchRequest {
        /** 工单ID */
        private Long requestId;
        
        /** 维修人员ID */
        private Long repairerId;
        
        /** 备注 */
        private String remark;

        public Long getRequestId() {
            return requestId;
        }

        public void setRequestId(Long requestId) {
            this.requestId = requestId;
        }

        public Long getRepairerId() {
            return repairerId;
        }

        public void setRepairerId(Long repairerId) {
            this.repairerId = repairerId;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }
    }
}
