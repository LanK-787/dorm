package com.dorm.manage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.dorm.common.annotation.Log;
import com.dorm.common.core.controller.BaseController;
import com.dorm.common.core.domain.AjaxResult;
import com.dorm.common.enums.BusinessType;
import com.dorm.common.utils.SecurityUtils;
import com.dorm.manage.domain.DormRepairRequest;
import com.dorm.manage.service.IDormRepairRequestService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 报修工单Controller
 * 
 * @author 王新瑜
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/dorm/request")
public class DormRepairRequestController extends BaseController
{
    @Autowired
    private IDormRepairRequestService dormRepairRequestService;

    /**
     * 查询报修工单列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormRepairRequest dormRepairRequest)
    {
        startPage();

        // 基于用户角色的权限控制
        if (!SecurityUtils.hasRole("admin")) {
            // 非管理员用户，只能查看自己的工单
            dormRepairRequest.setUserId(SecurityUtils.getUserId());
            logger.debug("非管理员用户[{}]查询自己的报修工单", SecurityUtils.getUsername());
        } else {
            // 管理员用户可以查看所有工单，不设置userId过滤条件
            logger.debug("管理员用户[{}]查询所有报修工单", SecurityUtils.getUsername());
        }

        List<DormRepairRequest> list = dormRepairRequestService.selectDormRepairRequestList(dormRepairRequest);
        return getDataTable(list);
    }

    /**
     * 导出报修工单列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:export')")
    @Log(title = "报修工单", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormRepairRequest dormRepairRequest)
    {
        // 基于用户角色的权限控制
        if (!SecurityUtils.hasRole("admin")) {
            // 非管理员用户，只能导出自己的工单
            dormRepairRequest.setUserId(SecurityUtils.getUserId());
            logger.debug("非管理员用户[{}]导出自己的报修工单", SecurityUtils.getUsername());
        } else {
            // 管理员用户可以导出所有工单
            logger.debug("管理员用户[{}]导出所有报修工单", SecurityUtils.getUsername());
        }

        List<DormRepairRequest> list = dormRepairRequestService.selectDormRepairRequestList(dormRepairRequest);
        ExcelUtil<DormRepairRequest> util = new ExcelUtil<DormRepairRequest>(DormRepairRequest.class);
        util.exportExcel(response, list, "报修工单数据");
    }

    /**
     * 获取报修工单详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:query')")
    @GetMapping(value = "/{requestId}")
    public AjaxResult getInfo(@PathVariable("requestId") Long requestId)
    {
        DormRepairRequest repairRequest = dormRepairRequestService.selectDormRepairRequestByRequestId(requestId);

        if (repairRequest == null) {
            return error("工单不存在");
        }

        // 基于用户角色的权限控制
        if (!SecurityUtils.hasRole("admin")) {
            // 非管理员用户，只能查看自己的工单详情
            Long currentUserId = SecurityUtils.getUserId();
            if (!currentUserId.equals(repairRequest.getUserId())) {
                logger.warn("用户[{}]尝试访问其他用户的工单[{}]", SecurityUtils.getUsername(), requestId);
                return error("无权限访问此工单");
            }
        }

        return success(repairRequest);
    }

    /**
     * 新增报修工单
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:add')")
    @Log(title = "报修工单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormRepairRequest dormRepairRequest)
    {
        // 自动设置当前用户ID
        dormRepairRequest.setUserId(SecurityUtils.getUserId());
        return toAjax(dormRepairRequestService.insertDormRepairRequest(dormRepairRequest));
    }

    /**
     * 修改报修工单
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:edit')")
    @Log(title = "报修工单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormRepairRequest dormRepairRequest)
    {
        // 基于用户角色的权限控制
        if (!SecurityUtils.hasRole("admin")) {
            // 非管理员用户，只能修改自己的工单
            DormRepairRequest existingRequest = dormRepairRequestService.selectDormRepairRequestByRequestId(dormRepairRequest.getRequestId());
            if (existingRequest == null) {
                return error("工单不存在");
            }

            Long currentUserId = SecurityUtils.getUserId();
            if (!currentUserId.equals(existingRequest.getUserId())) {
                logger.warn("用户[{}]尝试修改其他用户的工单[{}]", SecurityUtils.getUsername(), dormRepairRequest.getRequestId());
                return error("无权限修改此工单");
            }

            // 确保用户ID不被篡改
            dormRepairRequest.setUserId(currentUserId);
        }

        return toAjax(dormRepairRequestService.updateDormRepairRequest(dormRepairRequest));
    }

    /**
     * 删除报修工单
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:remove')")
    @Log(title = "报修工单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{requestIds}")
    public AjaxResult remove(@PathVariable Long[] requestIds)
    {
        // 基于用户角色的权限控制
        if (!SecurityUtils.hasRole("admin")) {
            // 非管理员用户，只能删除自己的工单
            Long currentUserId = SecurityUtils.getUserId();

            for (Long requestId : requestIds) {
                DormRepairRequest existingRequest = dormRepairRequestService.selectDormRepairRequestByRequestId(requestId);
                if (existingRequest == null) {
                    return error("工单[" + requestId + "]不存在");
                }

                if (!currentUserId.equals(existingRequest.getUserId())) {
                    logger.warn("用户[{}]尝试删除其他用户的工单[{}]", SecurityUtils.getUsername(), requestId);
                    return error("无权限删除工单[" + requestId + "]");
                }
            }
        }

        return toAjax(dormRepairRequestService.deleteDormRepairRequestByRequestIds(requestIds));
    }

    /**
     * 获取维修工单统计数据
     */
    @GetMapping("/statistics")
    public AjaxResult getRepairStatistics()
    {
        try {
            Map<String, Object> statistics = new HashMap<>();

            // 获取所有维修工单数据
            List<DormRepairRequest> allRequests = dormRepairRequestService.selectDormRepairRequestList(new DormRepairRequest());

            // 统计总工单数
            int totalRequests = allRequests.size();

            // 按状态统计工单数量
            long pendingRequests = allRequests.stream()
                .filter(request -> "0".equals(request.getStatus()))
                .count();

            long assignedRequests = allRequests.stream()
                .filter(request -> "1".equals(request.getStatus()))
                .count();

            long inProgressRequests = allRequests.stream()
                .filter(request -> "2".equals(request.getStatus()))
                .count();

            long completedRequests = allRequests.stream()
                .filter(request -> "3".equals(request.getStatus()))
                .count();

            long cancelledRequests = allRequests.stream()
                .filter(request -> "4".equals(request.getStatus()))
                .count();

            long manualDispatchRequests = allRequests.stream()
                .filter(request -> "5".equals(request.getStatus()))
                .count();

            // 按专业类型统计
            long electricalRequests = allRequests.stream()
                .filter(request -> "0".equals(request.getSpecialty()))
                .count();

            long plumbingRequests = allRequests.stream()
                .filter(request -> "1".equals(request.getSpecialty()))
                .count();

            long carpentryRequests = allRequests.stream()
                .filter(request -> "2".equals(request.getSpecialty()))
                .count();

            long cementRequests = allRequests.stream()
                .filter(request -> "3".equals(request.getSpecialty()))
                .count();

            statistics.put("totalRequests", totalRequests);
            statistics.put("pendingRequests", pendingRequests);
            statistics.put("assignedRequests", assignedRequests);
            statistics.put("inProgressRequests", inProgressRequests);
            statistics.put("completedRequests", completedRequests);
            statistics.put("cancelledRequests", cancelledRequests);
            statistics.put("manualDispatchRequests", manualDispatchRequests);
            statistics.put("electricalRequests", electricalRequests);
            statistics.put("plumbingRequests", plumbingRequests);
            statistics.put("carpentryRequests", carpentryRequests);
            statistics.put("cementRequests", cementRequests);

            return success(statistics);
        } catch (Exception e) {
            return error("获取维修工单统计数据失败：" + e.getMessage());
        }
    }
}
