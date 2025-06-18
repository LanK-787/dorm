package com.dorm.manage.controller;

import java.util.List;
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
        return success(dormRepairRequestService.selectDormRepairRequestByRequestId(requestId));
    }

    /**
     * 新增报修工单
     */
    @PreAuthorize("@ss.hasPermi('dorm:request:add')")
    @Log(title = "报修工单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormRepairRequest dormRepairRequest)
    {
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
        return toAjax(dormRepairRequestService.deleteDormRepairRequestByRequestIds(requestIds));
    }
}
