package com.dorm.manage.controller;

import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.TypeConvertUtils;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.manage.service.ISmartDispatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 智能派单管理控制器
 * 
 * @author 王新瑜
 * @date 2025-06-19
 */
@RestController
@RequestMapping("/dorm/dispatch/management")
public class SmartDispatchManagementController extends BaseController {

    @Autowired
    private ISmartDispatchService smartDispatchService;

    @Autowired
    private IDormRepairRequestService repairRequestService;

    /**
     * 手动检查并重新派单等待人工派单的工单
     */
    @PreAuthorize("@ss.hasPermi('dorm:dispatch:manage')")
    @Log(title = "智能派单管理", businessType = BusinessType.OTHER)
    @PostMapping("/check-pending")
    public AjaxResult checkPendingOrders() {
        try {
            ISmartDispatchService.PendingDispatchCheckResult result = 
                smartDispatchService.checkAndRedispatchPendingOrders();
            
            return success(result);
        } catch (Exception e) {
            logger.error("手动检查等待派单工单失败", e);
            return error("检查失败：" + e.getMessage());
        }
    }

    /**
     * 批量重新派单指定的工单
     */
    @PreAuthorize("@ss.hasPermi('dorm:dispatch:manage')")
    @Log(title = "智能派单管理", businessType = BusinessType.OTHER)
    @PostMapping("/batch-redispatch")
    public AjaxResult batchRedispatch(@RequestBody List<Object> rawRequestIds) {
        try {
            // 安全地处理requestIds类型转换，支持Integer和Long类型
            List<Long> requestIds = TypeConvertUtils.convertToLongList(rawRequestIds);

            if (requestIds == null || requestIds.isEmpty()) {
                return error("请选择要重新派单的工单");
            }
            
            if (requestIds.size() > 50) {
                return error("单次批量操作不能超过50个工单");
            }
            
            ISmartDispatchService.BatchRedispatchResult result = 
                smartDispatchService.batchRedispatch(requestIds);
            
            return success(result);
        } catch (Exception e) {
            logger.error("批量重新派单失败", e);
            return error("批量重新派单失败：" + e.getMessage());
        }
    }

    /**
     * 手动触发单个工单的智能派单
     */
    @PreAuthorize("@ss.hasPermi('dorm:dispatch:manage')")
    @Log(title = "智能派单管理", businessType = BusinessType.OTHER)
    @PostMapping("/manual-dispatch/{requestId}")
    public AjaxResult manualDispatch(@PathVariable Long requestId) {
        try {
            // 获取工单信息
            DormRepairRequest repairRequest = repairRequestService.selectDormRepairRequestByRequestId(requestId);
            if (repairRequest == null) {
                return error("工单不存在");
            }
            
            // 检查工单状态
            if (!"0".equals(repairRequest.getStatus()) && !"5".equals(repairRequest.getStatus())) {
                return error("工单状态不允许派单，当前状态：" + repairRequest.getStatus());
            }
            
            // 执行智能派单
            ISmartDispatchService.SmartDispatchResult result = 
                smartDispatchService.smartDispatch(repairRequest);
            
            if (result.isSuccess()) {
                return success(String.format("派单成功，工单[%s]已派给维修人员[%s]", 
                                            repairRequest.getRequestNo(), result.getSelectedRepairer().getName()));
            } else {
                return error("派单失败：" + result.getFailureReason());
            }
            
        } catch (Exception e) {
            logger.error("手动派单失败：工单ID[{}]", requestId, e);
            return error("手动派单失败：" + e.getMessage());
        }
    }

    /**
     * 获取等待人工派单的工单列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:dispatch:query')")
    @GetMapping("/pending-list")
    public AjaxResult getPendingDispatchList() {
        try {
            // 查询等待人工派单的工单
            DormRepairRequest queryRequest = new DormRepairRequest();
            queryRequest.setStatus("5"); // 等待人工派单
            
            startPage();
            List<DormRepairRequest> list = repairRequestService.selectDormRepairRequestList(queryRequest);
            
            return AjaxResult.success(getDataTable(list));
        } catch (Exception e) {
            logger.error("获取等待派单工单列表失败", e);
            return error("获取列表失败：" + e.getMessage());
        }
    }

    /**
     * 获取派单统计信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:dispatch:query')")
    @GetMapping("/statistics")
    public AjaxResult getDispatchStatistics() {
        try {
            // 这里可以实现派单统计逻辑
            // 比如各状态工单数量、派单成功率、维修人员工作负载等
            
            Map<String, Object> statistics = new HashMap<>();
            statistics.put("message", "统计功能待实现");
            
            return success(statistics);
        } catch (Exception e) {
            logger.error("获取派单统计信息失败", e);
            return error("获取统计信息失败：" + e.getMessage());
        }
    }
}
