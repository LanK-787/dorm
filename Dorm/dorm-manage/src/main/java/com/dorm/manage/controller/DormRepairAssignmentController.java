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
import com.dorm.manage.domain.DormRepairAssignment;
import com.dorm.manage.service.IDormRepairAssignmentService;
import com.dorm.common.utils.poi.ExcelUtil;
import com.dorm.common.core.page.TableDataInfo;

/**
 * 工单分配Controller
 *
 * @author 王新瑜
 * @date 2025-06-18
 */
@RestController
@RequestMapping("/dorm/assignment")
public class DormRepairAssignmentController extends BaseController
{
    @Autowired
    private IDormRepairAssignmentService dormRepairAssignmentService;

    /**
     * 查询工单分配列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:assignment:list')")
    @GetMapping("/list")
    public TableDataInfo list(DormRepairAssignment dormRepairAssignment)
    {
        startPage();
        List<DormRepairAssignment> list = dormRepairAssignmentService.selectDormRepairAssignmentList(dormRepairAssignment);
        return getDataTable(list);
    }

    /**
     * 导出工单分配列表
     */
    @PreAuthorize("@ss.hasPermi('dorm:assignment:export')")
    @Log(title = "工单分配", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DormRepairAssignment dormRepairAssignment)
    {
        List<DormRepairAssignment> list = dormRepairAssignmentService.selectDormRepairAssignmentList(dormRepairAssignment);
        ExcelUtil<DormRepairAssignment> util = new ExcelUtil<DormRepairAssignment>(DormRepairAssignment.class);
        util.exportExcel(response, list, "工单分配数据");
    }

    /**
     * 获取工单分配详细信息
     */
    @PreAuthorize("@ss.hasPermi('dorm:assignment:query')")
    @GetMapping(value = "/{assignmentId}")
    public AjaxResult getInfo(@PathVariable("assignmentId") Long assignmentId)
    {
        return success(dormRepairAssignmentService.selectDormRepairAssignmentByAssignmentId(assignmentId));
    }

    /**
     * 新增工单分配
     */
    @PreAuthorize("@ss.hasPermi('dorm:assignment:add')")
    @Log(title = "工单分配", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DormRepairAssignment dormRepairAssignment)
    {
        return toAjax(dormRepairAssignmentService.insertDormRepairAssignment(dormRepairAssignment));
    }

    /**
     * 修改工单分配
     */
    @PreAuthorize("@ss.hasPermi('dorm:assignment:edit')")
    @Log(title = "工单分配", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DormRepairAssignment dormRepairAssignment)
    {
        return toAjax(dormRepairAssignmentService.updateDormRepairAssignment(dormRepairAssignment));
    }

    /**
     * 删除工单分配
     */
    @PreAuthorize("@ss.hasPermi('dorm:assignment:remove')")
    @Log(title = "工单分配", businessType = BusinessType.DELETE)
    @DeleteMapping("/{assignmentIds}")
    public AjaxResult remove(@PathVariable Long[] assignmentIds)
    {
        return toAjax(dormRepairAssignmentService.deleteDormRepairAssignmentByAssignmentIds(assignmentIds));
    }
}
